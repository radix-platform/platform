#!/bin/sh

VERSION=1.2.8

tar --files-from=file.list -xzvf ../SDL_net-$VERSION.tar.gz
mv SDL_net-$VERSION SDL_net-$VERSION-orig

cp -rf ./SDL_net-$VERSION-new ./SDL_net-$VERSION

diff -b --unified -Nr  SDL_net-$VERSION-orig  SDL_net-$VERSION > SDL_net-$VERSION-automake.patch

mv SDL_net-$VERSION-automake.patch ../patches

rm -rf ./SDL_net-$VERSION
rm -rf ./SDL_net-$VERSION-orig
