use strict;
use warnings;
use v5.10;
use Hook::LexWrap;

package ProgArm;
our(%Actions, %Keys, $OldAction);

@Keys{qw(Repeat RepeatNegative)} = qw(Space Backspace);

my $thisActionIsRepeat;

wrap CallAction, post => sub {
  $OldAction = shift unless $thisActionIsRepeat;
  $thisActionIsRepeat = '';
};

sub Repeat {
  $Actions{$OldAction}->(1) if defined $OldAction;
  $thisActionIsRepeat = 1;
}

sub RepeatNegative {
  $Actions{$OldAction}->(-1) if defined $OldAction;
  $thisActionIsRepeat = 1;
}
