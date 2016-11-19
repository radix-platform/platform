#!/bin/sh

VERSION=3.3.5

tar --files-from=file.list -xzvf ../fftw-$VERSION.tar.gz
mv fftw-$VERSION fftw-$VERSION-orig

cp -rf ./fftw-$VERSION-new ./fftw-$VERSION

diff -b --unified -Nr  fftw-$VERSION-orig  fftw-$VERSION > fftw-$VERSION-arm-cross.patch

mv fftw-$VERSION-arm-cross.patch ../patches

rm -rf ./fftw-$VERSION
rm -rf ./fftw-$VERSION-orig
