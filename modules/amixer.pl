#use strict;
use warnings;

@Keys{qw(VolumeUp VolumeDown VolumeMute)} =
    ($INPUT_L, $INPUT_S, $INPUT_M);

sub VolumeUp {
  `amixer set Master playback 10%+ &`
}

sub VolumeDown {
  `amixer set Master playback 10%- &`
}

sub VolumeMute {
  `amixer set Master toggle &`;
}
