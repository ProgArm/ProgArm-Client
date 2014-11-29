use strict;
use warnings;
use v5.10;
use Hook::LexWrap;

package ProgArm;
our($LogDir, $BatteryVoltage, $BatteryCharge, $BatteryTemperature);

my $LogTimestampFormat = "%Y-%m-%d %H:%M:%S %s ";

# XXX this module is designed to log exclusively useful data for stats
# therefore we don't need any logging library (probably?)

sub WriteLog {
  open(my $fh, '>>', "$LogDir/$_[0]") or die "Cannot open log file: $!"; # XXX don't open it each time?
  say $fh strftime($LogTimestampFormat, localtime), @_[1 .. @_ - 1];
}

sub Log { WriteLog('log', @_) }
sub LogBattery { WriteLog('battery', @_) }

wrap CallAction, post => sub { Log 'Action ', $_[0] };
wrap OnConnect, post => sub { Log 'Connected' };
wrap OnDisconnect, post => sub { Log 'Disconnected' };
wrap ParseBatteryInfo, post => sub { LogBattery $BatteryCharge, ' ', $BatteryVoltage, ' ', $BatteryTemperature };
