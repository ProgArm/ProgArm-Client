use strict;
use warnings;
use v5.10;

use POSIX qw(strftime);

package ProgArm;
our(%Keys, $TimestampsFile, $TimestampFormat);

$Keys{SaveTimestamp} = 'w';
$TimestampsFile = 'timestamps';
$TimestampFormat = "%Y-%m-%d %H:%M:%S %s";

my $lastTimestamp = 0;
GetLastTimestamp();

sub GetLastTimestamp {   # TODO find a way to skip dismissed timestamps
  open(my $fh, '<', $TimestampsFile);
  while (<$fh>) { ($lastTimestamp) = /([0-9]+)$/ if /^[0-9]/ }
  close($fh);
}

sub TimestampHelper {
  my ($number, $text, $noComma) = @_;
  return '' if not $number and not $noComma; # not $noComma because we want to print 0
  return "$number $text" . ($number == 1 ? '' : 's') . ($noComma ? '' : ', ');
}

sub SaveTimestamp {
  return DismissLastTimestamp() if $_[0] ~~ -1;
  open(my $fh, '>>', $TimestampsFile);
  print $fh "\n", strftime($TimestampFormat, localtime);
  print     "\n", strftime($TimestampFormat, localtime);
  close($fh);
  my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = gmtime (time - $lastTimestamp);
  $lastTimestamp = time;
  Speak('Timestamp saved!');
  # TODO so why not strftime?
  Speak("Last timestamp " . TimestampHelper($yday, 'day') . TimestampHelper($hour, 'hour')
	. TimestampHelper($min, 'minute') . TimestampHelper($sec, 'second', 1) . ' ago');
}

sub DismissLastTimestamp {
  open(my $fh, '>>', $TimestampsFile);
  print $fh strftime("Dismissed! ($TimestampFormat)", localtime);
  print     strftime("Dismissed! (%TimestampFormat)", localtime);
  close($fh);
  Speak('Timestamp dismissed!');
}
