<%init>
my ($post) = Automa::Post->find(
    db    => $db,
    paths => [$m->path_info],
    limit => 1,
);

$m->not_found unless defined $post;

$.title($post->title);
</%init>

<& /_shared/posts/full.mi, post => $post &>
