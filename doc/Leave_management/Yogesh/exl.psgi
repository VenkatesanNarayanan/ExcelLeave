use strict;
use warnings;

use Exl;

my $app = Exl->apply_default_middlewares(Exl->psgi_app);
$app;

