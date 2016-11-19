#!/bin/sh

VERSION=7.2p1

tar --files-from=file.list -xzvf ../openssh-$VERSION.tar.gz
mv openssh-$VERSION openssh-$VERSION-orig

cp -rf ./openssh-$VERSION-new ./openssh-$VERSION

diff -b --unified -Nr  openssh-$VERSION-orig  openssh-$VERSION > openssh-$VERSION.patch

mv openssh-$VERSION.patch ../patches

rm -rf ./openssh-$VERSION
rm -rf ./openssh-$VERSION-orig
