#!/bin/sh

VERSION=3.9.1

tar --files-from=file.list -xzvf ../logrotate-$VERSION.tar.gz
mv logrotate-$VERSION logrotate-$VERSION-orig

cp -rf ./logrotate-$VERSION-new ./logrotate-$VERSION

diff -b --unified -Nr  logrotate-$VERSION-orig logrotate-$VERSION > logrotate-$VERSION.patch

mv logrotate-$VERSION.patch ../patches

rm -rf ./logrotate-$VERSION
rm -rf ./logrotate-$VERSION-orig
