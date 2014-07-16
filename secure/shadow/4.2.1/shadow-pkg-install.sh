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
  install_file etc/pam.d/chage.new
  install_file etc/pam.d/chgpasswd.new
  install_file etc/pam.d/chpasswd.new
  install_file etc/pam.d/groupadd.new
  install_file etc/pam.d/groupdel.new
  install_file etc/pam.d/groupmems.new
  install_file etc/pam.d/groupmod.new
  install_file etc/pam.d/newusers.new
  install_file etc/pam.d/passwd.new
  install_file etc/pam.d/shadow.new
  install_file etc/pam.d/useradd.new
  install_file etc/pam.d/userdel.new
  install_file etc/pam.d/usermod.new

  install_file etc/login.defs.new

  install_file var/log/faillog.new
  install_file var/log/lastlog.new
  rm -f var/log/faillog.new
  rm -f var/log/lastlog.new
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
