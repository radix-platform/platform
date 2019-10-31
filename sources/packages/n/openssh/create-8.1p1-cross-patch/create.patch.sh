#!/bin/sh

VERSION=8.1p1

tar --files-from=file.list -xzvf ../openssh-$VERSION.tar.gz
mv openssh-$VERSION openssh-$VERSION-orig

cp -rf ./openssh-$VERSION-new ./openssh-$VERSION

diff -b --unified -Nr  openssh-$VERSION-orig  openssh-$VERSION > openssh-$VERSION-cross.patch

mv openssh-$VERSION-cross.patch ../patches

rm -rf ./openssh-$VERSION
rm -rf ./openssh-$VERSION-orig
