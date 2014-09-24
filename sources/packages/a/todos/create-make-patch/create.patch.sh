#!/bin/sh

VERSION=none

tar --files-from=file.list -xzvf ../todos.tar.gz
mv todos todos-orig

cp -rf ./todos-new ./todos

diff -b --unified -Nr  todos-orig  todos > todos.patch

mv todos.patch ../patches

rm -rf ./todos
rm -rf ./todos-orig
