use strict;
use warnings;
use Hook::LexWrap;

package ProgArm;
our(%Actions, %Keys, %CODES, $OldAction);

@Keys{qw(Repeat RepeatNegative)} = ($CODES{Space}, $CODES{Backspace});

wrap CallAction, post => sub {
  my $action = shift;
  if ($action != $Keys{Repeat} and $action != $Keys{RepeatNegative}) {
    $OldAction = $action;
  }
};

sub Repeat {
  $Actions{$OldAction}->(1) if defined $OldAction;
}

sub RepeatNegative {
  $Actions{$OldAction}->(-1) if defined $OldAction;
}
