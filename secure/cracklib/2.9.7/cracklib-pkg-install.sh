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
  # We have to check that we are not in the installer mode on the target system
  # ("/etc/system-installer"), and we have to be sure that we are on the working system
  # on the target hardware ("proc/sys/kernel/osrelease" - relative path).
  if [ -r proc/sys/kernel/osrelease -a ! -r /etc/system-installer ]; then
    extra_words=
    if [ -x /bin/hostname ] ; then
      echo `/bin/hostname` >> /usr/share/dict/host-name
      extra_words=/usr/share/dict/host-name
    fi

    if [ ! -r var/cache/cracklib/pq_dict.hwm -o \
         ! -r var/cache/cracklib/pq_dict.pwd -o \
         ! -r var/cache/cracklib/pq_dict.pwi    ]; then
      LD_PRELOAD=/usr/lib/libcrack.so \
      /usr/sbin/create-cracklib-dict -o /var/cache/cracklib/pq_dict /usr/share/dict/cracklib ${extra_words}
    fi
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
  rm -f var/cache/cracklib/pq_dict.hwm
  rm -f var/cache/cracklib/pq_dict.pwd
  rm -f var/cache/cracklib/pq_dict.pwi
}


operation=$1
shift

$operation $*
