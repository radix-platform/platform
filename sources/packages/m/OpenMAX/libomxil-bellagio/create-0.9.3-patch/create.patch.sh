#!/bin/sh

VERSION=0.9.3

tar --files-from=file.list -xzvf ../libomxil-bellagio-$VERSION.tar.gz
mv libomxil-bellagio-$VERSION libomxil-bellagio-$VERSION-orig

cp -rf ./libomxil-bellagio-$VERSION-new ./libomxil-bellagio-$VERSION

diff -b --unified -Nr  libomxil-bellagio-$VERSION-orig  libomxil-bellagio-$VERSION > libomxil-bellagio-$VERSION.patch

mv libomxil-bellagio-$VERSION.patch ../patches

rm -rf ./libomxil-bellagio-$VERSION
rm -rf ./libomxil-bellagio-$VERSION-orig
