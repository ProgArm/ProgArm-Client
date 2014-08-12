use strict;
use warnings;

package ProgArm;
our(%Keys, %CODES);

@Keys{qw(AndroidMusicNext AndroidMusicPrevious AndroidMusicPause AndroidMusicAaa)} =
    ($CODES{n}, $CODES{p}, $CODES{c}, $CODES{a});

sub AndroidMusicStart {
  # TODO
}

sub AndroidMusicNext {
  return AndroidMusicPrevious() if $_[0] ~~ -1;
  $Android->sendBroadcast("android.intent.action.MEDIA_BUTTON", undef, undef;#, \%extrasDown); # TODO
  $Android->sendBroadcast("android.intent.action.MEDIA_BUTTON", undef, undef;#, \%extrasUp);
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
