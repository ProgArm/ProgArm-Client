use strict;
use warnings;

package ProgArm;

sub Speak {
  system(qw(flite -voice slt -t), shift); # TODO maybe String::ShellQuote instead of using system?
}
