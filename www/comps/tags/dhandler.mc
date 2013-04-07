<%init>
my @tags = grep { defined $_ && $_ =~ m{\w}o } split(/,/, (split('/'. $m->path_info))[0]);

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
