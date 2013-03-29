#!/usr/bin/perl

use strict;
use warnings;

use DBIx::DataStore ( config => 'yaml' );
use Getopt::Long;

my ($help, @ids);

die usage() unless GetOptions(
    'help'        => \$help,
    'id|i=i'      => \@ids,
);
exit usage() if $help;

my $db = DBIx::DataStore->new('automa');

foreach my $post_id (@ids) {
    $db->begin;

    my $post = $db->do(q{
        select *, to_char(now(), 'YYYY/MM/DD') as posted_at_url
        from posts
        where post_id = ? 
    }, $post_id);

    unless ($post && $post->next) {
        $db->rollback;
        printf("Article ID %d was invalid. Skipping.\n", $post_id);
        next;
    }

    if ($post->{'posted_at'}) {
        $db->rollback;
        printf("Article ID %d has already been published. Skipping.\n", $post_id);
        next;
    }

    $post->{'title_url'} = title_url($post->{'title'}) unless $post->{'title_url'};

    printf("About to publish Article ID %d.\n    %s\n    /posts/%s/%s/%d\n\nContinue? (Y/n) ",
        $post_id, $post->{'title'}, $post->{'posted_at_url'}, $post->{'title_url'}, $post_id);

    my $response = <STDIN>;
    chomp($response);
    unless ($response eq '' or $response =~ m{^y(es)?$}o) {
        $db->rollback;
        print "Skipped.\n";
        next;
    }

    my $res = $db->do(q{
        update posts
        set title_url = ?,
            posted_at = now()
        where post_id = ?
    }, $post->{'title_url'}, $post_id);

    unless ($res) {
        $db->rollback;
        printf("Error publishing Article ID %d: %s\n", $post_id, $res->error);
        next;
    }

    $db->commit;
}

sub title_url {
    my ($title) = @_;

    $title = lc($title);
    $title =~ s{[^a-z0-9_ -]}{}ogs;
    $title =~ s{[^a-z0-9]}{-}ogs;
    $title =~ s{(^[\s-]+|[\s-]+$)}{}ogs;
    $title =~ s{-+}{-}ogs;

    return $title;
}

sub usage {
    my $name = (split('/', $0))[-1];

    print <<EOU;
$name - Publish article bodies in Automa.

Examples:

    $name -i <int>

Options:

  -i <int>    ID of article to publish. May be given multiple times.

  -h          Display this message and exit.

Given a list of article IDs, will generate the URL title strings (if
not already present) and mark them as published (if not already so).

EOU
}
