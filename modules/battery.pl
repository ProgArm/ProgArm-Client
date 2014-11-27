use strict;
use warnings;
use v5.10;
use Hook::LexWrap;

use POSIX qw(strftime);

package ProgArm;
our(%Keys, %Commands, $BatteryLogInterval, $ChargePrescaler, $LogDir,
    $BatteryVoltage, $BatteryCharge, $BatteryTemperature);

$Keys{TellBatteryInfo} = qw(g);
$Commands{B} = \&ParseBatteryInfo;
$BatteryLogInterval = 30; # in seconds
$ChargePrescaler = 32;
my $lastLogTime = 0; # in seconds

# These will be set after we receive some info
$BatteryVoltage = 0;
$BatteryCharge = 0;
$BatteryTemperature = 0;

sub TellBatteryInfo {
  Write('b');
  # TODO
}

sub ParseBatteryInfo {
  say 'hello';
  return 0 if defined wantarray;
  my $charge = (ord(Read()) << 8) + ord Read(); # raw data
  my $voltage = (ord(Read()) << 8) + ord Read(); # raw data
  my $temperature = (ord(Read()) << 8) + ord Read(); # raw data
  $BatteryCharge = 0.085 * $ChargePrescaler / 128 * $charge;
  $BatteryVoltage = 6 * $voltage / 0xFFFF;
  $BatteryTemperature = 600 * $temperature / 0xFFFF - 273.15;
  #printf "Charge: %.3f mAh (%s)\n", $realCharge, $charge;
  #printf "Voltage: %.3f V (%s)\n", $realVoltage, $voltage;
  #printf "Temperature: %.3f °C (%s)\n", $realTemperature, $temperature;
  say 'bye';
}

wrap Update, post => sub {
  return if time() - $lastLogTime < $BatteryLogInterval;
  $lastLogTime = time();
  TellBatteryInfo();
};
