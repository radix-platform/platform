#!/bin/sh

VERSION=23.2

tar --files-from=file.list -xJvf ../psmisc-$VERSION.tar.xz
mv psmisc-$VERSION psmisc-$VERSION-orig

cp -rf ./psmisc-$VERSION-new ./psmisc-$VERSION

diff -b --unified -Nr  psmisc-$VERSION-orig  psmisc-$VERSION > psmisc-$VERSION-rpl-malloc.patch

mv psmisc-$VERSION-rpl-malloc.patch ../patches

rm -rf ./psmisc-$VERSION
rm -rf ./psmisc-$VERSION-orig
