#!/bin/sh

# arg 1:  the new package version
pre_install() {
  /bin/true
}

# arg 1:  the new package version
post_install() {
  if ! grep "^utmp:" etc/group 1> /dev/null 2> /dev/null ; then
    if ! grep ":22:" etc/group 1> /dev/null 2> /dev/null ; then
      # we'll be adding this in the etc package anyway.
      echo "utmp::22:" >> etc/group
    fi
  fi
  if [ -r var/run/utmp ] ; then
    chmod 664 var/run/utmp
  fi
  if [ -r var/log/wtmp ] ; then
    chmod 664 var/log/wtmp
  fi
}

# arg 1:  the new package version
# arg 2:  the old package version
pre_upgrade() {
  /bin/true
}

# arg 1:  the new package version
# arg 2:  the old package version
post_upgrade() {
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
