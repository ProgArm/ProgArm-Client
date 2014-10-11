use strict;
use warnings;
use v5.10;

package ProgArm;
our(%Keys);

@Keys{qw(AndroidMusicNext AndroidMusicPrevious AndroidMusicPause AndroidMusicAaa)} = qw(n p c a);

# This module will never work without some kind of a layer between
# the perl client and Android operating system

sub AndroidMusicStart {
  # TODO
}

sub AndroidMusicNext {
  return AndroidMusicPrevious() if $_[0] ~~ -1;
  #$Android->sendBroadcast("android.intent.action.MEDIA_BUTTON", undef, undef;#, \%extrasDown); # TODO
  #$Android->sendBroadcast("android.intent.action.MEDIA_BUTTON", undef, undef;#, \%extrasUp);
}

sub AndroidMusicPrevious {
  # TODO
}

sub AndroidMusicPause {
  # TODO
}

sub AndroidMusicAaa {
  # TODO
}
