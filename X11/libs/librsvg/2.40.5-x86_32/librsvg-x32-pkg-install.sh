#!/bin/sh

# arg 1:  the new package version
pre_install() {
  /bin/true
}

# arg 1:  the new package version
post_install() {
  # Notice we use an absolute path below, rather than usr/bin/gdk-pixbuf-query-loaders-32.
  # This is because we're testing to see if we are on the bootdisk, which will not have
  # /usr/bin/gdk-pixbuf-query-loaders-32.
  # Also we have to check that we are not in the installer mode on the target system
  # ("/etc/system-installer"), and we have to be sure that we are on the working system
  # on the target hardware ("proc/sys/kernel/osrelease" - relative path).
  if [ -r proc/sys/kernel/osrelease -a ! -r /etc/system-installer -a -x /usr/bin/gdk-pixbuf-query-loaders-32 ]; then
    /usr/bin/gdk-pixbuf-query-loaders-32 --update-cache
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
  post_install
}


operation=$1
shift

$operation $*