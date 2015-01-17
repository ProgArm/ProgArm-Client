use strict;
use warnings;
use v5.10;

package ProgArm;
our($BluetoothAddress, $BluetoothPort);

use Net::Bluetooth;
use IO::Handle;

$BluetoothAddress = '00:13:12:25:47:81';
$BluetoothPort = 1;

sub InitConnection {
  my $obj = Net::Bluetooth->newsocket("RFCOMM");
  return unless defined $obj;
  return if $obj->connect($BluetoothAddress, $BluetoothPort) != 0;
  *SERVER = $obj->perlfh();
}

sub Read {
  my $count = $_[0] // 1;
  my $buf = '';
  my $amount = read(SERVER, $buf, $count);
  return ($amount, split(//, $buf)) if wantarray;
  return $buf;
}

sub Write {
  print SERVER $_[0];
  SERVER->flush();
}

# close(SERVER); # should we do that ?
