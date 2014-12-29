#!/usr/bin/perl
=head1 NAME

progarm.pl - ProgArm client written in perl

=head1 SYNOPSIS

./progarm.pl [OPTIONS]

Options:

--config PATH

        Path to config file

--module-list gnu+linux|android|maemo|windows|...

        Normally it will try to detect your operating system and use a
        list that fits it. If that fails, you can specify it manually.
        This option is also useful if you want to use your own module list.

--modules PATH

        Path to module files (usually 'modules/' folder)

--module-lists-folder PATH

        Path to module lists folder (these files usually look like 'modules_os')

--update-interval NUM

        Approximate interval between Update() calls (in milliseconds)

--help

        Brief help message

=cut

use strict;
use warnings;
use v5.10;

package ProgArm;

use File::Basename;
use Getopt::Long;
use Pod::Usage;

our(%KEYS, %CODES, %Keys, %Actions, %Commands, @MyInitVariables,
    $ConfigFile, $LogDir, $ModuleDir, $ModuleListDir, $IgnoreFile, %IgnoredModules,
    $WorkDir, $SystemType, $UpdateInterval);

$WorkDir ||= dirname(__FILE__); # TODO is it the most convenient way for us?
chdir $WorkDir or die "Cannot cd to $WorkDir: $!\n";
$ConfigFile //= 'config.pl';
$LogDir ||= 'logs/';
$ModuleDir ||= 'modules/';
$ModuleListDir ||= 'packs/';
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
  return 'windows' if $^O eq 'MSWin32';
  die 'Your operating system is not supported yet :(';
}

sub Init {
  my ($man, $help);
  GetOptions('module-list=s' => \$SystemType, 'config=s' => \$ConfigFile, 'update-interval=i' => \$UpdateInterval,
	     'modules=s' => \$ModuleDir, 'module-lists-folder=s' => \$ModuleListDir,
	     'help|?' => \$help, 'man' => \$man); # TODO modules/module-list/module-lists-folder <- this is confusing, try to simplify it
  pod2usage(1) if $help;
  pod2usage(-exitval => 0, -verbose => 2) if $man;

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
