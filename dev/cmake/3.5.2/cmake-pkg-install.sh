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
  # Notice we use an absolute path below, rather than usr/bin/update-mime-database.
  # This is because we're testing to see if we are on the bootdisk, which will not
  # have /usr/bin/update-mime-database.
  # The presence of "/etc/system-installer" is under consideration as a better test.
  # Also we have to check that we are not in the installer mode on the target system
  # ("/etc/system-installer"), and we have to be sure that we are on the working system
  # on the target hardware ("proc/sys/kernel/osrelease" - relative path).
  if [ -r proc/sys/kernel/osrelease -a ! -r /etc/system-installer -a -x /usr/bin/update-mime-database ]; then
    /usr/bin/update-mime-database /usr/share/mime 1>/dev/null 2>/dev/null
    cat /etc/passwd | while read passwdline ; do
      homedir=$(echo $passwdline | cut -f 6 -d :)
      if [ -d $homedir/.local/share/mime ]; then
        username=$(echo $passwdline | cut -f 1 -d :)
        su $username -c "/usr/bin/update-mime-database $homedir/.local/share/mime 1>/dev/null 2>/dev/null" 2> /dev/null
      fi
    done
    # This is just "cleanup" in case something might be missed in /home/*/
    for homemimedir in /home/*/.local/share/mime ; do
      if [ -d $homemimedir ]; then
        username=$(echo $homemimedir | cut -f 3 -d /)
        su $username -c "/usr/bin/update-mime-database $homemimedir 1>/dev/null 2>/dev/null" 2> /dev/null
      fi
    done
  else
    # We are not on the target system and we can make use build-machine's utility
    if [ -x /usr/bin/update-mime-database ] ; then
      update-mime-database usr/share/mime 1>/dev/null 2>/dev/null
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
  /bin/true
}


operation=$1
shift

$operation $*
