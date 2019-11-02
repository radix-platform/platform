#!/bin/sh

VERSION=1.13.1

tar --files-from=file.list -xjvf ../gpgme-$VERSION.tar.bz2
mv gpgme-$VERSION gpgme-$VERSION-orig

cp -rf ./gpgme-$VERSION-new ./gpgme-$VERSION

diff -b --unified -Nr  gpgme-$VERSION-orig  gpgme-$VERSION > gpgme-$VERSION-python-cross.patch

mv gpgme-$VERSION-python-cross.patch ../patches

rm -rf ./gpgme-$VERSION
rm -rf ./gpgme-$VERSION-orig
