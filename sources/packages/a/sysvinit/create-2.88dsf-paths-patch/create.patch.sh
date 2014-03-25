#!/bin/sh

VERSION=2.88dsf

tar --files-from=file.list -xjf ../sysvinit-$VERSION.tar.bz2
mv sysvinit-$VERSION sysvinit-$VERSION-orig

cp -rf ./sysvinit-$VERSION-new ./sysvinit-$VERSION

diff -b --unified -Nr  sysvinit-$VERSION-orig  sysvinit-$VERSION > sysvinit-$VERSION-paths.patch

mv sysvinit-$VERSION-paths.patch ../patches

rm -rf ./sysvinit-$VERSION
rm -rf ./sysvinit-$VERSION-orig
