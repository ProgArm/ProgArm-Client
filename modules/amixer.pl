use strict;
use warnings;
use v5.10;

package ProgArm;
our(%Keys);

@Keys{qw(VolumeUp VolumeDown VolumeMute)} = qw(l s m);

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
