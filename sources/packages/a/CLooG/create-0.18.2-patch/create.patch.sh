#!/bin/sh

VERSION=0.18.2

mkdir cloog-$VERSION-orig

cp -rf ./cloog-$VERSION-new ./cloog-$VERSION

diff -b --unified -Nr  cloog-$VERSION-orig  cloog-$VERSION > cloog-$VERSION.patch

mv cloog-$VERSION.patch ../patches

rm -rf ./cloog-$VERSION
rm -rf ./cloog-$VERSION-orig
