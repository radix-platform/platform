#!/bin/sh

VERSION=1.5.0

tar --files-from=file.list -xjvf ../xf86-input-penmount-$VERSION.tar.bz2
mv xf86-input-penmount-$VERSION xf86-input-penmount-$VERSION-orig

cp -rf ./xf86-input-penmount-$VERSION-new ./xf86-input-penmount-$VERSION

diff -b --unified -Nr  xf86-input-penmount-$VERSION-orig  xf86-input-penmount-$VERSION > xf86-input-penmount-$VERSION-automake.patch

mv xf86-input-penmount-$VERSION-automake.patch ../patches

rm -rf ./xf86-input-penmount-$VERSION
rm -rf ./xf86-input-penmount-$VERSION-orig
