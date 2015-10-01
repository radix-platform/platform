#!/bin/sh

VERSION=0.99

tar --files-from=file.list -xzvf ../XML-SAX-$VERSION.tar.gz
mv XML-SAX-$VERSION XML-SAX-$VERSION-orig

cp -rf ./XML-SAX-$VERSION-new ./XML-SAX-$VERSION

diff -b --unified -Nr  XML-SAX-$VERSION-orig  XML-SAX-$VERSION > XML-SAX-$VERSION-no.patch

mv XML-SAX-$VERSION-no.patch ../patches

rm -rf ./XML-SAX-$VERSION
rm -rf ./XML-SAX-$VERSION-orig
