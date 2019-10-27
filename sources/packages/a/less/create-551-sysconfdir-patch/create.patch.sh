#!/bin/sh

VERSION=551

tar --files-from=file.list -xzvf ../less-$VERSION.tar.gz
mv less-$VERSION less-$VERSION-orig

cp -rf ./less-$VERSION-new ./less-$VERSION

diff -b --unified -Nr  less-$VERSION-orig  less-$VERSION > less-$VERSION-sysconfdir.patch

mv less-$VERSION-sysconfdir.patch ../patches

rm -rf ./less-$VERSION
rm -rf ./less-$VERSION-orig
