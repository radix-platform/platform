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
  install_file etc/gtk-2.0/gtkrc.new
  install_file etc/gtk-2.0/im-multipress.conf.new
  rm -f etc/gtk-2.0/gtkrc.new

  # Notice we use an absolute path below, rather than usr/bin/update-gdk-pixbuf-loaders
  # or usr/bin/update-gtk-immodules .
  # Also we have to check that we are not in the installer mode on the target system
  # ("/etc/system-installer"), and we have to be sure that we are on the working system
  # on the target hardware ("proc/sys/kernel/osrelease" - relative path).

  if [ -r proc/sys/kernel/osrelease -a ! -r /etc/system-installer ]; then
    rm -f /usr/share/icons/*/icon-theme.cache 1> /dev/null 2> /dev/null
  fi

  # Run this if we are on an installed system. Otherwise it will be handled on first boot.
  if [ -r proc/sys/kernel/osrelease -a ! -r /etc/system-installer -a -x /usr/bin/update-gtk-immodules-2.0 ]; then
    /usr/bin/update-gtk-immodules
  fi

  # Run this if we are on an installed system. Otherwise it will be handled on first boot.
  if [ -r proc/sys/kernel/osrelease -a ! -r /etc/system-installer -a -x /usr/bin/update-gdk-pixbuf-loaders ]; then
    /usr/bin/update-gdk-pixbuf-loaders 1> /dev/null 2> /dev/null
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
