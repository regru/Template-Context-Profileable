use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Template::Context::Profileable',
    license             => 'perl',
    dist_author         => 'Randal L. Schwartz <merlyn@stonehenge.com>',
    dist_version_from   => 'lib/Template/Context/Profileable.pm',
    build_requires => {
        'Test::More' => 0,
    },
    add_to_cleanup      => [ 'Template-Context-Profileable-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
