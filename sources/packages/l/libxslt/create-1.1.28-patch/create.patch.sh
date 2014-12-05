#!/bin/sh

VERSION=1.1.28

tar --files-from=file.list -xzvf ../libxslt-$VERSION.tar.gz
mv libxslt-$VERSION libxslt-$VERSION-orig

cp -rf ./libxslt-$VERSION-new ./libxslt-$VERSION

diff -b --unified -Nr  libxslt-$VERSION-orig  libxslt-$VERSION > libxslt-$VERSION.patch

mv libxslt-$VERSION.patch ../patches

rm -rf ./libxslt-$VERSION
rm -rf ./libxslt-$VERSION-orig
