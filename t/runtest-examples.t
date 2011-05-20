#!/usr/bin/env perl -w
use strict;
use Test::Cukes;
use Test::More tests => 11;

feature(<<FEATURE_TEXT);
Feature: foo
  In order to bleh
  I want to bleh

  Scenario: blehbleh
    Given I will <method> the word '<word>'
    When it is my birthday
    Then we will eat <number> <plurar>

    Examples:
    | method  |word    | plurar|number|
    |say      |cake    |cakes    |12|
    | yell    | banana |  bananas| 20083|
    | whisper |    beer|beers|1000093 |
FEATURE_TEXT

my @passed;
my @regex_matches;

Given qr/I will (.+) the word '(.+)'/ => sub {
    push @passed, 1;
    push @regex_matches, \@_;
};

When qr/it is my birthday/ => sub {
    push @passed, 2;
};

Then qr/we will eat (\d+) (.+)/ => sub {
    push @passed, 3;
    push @regex_matches, \@_;
};

runtests;

assert @passed        == 9;
assert @regex_matches == 6;

is_deeply [1, 2, 3, 1, 2, 3, 1, 2, 3], \@passed, "Steps were called in the correct order";
is_deeply 
    [
        [ 'say', 'cake' ], [ 12, 'cakes'],
        [ 'yell', 'banana' ], [ 20083, 'bananas' ],
        [ 'whisper', 'beer' ], [ 1000093, 'beers' ],
    ],
    \@regex_matches,
    'Regex matches were correctly passed to the step functions';


