use strict;
use warnings;
use v5.10;
use Hook::LexWrap;

use POSIX qw(strftime);

package ProgArm;
our(%Keys, %Commands, $BatteryLogInterval, $BatteryLogFile, $ChargePrescaler, $LogDir);

$Keys{TellBatteryInfo} = qw(g);
$Commands{B} = \&ParseBatteryInfo;
$BatteryLogInterval = 30; # in seconds
$BatteryLogFile = "$LogDir/battery";
$ChargePrescaler = 32;
my $lastLogTime = 0; # in seconds

sub TellBatteryInfo {
  Write('b');
}

sub ParseBatteryInfo {
  return 0 if defined wantarray;
  my $charge = (ord(Read()) << 8) + ord Read();
  my $voltage = (ord(Read()) << 8) + ord Read();
  my $temperature = (ord(Read()) << 8) + ord Read();
  my $realCharge = 0.085 * $ChargePrescaler / 128 * $charge;
  my $realVoltage = 6 * $voltage / 0xFFFF;
  my $realTemperature = 600 * $temperature / 0xFFFF - 273.15;
  #printf "Charge: %.3f mAh (%s)\n", $realCharge, $charge;
  #printf "Voltage: %.3f V (%s)\n", $realVoltage, $voltage;
  #printf "Temperature: %.3f °C (%s)\n", $realTemperature, $temperature;

  open(my $batteryFile, '>>', $BatteryLogFile) || die "Failed open battery log file: $!";
  printf $batteryFile "%d %f %d %f %d %f %d\n", time(), $realCharge, $charge, $realVoltage, $voltage, $realTemperature, $temperature;
  close $batteryFile || die "Failed to close battery log file: $!";
}

wrap Update, post => sub {
  return if time() - $lastLogTime < $BatteryLogInterval;
  $lastLogTime = time();
  TellBatteryInfo();
};
