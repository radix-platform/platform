#!/bin/sh

VERSION=2.44

tar --files-from=file.list -xzvf ../XML-Parser-$VERSION.tar.gz
mv XML-Parser-$VERSION XML-Parser-$VERSION-orig

cp -rf ./XML-Parser-$VERSION-new ./XML-Parser-$VERSION

diff -b --unified -Nr  XML-Parser-$VERSION-orig  XML-Parser-$VERSION > XML-Parser-$VERSION-cross.patch

mv XML-Parser-$VERSION-cross.patch ../patches

rm -rf ./XML-Parser-$VERSION
rm -rf ./XML-Parser-$VERSION-orig
