#!/usr/bin/perl

use strict;
use warnings;
use FindBin;

my $APP_NAME = 'logstalgia';

sub app_version {
    my $version = `cat $FindBin::Bin/../../src/logstalgia.h | grep LOGSTALGIA_VERSION`;
    $version =~ /"([^"]+)"/ or die("could not determine version\n");
    $version = $1;
    return $version;
}

my $WINBUILD = "$FindBin::Bin/../builds/win32/";

my $VERSION  = app_version();

sub doit {
    my $cmd = shift;

    if(system($cmd) != 0) {
        die("command '$cmd' failed: $!");
    }
}

sub dosify {
    my($src, $dest) = @_;

    my $content = `cat $src`;
    $content =~ s/\r?\n/\r\n/g;

    open  OUTPUT, ">$dest" or die("$!");
    print OUTPUT $content;
    close OUTPUT;
}

chdir("$FindBin::Bin/../../");

doit("rm -rf $WINBUILD");
doit("mkdir -p $WINBUILD");
doit("mkdir -p $WINBUILD/data/");
doit("mkdir -p $WINBUILD/data/fonts/");

doit("cp $APP_NAME.exe $WINBUILD");
doit("cp data/*.tga $WINBUILD/data/");
doit("cp data/example.log $WINBUILD/data/");
doit("cp data/fonts/*.ttf $WINBUILD/data/fonts/");

dosify('README',    "$WINBUILD/README.txt");
dosify('ChangeLog',    "$WINBUILD/ChangeLog.txt");
dosify('data/fonts/README', "$WINBUILD/data/fonts/README.txt");
dosify('README-SDL',"$WINBUILD/README-SDL.txt");
dosify('COPYING',   "$WINBUILD/COPYING.txt");
dosify('THANKS',    "$WINBUILD/THANKS.txt");

doit("cp dev/win32/SDL.dll $WINBUILD");
doit("cp dev/win32/SDL_image.dll $WINBUILD");
doit("cp dev/win32/pcre3.dll $WINBUILD");
doit("cp dev/win32/libjpeg-9.dll $WINBUILD");
doit("cp dev/win32/libpng15-15.dll $WINBUILD");
doit("cp dev/win32/zlib1.dll $WINBUILD");
doit("cp dev/win32/glew32.dll $WINBUILD");
doit("cp dev/win32/freetype6.dll $WINBUILD");

chdir($WINBUILD);
doit("zip -r $APP_NAME-$VERSION.win32.zip *");

doit("cp $APP_NAME-$VERSION.win32.zip ..");
chdir("$WINBUILD/..");
doit("rm -rf $WINBUILD");

