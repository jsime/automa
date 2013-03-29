#!/usr/bin/perl
use Cwd qw(realpath);
use DBIx::DataStore ( config => 'yaml' );
use File::Basename;
use Mason;
use Plack::Builder;
use Plack::App::File;
use warnings;
use strict;

# Include Mason plugins here
my @plugins = ('PSGIHandler', 'HTMLFilters');

# Create Mason object
my $cwd = dirname( realpath(__FILE__) );
my $interp = Mason->new(
    comp_root => "$cwd/comps",
    data_dir  => "$cwd/data",
    plugins   => \@plugins,
    allow_globals => [qw( $db )],
);

my $dbh = DBIx::DataStore->new('automa');

my $app = sub {
    my $env = shift;

    $interp->set_global('$db', $dbh);

    $interp->handle_psgi($env);
};
my $static = Plack::App::File->new( root => "$cwd/static" );
my $favicon = Plack::App::File->new( file => "$cwd/favicon.ico" );

builder {
    mount "/favicon.ico"=> $favicon;
    mount "/static"     => $static;
    mount "/"           => $app;
};
