use strict;
use warnings;
use v5.10;

use POSIX qw(strftime);

package ProgArm;
our(%Keys);

@Keys{qw(WatchTime WatchDate)} = qw(t d);

sub WatchTime {
  return WatchDate() if $_[0] ~~ -1;
  Speak(strftime("%H:%M", localtime));
}

sub WatchDate {
  return WatchTime() if $_[0] ~~ -1;
  Speak(strftime("%d %A %m", localtime));
}
