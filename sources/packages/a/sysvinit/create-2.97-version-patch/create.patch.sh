#!/bin/sh

VERSION=2.97

tar --files-from=file.list -xJvf ../sysvinit-$VERSION.tar.xz
mv sysvinit-$VERSION sysvinit-$VERSION-orig

cp -rf ./sysvinit-$VERSION-new ./sysvinit-$VERSION

diff -b --unified -Nr  sysvinit-$VERSION-orig  sysvinit-$VERSION > sysvinit-$VERSION-version.patch

mv sysvinit-$VERSION-version.patch ../patches

rm -rf ./sysvinit-$VERSION
rm -rf ./sysvinit-$VERSION-orig
