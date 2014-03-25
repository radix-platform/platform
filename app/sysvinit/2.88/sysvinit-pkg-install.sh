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
  if [ -r sbin/init ]; then
    mv sbin/init sbin/init.old
  fi

  mv sbin/init.new sbin/init

  # Add a btmp file to store login failure if one doesn't exist:
  if [ ! -r var/log/btmp ]; then
    ( cd var/log ; umask 077 ; touch btmp )
  fi

  # Notice we use an absolute path below, rather than usr/bin/last. This is because
  # we're testing to see if we are on the bootdisk, which will not have /usr/bin/last.
  # If we aren't, we will signal init to restart using the new binary.
  # The presence of "/etc/radix-installer" is under consideration as a better test.
  if [ -x /usr/bin/last -a ! -r /etc/radix-installer ]; then
    /sbin/init u
  fi

  ( cd sbin ; rm -rf telinit )
  ( cd sbin ; ln -sf  init telinit )
  ( cd sbin ; rm -rf reboot )
  ( cd sbin ; ln -sf  halt reboot )
  ( cd sbin ; rm -rf pidof )
  ( cd sbin ; ln -sf killall5 pidof )
  ( cd sbin ; rm -rf poweroff )
  ( cd sbin ; ln -sf halt poweroff )

  rm -f sbin/init.old
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
