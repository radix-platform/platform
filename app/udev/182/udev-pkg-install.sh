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
  # Keep same perms on rc.udev.new:
  if [ -e etc/rc.d/rc.udev ]; then
    cp -a etc/rc.d/rc.udev etc/rc.d/rc.udev.new.incoming
    cat etc/rc.d/rc.udev.new > etc/rc.d/rc.udev.new.incoming
    mv etc/rc.d/rc.udev.new.incoming etc/rc.d/rc.udev.new
  fi

  # There's no reason for a user to edit rc.udev, so overwrite it:
  if [ -r etc/rc.d/rc.udev.new ]; then
    mv etc/rc.d/rc.udev.new etc/rc.d/rc.udev
  fi

  # This should catch *all* files in /etc/modprobe.d/ and move them over to
  # have .conf extensions
  for modfile in `ls etc/modprobe.d/ | grep -v "\.\(conf\|bak\|orig\|new\)"`; do
    if [ "$modfile" = README ]; then
      true # do nothing
    elif [ -e etc/modprobe.d/$modfile -a ! -e etc/modprobe.d/$modfile.conf ]; then
      mv etc/modprobe.d/$modfile etc/modprobe.d/$modfile.conf
    elif [ -e etc/modprobe.d/$modfile -a -e etc/modprobe.d/$modfile.conf ]; then
      mv etc/modprobe.d/$modfile etc/modprobe.d/$modfile.bak
    fi
  done
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
