#!/bin/sh

VERSION=1.0.2

tar --files-from=file.list -xjvf ../libnetfilter_acct-$VERSION.tar.bz2
mv libnetfilter_acct-$VERSION libnetfilter_acct-$VERSION-orig

cp -rf ./libnetfilter_acct-$VERSION-new ./libnetfilter_acct-$VERSION

diff -b --unified -Nr  libnetfilter_acct-$VERSION-orig  libnetfilter_acct-$VERSION > libnetfilter_acct-$VERSION-automake.patch

mv libnetfilter_acct-$VERSION-automake.patch ../patches

rm -rf ./libnetfilter_acct-$VERSION
rm -rf ./libnetfilter_acct-$VERSION-orig
