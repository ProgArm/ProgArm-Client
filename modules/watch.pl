#use strict;
use warnings;

@Keys{qw(WatchTime WatchDate)} = ($INPUT_T, $INPUT_D);

sub TellTime {
  Speak(`date '+%-H %-M'`);
}

sub TellDate {
  Speak(`date '+%-d %-m %A'`);
}
