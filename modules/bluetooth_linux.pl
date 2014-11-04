use strict;
use warnings;
use v5.10;

package ProgArm;

use Device::SerialPort;

our ($UpdateInterval, $RfcommPath);
my $Port;
$RfcommPath = '/dev/rfcomm0'; # TODO get device from command line arguments?

sub InitConnection {
  $Port = Device::SerialPort->new($RfcommPath);
  return undef unless defined $Port;
  $Port->databits(8);
  $Port->baudrate(38400);
  $Port->parity('none');
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
