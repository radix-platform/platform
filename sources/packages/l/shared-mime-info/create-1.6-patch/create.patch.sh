#!/bin/sh

VERSION=1.6

tar --files-from=file.list -xJvf ../shared-mime-info-$VERSION.tar.xz
mv shared-mime-info-$VERSION shared-mime-info-$VERSION-orig

cp -rf ./shared-mime-info-$VERSION-new ./shared-mime-info-$VERSION

diff -b --unified -Nr  shared-mime-info-$VERSION-orig  shared-mime-info-$VERSION > shared-mime-info-$VERSION.patch

mv shared-mime-info-$VERSION.patch ../patches

rm -rf ./shared-mime-info-$VERSION
rm -rf ./shared-mime-info-$VERSION-orig
