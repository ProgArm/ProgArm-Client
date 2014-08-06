use strict;
use warnings;

package ProgArm;
our(%Keys, %CODES);

# TODO ensure that we are running after amixer.pl

sub VolumeMute {
  my $currentProfile = `dbus-send --type=method_call --print-reply=1 --dest=com.nokia.profiled /com/nokia/profiled com.nokia.profiled.get_profile`;
  my $newProfile = $currentProfile == 'silent' ? 'general' : 'silent';
  `dbus-send --type=method_call --dest=com.nokia.profiled /com/nokia/profiled com.nokia.profiled.set_profile string:$newProfile`;
}


