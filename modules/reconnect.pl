use strict;
use warnings;
use v5.10;
use Hook::LexWrap;

package ProgArm;

our $ReconnectionDelay = 3;

# XXX LexWrap approach is harder than naive *OldSub=*Sub; *Sub=*NewSub
wrap InitConnection,
    pre => sub {
      return if defined wantarray;
      $_[-1] = 1; # do nothing in main subroutine and in post
      scalar(InitConnection()); # run again in scalar context
},
    post => sub {
      if ($_[-1]) { # successful connection
	OnConnect();
	return;
      }
      return if $_[0] and $_[0] eq 'reconnect'; # do not allow recursion
      say 'Cannot initialize connection.';
      say "Trying to reconnect with $ReconnectionDelay second delay...";
      do { sleep $ReconnectionDelay } until InitConnection('reconnect');
};

wrap Read, post => sub {
  my ($bytesNeeded) = @_;
  $bytesNeeded = 1 if scalar @_ == 1; # Read with no arguments
  if (wantarray) {
    my ($count, @newBytes) = @{$_[-1]};
    if ($count < $bytesNeeded) {
      OnDisconnect();
      InitConnection();
      push @newBytes, Read($count - $bytesNeeded); # XXX this is untested
    }
    unshift @newBytes, $bytesNeeded;
    $_[-1] = \@newBytes;
  } else {
    return if defined $_[-1];
    OnDisconnect();
    InitConnection();
    $_[-1] = Read($bytesNeeded); # this recursion is not going to be deep
  }
};

sub OnConnect {
  Speak("Online!");
}

sub OnDisconnect {
  Speak("Offline!");
}
