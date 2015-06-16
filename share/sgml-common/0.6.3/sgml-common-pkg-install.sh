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

install_catalog() {
  centralized=$1
  ordinary=$2
  if ! grep -q "$ordinary" "$centralized" 2>/dev/null ; then
    echo "CATALOG \"/$ordinary\"" >> "$centralized"
  fi
  grep -q "$centralized" etc/sgml/catalog 2>/dev/null
  if [ $? -ne 0 ] ; then
    echo "CATALOG \"/$centralized\"" >> etc/sgml/catalog
  fi
}

remove_catalog() {
  centralized=$1
  ordinary=$2
  if grep -q "$ordinary" "$centralized" 2>/dev/null ; then
    sed -e "\:CATALOG \"\\?/$ordinary\"\\?:d" < "$centralized" > "${centralized}.new"
    mv "${centralized}.new" "$centralized"
  fi
  if [ ! -s "$centralized" ] ; then
    rm "$centralized"
    sed -e "\:CATALOG \"\\?/$centralized\"\\?:d" < etc/sgml/catalog > etc/sgml/catalog.new
    mv etc/sgml/catalog.new etc/sgml/catalog
  fi
}


# arg 1:  the new package version
pre_install() {
  /bin/true
}

# arg 1:  the new package version
post_install() {
  install_catalog etc/sgml/sgml-ent.cat usr/share/sgml/sgml-iso-entities-8879.1986/catalog
  install_catalog etc/sgml/sgml-docbook.cat etc/sgml/sgml-ent.cat
}

# arg 1:  the new package version
# arg 2:  the old package version
pre_update() {
  remove_catalog etc/sgml/sgml-docbook.cat etc/sgml/sgml-ent.cat
  remove_catalog etc/sgml/sgml-ent.cat usr/share/sgml/sgml-iso-entities-8879.1986/catalog
}

# arg 1:  the new package version
# arg 2:  the old package version
post_update() {
  post_install
}

# arg 1:  the old package version
pre_remove() {
  remove_catalog etc/sgml/sgml-docbook.cat etc/sgml/sgml-ent.cat
  remove_catalog etc/sgml/sgml-ent.cat usr/share/sgml/sgml-iso-entities-8879.1986/catalog
}

# arg 1:  the old package version
post_remove() {
  /bin/true
}


operation=$1
shift

$operation $*
