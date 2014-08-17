use strict;
use warnings;
use v5.10;
use Hook::LexWrap;

package ProgArm;

# This extension will provide terminal interaction

wrap Speak, pre => sub {
  say shift
}
