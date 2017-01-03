#!/bin/sh

VERSION=1.6.2

tar --files-from=file.list -xjvf ../xf86-input-joystick-$VERSION.tar.bz2
mv xf86-input-joystick-$VERSION xf86-input-joystick-$VERSION-orig

cp -rf ./xf86-input-joystick-$VERSION-new ./xf86-input-joystick-$VERSION

diff -b --unified -Nr  xf86-input-joystick-$VERSION-orig  xf86-input-joystick-$VERSION > xf86-input-joystick-$VERSION-automake.patch

mv xf86-input-joystick-$VERSION-automake.patch ../patches

rm -rf ./xf86-input-joystick-$VERSION
rm -rf ./xf86-input-joystick-$VERSION-orig
