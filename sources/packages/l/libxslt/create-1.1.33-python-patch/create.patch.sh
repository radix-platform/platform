#!/bin/sh

VERSION=1.1.33

tar --files-from=file.list -xzvf ../libxslt-$VERSION.tar.gz
mv libxslt-$VERSION libxslt-$VERSION-orig

cp -rf ./libxslt-$VERSION-new ./libxslt-$VERSION

diff -b --unified -Nr  libxslt-$VERSION-orig  libxslt-$VERSION > libxslt-$VERSION-python.patch

mv libxslt-$VERSION-python.patch ../patches

rm -rf ./libxslt-$VERSION
rm -rf ./libxslt-$VERSION-orig
