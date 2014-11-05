#!/usr/bin/perl -w

#
# sendmail.pl
# Developed by Dharma  <dharma@exceleron.com>

use strict;

use Email::MIME;
my $message = Email::MIME->create(
	header_str => [
		From    => 'dharma@dharma-exceleron',
		To      => 'girish@girish-exceleron',
		Subject => 'message from Dharma',
	],
	attributes => {
		encoding => 'quoted-printable',
		charset  => 'ISO-8859-1',
	},
	body_str => "Hai girish this is test mail!\n",
);

# send the message
use Email::Sender::Simple qw(sendmail);
sendmail($message);


1;
