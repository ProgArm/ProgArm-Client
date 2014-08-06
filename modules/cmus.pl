use v5.10; # ${^CHILD_ERROR_NATIVE} was added in 5.10
use strict;
use warnings;

package ProgArm;
our(%Keys, %CODES);

@Keys{qw(CmusNext CmusPrevious CmusPause CmusAaa)} =
    ($CODES{n}, $CODES{p}, $CODES{c}, $CODES{a});

sub CmusStart {
  `x-terminal-emulator -e cmus > /dev/null 2>&1 &`; # TODO nohup and disown?
}

sub CmusNext {
  `cmus-remote --next`;
  CmusStart() if ${^CHILD_ERROR_NATIVE};
}

sub CmusPrevious {
  `cmus-remote --prev`;
}

sub CmusPause {
  `cmus-remote --pause`;
  CmusStart() if ${^CHILD_ERROR_NATIVE};
}

sub CmusAaa {
  `cmus-remote -C 'toggle aaa_mode'`
}
