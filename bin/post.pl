#!/usr/bin/perl

use strict;
use warnings;

use DBIx::DataStore ( config => 'yaml' );
use Getopt::Long;

my ($help, $id, $title, $summary, $content1, $content2, @tags, @authors);

die usage() unless GetOptions(
    'help'        => \$help,
    'id|i=i'      => \$id,
    'title|t=s'   => \$title,
    'summary|s=s' => \$summary,
    'content|c=s' => \$content1,
    'extra|e=s'   => \$content2,
    'tags|g=s'    => \@tags,
    'authors|a=i' => \@authors
);
exit usage() if $help;

my %post;

$post{'title'} = $title if $title;
$post{'summary'} = file_contents($summary) if $summary;
$post{'content_above'} = file_contents($content1) if $content1;
$post{'content_below'} = file_contents($content2) if $content2;

unless ($id or keys %post > 0) {
    print "There is nothing for me to do.\n";
    exit;
}

my $db = DBIx::DataStore->new('automa');
my $res_post;

$db->begin;

if ($id) {
    $post{'updated_at'} = 'now';
    $res_post = $db->do(q{ update posts set ??? where post_id = ? returning * }, \%post, $id);
} else {
    $post{'created_at'} = 'now';
    $res_post = $db->do(q{ insert into posts ??? returning * }, \%post);
}

unless ($res_post && $res_post->next) {
    $db->rollback;
    die $res_post->error;
}

if (@tags and @tags > 0) {
    @tags = map { lc($_) } @tags;

    my $res = $db->do(q{ delete from post_tags where post_id = ? }, $res_post->{'post_id'});
    die $res->error unless $res;

    $res = $db->do(q{
        insert into post_tags
            (post_id, tag_id)
        select ?, tag_id
        from tags
        where lower(name) in ??? or lower(name_url) in ???
    }, $res_post->{'post_id'}, \@tags, \@tags);

    die $res->error unless $res;
}

if (@authors and @authors > 0) {
    my $res = $db->do(q{ delete from post_authors where post_id = ? }, $res_post->{'post_id'});
    die $res->error unless $res;

    $res = $db->do(q{
        insert into post_authors
            (post_id, user_id)
        select ?, user_id
        from users
        where user_id in ???
    }, $res_post->{'post_id'}, \@authors);

    die $res->error unless $res;
}

$db->commit;

printf("Post %d updated.\n", $res_post->{'post_id'});
printf("  Title: %s\n", $res_post->{'title'}) if $res_post->{'title'};

sub file_contents {
    my ($fn) = @_;

    die "File $fn does not exist, or is not readable!" unless -f $fn && -r _;

    local $/ = '';
    open (my $fh, '<', $fn) or die "Error opening $fn: $!";
    my $text = <$fh>;
    close($fh);

    return $text;
}

sub usage {
    my $name = (split('/', $0))[-1];

    print <<EOU;
$name - Add and update post bodies in Automa.

Examples:

    $name --subject "An Insightful Post" --tag file

Options:

  -i <int>    ID of post to update. If not given, creates new one.

  -t <text>   Post's title.

  -s <file>   File containing HTML snippet for summary.

  -c <file>   File containing HTML snippet for above-the-fold content.

  -e <file>   File containing HTML snippet for below-the-fold content.

  -g <tag>    Tag name to add to post. May be given multiple times.

  -a <id>     ID of author. May be given multiple times.

  -h          Display this message and exit.

All fields are effectively optional, though if you provide no ID and no
content, the script becomes a noop. Also, you will not be able to
publish a post if it does not have at least a title and above-the-fold
content.

EOU
}
