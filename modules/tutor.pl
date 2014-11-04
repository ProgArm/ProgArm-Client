use strict;
use warnings;
use v5.10;
use Hook::LexWrap;

package ProgArm;
our(%Keys, %CODES, $TutorMaxAttempts);

$Keys{TutorMode} = 'x';

$TutorMaxAttempts = 2;
my $tutorOn;
my $tutorChar;
my $tutorAttempts;

# this hash is based on RAF phonetic alphabet
my %SPELLING_ALPHABET = (a => 'Able', b => 'Baker', c => 'Charlie', d => 'Dog', e => 'Easy', f => 'Fox', g => 'George', h => 'How', i => 'Item', j => 'Jig', k => 'King', l => 'Love', m => 'Mike', n => 'Nan', o => 'Oboe', p => 'Peter', q => 'Queen', r => 'Roger', s => 'Sugar', t => 'Tare', u => 'Uncle', v => 'Victor', w => 'William', x => 'X-ray', y => 'Yoke', z => 'Zebra', );

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
  $tutorChar = lc $tutorChar if length $tutorChar == 1;
  Speak("$tutorChar, " . (length $tutorChar == 1 ? $SPELLING_ALPHABET{$tutorChar} : ''));
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
      Speak("$tutorChar, " . (length $tutorChar == 1 ? $SPELLING_ALPHABET{$tutorChar} : ''));
    }
  }
};
