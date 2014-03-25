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
  if [ -x usr/bin/install-info ] ; then
    install-info --info-dir=usr/share/info usr/share/info/diff.info.gz 2>/dev/null
  elif ! grep "diff3" usr/share/info/dir 1> /dev/null 2> /dev/null ; then
  cat << EOF >> usr/info/dir

GNU packages
* Diff: (diff).                 Comparing and merging files.

Individual utilities
* cmp: (diff)Invoking cmp.                      Compare 2 files byte by byte.
* diff3: (diff)Invoking diff3.                  Compare 3 files line by line.
* diff: (diff)Invoking diff.                    Compare 2 files line by line.
* patch: (diff)Invoking patch.                  Apply a patch to a file.
* sdiff: (diff)Invoking sdiff.                  Merge 2 files side-by-side.
EOF
  fi
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
