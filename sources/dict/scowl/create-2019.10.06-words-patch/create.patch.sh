#!/bin/sh

VERSION=2019.10.06

tar --files-from=file.list -xzvf ../scowl-$VERSION.tar.gz
mv scowl-$VERSION scowl-$VERSION-orig

cp -rf ./scowl-$VERSION-new ./scowl-$VERSION

diff -b --unified -Nr  scowl-$VERSION-orig  scowl-$VERSION > scowl-$VERSION-words.patch

mv scowl-$VERSION-words.patch ../patches

rm -rf ./scowl-$VERSION
rm -rf ./scowl-$VERSION-orig
