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
  install_file etc/HOSTNAME.new
  install_file etc/csh.login.new
  install_file etc/filesystems.new
  install_file etc/fstab.new
  install_file etc/hosts.new
  install_file etc/group.new
  install_file etc/gshadow.new
  install_file etc/inittab.new
  install_file etc/inputrc.new
  install_file etc/issue.new
  install_file etc/issue.net.new
  install_file etc/networks.new
  install_file etc/nsswitch.conf.new
  install_file etc/passwd.new
  install_file etc/printcap.new
  install_file etc/profile.new
  install_file etc/securetty.new
  install_file etc/services.new
  install_file etc/shadow.new
  install_file etc/shells.new
  install_file etc/termcap.new

  install_file etc/profile.d/lang.csh.new
  install_file etc/profile.d/lang.sh.new

  install_file etc/rc.d/rc.4.new
  install_file etc/rc.d/rc.6.new
  install_file etc/rc.d/rc.K.new
  install_file etc/rc.d/rc.M.new
  install_file etc/rc.d/rc.S.new

  install_file etc/rc.d/rc.local.new
  install_file etc/rc.d/rc.local_shutdown.new
  install_file etc/rc.d/rc.loop.new
  install_file etc/rc.d/rc.sysvinit.new

  install_file var/log/lastlog.new

  install_file etc/ld.so.conf.new

  # not fully finished stuff - depends on app/kbd, app/gpm, and kernel modules:
  install_file etc/rc.d/rc.font.new
  install_file etc/rc.d/rc.gpm.new
  install_file etc/rc.d/rc.keymap.new
  install_file etc/rc.d/rc.modules.new

  ( cd etc/rc.d ; rm -rf rc.0 )
  ( cd etc/rc.d ; ln -sf rc.6 rc.0 )
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
