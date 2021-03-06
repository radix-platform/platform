#!/bin/sh

VERSION=5.9
DATE=20130504

tar -xzf ../ncurses-$VERSION.tar.gz
zcat ../patch-$VERSION-$DATE.sh.gz > ncurses-$VERSION/patch.sh
chmod a+x ncurses-$VERSION/patch.sh
( cd ncurses-$VERSION && ./patch.sh > /dev/null 2>&1 )
tar -czf ncurses-$VERSION.tar.gz ncurses-$VERSION
rm -rf ncurses-$VERSION

tar --files-from=file.list -xzvf ./ncurses-$VERSION.tar.gz
rm -f ./ncurses-$VERSION.tar.gz
mv ncurses-$VERSION ncurses-$VERSION-orig

cp -rf ./ncurses-$VERSION-new ./ncurses-$VERSION

diff -b --unified -Nr  ncurses-$VERSION-orig  ncurses-$VERSION > ncurses-$VERSION-cross.patch

mv ncurses-$VERSION-cross.patch ../patches

rm -rf ./ncurses-$VERSION
rm -rf ./ncurses-$VERSION-orig
