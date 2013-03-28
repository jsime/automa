#!/usr/bin/perl
use Cwd qw(realpath);
use File::Basename;
use Mason;
use Plack::Builder;
use warnings;
use strict;

# Include Mason plugins here
my @plugins = ('PSGIHandler');

# Create Mason object
my $cwd = dirname( realpath(__FILE__) );
my $interp = Mason->new(
    comp_root => "$cwd/comps",
    data_dir  => "$cwd/data",
    plugins   => \@plugins,
);

my $app = sub {
    my $env = shift;
    $interp->handle_psgi($env);
};
my $static = Plack::App::File->new( root => "$cwd/static" );
my $favicon = Plack::App::File->new( file => "$cwd/favicon.ico" );

builder {
    mount "/favicon.ico"=> $favicon;
    mount "/static"     => $static;
    mount "/"           => $app;
};
