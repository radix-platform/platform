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
  if [ ! -e etc/xml/catalog ]; then
    xmlcatalog --noout --create etc/xml/catalog
  fi &&
  xmlcatalog --noout --add "delegatePublic" \
    "-//OASIS//ENTITIES DocBook XML"        \
    "file:///etc/xml/docbook-xml"           \
    etc/xml/catalog &&
  xmlcatalog --noout --add "delegatePublic" \
    "-//OASIS//DTD DocBook XML"             \
    "file:///etc/xml/docbook-xml"           \
    etc/xml/catalog &&
  xmlcatalog --noout --add "delegateSystem" \
    "http://www.oasis-open.org/docbook/"    \
    "file:///etc/xml/docbook-xml"           \
    etc/xml/catalog &&
  xmlcatalog --noout --add "delegateURI"    \
    "http://www.oasis-open.org/docbook/"    \
    "file:///etc/xml/docbook-xml"           \
    etc/xml/catalog
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
  xmlcatalog --noout --del file:///etc/xml/docbook-xml etc/xml/catalog
}


operation=$1
shift

$operation $*
