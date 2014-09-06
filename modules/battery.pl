use strict;
use warnings;
use v5.10;

use POSIX qw(strftime);

package ProgArm;
our(%Keys, %Commands);

$Keys{TellBatteryInfo} = qw(g);
$Commands{B} = \&ParseBatteryInfo;

sub TellBatteryInfo {
  Write('b');
}

sub ParseBatteryInfo {
  return 0 if defined wantarray;
  my $charge = (ord(Read()) << 8) + ord Read();
  my $voltage = (ord(Read()) << 8) + ord Read();
  my $temperature = (ord(Read()) << 8) + ord Read();
  say "Charge: " . $charge;
  printf "Voltage: %.3f V (%s)\n", 6 * $voltage / 0xFFFF, $voltage;
  printf "Temperature: %.3f °C (%s)\n", 600 * $temperature / 0xFFFF - 273.15, $temperature;
}
