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
  # If there is a known buggy certwatch script with no local modifications, just replace it:
  if [ "$(md5sum etc/cron.daily/certwatch 2> /dev/null)" = "033974b7e9669fe30996c02fc4fcb66a  etc/cron.daily/certwatch" ]; then
    cat etc/cron.daily/certwatch.new > etc/cron.daily/certwatch
    touch -r etc/cron.daily/certwatch.new etc/cron.daily/certwatch
  fi

  install_file etc/ssl/openssl.cnf.new
  install_file etc/cron.daily/certwatch.new

  # Rehash certificates if the package is upgraded on a running system:
  # Note that we have to be sure that we are on the working system
  # on the target hardware ("proc/sys/kernel/osrelease" - relative path).
  if [ -r proc/sys/kernel/osrelease -a -x /usr/bin/c_rehash ]; then
    /usr/bin/c_rehash 1> /dev/null 2> /dev/null
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
