#!/bin/sh

VERSION=2.1.23

tar --files-from=file.list -xzvf ../cyrus-sasl-$VERSION.tar.gz
mv cyrus-sasl-$VERSION cyrus-sasl-$VERSION-orig

cp -rf ./cyrus-sasl-$VERSION-new ./cyrus-sasl-$VERSION

diff -b --unified -Nr  cyrus-sasl-$VERSION-orig  cyrus-sasl-$VERSION > cyrus-sasl-$VERSION.patch

mv cyrus-sasl-$VERSION.patch ../patches

rm -rf ./cyrus-sasl-$VERSION
rm -rf ./cyrus-sasl-$VERSION-orig
