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
    install-info --info-dir=usr/share/info usr/share/info/cpp.info.gz          2>/dev/null
    install-info --info-dir=usr/share/info usr/share/info/cppinternals.info.gz 2>/dev/null
    install-info --info-dir=usr/share/info usr/share/info/gcc.info.gz          2>/dev/null
    install-info --info-dir=usr/share/info usr/share/info/gccgo.info.gz        2>/dev/null
    install-info --info-dir=usr/share/info usr/share/info/gccinstall.info.gz   2>/dev/null
    install-info --info-dir=usr/share/info usr/share/info/gccint.info.gz       2>/dev/null
    install-info --info-dir=usr/share/info usr/share/info/gfortran.info.gz     2>/dev/null
    install-info --info-dir=usr/share/info usr/share/info/gnat-style.info.gz   2>/dev/null
    install-info --info-dir=usr/share/info usr/share/info/gnat_rm.info.gz      2>/dev/null
    install-info --info-dir=usr/share/info usr/share/info/gnat_ugn.info.gz     2>/dev/null
    install-info --info-dir=usr/share/info usr/share/info/libgomp.info.gz      2>/dev/null
    install-info --info-dir=usr/share/info usr/share/info/libitm.info.gz       2>/dev/null
    install-info --info-dir=usr/share/info usr/share/info/libquadmath.info.gz  2>/dev/null
  elif ! grep "(gcc)" usr/share/info/dir 1> /dev/null 2> /dev/null ; then
  cat << EOF >> usr/share/info/dir

GNU Ada Tools
* gnat_rm: (gnat_rm.info).      gnat_rm
* gnat_ugn: (gnat_ugn.info).    gnat_ugn

GNU Libraries
* libgomp: (libgomp).           GNU Offloading and Multi Processing Runtime 
                                  Library.
* libitm: (libitm).             GNU Transactional Memory Library
* libquadmath: (libquadmath).   GCC Quad-Precision Math Library

Software development
* Cpp: (cpp).                   The GNU C preprocessor.
* Cpplib: (cppinternals).       Cpplib internals.
* Gccgo: (gccgo).               A GCC-based compiler for the Go language
* g++: (gcc).                   The GNU C++ compiler.
* gcc: (gcc).                   The GNU Compiler Collection.
* gccinstall: (gccinstall).     Installing the GNU Compiler Collection.
* gccint: (gccint).             Internals of the GNU Compiler Collection.
* gcov: (gcc) Gcov.             'gcov'--a test coverage program.
* gcov-dump: (gcc) Gcov-dump.   'gcov-dump'--an offline gcda and gcno profile 
                                  dump tool.
* gcov-tool: (gcc) Gcov-tool.   'gcov-tool'--an offline gcda profile 
                                  processing program.
* gfortran: (gfortran).         The GNU Fortran Compiler.
* gnat-style: (gnat-style).     GNAT Coding Style
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
  if [ -x /usr/bin/install-info ] ; then
    install-info --delete --info-file=usr/share/info/cpp.info.gz          --dir-file=usr/share/info/dir 2>/dev/null || /bin/true
    install-info --delete --info-file=usr/share/info/cppinternals.info.gz --dir-file=usr/share/info/dir 2>/dev/null || /bin/true
    install-info --delete --info-file=usr/share/info/gcc.info.gz          --dir-file=usr/share/info/dir 2>/dev/null || /bin/true
    install-info --delete --info-file=usr/share/info/gccgo.info.gz        --dir-file=usr/share/info/dir 2>/dev/null || /bin/true
    install-info --delete --info-file=usr/share/info/gccinstall.info.gz   --dir-file=usr/share/info/dir 2>/dev/null || /bin/true
    install-info --delete --info-file=usr/share/info/gccint.info.gz       --dir-file=usr/share/info/dir 2>/dev/null || /bin/true
    install-info --delete --info-file=usr/share/info/gfortran.info.gz     --dir-file=usr/share/info/dir 2>/dev/null || /bin/true
    install-info --delete --info-file=usr/share/info/gnat-style.info.gz   --dir-file=usr/share/info/dir 2>/dev/null || /bin/true
    install-info --delete --info-file=usr/share/info/gnat_rm.info.gz      --dir-file=usr/share/info/dir 2>/dev/null || /bin/true
    install-info --delete --info-file=usr/share/info/gnat_ugn.info.gz     --dir-file=usr/share/info/dir 2>/dev/null || /bin/true
    install-info --delete --info-file=usr/share/info/libgomp.info.gz      --dir-file=usr/share/info/dir 2>/dev/null || /bin/true
    install-info --delete --info-file=usr/share/info/libitm.info.gz       --dir-file=usr/share/info/dir 2>/dev/null || /bin/true
    install-info --delete --info-file=usr/share/info/libquadmath.info.gz  --dir-file=usr/share/info/dir 2>/dev/null || /bin/true
  fi
}


operation=$1
shift

$operation $*
