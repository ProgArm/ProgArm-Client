use strict;
use warnings;

package ProgArm;

our($Android);

sub InitConnection {
  $Android->toggleBluetoothState(1); # turn on bluetooth
  $Android->bluetoothConnect('00001101-0000-1000-8000-00805F9B34FB'); # TODO Why this UUID?
}

sub Read {
  my $count = $_[0] // 1;
  if (wantarray) {
    my @result = ();
    push @result, $Android->bluetoothRead(1)->{'result'} for 1..$count; # TODO any way to read many bytes at once?
    return ($count, @result);
  }
  return $Android->bluetoothRead($count)->{'result'};
}

sub Write {
  $Android->bluetoothWrite($_[0]);
}
