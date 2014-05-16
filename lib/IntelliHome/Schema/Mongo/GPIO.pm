package IntelliHome::Schema::Mongo::GPIO;
use Moose;
use namespace::autoclean;
use Mongoose::Class;
with 'Mongoose::Document' => {
    -collection_name => 'gpio',
    -pk              => [qw/ pin_id /]
};

has 'pin_id' => ( is => "rw" );
has 'node' => (
    is      => 'rw',
    isa     => 'Mongoose::Join[IntelliHome::Schema::Mongo::Node]',
    default => sub {
        Mongoose::Join->new(
            with_class => 'IntelliHome::Schema::Mongo::Node' );
    }
);
has 'tags' => (
    is  => 'rw',
    isa => 'ArrayRef'
);
has 'timing' => ( is => "rw", default => 0 );

1;
