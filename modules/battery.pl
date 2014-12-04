use strict;
use warnings;
use v5.10;
use Hook::LexWrap;

use POSIX qw(strftime);

package ProgArm;
our(%Keys, %Commands, $BatteryLogInterval, $ChargePrescaler, $LogDir,
    $BatteryVoltage, $BatteryCharge, $BatteryTemperature);

$Keys{TellBatteryInfo} = qw(g);
$Commands{B} = \&ReadBatteryInfo;
$BatteryLogInterval = 30; # in seconds
$ChargePrescaler = 32;
my $lastLogTime = 0; # in seconds

# These will be set after we receive some info
$BatteryVoltage = 0;
$BatteryCharge = 0;
$BatteryTemperature = 0;

my $speakIt = 0;

sub AskBatteryInfo {
  Write('b');
}

sub TellBatteryInfo {
  $speakIt = 1;
  AskBatteryInfo();
}

sub SpeakBatteryInfo {
  $speakIt = 0;
  # TODO add % when ProgArm 0.3 comes
  Speak sprintf "%.0f milliampere-hour. %.2f volts.", $BatteryCharge, $BatteryVoltage;
}

sub ReadBatteryInfo {
  return 0 if defined wantarray;
  my $charge = (ord(Read()) << 8) + ord Read(); # raw data
  my $voltage = (ord(Read()) << 8) + ord Read(); # raw data
  my $temperature = (ord(Read()) << 8) + ord Read(); # raw data
  ParseBatteryInfo($charge, $voltage, $temperature);
}

sub ParseBatteryInfo {
  my ($charge, $voltage, $temperature) = @_;
  $BatteryCharge = 0.085 * $ChargePrescaler / 128 * $charge;
  $BatteryVoltage = 6 * $voltage / 0xFFFF;
  $BatteryTemperature = 600 * $temperature / 0xFFFF - 273.15;
  SpeakBatteryInfo() if $speakIt;
}

wrap Update, post => sub {
  return if time() - $lastLogTime < $BatteryLogInterval;
  $lastLogTime = time();
  AskBatteryInfo();
};
