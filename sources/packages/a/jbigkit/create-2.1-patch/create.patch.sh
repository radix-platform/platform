#!/bin/sh

VERSION=2.1

tar --files-from=file.list -xzvf ../jbigkit-$VERSION.tar.gz
mv jbigkit-$VERSION jbigkit-$VERSION-orig

cp -rf ./jbigkit-$VERSION-new ./jbigkit-$VERSION

diff -b --unified -Nr  jbigkit-$VERSION-orig  jbigkit-$VERSION > jbigkit-$VERSION.patch

mv jbigkit-$VERSION.patch ../patches

rm -rf ./jbigkit-$VERSION
rm -rf ./jbigkit-$VERSION-orig
