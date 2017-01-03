#!/bin/sh

VERSION=1.2.12

tar --files-from=file.list -xzvf ../SDL_image-$VERSION.tar.gz
mv SDL_image-$VERSION SDL_image-$VERSION-orig

cp -rf ./SDL_image-$VERSION-new ./SDL_image-$VERSION

diff -b --unified -Nr  SDL_image-$VERSION-orig  SDL_image-$VERSION > SDL_image-$VERSION-automake.patch

mv SDL_image-$VERSION-automake.patch ../patches

rm -rf ./SDL_image-$VERSION
rm -rf ./SDL_image-$VERSION-orig
