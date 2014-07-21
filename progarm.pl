#!/usr/bin/perl
use Device::SerialPort;

my $port = Device::SerialPort->new("/dev/rfcomm0"); # TODO get device from parameter
$port->databits(8);
$port->baudrate(38400);
$port->parity("none");
$port->stopbits(1);

while(1) {
  my $byte=$port->read(1);
  print "$byte";
}
