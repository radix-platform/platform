#!/bin/sh

VERSION=1.2.12

tar --files-from=file.list -xzvf ../SDL_mixer-$VERSION.tar.gz
mv SDL_mixer-$VERSION SDL_mixer-$VERSION-orig

cp -rf ./SDL_mixer-$VERSION-new ./SDL_mixer-$VERSION

diff -b --unified -Nr  SDL_mixer-$VERSION-orig  SDL_mixer-$VERSION > SDL_mixer-$VERSION-automake.patch

mv SDL_mixer-$VERSION-automake.patch ../patches

rm -rf ./SDL_mixer-$VERSION
rm -rf ./SDL_mixer-$VERSION-orig
