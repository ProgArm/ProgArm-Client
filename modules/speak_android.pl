use strict;
use warnings;

package ProgArm;

our($Android);

sub Speak {
  $Android->ttsSpeak(shift);
}
