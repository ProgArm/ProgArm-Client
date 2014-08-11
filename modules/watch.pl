use strict;
use warnings;

package ProgArm;
our(%Keys, %CODES);

@Keys{qw(WatchTime WatchDate)} = ($CODES{t}, $CODES{d});

sub WatchTime {
  return WatchDate() if $_[0] ~~ -1;
  Speak(`date '+%-H %-M'`);
}

sub WatchDate {
  return WatchTime() if $_[0] ~~ -1;
  Speak(`date '+%-d %-m %A'`);
}
