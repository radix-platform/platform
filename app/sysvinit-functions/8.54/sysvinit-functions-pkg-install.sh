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
  ( cd etc
    for dir in init.d rc0.d rc1.d rc2.d rc3.d rc4.d rc5.d rc6.d ; do
      if [ ! -L $dir -a -d $dir ]; then
        mv ${dir} ${dir}.bak
      fi
    done
  )
  ( cd etc ; rm -rf init.d )
  ( cd etc ; ln -sf rc.d/init.d init.d )
  ( cd etc ; rm -rf rc0.d )
  ( cd etc ; ln -sf rc.d/rc0.d rc0.d )
  ( cd etc ; rm -rf rc1.d )
  ( cd etc ; ln -sf rc.d/rc1.d rc1.d )
  ( cd etc ; rm -rf rc2.d )
  ( cd etc ; ln -sf rc.d/rc2.d rc2.d )
  ( cd etc ; rm -rf rc3.d )
  ( cd etc ; ln -sf rc.d/rc3.d rc3.d )
  ( cd etc ; rm -rf rc4.d )
  ( cd etc ; ln -sf rc.d/rc4.d rc4.d )
  ( cd etc ; rm -rf rc5.d )
  ( cd etc ; ln -sf rc.d/rc5.d rc5.d )
  ( cd etc ; rm -rf rc6.d )
  ( cd etc ; ln -sf rc.d/rc6.d rc6.d )
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
