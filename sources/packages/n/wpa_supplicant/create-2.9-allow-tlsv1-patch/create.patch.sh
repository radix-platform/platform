#!/bin/sh

VERSION=2.9

tar --files-from=file.list -xzvf ../wpa_supplicant-$VERSION.tar.gz
mv wpa_supplicant-$VERSION wpa_supplicant-$VERSION-orig

cp -rf ./wpa_supplicant-$VERSION-new ./wpa_supplicant-$VERSION

diff -b --unified -Nr  wpa_supplicant-$VERSION-orig  wpa_supplicant-$VERSION > wpa_supplicant-$VERSION-allow-tlsv1.patch

mv wpa_supplicant-$VERSION-allow-tlsv1.patch ../patches

rm -rf ./wpa_supplicant-$VERSION
rm -rf ./wpa_supplicant-$VERSION-orig
