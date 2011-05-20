package Test::Cukes::Scenario::Examples;
use Text::CSV;
use Any::Moose;

has csv => (
    is => 'ro',
    required => 1,
    isa => 'Text::CSV',
    builder => '_build_csv',
);

sub _build_csv {
    return Text::CSV->new( { sep_char => q{|}, allow_whitespace => 1 } );
}

has examples_plain => (
    is => 'ro',
    required => 1,
    isa => 'ArrayRef[Str]',
);

has examples => (
    is => 'rw',
    required => 1,
    isa => 'HashRef',
    lazy => 1,
    builder => '_build_examples',
);

sub _build_examples {
    my $self = shift;
    my $_headers = 1;
    my ($examples, @headers);
    for my $example ( @{$self->examples_plain}) {
        if($self->csv->parse($example)) {
            if($_headers) {
                $_headers = 0;
                @headers = $self->csv->fields();
                # the format is: |x|y|\n, so Text::CSV thinks it's: empty record | x | y | empty record
                shift @headers; pop @headers;
                $examples = { rows => [], headers => \@headers };
            }
            else {
                my @fields = $self->csv->fields();
                shift @fields; pop @fields;
                if(@fields == @headers){
                    push @{$examples->{rows}}, \@fields;
                }
                else {
                    die 'more fields then headers';
                }
            }
        } else {
            die 'bad example';
        }
    }

    return $examples;
}

__PACKAGE__->meta->make_immutable;
no Any::Moose;

1;
