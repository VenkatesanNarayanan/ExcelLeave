#!/usr/bin/perl -w

#
# token.pl
# Developed by Dharma  <dharma@exceleron.com>

use strict;
use Session::Token;
use Data::Dumper;
use Digest::MD5;


my $token = Session::Token->new->get;

print Dumper $token;

my $data="Dharma";

my $ctx = Digest::MD5->new;
$ctx->add($data);
my $digest = $ctx->hexdigest;
print Dumper $digest;

1;
