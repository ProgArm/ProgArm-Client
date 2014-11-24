use strict;
use warnings;
use v5.10;
use Hook::LexWrap;

package ProgArm;
our($LogDir);

my $LogTimestampFormat = "%Y-%m-%d %H:%M:%S %s ";

# XXX this module is designed to log exclusively useful data for stats
# therefore we don't need any logging library (probably?)

sub Log {
  open(my $fh, '>>', "$LogDir/log") or die "cannot open log file: $!"; # XXX don't open it each time?
  say $fh strftime($LogTimestampFormat, localtime), @_;
}

wrap CallAction, post => sub { Log 'Action ', $_[0] };
wrap OnConnect, post => sub { Log 'Connected' };
wrap OnDisconnect, post => sub { Log 'Disconnected' };
