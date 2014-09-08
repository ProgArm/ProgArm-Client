use strict;
use warnings;

package ProgArm;

use Device::SerialPort;

our $UpdateInterval;
my $Port;

sub InitConnection {
  $Port = Device::SerialPort->new("/dev/rfcomm0"); # TODO get device from command line arguments?
  return undef unless defined $Port;
  $Port->databits(8);
  $Port->baudrate(38400);
  $Port->parity("none");
  $Port->stopbits(1);
  $Port->read_char_time($UpdateInterval);
}

sub Read {
  my $count = $_[0] // 1;
  if (wantarray) {
    my ($realCount, $result) = $Port->read($count);
    return ($realCount, split(//, $result));
  }
  return $Port->read($count);
}

sub Write {
  $Port->write($_[0]);
}
