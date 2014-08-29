use strict;
use warnings;

package ProgArm;

our($Android);

sub InitConnection {
  $Android->toggleBluetoothState(1); # turn on bluetooth
  $Android->bluetoothConnect('00001101-0000-1000-8000-00805F9B34FB'); # TODO Why this UUID?
}

sub Read {
  if (wantarray) {
    my $count = $_[0];
    my @result = ();
    push @result, $Android->bluetoothRead(1)->{'result'} for 1..$count;
    return ($count, @result);
  }
  return $Android->bluetoothRead($_[0])->{'result'};
}

sub Write {
  $Android->bluetoothWrite(shift);
}
