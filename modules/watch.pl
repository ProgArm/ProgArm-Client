use strict;
use warnings;

package ProgArm;
our(%Keys);

@Keys{qw(WatchTime WatchDate)} = qw(t d);

my @days = qw(Monday Tuesday Wednesday Thursday Friday);

sub WatchTime {
  return WatchDate() if $_[0] ~~ -1;
  my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
  Speak(($hour < 10 ? '0' : '') . $hour . ':' . ($min < 10 ? '0' : '') . $min); # e.g. 05:03
}

sub WatchDate {
  return WatchTime() if $_[0] ~~ -1;
  my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
  Speak("$mday $days[$wday - 1] $mon");
}
