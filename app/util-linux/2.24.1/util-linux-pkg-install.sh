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
  # Keep same perms on rc.serial.new:
  if [ -e etc/rc.d/rc.serial ]; then
    cp -a etc/rc.d/rc.serial etc/rc.d/rc.serial.new.incoming
    cat etc/rc.d/rc.serial.new > etc/rc.d/rc.serial.new.incoming
    mv etc/rc.d/rc.serial.new.incoming etc/rc.d/rc.serial.new
  fi

  install_file etc/rc.d/rc.serial.new
  install_file etc/serial.conf.new

  # We use an relative path to 'proc/sys/kernel/osrelease' because we have to be sure
  # that we are running on the target platform. Only in this case we will use
  # absolute path to coreutils ('/bin/chgrp' and '/bin/chmod') and we have to check
  # is the coreutils already installed.
  if [ -r proc/sys/kernel/osrelease -a -x /bin/chgrp -a -x /bin/chmod ]; then
    /bin/chgrp tty /usr/bin/wall
    /bin/chmod g+s /usr/bin/wall
    /bin/chgrp tty /usr/bin/write
    /bin/chmod g+s /usr/bin/write
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
