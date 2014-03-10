#!/bin/sh

VERSION=5.9
DATE=20130504

tar -xzvf ../ncurses-$VERSION.tar.gz
zcat ../patch-$VERSION-$DATE.sh.gz > ncurses-$VERSION/patch.sh
chmod a+x ncurses-$VERSION/patch.sh
( cd ncurses-$VERSION && ./patch.sh )
tar -czvf ncurses-$VERSION.tar.gz ncurses-$VERSION
rm -rf ncurses-$VERSION

tar --files-from=file.list -xzvf ./ncurses-$VERSION.tar.gz
rm -f ./ncurses-$VERSION.tar.gz
mv ncurses-$VERSION ncurses-$VERSION-orig

cp -rf ./ncurses-$VERSION-new ./ncurses-$VERSION

diff -b --unified -Nr  ncurses-$VERSION-orig  ncurses-$VERSION > ncurses-$VERSION-mkhashsize.patch

mv ncurses-$VERSION-mkhashsize.patch ../patches

rm -rf ./ncurses-$VERSION
rm -rf ./ncurses-$VERSION-orig
