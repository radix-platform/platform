#!/bin/sh

VERSION=1.1.0

tar --files-from=file.list -xjvf ../sessreg-$VERSION.tar.bz2
mv sessreg-$VERSION sessreg-$VERSION-orig

cp -rf ./sessreg-$VERSION-new ./sessreg-$VERSION

diff -b --unified -Nr  sessreg-$VERSION-orig  sessreg-$VERSION > sessreg-$VERSION-man.patch

mv sessreg-$VERSION-man.patch ../patches

rm -rf ./sessreg-$VERSION
rm -rf ./sessreg-$VERSION-orig
