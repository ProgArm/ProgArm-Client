use strict;
use warnings;
use v5.10;
use Hook::LexWrap;

package ProgArm;
our(%Keys, %CODES);

$Keys{TutorMode} = 'x';

our $TutorMaxAttempts = 3;
my $tutorOn;
my $tutorChar;
my $tutorAttempts;

sub TutorMode {
  $tutorOn = !$tutorOn;
  if ($tutorOn) {
    Write("E0"); # disable device actions
    Speak('Welcome to typing tutor!');
    TutorRandom();
  } else {
    Speak('Goodbye!');
    Write("E1"); # disable device actions
  }
}

sub TutorRandom {
  $tutorAttempts = 0;
  $tutorChar = (keys %CODES)[rand keys %CODES];
  Speak($tutorChar);
}

wrap CallAction, pre => \&Tutor;
wrap UnknownAction, pre => \&Tutor;

sub Tutor {
  return unless $tutorOn;
  $_[-1] = ''; # do not call original subroutine
  my $action = shift;
  if ($CODES{$tutorChar} == $action) {
    Speak('Right!');
    TutorRandom();
  } else {
    return TutorMode() if $CODES{'q'} == $action;
    Speak('Wrong!');
    $tutorAttempts++;
    if ($tutorAttempts >= $TutorMaxAttempts) {
      Speak('Lets try another!');
      TutorRandom();
    } else {
      Speak($tutorChar);
    }
  }
};
