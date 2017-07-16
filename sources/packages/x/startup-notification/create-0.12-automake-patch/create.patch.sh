#!/bin/sh

VERSION=0.12

tar --files-from=file.list -xzvf ../startup-notification-$VERSION.tar.gz
mv startup-notification-$VERSION startup-notification-$VERSION-orig

cp -rf ./startup-notification-$VERSION-new ./startup-notification-$VERSION

diff -b --unified -Nr  startup-notification-$VERSION-orig  startup-notification-$VERSION > startup-notification-$VERSION-automake.patch

mv startup-notification-$VERSION-automake.patch ../patches

rm -rf ./startup-notification-$VERSION
rm -rf ./startup-notification-$VERSION-orig
