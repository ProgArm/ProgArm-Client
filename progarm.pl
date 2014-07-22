#!/usr/bin/perl
use strict;
use warnings;
use 5.12.0;

use Device::SerialPort;

my $port = Device::SerialPort->new("/dev/rfcomm0"); # TODO get device from parameter
$port->databits(8);
$port->baudrate(38400);
$port->parity("none");
$port->stopbits(1);

Action = (p => \&Ping, p => \&Pong);

sub Ping {
  return 1 if wantarray eq ''; # TODO is it the best way to check for false but NOT undefined?
  ...
}

sub Pong {
  return 1 if wantarray eq ''; # TODO use return value instead of context to determine required number of bytes?
  say 'Pong received';
}

my @bytes = ();

while(1) {
  my $byte = $port->read(1);
  say "$byte";
  push @bytes, $byte;
  if (scalar($bytes) >= Action{$bytes[0]}) {
    &{$Action{$bytes[0]}}($bytes);
  }
  @bytes = ();
}
