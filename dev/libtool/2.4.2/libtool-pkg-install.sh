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
  #
  # NOTE:
  #   'install-info' can work using relative paths and we can make use build machine
  #   utility during installation to the some partition and use target 'install-info'
  #   during installation directly on the running target machine.
  #
  if [ -x /usr/bin/install-info ] ; then
    install-info --info-dir=usr/share/info usr/share/info/libtool.info.gz 2>/dev/null
  elif fgrep "libtoolize" usr/share/info/dir 1> /dev/null 2> /dev/null ; then
    GOOD=yes # It seems to be entered in the /usr/share/info/dir already
    /bin/true
  else # add the info to the dir file directly:
  cat << EOF >> usr/share/info/dir

GNU programming tools
* libtoolize: (libtool)Invoking libtoolize.     Adding libtool support.
* Libtool: (libtool).           Generic shared library support script.

Individual utilities
* libtoolize: (libtool)Invoking libtoolize.     Adding libtool support.
* Libtool: (libtool).           Generic shared library support script.
EOF
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
