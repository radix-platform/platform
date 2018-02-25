#!/bin/sh

VERSION=1.1

tar --files-from=file.list -xJvf ../ppl-$VERSION.tar.xz
mv ppl-$VERSION ppl-$VERSION-orig

cp -rf ./ppl-$VERSION-new ./ppl-$VERSION

diff -b --unified -Nr  ppl-$VERSION-orig  ppl-$VERSION > ppl-$VERSION-ptrdiff.patch

mv ppl-$VERSION-ptrdiff.patch ../patches

rm -rf ./ppl-$VERSION
rm -rf ./ppl-$VERSION-orig
