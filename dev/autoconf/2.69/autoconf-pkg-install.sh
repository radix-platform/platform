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
    install-info --info-dir=usr/share/info usr/share/info/standards.info.gz 2>/dev/null
  elif ! grep "standards" usr/share/info/dir 1> /dev/null 2> /dev/null ; then
  cat << EOF >> usr/share/info/dir

GNU organization
* Standards: (standards).       GNU coding standards.
EOF
  fi

  if [ -x /usr/bin/install-info ] ; then
    install-info --info-dir=usr/share/info usr/share/info/autoconf.info.gz 2>/dev/null
  elif ! grep "autoconf" usr/share/info/dir 1> /dev/null 2> /dev/null ; then
  cat << EOF >> usr/share/info/dir

Individual utilities
* autoconf-invocation: (autoconf)autoconf Invocation.
                                                How to create configuration 
                                                  scripts
* autoheader: (autoconf)autoheader Invocation.  How to create configuration 
                                                  templates
* autom4te: (autoconf)autom4te Invocation.      The Autoconf executables 
                                                  backbone
* autoreconf: (autoconf)autoreconf Invocation.  Remaking multiple `configure' 
                                                  scripts
* autoscan: (autoconf)autoscan Invocation.      Semi-automatic `configure.ac' 
                                                  writing
* autoupdate: (autoconf)autoupdate Invocation.  Automatic update of 
                                                  `configure.ac'
* config.status: (autoconf)config.status Invocation.
                                                Recreating configurations.
* configure: (autoconf)configure Invocation.    Configuring a package.
* ifnames: (autoconf)ifnames Invocation.        Listing conditionals in source.
* testsuite: (autoconf)testsuite Invocation.    Running an Autotest test suite.

Software development
* Autoconf: (autoconf).         Create source code configuration scripts.
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
    install-info --delete --info-file=usr/share/info/standards.info.gz --dir-file=usr/share/info/dir 2> /dev/null || /bin/true
    install-info --delete --info-file=usr/share/info/autoconf.info.gz  --dir-file=usr/share/info/dir 2> /dev/null || /bin/true
  fi
}

# arg 1:  the old package version
post_remove() {
  /bin/true
}


operation=$1
shift

$operation $*
