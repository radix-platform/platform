#!/bin/sh

VERSION=0.1.2

tar --files-from=file.list -xJvf ../soxr-$VERSION-Source.tar.xz
mv soxr-$VERSION-Source soxr-$VERSION-Source-orig

cp -rf ./soxr-$VERSION-Source-new ./soxr-$VERSION-Source

diff -b --unified -Nr  soxr-$VERSION-Source-orig  soxr-$VERSION-Source > soxr-$VERSION-policy.patch

mv soxr-$VERSION-policy.patch ../patches

rm -rf ./soxr-$VERSION-Source
rm -rf ./soxr-$VERSION-Source-orig
