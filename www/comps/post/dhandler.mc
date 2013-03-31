<%init>
my ($post) = Automa::Post->find(
    db    => $db,
    paths => [$m->path_info],
    limit => 1,
);

$m->not_found unless defined $post;

my $given_path = sprintf('/post/%s', $m->path_info);

$m->redirect($post->path) unless $given_path eq $post->path;

$.title($post->title);
</%init>

<& /_shared/posts/full.mi, post => $post &>
