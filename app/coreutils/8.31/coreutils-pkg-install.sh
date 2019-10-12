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
  install_file etc/DIR_COLORS.new

  #
  # NOTE:
  #   'install-info' can work using relative paths and we can make use build machine
  #   utility during installation to the some partition and use target 'install-info'
  #   during installation directly on the running target machine.
  #
  if [ -x /usr/bin/install-info ] ; then
    install-info --info-dir=usr/share/info usr/share/info/coreutils.info.gz 2>/dev/null
  elif ! grep "(coreutils)" usr/share/info/dir 1> /dev/null 2> /dev/null ; then
  cat << EOF >> usr/share/info/dir

Basics
* Common options: (coreutils)Common options.
* Coreutils: (coreutils).       Core GNU (file, text, shell) utilities.
* Date input formats: (coreutils)Date input formats.
* File permissions: (coreutils)File permissions.
                                Access modes.

Individual utilities
* arch: (coreutils)arch invocation.             Print machine hardware name.
* b2sum: (coreutils)b2sum invocation.           Print or check BLAKE2 digests.
* base32: (coreutils)base32 invocation.         Base32 encode/decode data.
* base64: (coreutils)base64 invocation.         Base64 encode/decode data.
* basename: (coreutils)basename invocation.     Strip directory and suffix.
* basenc: (coreutils)basenc invocation.         Encoding/decoding of data.
* cat: (coreutils)cat invocation.               Concatenate and write files.
* chcon: (coreutils)chcon invocation.           Change SELinux CTX of files.
* chgrp: (coreutils)chgrp invocation.           Change file groups.
* chmod: (coreutils)chmod invocation.           Change access permissions.
* chown: (coreutils)chown invocation.           Change file owners and groups.
* chroot: (coreutils)chroot invocation.         Specify the root directory.
* cksum: (coreutils)cksum invocation.           Print POSIX CRC checksum.
* comm: (coreutils)comm invocation.             Compare sorted files by line.
* cp: (coreutils)cp invocation.                 Copy files.
* csplit: (coreutils)csplit invocation.         Split by context.
* cut: (coreutils)cut invocation.               Print selected parts of lines.
* date: (coreutils)date invocation.             Print/set system date and time.
* dd: (coreutils)dd invocation.                 Copy and convert a file.
* df: (coreutils)df invocation.                 Report file system disk usage.
* dircolors: (coreutils)dircolors invocation.   Color setup for ls.
* dirname: (coreutils)dirname invocation.       Strip last file name component.
* dir: (coreutils)dir invocation.               List directories briefly.
* du: (coreutils)du invocation.                 Report on disk usage.
* echo: (coreutils)echo invocation.             Print a line of text.
* env: (coreutils)env invocation.               Modify the environment.
* expand: (coreutils)expand invocation.         Convert tabs to spaces.
* expr: (coreutils)expr invocation.             Evaluate expressions.
* factor: (coreutils)factor invocation.         Print prime factors
* false: (coreutils)false invocation.           Do nothing, unsuccessfully.
* fmt: (coreutils)fmt invocation.               Reformat paragraph text.
* fold: (coreutils)fold invocation.             Wrap long input lines.
* groups: (coreutils)groups invocation.         Print group names a user is in.
* head: (coreutils)head invocation.             Output the first part of files.
* hostid: (coreutils)hostid invocation.         Print numeric host identifier.
* hostname: (coreutils)hostname invocation.     Print or set system name.
* id: (coreutils)id invocation.                 Print user identity.
* install: (coreutils)install invocation.       Copy files and set attributes.
* join: (coreutils)join invocation.             Join lines on a common field.
* kill: (coreutils)kill invocation.             Send a signal to processes.
* link: (coreutils)link invocation.             Make hard links between files.
* ln: (coreutils)ln invocation.                 Make links between files.
* logname: (coreutils)logname invocation.       Print current login name.
* ls: (coreutils)ls invocation.                 List directory contents.
* md5sum: (coreutils)md5sum invocation.         Print or check MD5 digests.
* mkdir: (coreutils)mkdir invocation.           Create directories.
* mkfifo: (coreutils)mkfifo invocation.         Create FIFOs (named pipes).
* mknod: (coreutils)mknod invocation.           Create special files.
* mktemp: (coreutils)mktemp invocation.         Create temporary files.
* mv: (coreutils)mv invocation.                 Rename files.
* nice: (coreutils)nice invocation.             Modify niceness.
* nl: (coreutils)nl invocation.                 Number lines and write files.
* nohup: (coreutils)nohup invocation.           Immunize to hangups.
* nproc: (coreutils)nproc invocation.           Print the number of processors.
* numfmt: (coreutils)numfmt invocation.         Reformat numbers.
* od: (coreutils)od invocation.                 Dump files in octal, etc.
* paste: (coreutils)paste invocation.           Merge lines of files.
* pathchk: (coreutils)pathchk invocation.       Check file name portability.
* printenv: (coreutils)printenv invocation.     Print environment variables.
* printf: (coreutils)printf invocation.         Format and print data.
* pr: (coreutils)pr invocation.                 Paginate or columnate files.
* ptx: (coreutils)ptx invocation.               Produce permuted indexes.
* pwd: (coreutils)pwd invocation.               Print working directory.
* readlink: (coreutils)readlink invocation.     Print referent of a symlink.
* realpath: (coreutils)realpath invocation.     Print resolved file names.
* rmdir: (coreutils)rmdir invocation.           Remove empty directories.
* rm: (coreutils)rm invocation.                 Remove files.
* runcon: (coreutils)runcon invocation.         Run in specified SELinux CTX.
* seq: (coreutils)seq invocation.               Print numeric sequences
* sha1sum: (coreutils)sha1sum invocation.       Print or check SHA-1 digests.
* sha2: (coreutils)sha2 utilities.              Print or check SHA-2 digests.
* shred: (coreutils)shred invocation.           Remove files more securely.
* shuf: (coreutils)shuf invocation.             Shuffling text files.
* sleep: (coreutils)sleep invocation.           Delay for a specified time.
* sort: (coreutils)sort invocation.             Sort text files.
* split: (coreutils)split invocation.           Split into pieces.
* stat: (coreutils)stat invocation.             Report file(system) status.
* stdbuf: (coreutils)stdbuf invocation.         Modify stdio buffering.
* stty: (coreutils)stty invocation.             Print/change terminal settings.
* sum: (coreutils)sum invocation.               Print traditional checksum.
* sync: (coreutils)sync invocation.             Synchronize memory to disk.
* tac: (coreutils)tac invocation.               Reverse files.
* tail: (coreutils)tail invocation.             Output the last part of files.
* tee: (coreutils)tee invocation.               Redirect to multiple files.
* test: (coreutils)test invocation.             File/string tests.
* timeout: (coreutils)timeout invocation.       Run with time limit.
* touch: (coreutils)touch invocation.           Change file timestamps.
* true: (coreutils)true invocation.             Do nothing, successfully.
* truncate: (coreutils)truncate invocation.     Shrink/extend size of a file.
* tr: (coreutils)tr invocation.                 Translate characters.
* tsort: (coreutils)tsort invocation.           Topological sort.
* tty: (coreutils)tty invocation.               Print terminal name.
* uname: (coreutils)uname invocation.           Print system information.
* unexpand: (coreutils)unexpand invocation.     Convert spaces to tabs.
* uniq: (coreutils)uniq invocation.             Uniquify files.
* unlink: (coreutils)unlink invocation.         Removal via unlink(2).
* uptime: (coreutils)uptime invocation.         Print uptime and load.
* users: (coreutils)users invocation.           Print current user names.
* vdir: (coreutils)vdir invocation.             List directories verbosely.
* wc: (coreutils)wc invocation.                 Line, word, and byte counts.
* whoami: (coreutils)whoami invocation.         Print effective user ID.
* who: (coreutils)who invocation.               Print who is logged in.
* yes: (coreutils)yes invocation.               Print a string indefinitely.
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
    install-info --delete --info-file=usr/share/info/coreutils.info.gz --dir-file=usr/share/info/dir 2> /dev/null || /bin/true
  fi
}

# arg 1:  the old package version
post_remove() {
  /bin/true
}


operation=$1
shift

$operation $*
