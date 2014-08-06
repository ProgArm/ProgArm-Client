#use strict;
use warnings;

@Keys{qw(CmusNext CmusPrevious CmusPause CmusAaa)} =
    ($INPUT_N, $INPUT_P, $INPUT_C, $INPUT_A);

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
