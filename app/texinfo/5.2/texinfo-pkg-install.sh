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
    install-info --info-dir=usr/share/info usr/share/info/info.info.gz 2>/dev/null
    install-info --info-dir=usr/share/info usr/share/info/info-stnd.info.gz 2>/dev/null
    install-info --info-dir=usr/share/info usr/share/info/texinfo.info.gz 2>/dev/null
  elif ! grep "texinfo" usr/share/info/dir 1> /dev/null 2> /dev/null ; then
  cat << EOF >> usr/share/info/dir

Texinfo documentation system
* Info: (info).                 How to use the documentation browsing system.
* info stand-alone: (info-stnd).
                                Read Info documents without Emacs.
* infokey: (info-stnd)Invoking infokey.
                                Compile Info customizations.
* install-info: (texinfo)Invoking install-info.
                                Update info/dir entries.
* makeinfo: (texinfo)Invoking makeinfo.
                                Translate Texinfo source.
* pdftexi2dvi: (texinfo)PDF Output.
                                PDF output for Texinfo.
* pod2texi: (pod2texi)Invoking pod2texi.
                                Translate Perl POD to Texinfo.
* texi2dvi: (texinfo)Format with texi2dvi.
                                Print Texinfo documents.
* texi2pdf: (texinfo)PDF Output.
                                PDF output for Texinfo.
* texindex: (texinfo)Format with tex/texindex.
                                Sort Texinfo index files.
* Texinfo: (texinfo).           The GNU documentation format.
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
    install-info --delete --info-file=usr/share/info/texinfo.info.gz --dir-file=usr/share/info/dir 2> /dev/null
    install-info --delete --info-file=usr/share/info/info-stnd.info.gz --dir-file=usr/share/info/dir 2> /dev/null
    install-info --delete --info-file=usr/share/info/info.info.gz --dir-file=usr/share/info/dir 2> /dev/null
  fi
}

# arg 1:  the old package version
post_remove() {
  /bin/true
}


operation=$1
shift

$operation $*
