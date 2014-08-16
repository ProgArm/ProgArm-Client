use strict;
use warnings;

package ProgArm;
our(%Keys, %CODES);

@Keys{qw(CallAnswer CallRelease)} = qw(w r);

sub CallAnswer {
  `dbus-send --system --print-reply --dest=com.nokia.csd.Call /com/nokia/csd/call/1 com.nokia.csd.Call.Instance.Answer`;
}

sub CallRelease {
  `dbus-send --system --print-reply --dest=com.nokia.csd.Call /com/nokia/csd/call com.nokia.csd.Call.Release`;
}

sub CmusStart {
  `osso-xterm cmus &`;
}

sub VolumeMute {
  my $currentProfile = `dbus-send --type=method_call --print-reply=1 --dest=com.nokia.profiled /com/nokia/profiled com.nokia.profiled.get_profile`;
  my $newProfile = $currentProfile eq 'silent' ? 'general' : 'silent';
  `dbus-send --type=method_call --dest=com.nokia.profiled /com/nokia/profiled com.nokia.profiled.set_profile string:$newProfile`;
}
