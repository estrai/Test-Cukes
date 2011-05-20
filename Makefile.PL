use inc::Module::Install;

name 'Test-Cukes';
perl_version '5.008';
all_from 'lib/Test/Cukes.pm';

requires
    "Try::Tiny"              => "0.07",
    "Carp::Assert"           => "0.20",
    "Any::Moose"             => "0.07",
    "Test::Builder::Module"  => "0.80",
    "Text::CSV"              => "1.00",
    ;

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';

WriteAll;
