use strict;
use warnings;

package ProgArm;
our(%Keys, %CODES);

@Keys{qw(WatchTime WatchDate)} = ($CODES{t}, $CODES{d});

sub WatchTime {
  Speak(`date '+%-H %-M'`);
}

sub WatchDate {
  Speak(`date '+%-d %-m %A'`);
}
