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
  install_file etc/dbus-1/system.d/cups.conf.new

  install_file etc/cups/cups-files.conf.default.new
  install_file etc/cups/cups-files.conf.new
  install_file etc/cups/snmp.conf.default.new
  install_file etc/cups/snmp.conf.new
  install_file etc/cups/cupsd.conf.default.new
  install_file etc/cups/cupsd.conf.new

  if [ -e etc/rc.d/rc.cups ]; then
    if [ -x etc/rc.d/rc.cups ]; then
      chmod 755 etc/rc.d/rc.cups.new
    else
      chmod 644 etc/rc.d/rc.cups.new
    fi
  fi
  install_file etc/rc.d/rc.cups.new

  if [ -x usr/bin/xdg-icon-resource ]; then
    xdg-icon-resource forceupdate --theme hicolor 2> /dev/null
  fi

  # Update desktop database
  if [ -x /usr/bin/update-desktop-database ]; then
    /usr/bin/update-desktop-database -q usr/share/applications > /dev/null 2>&1
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
  if [ -x usr/bin/xdg-icon-resource ]; then
    xdg-icon-resource forceupdate --theme hicolor 2> /dev/null
  fi
}


operation=$1
shift

$operation $*
