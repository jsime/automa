<%init>
my @path_parts = split('/', $m->path_info);
$m->redirect('/') unless @path_parts && $path_parts[0] =~ m{\w}o;

my @tags = grep { defined $_ && $_ =~ m{\w}o } split(',', $path_parts[0]);
$m->redirect('/') unless @tags > 0;

my @posts = Automa::Post->find(
    db    => $db,
    tags  => \@tags,
);

$m->not_found unless @posts && @posts > 0;

$.title('Tags');
</%init>

<div id="posts">
% foreach my $post (@posts) {
    <& /_shared/posts/entry_above.mi, post => $post &>
% }
</div>
