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
  # Keep same perms on rc.bind.new:
  if [ -e etc/rc.d/rc.bind ]; then
    cp -a etc/rc.d/rc.bind etc/rc.d/rc.bind.new.incoming
    cat etc/rc.d/rc.bind.new > etc/rc.d/rc.bind.new.incoming
    mv etc/rc.d/rc.bind.new.incoming etc/rc.d/rc.bind.new
  fi

  install_file etc/named.conf.new
  install_file etc/rc.d/rc.bind.new

  # Add a /var/named if it doesn't exist:
  if [ ! -d var/named ]; then
    mkdir -p var/named
    chmod 755 var/named
  fi

  # Generate /etc/rndc.key if there's none there, and there also no /etc/rndc.conf
  # (the other way to set this up).
  #
  # Also we have to check that we are not in the installer mode on the target system
  # ("/etc/system-installer"), and we have to be sure that we are on the working system
  # on the target hardware ("proc/sys/kernel/osrelease" - relative path).
  if [ -r proc/sys/kernel/osrelease -a ! -r /etc/system-installer -a ! -r /etc/rndc.key -a ! -r /etc/rndc.conf ]; then
    /sbin/ldconfig
    /usr/sbin/rndc-confgen -r /dev/urandom -a 2> /dev/null
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
