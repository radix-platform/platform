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
  if [ -r etc/asound.state -a ! -r var/lib/alsa/asound.state -a ! -L etc/asound.state ]; then
    mv etc/asound.state var/lib/alsa
  fi
  # Better a dangling symlink than for nobody to know where this went:
  rm -f etc/asound.state
  ( cd etc && ln -sf ../var/lib/alsa/asound.state . )

  # Duplicate permissions from any existing rc scripts:
  if [ -e etc/rc.d/rc.alsa ]; then
    if [ -x etc/rc.d/rc.alsa ]; then
      chmod 755 etc/rc.d/rc.alsa.new
    else
      chmod 644 etc/rc.d/rc.alsa.new
    fi
  fi
  if [ -e etc/rc.d/rc.alsa-oss ]; then
    if [ -x etc/rc.d/rc.alsa-oss ]; then
      chmod 755 etc/rc.d/rc.alsa-oss.new
    else
      chmod 644 etc/rc.d/rc.alsa-oss.new
    fi
  fi

  # Move the scripts into place:
  mv etc/rc.d/rc.alsa.new etc/rc.d/rc.alsa
  mv etc/rc.d/rc.alsa-oss.new etc/rc.d/rc.alsa-oss
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
