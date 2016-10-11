#!/bin/sh

VERSION=9.0

tar --files-from=file.list -xJvf ../pulseaudio-$VERSION.tar.xz
mv pulseaudio-$VERSION pulseaudio-$VERSION-orig

cp -rf ./pulseaudio-$VERSION-new ./pulseaudio-$VERSION

diff -b --unified -Nr  pulseaudio-$VERSION-orig  pulseaudio-$VERSION > pulseaudio-$VERSION-root-autospawn.patch

mv pulseaudio-$VERSION-root-autospawn.patch ../patches

rm -rf ./pulseaudio-$VERSION
rm -rf ./pulseaudio-$VERSION-orig
