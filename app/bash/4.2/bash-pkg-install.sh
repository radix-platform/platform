#!/bin/sh

# arg 1:  the new package version
pre_install() {
  /bin/true
}

# arg 1:  the new package version
post_install() {
  if [ -r bin/bash ]; then
    mv bin/bash bin/bash.old
  fi
  mv bin/bash4.new bin/bash
  if [ -f bin/bash.old ]; then
    rm -f bin/bash.old
  fi
  if [ ! -r etc/shells ]; then
    touch etc/shells
    chmod 644 etc/shells
  fi
  if grep -wq bin/bash etc/shells ; then
    true
  else
    echo "/bin/bash" >> etc/shells
  fi
  ( cd usr/bin ; rm -rf bash )
  ( cd usr/bin ; ln -sf ../../bin/bash bash )
  if [ ! -r bin/sh -a ! -L bin/sh ]; then
    ( cd bin ; ln -sf bash sh )
  fi
}

# arg 1:  the new package version
# arg 2:  the old package version
pre_update() {
  /bin/true
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
