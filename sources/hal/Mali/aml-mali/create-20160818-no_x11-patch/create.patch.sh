#!/bin/sh

VERSION=20160818

tar --files-from=file.list -xJvf ../aml-mali-$VERSION.tar.xz
mv aml-mali-$VERSION aml-mali-$VERSION-orig

cp -rf ./aml-mali-$VERSION-new ./aml-mali-$VERSION

diff -b --unified -Nr  aml-mali-$VERSION-orig  aml-mali-$VERSION > aml-mali-$VERSION-no_x11.patch

mv aml-mali-$VERSION-no_x11.patch ../patches

rm -rf ./aml-mali-$VERSION
rm -rf ./aml-mali-$VERSION-orig
