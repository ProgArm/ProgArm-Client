use strict;
use warnings;
use v5.10;

use POSIX qw(strftime);

package ProgArm;
our(%Keys, $TimestampsFile);

$Keys{SaveTimestamp} = 'w';
$TimestampsFile = 'timestamps';

sub SaveTimestamp {
  return DismissLastTimestamp() if $_[0] ~~ -1;
  open(my $fh, '>>', $TimestampsFile);
  say $fh strftime("%Y-%m-%d %H:%M:%S", localtime);
  close($fh);
  Speak('Timestamp saved!');
}

sub DismissLastTimestamp {
  open(my $fh, '>>', $TimestampsFile);
  say $fh strftime("Dismiss! (%Y-%m-%d %H:%M:%S)", localtime);
  say     strftime("Dismiss! (%Y-%m-%d %H:%M:%S)", localtime);
  close($fh);
  Speak('Timestamp dismissed!');
}
