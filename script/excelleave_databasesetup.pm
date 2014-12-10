# excelleave_databasesetup.pm
#
# Developed by Dharma <dharma@exceleron.com>
# Changelog:
# 2014-12-08 - created
#


package excelleave_databasesetup;

use strict;
use Exporter;

our @ISA		= qw(Exporter);
our @EXPORT		= qw($dsnvalue $usernamevalue $passwordvalue);

our $dsnvalue='dbi:Pg:database=trial';
our $usernamevalue='';
our $passwordvalue='';

1;
