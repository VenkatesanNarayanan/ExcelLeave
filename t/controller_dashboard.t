use strict;
use warnings;
use Test::More;


use Catalyst::Test 'ExcelLeave';
use ExcelLeave::Controller::dashboard;

ok( request('/dashboard')->is_success, 'Request should succeed' );
done_testing();
