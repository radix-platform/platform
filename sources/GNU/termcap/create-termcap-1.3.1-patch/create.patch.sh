#!/bin/sh

VERSION=1.3.1

tar --files-from=file.list -xzvf ../termcap-$VERSION.tar.gz
mv termcap-$VERSION termcap-$VERSION-orig

cp -rf ./termcap-$VERSION-new ./termcap-$VERSION

diff -b --unified -Nr  termcap-$VERSION-orig  termcap-$VERSION  >  ../patches/termcap-$VERSION.patch

rm -rf ./termcap-$VERSION
rm -rf ./termcap-$VERSION-orig
