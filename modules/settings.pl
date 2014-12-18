use strict;
use warnings;
use v5.10;

package ProgArm;
our(%Keys, %Commands, $SettingsFile, %Settings);

$Keys{SendSettings} = qw(S);
$Commands{s} = \&ReadSettings;
$SettingsFile = 'settings';
%Settings = ();

LoadSettings();

sub SendSettings {
  Write('TODO'); # TODO
}

sub ReadSettings {
  Read(); # TODO
}

sub SaveSettings {
  open(my $fh, '>', $SettingsFile) or die "Cannot open settings file: $!";
  for (sort keys %Settings) {
    say $fh $_, '=', $Settings{$_}; # XXX "Inappropriate ioctl for device" - what?
  }
}

sub LoadSettings {
  open(my $fh, '<', $SettingsFile) or die "Cannot open settings file: $!";
  while (<$fh>) {
    $Settings{$1} = $2 if /([^=\s]+)\s*=\s*([^\s]+)/;
  }
}
