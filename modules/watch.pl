use strict;
use warnings;

package ProgArm;
our(%Keys, %CODES);

@Keys{qw(WatchTime WatchDate)} = ($CODES{t}, $CODES{d});

sub TellTime {
  Speak(`date '+%-H %-M'`);
}

sub TellDate {
  Speak(`date '+%-d %-m %A'`);
}
