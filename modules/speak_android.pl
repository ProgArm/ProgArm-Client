use strict;
use warnings;
use v5.10;

package ProgArm;

our($Android);

sub Speak {
  $Android->ttsSpeak(shift);
}
