use strict;
use warnings;

package ProgArm;

use Android;

use Cwd 'abs_path';
use lib abs_path('./perl_modules'); # to search for all missing perl modules
use File::Basename;

our($Android, $SystemType, $WorkDir);

$Android = Android->new();
$SystemType = 'android';
$WorkDir = dirname(abs_path(__FILE__));

do "$WorkDir/progarm.pl";
