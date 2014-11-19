use strict;
use warnings;
use v5.10;
use Hook::LexWrap;

package ProgArm;

my $LogTimestampFormat = "%Y-%m-%d %H:%M:%S %s";

wrap CallAction, post => sub {
  open(my $fh, '>>', 'log') or die "cannot open log file: $!"; # XXX don't open it each time?
  say $fh strftime($LogTimestampFormat, localtime), " Action($_[0])"
};
