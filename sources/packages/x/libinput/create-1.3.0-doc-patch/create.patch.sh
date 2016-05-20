#!/bin/sh

VERSION=1.3.0

tar --files-from=file.list -xJvf ../libinput-$VERSION.tar.xz
mv libinput-$VERSION libinput-$VERSION-orig

cp -rf ./libinput-$VERSION-new ./libinput-$VERSION

diff -b --unified -Nr  libinput-$VERSION-orig  libinput-$VERSION > libinput-$VERSION-doc.patch

mv libinput-$VERSION-doc.patch ../patches

rm -rf ./libinput-$VERSION
rm -rf ./libinput-$VERSION-orig
