use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Sys::Sendfile',
    license             => 'perl',
    dist_author         => 'Leon Timmermans <leont@cpan.org>',
    dist_version_from   => 'lib/Sys/Sendfile.pm',
    build_requires => {
        'Test::More' => 0,
    },
    requires       => {
    	'List::MoreUtils' => 0,
    },
    meta_merge => {
        resources       => {
            bugtracker  => 'http://rt.cpan.org/NoAuth/Bugs.html?Dist=Sys-Sendfile',
        },
        keywords        => [ 'sendfile', 'zero-copy' ],
    },
    add_to_cleanup      => [ 'Sys-Sendfile-*' ],
    create_makefile_pl  => 'traditional',
    sign                => 1,
);

$builder->create_build_script();
