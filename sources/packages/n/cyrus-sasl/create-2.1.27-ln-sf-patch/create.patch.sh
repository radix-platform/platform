#!/bin/sh

VERSION=2.1.27

tar --files-from=file.list -xzvf ../cyrus-sasl-$VERSION.tar.gz
mv cyrus-sasl-$VERSION cyrus-sasl-$VERSION-orig

cp -rf ./cyrus-sasl-$VERSION-new ./cyrus-sasl-$VERSION

diff -b --unified -Nr  cyrus-sasl-$VERSION-orig  cyrus-sasl-$VERSION > cyrus-sasl-$VERSION-ln-sf.patch

mv cyrus-sasl-$VERSION-ln-sf.patch ../patches

rm -rf ./cyrus-sasl-$VERSION
rm -rf ./cyrus-sasl-$VERSION-orig
