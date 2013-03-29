package Automa::Tag;

use strict;
use warnings;

sub new {
    my ($class, $db, $name) = @_;

    my $self = bless {}, $class;

    $self->{'db'} = $db if defined $db && ref($db) eq 'DBIx::DataStore';
    $self->{'name'} = $name if defined $name;

    return $self;
}

sub find {
}

sub db {
    my ($self, $db) = @_;

    $self->{'db'} = $db if defined $db && ref($db) eq 'DBIx::DataStore';

    return $self->{'db'} if exists $self->{'db'};
    return;
}

sub id {
}

sub name {
}

sub name_url {
}

sub save {
}

1;
