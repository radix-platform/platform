#!/bin/sh

VERSION=2.0.11

tar --files-from=file.list -xzvf ../SDL_ttf-$VERSION.tar.gz
mv SDL_ttf-$VERSION SDL_ttf-$VERSION-orig

cp -rf ./SDL_ttf-$VERSION-new ./SDL_ttf-$VERSION

diff -b --unified -Nr  SDL_ttf-$VERSION-orig  SDL_ttf-$VERSION > SDL_ttf-$VERSION-automake.patch

mv SDL_ttf-$VERSION-automake.patch ../patches

rm -rf ./SDL_ttf-$VERSION
rm -rf ./SDL_ttf-$VERSION-orig
