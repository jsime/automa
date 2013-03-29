package Automa::Tag;

use strict;
use warnings;

sub find {
    my ($class, %opts) = @_;
}

sub new {
    my ($class, $db, $name) = @_;

    my $self = bless {}, $class;

    $self->{'db'} = $db if defined $db && ref($db) eq 'DBIx::DataStore';
    $self->{'name'} = $name if defined $name;

    return $self;
}

sub db {
    my ($self, $db) = @_;

    $self->{'db'} = $db if defined $db && ref($db) eq 'DBIx::DataStore';

    return $self->{'db'} if exists $self->{'db'};
    return;
}

sub id {
    my ($self) = @_;

    return $self->save unless exists $self->{'id'};
    return $self->{'id'};
}

sub name {
    my ($self, $name) = @_;

    $self->{'name'} = $name if defined $name;

    return $self->{'name'} if exists $self->{'name'};
    return;
}

sub name_url {
    my ($self, $name_url) = @_;

    if (defined $name_url) {
        $self->{'name_url'} = $name_url;
    } elsif (!exists $self->{'name_url'} and $self->name) {
        $self->{'name_url'} = lc($self->name);

        $self->{'name_url'} =~ s{[^a-z0-9_ -]}{}ogs;
        $self->{'name_url'} =~ s{[^a-z0-9]}{-}ogs;
        $self->{'name_url'} =~ s{(^[\s-]+|[\s-]+$)}{}ogs;
        $self->{'name_url'} =~ s{-+}{-}ogs;
    }

    return $self->{'name_url'} if exists $self->{'name_url'};
    return;
}

sub save {
    my ($self) = @_;

    return unless $self->db;

    if (exists $self->{'id'}) {
        my $res = $self->db->do(q{
            update tags set ??? where tag_id = ? returning tag_id
        }, {
            name     => $self->name,
            name_url => $self->name_url
        });

        return unless $res && $res->next;
    } else {
        my $res = $self->db->do(q{
            insert into tags ??? returning tag_id
        }, {
            name     => $self->name,
            name_url => $self->name_url
        });

        return unless $res && $res->next;
        $self->{'id'} = $res->{'tag_id'};
    }

    return $self->{'id'} if exists $self->{'id'};
    return;
}

1;
