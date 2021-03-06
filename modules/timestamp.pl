use strict;
use warnings;
use v5.10;

use POSIX qw(strftime);

package ProgArm;
our(%Keys, $TimestampsFile, $TimestampFormat, $LogDir);

$Keys{SaveTimestamp} = 'w';
$TimestampsFile = "$LogDir/timestamps";
$TimestampFormat = "%Y-%m-%d %H:%M:%S %s";

my $lastTimestamp = 0;
GetLastTimestamp();

sub GetLastTimestamp {
  open(my $fh, '<', $TimestampsFile);
  while (<$fh>) {
    $lastTimestamp = $1 if /([0-9]+)$/;
  }
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
  say             strftime($TimestampFormat, localtime);
  close($fh);
  my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = gmtime (time - $lastTimestamp);
  my $tellDifference = $lastTimestamp > 0;
  $lastTimestamp = time;
  Speak('Timestamp saved!');
  # TODO so why not strftime?
  if ($tellDifference) {
    my $speakStr = "Last timestamp " . TimestampHelper($yday, 'day') . TimestampHelper($hour, 'hour');
    $speakStr .= TimestampHelper($min, 'minute') . TimestampHelper($sec, 'second', 1) unless $yday; # do not tell minutes and seconds for huge differences
    $speakStr .= ' ago';
    Speak();
  }
}

sub DismissLastTimestamp {
  open(my $fh, '>>', $TimestampsFile);
  print $fh strftime(" Dismissed! ($TimestampFormat)", localtime);
  say       strftime("Dismissed! ($TimestampFormat)", localtime);
  close($fh);
  Speak('Timestamp dismissed!');
  GetLastTimestamp();
}
