#!perl -T

use Test::More tests => 1;

BEGIN {
        use_ok( 'Template::Context::Profileable' );
}

diag( "Testing Template::Context::Profileable $Template::Context::Profileable::VERSION, Perl $], $^X" );
