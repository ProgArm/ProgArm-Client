use strict;
use warnings;
use v5.10;

package ProgArm;
our(%Keys, %Commands);

$Keys{SendSettings} = qw(S);
$Commands{s} = \&ReadSettings;

sub SendSettings {
  Write('TODO'); # TODO
}

sub ReadSettings {
  Read(); # TODO
}
