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
  install_file etc/ssh/ssh_config.new
  install_file etc/ssh/sshd_config.new
  install_file etc/rc.d/rc.sshd.new

  # If the sshd user/group/shadow don't exist, add them:
  if ! grep -q "^sshd:" etc/passwd -o ! -r etc/passwd ; then
    echo "sshd:x:33:33:sshd:/:" >> etc/passwd
  fi

  if ! grep -q "^sshd:" etc/group -o ! -r etc/group ; then
    echo "sshd::33:sshd" >> etc/group
  fi

  if ! grep -q "^sshd:" etc/shadow -o ! -r etc/shadow ; then
    echo "sshd:*:9797:0:::::" >> etc/shadow
  fi

  # Add a btmp file to store login failure if one doesn't exist:
  if [ ! -r var/log/btmp ]; then
    ( cd var/log ; umask 077 ; touch btmp )
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
