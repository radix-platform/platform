#!/bin/sh

VERSION=1.2.3

tar --files-from=file.list -xzvf ../termcap-compat_$VERSION.tar.gz
mv termcap-compat-$VERSION termcap-compat-$VERSION-orig

cp -rf ./termcap-compat-$VERSION-new ./termcap-compat-$VERSION

diff -b --unified -Nr  termcap-compat-$VERSION-orig  termcap-compat-$VERSION  > ../patches/termcap-compat-$VERSION.patch

rm -rf ./termcap-compat-$VERSION
rm -rf ./termcap-compat-$VERSION-orig
