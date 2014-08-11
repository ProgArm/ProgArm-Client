#!/usr/bin/perl
use v5.10;
use strict;
use warnings;

package ProgArm;

use Device::SerialPort;
use File::Glob ':glob';
use File::Basename;
#use Data::Dumper;

our(%KEYS, %CODES, %Keys, %Actions, %Commands, @MyInitVariables,
    $ConfigFile, $ModuleDir, $IgnoreFile, %IgnoredModules, $Port);

$ConfigFile ||= 'config.pl';
$ModuleDir ||= 'modules/';
$IgnoreFile ||= 'ignored_modules';
%IgnoredModules = ();
%Actions = ();
%Commands = (p => \&Ping, P => \&Pong, L => \&ProcessAction);

sub Init {
  do 'input_codes.pl'; # TODO write something like a perl module instead?
  InitModules();
  $Actions{$Keys{$_}} = \&{$_} for keys %Keys; # fill %Actions
  say 'Warning! Duplicate keys found.' if keys %Actions < keys %Keys;
  do $ConfigFile if $ConfigFile and -f $ConfigFile; # init config
  &$_ for @MyInitVariables;
  InitConnection();
}

sub InitModules {
  die 'No modules found.' unless ($ModuleDir and -d $ModuleDir); # because running core without any modules is foolish
  if ($IgnoreFile and -e $IgnoreFile) {
    open(my $fh, "<", $IgnoreFile) or die "Failed to open file: $!\n";
    while(<$fh>) {
      chomp;
      $IgnoredModules{$_} = 1;
    }
    close $fh;
  }
  for (bsd_glob("$ModuleDir/*.p[ml]")) {
    my $basename = fileparse($_);
    next if exists $IgnoredModules{$basename};
    say "Initializing $_";
    do $_;
    say $@ if $@;
  }
}

sub Loop {
  while(1) {
    my $command = Read(1);
    say "Byte: $command";
    if (not exists $Commands{$command}) {
      UnexpectedByte($command);
      next;
    }
    my $bytesNeeded = &{$Commands{$command}}();
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
  return 1 if defined wantarray; # TODO why bother? Just Read() as much bytes as we need?
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
  ...
}

sub OnDisconnect {
  ...
}

Init();
Loop();
