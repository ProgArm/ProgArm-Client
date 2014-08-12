use strict;
use warnings;

package ProgArm;

our($Android);

sub InitConnection {
  my $Android = Android->new();

  $Android->toggleBluetoothState(1); # turn on bluetooth
  $Android->bluetoothConnect('00001101-0000-1000-8000-00805F9B34FB'); # TODO Why this UUID?
}

sub Read {
  return $Android->bluetoothRead(shift)->{'result'};
}

sub Write {
  $Android->bluetoothWrite(shift);
}
