#!/bin/sh

VERSION=19_20140130

tar --files-from=file.list -xzvf ../pa_stable_v$VERSION.tgz
mv portaudio portaudio-orig

cp -rf ./portaudio-new ./portaudio

diff -b --unified -Nr  portaudio-orig  portaudio > portaudio-$VERSION-automake.patch

mv portaudio-$VERSION-automake.patch ../patches

rm -rf ./portaudio
rm -rf ./portaudio-orig
