#use v5.10;
#use strict;
use warnings;

sub Speak {
  my $text = shift;
  system(qw(flite -voice slt -t), $text); # TODO maybe String::ShellQuote instead of using system?
}
