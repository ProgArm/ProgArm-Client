#!/usr/bin/perl
use strict;
use warnings;
use v5.10;

package ProgArm;

use File::Basename;
use Getopt::Long;

our(%KEYS, %CODES, %Keys, %Actions, %Commands, @MyInitVariables,
    $ConfigFile, $ModuleDir, $ModuleListDir, $IgnoreFile, %IgnoredModules,
    $WorkDir, $SystemType, $UpdateInterval);

$WorkDir ||= dirname(__FILE__); # TODO is it the most convenient way for us?
chdir $WorkDir or die "Cannot cd to $WorkDir: $!\n";
$ConfigFile ||= 'config.pl'; # TODO change to //= ?
$ModuleDir ||= 'modules/';
$ModuleListDir ||= './';
%IgnoredModules = ();
$UpdateInterval //= 10000; # approximate interval between Update() calls (in milliseconds)
my $lastUpdate = 0;

%Actions = ();
%Commands = (d => \&SendDate, p => \&Ping, P => \&Pong, L => \&ProcessAction, T => \&PrintPlain);

sub DetectSystem { # sloppy rules to determine operating system
  if ($^O eq 'linux') {
    # there is no android detection beacuse android_launcher.pl will set $SystemType variable
    return 'maemo' if `uname -n` =~ /^Nokia-N900/;
    return 'gnu+linux';
  }
  die 'Your operating system is not supported yet :(';
}

sub Init {
  GetOptions('os=s' => \$SystemType, 'config=s' => \$ConfigFile, 'update-interval=i' => \$UpdateInterval,
	     'modules=s' => \$ModuleDir, 'modulelists=s' => \$ModuleListDir); # TODO add help text
  $SystemType ||= DetectSystem();
  do "$WorkDir/input_codes.pl"; # TODO write something like a perl module instead?
  say $! if $!;
  InitModules();
  $Actions{$CODES{$Keys{$_}}} = \&{$_} for keys %Keys; # fill %Actions
  say 'Warning! Duplicate keys found.' if keys %Actions < keys %Keys;
  do $ConfigFile if $ConfigFile and -f $ConfigFile; # init config
  say $! if $!;
  &$_ for @MyInitVariables;
  InitConnection(); # initialize connection
}

sub InitModules {
  open(my $fh, "<", $ModuleListDir . '/modules_' . $SystemType) or die "Failed to open module list file: $!\n";
  while(<$fh>) {
    chomp;
    next unless $_;
    say "Initializing $_";
    do "$ModuleDir/$_";
    say $@ if $@;
    say $! if $!; # TODO is it correct?
  }
  close $fh;
}

sub Loop {
  while(1) {
    Update() if time() - $lastUpdate >= $UpdateInterval / 1000;
    my $command = Read();
    next unless $command; # no data
    say 'Byte: ' . ord($command) . " ($command)";
    if (not exists $Commands{$command}) {
      UnexpectedByte($command);
      next; # skipping bytes is bad, because it can have unknown side effects, but it works OK in practice
    }
    my $bytesNeeded = $Commands{$command}->();
    my ($count, @newBytes) = Read($bytesNeeded);
    $Commands{$command}->(@newBytes);
  }
}

sub Update {
  $lastUpdate = time();
}

sub ProcessAction {
  return 1 if defined wantarray;
  my $actionCode = ord shift;
  say "Action: $actionCode ($KEYS{$actionCode})";
  if (defined $Actions{$actionCode}) {
    CallAction($actionCode);
  } else {
    UnknownAction($actionCode);
  }
}

sub Ping {
  return 0 if defined wantarray; # TODO why bother? Just Read() as much bytes as we need? # TODO indeed.
  Write('p');
}

sub Pong {
  return 0 if defined wantarray;
  say 'Pong received';
}

sub PrintPlain {
  return 0 if defined wantarray;
  print while ($_ = Read()) ne "\0";
  say;
}

sub UnexpectedByte {
  say "Skipping unexpected byte: ", shift;
}

sub CallAction {
  $Actions{$_[0]}->();
}

sub UnknownAction {
  my $actionCode = shift;
  say "Unknown action: $actionCode ($KEYS{$actionCode})";
  Speak($KEYS{$actionCode});
}

sub SendDate {
  my @bytes = ();
  my $time = time();
  for (1..4) {
    push @bytes, $time & 0xFF;
    $time >>= 8;
  }
  Write(chr($_)) for @bytes;
}

Init();
Loop();
