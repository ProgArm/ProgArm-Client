use strict;
use warnings;
use v5.10;

use POSIX qw(strftime);

package ProgArm;
our(%Keys);

@Keys{qw(StartVibrating StopVibrating)} = qw(o O);

sub SendFakeCommand {
  Write('l' . chr(7));
}

sub StartVibrating {
  Write('V' . chr(255));
}

sub StopVibrating {
  Write('V' . chr(0));
}
