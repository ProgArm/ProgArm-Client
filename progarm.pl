#!/usr/bin/perl
use strict;
use warnings;
use v5.10;

use File::Glob ':glob';
use Device::SerialPort;
#use Data::Dumper;

our(%Keys, %Actions, %Commands, @MyInitVariables, $ConfigFile, $ModuleDir, $Port);

$ConfigFile ||= 'config.pl';
$ModuleDir ||= 'modules/';
%Actions = ();
%Commands = (p => \&Ping, P => \&Pong, L => \&ProcessAction);

sub Init {
  do 'input_codes.pl'; # TODO write something like a perl module instead?
  if ($ModuleDir and -d $ModuleDir) {
    for (bsd_glob("$ModuleDir/*.p[ml]")) { # init modules
      say "Initializing $_";
      do $_;
      say $@ if $@;
    }
  }
  $Actions{$Keys{$_}} = \&{$_} for keys %Keys; # fill %Actions
  do $ConfigFile if $ConfigFile and -f $ConfigFile; # init config
  &$_ for @MyInitVariables;
  InitSerialPort();
}

sub InitSerialPort {
  $Port = Device::SerialPort->new("/dev/rfcomm0"); # TODO get device from command line arguments
  $Port->databits(8);
  $Port->baudrate(38400);
  $Port->parity("none");
  $Port->stopbits(1);
  $Port->read_char_time(9e9); # wait forever until some byte is received
}

sub Loop {
  while(1) {
    my $command = $Port->read(1);
    say "Byte: $command";
    if (not exists $Commands{$command}) {
      UnexpectedByte($command);
      next;
    }
    my $bytesNeeded = &{$Commands{$command}}();
    my ($count, @newBytes) = $Port->read($bytesNeeded); # TODO check count?
    &{$Commands{$command}}(@newBytes);
  }
}

sub ProcessAction {
  return 1 if defined wantarray;
  my $actionLetter = ord shift;
  say "Action: $actionLetter";
  &{$Actions{$actionLetter}}() if defined $Actions{$actionLetter};
}

sub Ping {
  return 1 if defined wantarray; # TODO why bother? Just read from $Port?
  $Port->write('p');
}

sub Pong {
  return 0 if defined wantarray;
  say 'Pong received';
}

sub UnexpectedByte {
  say "Skipping unexpected byte: ", shift;
}

sub UnknownAction {
  say "Unknown action: ", shift;
}

sub OnConnect {
  ...
}

sub OnDisconnect {
  ...
}

Init();
Loop();
