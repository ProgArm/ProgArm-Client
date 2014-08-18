use strict;
use warnings;

package ProgArm;

use Device::SerialPort;

my $Port;

sub InitConnection {
  $Port = Device::SerialPort->new("/dev/rfcomm0"); # TODO get device from command line arguments?
  return undef unless defined $Port;
  $Port->databits(8);
  $Port->baudrate(38400);
  $Port->parity("none");
  $Port->stopbits(1);
  $Port->read_char_time(9e9); # wait forever until some byte is received
}

sub Read {
  return $Port->read(shift);
}

sub Write {
  $Port->write(shift);
}
