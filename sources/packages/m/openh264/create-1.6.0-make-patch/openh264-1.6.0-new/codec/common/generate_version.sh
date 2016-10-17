#!/bin/bash

if [ -f $SRC_PATH/.git-revision ] ; then
  . $SRC_PATH/.git-revision
  VER="`echo $REVISION | cut -c 1-7`"
else
  VER="x"
fi
GIT_VERSION='"'$VER'"'

mkdir -p codec/common/inc
cat $SRC_PATH/codec/common/inc/version_gen.h.template | sed "s/\$FULL_VERSION/$GIT_VERSION/g" > codec/common/inc/version_gen.h.new
if cmp codec/common/inc/version_gen.h.new codec/common/inc/version_gen.h > /dev/null 2>&1; then
    # Identical to old version, don't touch it (to avoid unnecessary rebuilds)
    rm codec/common/inc/version_gen.h.new
    echo "Keeping existing codec/common/inc/version_gen.h"
    exit 0
fi
mv codec/common/inc/version_gen.h.new codec/common/inc/version_gen.h

echo "Generated codec/common/inc/version_gen.h"
