#!/bin/sh

VERSION=1.10.13

mkdir Botan-$VERSION-orig

cp -rf ./Botan-$VERSION-new ./Botan-$VERSION

diff -b --unified -Nr  Botan-$VERSION-orig  Botan-$VERSION > Botan-$VERSION-aarch64.patch

mv Botan-$VERSION-aarch64.patch ../patches

rm -rf ./Botan-$VERSION
rm -rf ./Botan-$VERSION-orig
