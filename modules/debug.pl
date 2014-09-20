use strict;
use warnings;
use v5.10;

use POSIX qw(strftime);

package ProgArm;
our(%Keys);

@Keys{qw(SendFakeCommand)} = qw(u);

sub SendFakeCommand {
  Write('l' . chr(7));
}
