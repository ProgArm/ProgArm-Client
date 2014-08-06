use strict;
use warnings;

package ProgArm;

sub Speak {
  my $text = shift;
  system(qw(flite -voice slt -t), $text); # TODO maybe String::ShellQuote instead of using system?
}
