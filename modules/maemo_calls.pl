use strict;
use warnings;

package ProgArm;
our(%Keys, %CODES);

@Keys{qw(CallAnswer CallRelease)} = ($CODES{w}, $CODES{r});

sub CallAnswer {
  `dbus-send --system --print-reply --dest=com.nokia.csd.Call /com/nokia/csd/call/1 com.nokia.csd.Call.Instance.Answer`;
}

sub CallRelease {
  `dbus-send --system --print-reply --dest=com.nokia.csd.Call /com/nokia/csd/call com.nokia.csd.Call.Release`;
}
