use strict;
use warnings;

use ExcelLeave;

my $app = ExcelLeave->apply_default_middlewares(ExcelLeave->psgi_app);
$app;

