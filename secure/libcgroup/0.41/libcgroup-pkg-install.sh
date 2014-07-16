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
  # Leave any new rc files with the same permissions as the old ones:
  if [ -e etc/rc.d/rc.cgconfig ]; then
    if [ -x etc/rc.d/rc.cgconfig ]; then
      chmod 755 etc/rc.d/rc.cgconfig.new
    else
      chmod 644 etc/rc.d/rc.cgconfig.new
    fi
  fi
  if [ -e etc/rc.d/rc.cgred ]; then
    if [ -x etc/rc.d/rc.cgred ]; then
      chmod 755 etc/rc.d/rc.cgred.new
    else
      chmod 644 etc/rc.d/rc.cgred.new
    fi
  fi

  # Then install_file() them:
  install_file etc/rc.d/rc.cgconfig.new
  install_file etc/rc.d/rc.cgred.new

  # install_file() the other configuration files:
  install_file etc/cgconfig.conf.new
  install_file etc/cgred.conf.new
  install_file etc/cgrules.conf.new
  install_file etc/cgsnapshot_blacklist.conf.new

  # If there are already installed config files, get rid of the .new ones.
  # There will still be fresh samples in the docs.
  rm -f etc/cgconfig.conf.new etc/cgred.conf.new etc/cgrules.conf.new etc/cgsnapshot_blacklist.conf.new
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
