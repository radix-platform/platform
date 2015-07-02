#!/bin/sh

# arg 1:  the new package version
pre_install() {
  if [ -f etc/X11/xkb/symbols/pc ]; then
    mv etc/X11/xkb etc/X11/xkb.old.bak.$$
    mkdir -p etc/X11/xkb/rules
  fi
}

# arg 1:  the new package version
post_install() {
  /bin/true
}

# arg 1:  the new package version
# arg 2:  the old package version
pre_update() {
  pre_install
}

# arg 1:  the new package version
# arg 2:  the old package version
post_update() {
  post_install
}

# arg 1:  the old package version
pre_remove() {
  /bin/true
}

# arg 1:  the old package version
post_remove() {
  /bin/true
}


operation=$1
shift

$operation $*
