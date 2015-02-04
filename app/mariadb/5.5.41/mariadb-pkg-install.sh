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
  # Keep same perms on rc.mysqld.new:
  if [ -e etc/rc.d/rc.mysqld ]; then
    cp -a etc/rc.d/rc.mysqld etc/rc.d/rc.mysqld.new.incoming
    cat etc/rc.d/rc.mysqld.new > etc/rc.d/rc.mysqld.new.incoming
    mv etc/rc.d/rc.mysqld.new.incoming etc/rc.d/rc.mysqld.new
  fi

  install_file etc/rc.d/rc.mysqld.new
  install_file etc/mysqlaccess.conf.new
  install_file etc/my.cnf.new
  install_file etc/my.cnf.d/client.cnf.new
  install_file etc/my.cnf.d/mysql-clients.cnf.new
  install_file etc/my.cnf.d/server.cnf.new
  install_file etc/logrotate.d/mysql.new
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
