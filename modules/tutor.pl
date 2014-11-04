use strict;
use warnings;
use v5.10;
use Hook::LexWrap;

package ProgArm;
our(%Keys, %CODES, $TutorMaxAttempts);

$Keys{TutorMode} = 'x';

# these hashes are taken from https://github.com/ProgArm/ProgArm-Misc/blob/master/bimorse/progarm-keys.pl
# which was originally made for the wiki
my %KEYS = ('SX SX' => 'SPACE','XS XS' => 'BACKSPACE','SS SS' => 'ENTER','SX XS' => 'SHIFT','XS SX' => 'SYMBOLS','SX SS' => 'E','XS SS' => 'T','SS SX' => 'A','SS XS' => 'O','SX LX' => 'I','LX SX' => 'N','XS XL' => 'S','XL XS' => 'H','SS LL' => 'R','LL SS' => 'D','SX XL' => 'L','LX XS' => 'C','XS LX' => 'U','XL SX' => 'M','SX LL' => 'W','LX SS' => 'F','XS LL' => 'G','XL SS' => 'Y','SS LX' => 'P','SS XL' => 'B','LL SX' => 'V','LL XS' => 'K','LX LX' => 'J','XL XL' => 'X','LL LL' => 'Q','LX XL' => 'Z','XL LX' => 'CTRL','LX LL' => 'ALT','XL LL' => 'ESCAPE','LL LX' => 'TAB',);
my %COMBINATIONS = reverse %KEYS;

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

# This code is copied from https://github.com/ProgArm/ProgArm-Website/blob/master/wiki/modules/progarm-keys.pl
sub GetProgArmPressDescription {
  my ($part1, $part2) = @_;
  my $type = ($part1 eq 'L' or $part2 eq 'L') ? 'long' : 'short';
  return "make a $type press on both buttons" if $part1 eq $part2;;
  return "make a $type press on the lower button" if $part1 ne 'x';
  return "make a $type press on the upper button" if $part2 ne 'x';
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
      my $combination = %COMBINATIONS{uc($tutorChar)};
      $combination =~ s/X/x/g;
      $combination =~ /(.)(.) (.)(.)/;
      my $part1 .= GetProgArmPressDescription($1, $2);
      my $part2 .= GetProgArmPressDescription($3, $4);
      Speak($part1 eq $part2 ? $part1 . ' twice' : $part1 . ' and then ' . $part2);
      #TutorRandom();
    } else {
      Speak("$tutorChar, " . (length $tutorChar == 1 ? $SPELLING_ALPHABET{$tutorChar} : ''));
    }
  }
};
