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
  install_file etc/logrotate.d/syslog.new
  install_file etc/syslog.conf.new
  install_file etc/rc.d/rc.syslog.new
  install_file var/log/cron.new
  install_file var/log/debug.new
  install_file var/log/maillog.new
  install_file var/log/messages.new
  install_file var/log/secure.new
  install_file var/log/spooler.new
  install_file var/log/syslog.new

  # Remove any leftover empty files:
  rm -f var/log/cron.new
  rm -f var/log/debug.new
  rm -f var/log/maillog.new
  rm -f var/log/messages.new
  rm -f var/log/secure.new
  rm -f var/log/spooler.new
  rm -f var/log/syslog.new
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
