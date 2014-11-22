#!/bin/sh

VERSION=1.3.1

tar --files-from=file.list -xzvf ../libjpeg-turbo-$VERSION.tar.gz
mv libjpeg-turbo-$VERSION libjpeg-turbo-$VERSION-orig

cp -rf ./libjpeg-turbo-$VERSION-new ./libjpeg-turbo-$VERSION

diff -b --unified -Nr  libjpeg-turbo-$VERSION-orig  libjpeg-turbo-$VERSION > libjpeg-turbo-$VERSION-jstdhuff.patch

mv libjpeg-turbo-$VERSION-jstdhuff.patch ../patches

rm -rf ./libjpeg-turbo-$VERSION
rm -rf ./libjpeg-turbo-$VERSION-orig
