#!/usr/bin/perl
use strict;
use warnings;
use v5.10;

use File::Glob ':glob';
use Device::SerialPort;

our($Port, %Commands, %Actions, $ConfigFile, $ModuleDir);

$ConfigFile ||= 'config.pl';
$ModuleDir ||= 'modules/';
%Commands = (p => \&Ping, P => \&Pong, L => \&ProcessAction);
%Actions = ();

sub Init {
  if ($ModuleDir and -d $ModuleDir) {
    do $_ for bsd_glob("$ModuleDir/*.p[ml]"); # init modules
  }
  do $ConfigFile if $ConfigFile and -f $ConfigFile; # init config
  InitVariables();
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

sub InitVariables {
}

sub Loop {
  while(1) {
    my $command = $Port->read(1);
    say "Byte: $command";
    if (not defined $Commands{$command}) {
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
  say ord shift;
  
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

Init();
Loop();
