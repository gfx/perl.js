#!/usr/bin/env perl
use strict;
use warnings;
use Fatal qw(chdir);
use File::Basename qw(dirname);
use File::Which qw(which);
use File::Find;

if ($ENV{NO_MODULES}) {
    exit 0;
}

my $emcc       = which('emcc') or die "No emcc(1) in PATH.\n";
my $emscripten = dirname($emcc);
my $packager   = "$emscripten/tools/file_packager.py";

my @files;
chdir 'perl';

find {
    no_chdir => 1,
    wanted => sub {
        if (/\.pm$/ || /\.pl$/) {
            return if /ExtUtils/;
            return if /Net/;
            return if /DBM/;
            return if /User/;
            return if /\bt\b/;
            push @files, $_;
        }
    },
}, 'lib';

warn "packing:\n", "@files\n";

system('python', $packager, '--pre-run', '--embed', @files);
