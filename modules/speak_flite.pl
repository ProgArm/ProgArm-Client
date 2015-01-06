use strict;
use warnings;
use v5.10;

package ProgArm;

our(@FliteArgs);
@FliteArgs = qw(-voice slt);

sub Speak {
  system('flite', @FliteArgs,  '-t', shift); # TODO maybe String::ShellQuote instead of using system?
}
