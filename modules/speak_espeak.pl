use strict;
use warnings;

package ProgArm;

sub Speak {
  system('espeak', '-ven+f4', shift); # TODO maybe String::ShellQuote instead of using system?
}
