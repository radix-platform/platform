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
  # Keep same perms on rc.snmpd.new:
  if [ -e etc/rc.d/rc.snmpd ]; then
    cp -a etc/rc.d/rc.snmpd etc/rc.d/rc.snmpd.new.incoming
    cat etc/rc.d/rc.snmpd.new > etc/rc.d/rc.snmpd.new.incoming
    mv etc/rc.d/rc.snmpd.new.incoming etc/rc.d/rc.snmpd.new
  fi

  install_file etc/snmp/snmpd.conf.new
  install_file etc/rc.d/rc.snmpd.new
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
