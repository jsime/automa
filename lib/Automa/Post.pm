package Automa::Post;

use strict;
use warnings;

sub find {
    my ($class, %opts) = @_;
}

sub new {
    my ($class) = @_;

    my $self = bless {}, $class;

    return $self;
}

sub id {
}

sub title {
    my ($self, $title) = @_;

    $self->{'title'} = $title if defined $title;

    return $self->{'title'} if exists $self->{'title'};
    return;
}

sub title_url {
}

sub summary {
    my ($self, $summary) = @_;

    $self->{'summary'} = $summary if defined $summary;

    return $self->{'summary'} if exists $self->{'summary'};
    return;
}

sub content_above {
    my ($self, $content) = @_;

    $self->{'content_above'} = $content if defined $content;

    return $self->{'content_above'} if exists $self->{'content_above'};
    return;
}

sub content_below {
    my ($self, $content) = @_;

    $self->{'content_below'} = $content if defined $content;

    return $self->{'content_below'} if exists $self->{'content_below'};
    return;
}

sub posted_at {
    my ($self) = @_;

    return unless exists $self->{'posted_at'};
    return $self->{'posted_at'};
}

sub path {
    my ($self) = @_;

    return unless exists $self->{'posted_at_url'} && exists $self->{'id'} && exists $self->{'title_url'};
    return sprintf('/post/%s/%s/%d', $self->{'posted_at_url'}, $self->{'title_url'}, $self->{'id'};
}

sub live {
    my ($self, $live) = @_;

    if (defined $live) {
        if ($live) {
            $self->{'posted_at'} = 'now' unless $self->{'posted_at'};
        } else {
            $self->{'posted_at'} = undef;
        }
    }

    return 1 if exists $self->{'posted_at'} && $self->{'posted_at'};
    return 0;
}

sub save {
}

sub tags {
    my ($self) = @_;

    return @{$self->{'tags'}} if exists $self->{'tags'} && ref($self->{'tags'}) eq 'ARRAY';
    return;
}

sub add_tag {
}

sub remove_tag {
}

sub authors {
    my ($self) = @_;

    return @{$self->{'authors'}} if exists $self->{'authors'} && ref($self->{'authors'}) eq 'ARRAY';
    return;
}

sub add_author {
    my ($self, $author) = @_;

    return unless defined $author && ref($author) eq 'Automa::User';
    return if grep { $_->id == $author->id } $self->authors;

    push(@{$self->{'authors'}}, $author);
    return 1;
}

sub remove_author {
    my ($self, $author) = @_;

    return unless exists $self->{'authors'} && ref($self->{'authors'}) eq 'ARRAY';
    return unless defined $author && ref($author) eq 'Automa::User';

    my $orig_count = @{$self->{'authors'}};

    $self->{'authors'} = [ grep { $_->id != $author->id } $self->{'authors'} ];

    return 1 if @{$self->{'authors'}} < $orig_count;
    return;
}

1;
