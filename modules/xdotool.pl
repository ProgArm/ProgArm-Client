use strict;
use warnings;
use v5.10;
use Hook::LexWrap;

package ProgArm;
our(%Keys, %KEYS, %XdotoolLayout);

$Keys{XdotoolInputMode} = 'k';
%XdotoolLayout = (Space => 'space', Backspace => 'BackSpace',
		  Enter => 'Return', Tab => 'Tab', Escape => 'Escape');
my %Modifiers = (Ctrl => '', Alt => '', Shift => ''); # TODO Alt and Ctrl are not used yet

my $inputOn;

sub XdotoolInputMode {
  $inputOn = !$inputOn;
  if ($inputOn) {
    Write("E0"); # disable device actions
    Speak('Input mode!');
  } else {
    Speak('Done!');
    Write("E1"); # disable device actions
  }
}

wrap CallAction, pre => \&XdotoolInput;
wrap UnknownAction, pre => \&XdotoolInput;

sub XdotoolInput {
  return unless $inputOn;
  $_[-1] = ''; # do not call original subroutine
  my $action = shift;
  my $key = $KEYS{$action}; # TODO
  # XXX xdotool type is bugged (does not work layouts like dvorak),
  # XXX so it seems like the only way to input text is to paste it.
  # XXX there is a possible fix: https://github.com/jordansissel/xdotool/pull/39
  return ($Modifiers{$key} = !$Modifiers{$key}) if exists $Modifiers{$key}; # return value does not matter
  return `xdotool key $XdotoolLayout{$key}` if exists $XdotoolLayout{$key};
  $key = "\u$key" if $Modifiers{Shift};
  `echo -n $key | xsel -i; echo -n $key | xsel -ib; xdotool key shift+Insert`;
  $Modifiers{Shift} = '';
};

# TODO
# F "xte 'keydown Alt_L' 'key F4' 'keyup Alt_L' &"
# R "xdotool key Right &"
# Z, "xdotool key Left &"
