#!/bin/sh

VERSION=0.1.8

tar --files-from=file.list -xzvf ../libsamplerate-$VERSION.tar.gz
mv libsamplerate-$VERSION libsamplerate-$VERSION-orig

cp -rf ./libsamplerate-$VERSION-new ./libsamplerate-$VERSION

diff -b --unified -Nr  libsamplerate-$VERSION-orig  libsamplerate-$VERSION > libsamplerate-$VERSION-automake.patch

mv libsamplerate-$VERSION-automake.patch ../patches

rm -rf ./libsamplerate-$VERSION
rm -rf ./libsamplerate-$VERSION-orig
