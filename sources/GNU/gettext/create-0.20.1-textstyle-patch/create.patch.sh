#!/bin/sh

VERSION=0.20.1

tar --files-from=file.list -xJvf ../gettext-$VERSION.tar.xz
mv gettext-$VERSION gettext-$VERSION-orig

cp -rf ./gettext-$VERSION-new ./gettext-$VERSION

diff -b --unified -Nr  gettext-$VERSION-orig  gettext-$VERSION > gettext-$VERSION-textstyle.patch

mv gettext-$VERSION-textstyle.patch ../patches

rm -rf ./gettext-$VERSION
rm -rf ./gettext-$VERSION-orig
