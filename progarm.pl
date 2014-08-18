#!/usr/bin/perl
use strict;
use warnings;
use v5.10;

package ProgArm;

use File::Basename;

our(%KEYS, %CODES, %Keys, %Actions, %Commands, @MyInitVariables,
    $ConfigFile, $ModuleDir, $ModuleListDir, $IgnoreFile, %IgnoredModules,
    $WorkDir, $SystemType);

$WorkDir ||= dirname(__FILE__); # TODO is it the most convenient way for us?
chdir $WorkDir or die "Cannot cd to $WorkDir: $!\n";
$ConfigFile ||= 'config.pl'; # TODO change to //= ?
$ModuleDir ||= 'modules/';
$ModuleListDir ||= './';
%IgnoredModules = ();

%Actions = ();
%Commands = (p => \&Ping, P => \&Pong, L => \&ProcessAction);

# TODO ignore detection if OS was specified via command-line arguments
sub DetectSystem { # sloppy rules to determine operating system
  if ($^O eq 'linux') {
    # there is no android detection beacuse android_launcher.pl will set $SystemType variable
    return 'maemo' if `uname -n` eq 'Nokia-N900';
    return 'gnu+linux';
  }
  die 'Your operating system is not supported yet :(';
}

sub Init {
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
  Speak("Online!");
}

sub InitModules {
  open(my $fh, "<", $ModuleListDir . '/modules_' . $SystemType) or die "Failed to open file: $!\n";
  while(<$fh>) {
    chomp;
    next unless $_;
    say "Initializing $_";
    do "$ModuleDir/$_";
    say $@ if $@;
    say $! if $!;
  }
  close $fh;
}

sub Loop {
  while(1) {
    my $command = Read(1);
    say "Byte: $command";
    if (not exists $Commands{$command}) {
      UnexpectedByte($command);
      next; # skipping bytes is bad, because it can have unknown side effects, but it works OK in practice
    }
    my $bytesNeeded = $Commands{$command}->();
    my ($count, @newBytes) = Read($bytesNeeded); # TODO check count?
    $Commands{$command}->(@newBytes);
  }
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
  return 1 if defined wantarray; # TODO why bother? Just Read() as much bytes as we need? # TODO indeed.
  Write('p');
}

sub Pong {
  return 0 if defined wantarray;
  say 'Pong received';
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

sub OnConnect {
  # TODO
}

sub OnDisconnect {
  # TODO
}

Init();
Loop();
