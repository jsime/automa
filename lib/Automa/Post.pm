package Automa::Post;

use Moose;
use MooseX::Params::Validate;

use strict;
use warnings;

sub find {
    my $class = shift;

    my %opts = validated_hash(\@_,
        db      => { isa => 'DBIx::DataStore' },

        ids     => { isa => 'ArrayRef[Int]', optional => 1 },
        paths   => { isa => 'ArrayRef[Str]', optional => 1 },
        from    => { isa => 'Str', optional => 1 },
        to      => { isa => 'Str', optional => 1 },

        tags    => { isa => 'ArrayRef', optional => 1 },
        authors => { isa => 'ArrayRef', optional => 1 },

        pager   => { isa => 'Bool', default => 1 },
        page    => { isa => 'Int', default => 1 },
        limit   => { isa => 'Int', default => -1 },

        order   => { isa => 'Str', default => 'p.posted_at desc' },

        MX_PARAMS_VALIDATE_NO_CACHE => 1,
    );

    my (@joins, @where, @binds);

    push(@where, 'p.posted_at is not null');

    if (exists $opts{'paths'} && @{$opts{'paths'}} > 0) {
        my @path_wheres;

        foreach my $path (@{$opts{'paths'}}) {
            if ($path =~ m{^/?(\d+)$}o) {
                push(@path_wheres, '(p.post_id = ?)');
                push(@binds, $1);
            } elsif ($path =~ m{(\d{4})/(\d\d)/(\d\d)/([^/]+)(?:/(\d+))}o) {
                if (defined $5) {
                    push(@path_wheres, '(p.post_id = ?)');
                    push(@binds, $5);
                } else {
                    push(@path_wheres, '(p.posted_at::date = ? and lower(p.title_url) = lower(?))');
                    push(@binds, "$1-$2-$3", $4);
                }
            } elsif ($path =~ m{(\d{4})/(\d\d)/(\d\d)}o) {
                push(@path_wheres, '(p.posted_at::date = ?)');
                push(@binds, "$1-$2-$3");
            } elsif ($path =~ m{(\d{4})/(\d\d)}o) {
                push(@path_wheres, '(extract(year from p.posted_at) = ? and extract(month from p.posted_at) = ? )');
                push(@binds, $1, $2);
            } elsif ($path =~ m{(\d{4})}o) {
                push(@path_wheres, '(extract(year from p.posted_at) = ?)');
                push(@binds, $1);
            }
        }

        if (@path_wheres > 0) {
            push(@where, sprintf('(%s)', join(' or ', @path_wheres)));
        }
    }

    if (exists $opts{'ids'} && @{$opts{'ids'}} > 0) {
        push(@where, 'p.post_id in ???');
        push(@binds, $opts{'ids'});
    }

    if (exists $opts{'from'}) {
        push(@where, 'p.posted_at >= ?');
        push(@binds, $opts{'from'});
    }
    if (exists $opts{'to'}) {
        push(@where, 'p.posted_at <= ?');
        push(@binds, $opts{'to'});
    }

    if (exists $opts{'tags'} && @{$opts{'tags'}} > 0) {
        push(@joins, 'join post_tags pt on (pt.post_id = p.post_id) join tags t on (t.tag_id = pt.tag_id)');
        push(@where, '(t.name_url in ??? or t.tag_id in ???)');
        push(@binds, $opts{'tags'}, [0, grep { $_ =~ m{^\d+$}o } @{$opts{'tags'}}]);
    }

    if (exists $opts{'authors'} && @{$opts{'authors'}} > 0) {
        push(@joins, 'join post_authors pa on (pa.post_id = p.post_id) join users u on (u.user_id = pa.user_id)');
        push(@where, '(u.name_url in ??? or u.user_id in ???)');
        push(@binds, $opts{'authors'}, [0, grep { $_ =~ m{^\d+$}o } @{$opts{'authors'}}]);
    }

    my $order_by = $opts{'order'};

    my $res = $opts{'db'}->do(
        { pager => $opts{'pager'}, page => $opts{'page'}, per_page => $opts{'limit'} },
        q{  select p.post_id, p.title, p.title_url, p.summary,
                p.content_above, p.content_below,
                to_char(p.posted_at, 'YYYY-MM-DD HH24:MI TZ') as posted_at,
                to_char(p.posted_at, 'Dy, DD Mon YYYY HH24:MI:SS TZ') as posted_at_rfc822,
                to_char(p.posted_at, 'YYYY/MM/DD') as posted_at_url
            from posts p } . join(' ', @joins) . q{
            where } . join(' and ', @where) . qq{
            order by $order_by
        }, @binds);

    return unless $res;

    my @posts;

    while ($res->next) {
        push(@posts, (bless { map { $_ => $res->{$_} } $res->columns }, $class));
        $posts[-1]->db($opts{'db'});
    }

    return @posts;
}

sub new {
    my ($class) = @_;

    my $self = bless {}, $class;

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

    return $self->{'post_id'} if exists $self->{'post_id'} or $self->save;
    return;
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

sub posted_at_rfc822 {
    my ($self) = @_;

    return unless exists $self->{'posted_at_rfc822'};
    return $self->{'posted_at_rfc822'};
}

sub posted_at_url {
    my ($self) = @_;

    return unless exists $self->{'posted_at_url'};
    return $self->{'posted_at_url'};
}

sub path {
    my ($self) = @_;

    return unless exists $self->{'posted_at_url'} && exists $self->{'post_id'} && exists $self->{'title_url'};
    return sprintf('/post/%s/%s/%d', $self->{'posted_at_url'}, $self->{'title_url'}, $self->{'post_id'});
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
