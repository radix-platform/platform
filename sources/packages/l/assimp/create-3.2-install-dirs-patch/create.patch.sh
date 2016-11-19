#!/bin/sh

VERSION=3.2

tar --files-from=file.list -xJvf ../assimp-$VERSION.tar.xz
mv assimp-$VERSION assimp-$VERSION-orig

cp -rf ./assimp-$VERSION-new ./assimp-$VERSION

diff -b --unified -Nr  assimp-$VERSION-orig  assimp-$VERSION > assimp-$VERSION-install-dirs.patch

mv assimp-$VERSION-install-dirs.patch ../patches

rm -rf ./assimp-$VERSION
rm -rf ./assimp-$VERSION-orig
