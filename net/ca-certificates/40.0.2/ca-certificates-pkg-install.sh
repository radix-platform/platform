#!/bin/sh

# Preserve new files
install_file() {
  NEW="$1"
  OLD="`dirname $NEW`/`basename $NEW .new`"
  # If there's no file by that name, mv it over:
  if [ ! -r $OLD ]; then
    mv $NEW $OLD
  elif [ "`cat $OLD | md5sum`" = "`cat $NEW | md5sum`" ]; then # toss the redundant copy
    rm $NEW
  fi
  # Otherwise, we leave the .new copy for the admin to consider...
}


# arg 1:  the new package version
pre_install() {
  /bin/true
}

# arg 1:  the new package version
post_install() {
  install_file etc/ca-certificates.conf.new

  # Notice we use an absolute path below, rather than usr/sbin/update-ca-certificates.
  # This is because we're testing to see if we are on the bootdisk, which will not have
  # /usr/sbin/update-ca-certificates.
  # Also we have to check that we are not in the installer mode on the target system
  # ("/etc/system-installer"), and we have to be sure that we are on the working system
  # on the target hardware ("proc/sys/kernel/osrelease" - relative path).
  if [ -r proc/sys/kernel/osrelease -a ! -r /etc/system-installer -a -x /usr/sbin/update-ca-certificates ]; then
    /usr/sbin/update-ca-certificates --fresh 1> /dev/null 2> /dev/null
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
