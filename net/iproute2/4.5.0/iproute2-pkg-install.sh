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
  install_file etc/iproute2/bpf_pinning.new
  install_file etc/iproute2/ematch_map.new
  install_file etc/iproute2/group.new
  install_file etc/iproute2/nl_protos.new
  install_file etc/iproute2/rt_dsfield.new
  install_file etc/iproute2/rt_protos.new
  install_file etc/iproute2/rt_realms.new
  install_file etc/iproute2/rt_scopes.new
  install_file etc/iproute2/rt_tables.new
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
