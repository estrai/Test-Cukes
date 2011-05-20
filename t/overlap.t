use strict;
use warnings;

use Test::Cukes tests => 16;
use Test::More;

# I'm treating dogs specially:
my ($dog, $collar);
my %other;


# Some overlapping step definitions:
Given qr/I have a dog collar/  => sub { $collar++ };
Given qr/I have a dog\b/       => sub { $dog++ };
Given qr/I have an? (.*)/      => sub { $other{ $_[0] }++ };

# filler:
When qr/I stroke it/ => sub { 1 };
When qr/I put it on/ => sub { 1 };
Then qr/it (.*)/     => sub { 1 };

# This one should be unreachable
Given qr/I have a dog license/ => sub {
    die "got to unreachable step definition"
};

runtests(q{
Feature: guard dog
  I want a bad tempered dog

  Scenario: stroke dog
    Given I have a dog
    When I stroke it
    Then it bites me
});

is $dog, 1, 'dog scenario was picked up first';

runtests(q{
Feature: nice dog
  I want a nice dog (doggy)

  Scenario: stroke doggy
    Given I have a doggy
    When I stroke it
    Then it wags its tail
});

is $other{doggy}, 1, 'doggy test falls through';

runtests(q{
Feature: put collar on dog
  I want to put a collar on my dog

  Scenario: put collar on dog
    Given I have a dog collar
    When I put it on my dog
    Then it wags its tail
});

is $collar, 1, 'doggy test falls through';

runtests(q{
Feature: legal owner
  I want to make my dog ownership legal

  Scenario: dog license
    Given I have a dog license
    When I stroke it
    Then it remains inert
});

is $dog, 2, 'dog license step picked up by "dog" definition';

