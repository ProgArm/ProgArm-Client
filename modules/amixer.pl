use strict;
use warnings;

package ProgArm;
our(%Keys, %CODES);

@Keys{qw(VolumeUp VolumeDown VolumeMute)} =
    ($CODES{l}, $CODES{s}, $CODES{m});

sub VolumeUp {
  `amixer set Master playback 10%+ &`
}

sub VolumeDown {
  `amixer set Master playback 10%- &`
}

sub VolumeMute {
  `amixer set Master toggle &`;
}
