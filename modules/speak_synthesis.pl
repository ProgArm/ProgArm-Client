use strict;
use warnings;
use v5.10;
use Speech::Synthesis;

package ProgArm;

my $engine = 'SAPI5'; # or 'SAPI4', 'MSAgent', 'MacSpeech' or 'Festival'
my @voices = Speech::Synthesis->InstalledVoices(engine => $engine);
#my @avatars = Speech::Synthesis->InstalledAvatars(engine => $engine);
my %params = (engine   => $engine,
	      avatar   => undef,
	      language => $voices[0]->{language},
	      voice    => $voices[0]->{id},
	      async    => 0);
my $ss = Speech::Synthesis->new(%params);

sub Speak {
  $ss->speak(shift);
}
