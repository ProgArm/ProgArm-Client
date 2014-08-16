use strict;
use warnings;
use v5.10;

package ProgArm;

# This extension will provide terminal interaction

wrap Speak, pre => sub {
  say shift
}
