use strict;
use warnings;
use v5.10;

package ProgArm;

sub Speak {
  system('espeak', '-ven+f4', shift); # TODO maybe String::ShellQuote instead of using system?
}
