#!/bin/sh

VERSION=1.634

tar --files-from=file.list -xzvf ../DBI-$VERSION.tar.gz
mv DBI-$VERSION DBI-$VERSION-orig

cp -rf ./DBI-$VERSION-new ./DBI-$VERSION

diff -b --unified -Nr  DBI-$VERSION-orig  DBI-$VERSION > DBI-$VERSION-prev-inst-warn.patch

mv DBI-$VERSION-prev-inst-warn.patch ../patches

rm -rf ./DBI-$VERSION
rm -rf ./DBI-$VERSION-orig
