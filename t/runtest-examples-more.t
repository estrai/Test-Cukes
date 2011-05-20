#!/usr/bin/env perl -w
use strict;
use Test::Cukes;
use Test::More tests => 23;

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

  Scenario Outline: Add two numbers
    Given I have entered <input_1> into the calculator
    And I have entered <input_2> into the calculator
    When I press <button>
    Then the result should be <output> on the screen

  Examples:
    | input_1 | input_2 | button | output |
    | 20 | 30 | add | 50 |
    | 2 | 5 | add | 7 |
    | 0 | 40 | add | 40 | 

FEATURE_TEXT

my @passed;
my @regex_matches;

# 1st scenario

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

# 2nd scenario
    
# this will be run twice
Given qr/I have entered (\d+) into the calculator/ => sub {
    push @passed, 4;
    push @regex_matches, \@_;
};

When qr/I press (\w+)/ => sub {
    push @passed, 5;
    push @regex_matches, \@_;

};

Then qr/the result should be (\d+) on the screen/ => sub {
    push @passed, 6;
    push @regex_matches, \@_;
};

runtests;

assert @passed        == 9 + 12; # 1st scenario + 2nd scenario
assert @regex_matches == 6 + 12; # 1st scenario + 2nd scenario

is_deeply 
    [
        1, 2, 3,
        1, 2, 3,
        1, 2, 3,
        4, 4, 5, 6,
        4, 4, 5, 6,
        4, 4, 5, 6,
    ],
    \@passed,
    'Steps were called in the correct order';

is_deeply 
    [
        # 1st scenario
        [ 'say',     'cake'   ], [      12, 'cakes'   ],
        [ 'yell',    'banana' ], [   20083, 'bananas' ],
        [ 'whisper', 'beer'   ], [ 1000093, 'beers'   ],

        # 2nd scenario
        [  20 ], [ 30 ], [ 'add' ], [ 50 ],
        [   2 ], [  5 ], [ 'add' ], [  7 ],
        [   0 ], [ 40 ], [ 'add' ], [ 40 ],
    ],
    \@regex_matches,
    'Regex matches were correctly passed to the step functions';


