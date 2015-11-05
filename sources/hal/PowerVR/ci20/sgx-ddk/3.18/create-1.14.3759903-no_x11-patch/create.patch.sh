#!/bin/sh

VERSION=1.14.3759903

tar --files-from=file.list -xJvf ../ci20-sgx-um-$VERSION.tar.xz
mv ci20-sgx-um-$VERSION ci20-sgx-um-$VERSION-orig

cp -rf ./ci20-sgx-um-$VERSION-new ./ci20-sgx-um-$VERSION

diff -b --unified -Nr  ci20-sgx-um-$VERSION-orig  ci20-sgx-um-$VERSION > ci20-sgx-um-$VERSION-no_x11.patch

mv ci20-sgx-um-$VERSION-no_x11.patch ../patches

rm -rf ./ci20-sgx-um-$VERSION
rm -rf ./ci20-sgx-um-$VERSION-orig
