use strict;
use warnings;

package ProgArm;
our(%Keys, %CODES);

@Keys{qw(VolumeUp VolumeDown VolumeMute)} =
    ($CODES{l}, $CODES{s}, $CODES{m});

sub VolumeUp {
  return VolumeDown() if $_[0] ~~ -1;
  `amixer set Master playback 10%+ &`;
}

sub VolumeDown {
  return VolumeUp() if $_[0] ~~ -1;
  `amixer set Master playback 10%- &`;
}

sub VolumeMute {
  `amixer set Master toggle &`;
}
