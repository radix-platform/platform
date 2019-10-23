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
  if [ -r bin/bash ]; then
    mv bin/bash bin/bash.old
  fi
  mv bin/bash5.new bin/bash
  if [ -f bin/bash.old ]; then
    rm -f bin/bash.old
  fi
  if [ ! -r etc/shells ]; then
    touch etc/shells
    chmod 644 etc/shells
  fi
  if grep -wq bin/bash etc/shells ; then
    true
  else
    echo "/bin/bash" >> etc/shells
  fi
  ( cd usr/bin ; rm -rf bash )
  ( cd usr/bin ; ln -sf ../../bin/bash bash )
  if [ ! -r bin/sh -a ! -L bin/sh ]; then
    ( cd bin ; ln -sf bash sh )
  fi
  #
  # NOTE:
  #   'install-info' can work using relative paths and we can make use build machine
  #   utility during installation to the some partition and use target 'install-info'
  #   during installation directly on the running target machine.
  #
  if [ -x /usr/bin/install-info ] ; then
    install-info --info-dir=usr/share/info usr/share/info/bash.info.gz 2>/dev/null
  elif ! grep "(bash)" usr/share/info/dir 1> /dev/null 2> /dev/null ; then
  cat << EOF >> usr/share/info/dir

Basics
* Bash: (bash).                 The GNU Bourne-Again SHell.
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
  if [ -x /usr/bin/install-info ] ; then
    install-info --delete --info-file=usr/share/info/bash.info.gz --dir-file=usr/share/info/dir 2> /dev/null || /bin/true
  fi
}

# arg 1:  the old package version
post_remove() {
  /bin/true
}


operation=$1
shift

$operation $*
