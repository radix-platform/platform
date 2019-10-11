#!/bin/sh

VERSION=6.1-20191005

tar --files-from=file.list -xzvf ../ncurses-$VERSION.tgz
mv ncurses-$VERSION ncurses-$VERSION-orig

cp -rf ./ncurses-$VERSION-new ./ncurses-$VERSION

diff -b --unified -Nr  ncurses-$VERSION-orig  ncurses-$VERSION > ncurses-$VERSION-mkhashsize.patch

mv ncurses-$VERSION-mkhashsize.patch ../patches

rm -rf ./ncurses-$VERSION
rm -rf ./ncurses-$VERSION-orig
