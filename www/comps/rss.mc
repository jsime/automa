<%class>
use XML::RSS;
</%class>

<%flags>
extends => undef
</%flags>

<%init>
$m->req->content_type('text/xml');

my @posts = Automa::Post->find( db => $db );

my $rss = XML::RSS->new( version => '2.0' );
$rss->channel(  title       => 'Automatomatromaton',
                link        => 'http://automatomatromaton.com/',
                language    => 'en',
                description => 'Automatomatromaton',
                copyright   => 'Copyright 2013, Jon Sime',
                pubDate     => $posts[0]->posted_at_rfc822,
              );

foreach my $post (@posts) {
    $rss->add_item( title => $post->title,
                    pubDate => $post->posted_at_rfc822,
                    permaLink => 'http://automatomatromaton.com' . $post->path,
                    description => $post->content_above . $post->content_below
                  );
}

print $rss->as_string;
</%init>
