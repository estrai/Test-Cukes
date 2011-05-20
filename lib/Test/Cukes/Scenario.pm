package Test::Cukes::Scenario;
use Any::Moose;
use Text::CSV;
use Test::Cukes::Scenario::Examples;

has name => (
    is => "rw",
    required => 1,
    isa => "Str"
);

has steps => (
    is => "rw",
    required => 1,
    isa => "ArrayRef[Str]"
);

has examples => (
    is => 'rw',
    required => 0,
    isa => 'HashRef',
);

sub BUILDARGS {
    my $class = shift;
    if (@_ == 1 && ! ref $_[0]) {
        my $scenario_text = shift;
        my $args = {
            name => "",
            steps => []
        };

        my $_examples = 0;
        my @examples_plain;
        my $scenario_re = qr/^Scenario(?:\sOutline)?:\s(.+)$/;
        for my $line (split /\n+/, $scenario_text) {
            if ($_examples && $line !~ $scenario_re) {
                push @examples_plain, $line;
            }
            elsif ($line =~ $scenario_re) {
                $args->{name} = $1;
            }
            elsif ($line =~ /^\s*(Given|When|Then|And|But)\s+(.+)$/) {
                push @{$args->{ steps }}, "$1 $2";
            }
            elsif ($line =~ /^\s*Examples:$/) {
                $_examples++;
            }
            elsif ($line =~ /\S/) {
                die "Unrecognised scenario syntax:\n",
                    "----\n$line\n----\n\n";
            }
        }

        if(@examples_plain) {
            $args->{examples} =
                Test::Cukes::Scenario::Examples->new( examples_plain => \@examples_plain )
                    ->examples;
        }

        return $args;
    }

    return $class->SUPER::BUILDARGS(@_);
}

__PACKAGE__->meta->make_immutable;
no Any::Moose;
1;
