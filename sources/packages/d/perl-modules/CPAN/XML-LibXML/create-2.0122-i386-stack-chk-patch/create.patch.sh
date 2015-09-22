#!/bin/sh

VERSION=2.0122

tar --files-from=file.list -xzvf ../XML-LibXML-$VERSION.tar.gz
mv XML-LibXML-$VERSION XML-LibXML-$VERSION-orig

cp -rf ./XML-LibXML-$VERSION-new ./XML-LibXML-$VERSION

diff -b --unified -Nr  XML-LibXML-$VERSION-orig  XML-LibXML-$VERSION > XML-LibXML-$VERSION-i386-stack-chk.patch

mv XML-LibXML-$VERSION-i386-stack-chk.patch ../patches

rm -rf ./XML-LibXML-$VERSION
rm -rf ./XML-LibXML-$VERSION-orig
