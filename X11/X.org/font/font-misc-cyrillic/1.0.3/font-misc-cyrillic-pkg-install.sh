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
  # We use an relative path to 'proc/sys/kernel/osrelease' because we have
  # to be sure that we are running on the target platform. Only in this case
  # we will use absolute path to mkfonts{dir,scale}.
  if [ -r proc/sys/kernel/osrelease -a -x /usr/bin/mkfontdir -a -x /usr/bin/mkfontscale ]; then
    ( cd /usr/share/fonts/cyrillic
      mkfontscale .
      mkfontdir .
    )
  fi
  # We use an relative path to 'proc/sys/kernel/osrelease' because we have
  # to be sure that we are running on the target platform. Only in this case
  # we will use absolute path to fc-cache.
  if [ -r proc/sys/kernel/osrelease -a -x /usr/bin/fc-cache ]; then
    /usr/bin/fc-cache -f
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
