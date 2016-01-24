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
    install-info --info-dir=usr/share/info usr/share/info/as.info.gz       2>/dev/null
    install-info --info-dir=usr/share/info usr/share/info/bfd.info.gz      2>/dev/null
    install-info --info-dir=usr/share/info usr/share/info/binutils.info.gz 2>/dev/null
    install-info --info-dir=usr/share/info usr/share/info/gprof.info.gz    2>/dev/null
    install-info --info-dir=usr/share/info usr/share/info/ld.info.gz       2>/dev/null
  elif ! grep "(binutils)" usr/share/info/dir 1> /dev/null 2> /dev/null ; then
  cat << EOF >> usr/share/info/dir

Individual utilities
* addr2line: (binutils)addr2line.               Convert addresses to file and 
                                                  line.
* ar: (binutils)ar.                             Create, modify, and extract 
                                                  from archives.
* c++filt: (binutils)c++filt.                   Filter to demangle encoded C++ 
                                                  symbols.
* cxxfilt: (binutils)c++filt.                   MS-DOS name for c++filt.
* dlltool: (binutils)dlltool.                   Create files needed to build 
                                                  and use DLLs.
* elfedit: (binutils)elfedit.                   Update the ELF header of ELF 
                                                  files.
* nlmconv: (binutils)nlmconv.                   Converts object code into an 
                                                  NLM.
* nm: (binutils)nm.                             List symbols from object files.
* objcopy: (binutils)objcopy.                   Copy and translate object 
                                                  files.
* objdump: (binutils)objdump.                   Display information from 
                                                  object files.
* ranlib: (binutils)ranlib.                     Generate index to archive 
                                                  contents.
* readelf: (binutils)readelf.                   Display the contents of ELF 
                                                  format files.
* size: (binutils)size.                         List section sizes and total 
                                                  size.
* strings: (binutils)strings.                   List printable strings from 
                                                  files.
* strip: (binutils)strip.                       Discard symbols.
* windmc: (binutils)windmc.                     Generator for Windows message 
                                                  resources.
* windres: (binutils)windres.                   Manipulate Windows resources.

Software development
* As: (as).                     The GNU assembler.
* Bfd: (bfd).                   The Binary File Descriptor library.
* Binutils: (binutils).         The GNU binary utilities.
* Gas: (as).                    The GNU assembler.
* Ld: (ld).                     The GNU linker.
* gprof: (gprof).               Profiling your program's execution
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
    install-info --delete --info-file=usr/share/info/as.info.gz       --dir-file=usr/share/info/dir 2> /dev/null
    install-info --delete --info-file=usr/share/info/bfd.info.gz      --dir-file=usr/share/info/dir 2> /dev/null
    install-info --delete --info-file=usr/share/info/binutils.info.gz --dir-file=usr/share/info/dir 2> /dev/null
    install-info --delete --info-file=usr/share/info/gprof.info.gz    --dir-file=usr/share/info/dir 2> /dev/null
    install-info --delete --info-file=usr/share/info/ld.info.gz       --dir-file=usr/share/info/dir 2> /dev/null
  fi
}

# arg 1:  the old package version
post_remove() {
  /bin/true
}


operation=$1
shift

$operation $*
