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
    install-info --info-dir=usr/share/info usr/share/info/libc.info.gz 2>/dev/null
  elif ! grep "(libc)" usr/share/info/dir 1> /dev/null 2> /dev/null ; then
  cat << __EOF__ >> usr/share/info/dir

GNU C library functions and macros
* __fbufsize: (libc)Controlling Buffering.
* __flbf: (libc)Controlling Buffering.
* __fpending: (libc)Controlling Buffering.
* __fpurge: (libc)Flushing Buffers.
* __freadable: (libc)Opening Streams.
* __freading: (libc)Opening Streams.
* __fsetlocking: (libc)Streams and Threads.
* __fwritable: (libc)Opening Streams.
* __fwriting: (libc)Opening Streams.
* __gconv_end_fct: (libc)glibc iconv Implementation.
* __gconv_fct: (libc)glibc iconv Implementation.
* __gconv_init_fct: (libc)glibc iconv Implementation.
* __ppc_get_timebase_freq: (libc)PowerPC.
* __ppc_get_timebase: (libc)PowerPC.
* __ppc_mdoio: (libc)PowerPC.
* __ppc_mdoom: (libc)PowerPC.
* __ppc_set_ppr_low: (libc)PowerPC.
* __ppc_set_ppr_med_low: (libc)PowerPC.
* __ppc_set_ppr_med: (libc)PowerPC.
* __ppc_yield: (libc)PowerPC.
* __va_copy: (libc)Argument Macros.
* _Complex_I: (libc)Complex Numbers.
* _exit: (libc)Termination Internals.
* _Exit: (libc)Termination Internals.
* _flushlbf: (libc)Flushing Buffers.
* _Imaginary_I: (libc)Complex Numbers.
* _IOFBF: (libc)Controlling Buffering.
* _IOLBF: (libc)Controlling Buffering.
* _IONBF: (libc)Controlling Buffering.
* _PATH_UTMP: (libc)Manipulating the Database.
* _PATH_WTMP: (libc)Manipulating the Database.
* _POSIX2_C_DEV: (libc)System Options.
* _POSIX2_C_VERSION: (libc)Version Supported.
* _POSIX2_FORT_DEV: (libc)System Options.
* _POSIX2_FORT_RUN: (libc)System Options.
* _POSIX2_LOCALEDEF: (libc)System Options.
* _POSIX2_SW_DEV: (libc)System Options.
* _POSIX_CHOWN_RESTRICTED: (libc)Options for Files.
* _POSIX_JOB_CONTROL: (libc)System Options.
* _POSIX_NO_TRUNC: (libc)Options for Files.
* _POSIX_SAVED_IDS: (libc)System Options.
* _POSIX_VDISABLE: (libc)Options for Files.
* _POSIX_VERSION: (libc)Version Supported.
* _tolower: (libc)Case Conversion.
* _toupper: (libc)Case Conversion.
* a64l: (libc)Encode Binary Data.
* abort: (libc)Aborting a Program.
* abs: (libc)Absolute Value.
* accept: (libc)Accepting Connections.
* access: (libc)Testing File Access.
* acosf: (libc)Inverse Trig Functions.
* acoshf: (libc)Hyperbolic Functions.
* acoshl: (libc)Hyperbolic Functions.
* acosh: (libc)Hyperbolic Functions.
* acosl: (libc)Inverse Trig Functions.
* acos: (libc)Inverse Trig Functions.
* addmntent: (libc)mtab.
* addseverity: (libc)Adding Severity Classes.
* adjtimex: (libc)High-Resolution Calendar.
* adjtime: (libc)High-Resolution Calendar.
* aio_cancel: (libc)Cancel AIO Operations.
* aio_cancel64: (libc)Cancel AIO Operations.
* aio_error: (libc)Status of AIO Operations.
* aio_error64: (libc)Status of AIO Operations.
* aio_fsync: (libc)Synchronizing AIO Operations.
* aio_fsync64: (libc)Synchronizing AIO Operations.
* aio_init: (libc)Configuration of AIO.
* aio_read: (libc)Asynchronous Reads/Writes.
* aio_read64: (libc)Asynchronous Reads/Writes.
* aio_return: (libc)Status of AIO Operations.
* aio_return64: (libc)Status of AIO Operations.
* aio_suspend: (libc)Synchronizing AIO Operations.
* aio_suspend64: (libc)Synchronizing AIO Operations.
* aio_write: (libc)Asynchronous Reads/Writes.
* aio_write64: (libc)Asynchronous Reads/Writes.
* alarm: (libc)Setting an Alarm.
* aligned_alloc: (libc)Aligned Memory Blocks.
* alloca: (libc)Variable Size Automatic.
* alphasort: (libc)Scanning Directory Content.
* alphasort64: (libc)Scanning Directory Content.
* ALTWERASE: (libc)Local Modes.
* ARG_MAX: (libc)General Limits.
* ARGP_ERR_UNKNOWN: (libc)Argp Parser Functions.
* argp_error: (libc)Argp Helper Functions.
* argp_failure: (libc)Argp Helper Functions.
* argp_help: (libc)Argp Help.
* argp_parse: (libc)Argp.
* argp_state_help: (libc)Argp Helper Functions.
* argp_usage: (libc)Argp Helper Functions.
* argz_add_sep: (libc)Argz Functions.
* argz_add: (libc)Argz Functions.
* argz_append: (libc)Argz Functions.
* argz_count: (libc)Argz Functions.
* argz_create_sep: (libc)Argz Functions.
* argz_create: (libc)Argz Functions.
* argz_delete: (libc)Argz Functions.
* argz_extract: (libc)Argz Functions.
* argz_insert: (libc)Argz Functions.
* argz_next: (libc)Argz Functions.
* argz_replace: (libc)Argz Functions.
* argz_stringify: (libc)Argz Functions.
* asctime_r: (libc)Formatting Calendar Time.
* asctime: (libc)Formatting Calendar Time.
* asinf: (libc)Inverse Trig Functions.
* asinhf: (libc)Hyperbolic Functions.
* asinhl: (libc)Hyperbolic Functions.
* asinh: (libc)Hyperbolic Functions.
* asinl: (libc)Inverse Trig Functions.
* asin: (libc)Inverse Trig Functions.
* asprintf: (libc)Dynamic Output.
* assert_perror: (libc)Consistency Checking.
* assert: (libc)Consistency Checking.
* atanf: (libc)Inverse Trig Functions.
* atanhf: (libc)Hyperbolic Functions.
* atanhl: (libc)Hyperbolic Functions.
* atanh: (libc)Hyperbolic Functions.
* atanl: (libc)Inverse Trig Functions.
* atan: (libc)Inverse Trig Functions.
* atan2f: (libc)Inverse Trig Functions.
* atan2l: (libc)Inverse Trig Functions.
* atan2: (libc)Inverse Trig Functions.
* atexit: (libc)Cleanups on Exit.
* atof: (libc)Parsing of Floats.
* atoi: (libc)Parsing of Integers.
* atoll: (libc)Parsing of Integers.
* atol: (libc)Parsing of Integers.
* backtrace_symbols_fd: (libc)Backtraces.
* backtrace_symbols: (libc)Backtraces.
* backtrace: (libc)Backtraces.
* basename: (libc)Finding Tokens in a String.
* basename: (libc)Finding Tokens in a String.
* BC_BASE_MAX: (libc)Utility Limits.
* BC_DIM_MAX: (libc)Utility Limits.
* BC_SCALE_MAX: (libc)Utility Limits.
* BC_STRING_MAX: (libc)Utility Limits.
* bcmp: (libc)String/Array Comparison.
* bcopy: (libc)Copying and Concatenation.
* bind_textdomain_codeset: (libc)Charset conversion in gettext.
* bindtextdomain: (libc)Locating gettext catalog.
* bind: (libc)Setting Address.
* brk: (libc)Resizing the Data Segment.
* BRKINT: (libc)Input Modes.
* bsearch: (libc)Array Search Function.
* btowc: (libc)Converting a Character.
* BUFSIZ: (libc)Controlling Buffering.
* bzero: (libc)Copying and Concatenation.
* cabsf: (libc)Absolute Value.
* cabsl: (libc)Absolute Value.
* cabs: (libc)Absolute Value.
* cacosf: (libc)Inverse Trig Functions.
* cacoshf: (libc)Hyperbolic Functions.
* cacoshl: (libc)Hyperbolic Functions.
* cacosh: (libc)Hyperbolic Functions.
* cacosl: (libc)Inverse Trig Functions.
* cacos: (libc)Inverse Trig Functions.
* calloc: (libc)Allocating Cleared Space.
* canonicalize_file_name: (libc)Symbolic Links.
* cargf: (libc)Operations on Complex.
* cargl: (libc)Operations on Complex.
* carg: (libc)Operations on Complex.
* casinf: (libc)Inverse Trig Functions.
* casinhf: (libc)Hyperbolic Functions.
* casinhl: (libc)Hyperbolic Functions.
* casinh: (libc)Hyperbolic Functions.
* casinl: (libc)Inverse Trig Functions.
* casin: (libc)Inverse Trig Functions.
* catanf: (libc)Inverse Trig Functions.
* catanhf: (libc)Hyperbolic Functions.
* catanhl: (libc)Hyperbolic Functions.
* catanh: (libc)Hyperbolic Functions.
* catanl: (libc)Inverse Trig Functions.
* catan: (libc)Inverse Trig Functions.
* catclose: (libc)The catgets Functions.
* catgets: (libc)The catgets Functions.
* catopen: (libc)The catgets Functions.
* cbc_crypt: (libc)DES Encryption.
* cbrtf: (libc)Exponents and Logarithms.
* cbrtl: (libc)Exponents and Logarithms.
* cbrt: (libc)Exponents and Logarithms.
* ccosf: (libc)Trig Functions.
* ccoshf: (libc)Hyperbolic Functions.
* ccoshl: (libc)Hyperbolic Functions.
* ccosh: (libc)Hyperbolic Functions.
* ccosl: (libc)Trig Functions.
* ccos: (libc)Trig Functions.
* CCTS_OFLOW: (libc)Control Modes.
* ceilf: (libc)Rounding Functions.
* ceill: (libc)Rounding Functions.
* ceil: (libc)Rounding Functions.
* cexpf: (libc)Exponents and Logarithms.
* cexpl: (libc)Exponents and Logarithms.
* cexp: (libc)Exponents and Logarithms.
* cfgetispeed: (libc)Line Speed.
* cfgetospeed: (libc)Line Speed.
* cfmakeraw: (libc)Noncanonical Input.
* cfree: (libc)Freeing after Malloc.
* cfsetispeed: (libc)Line Speed.
* cfsetospeed: (libc)Line Speed.
* cfsetspeed: (libc)Line Speed.
* chdir: (libc)Working Directory.
* CHILD_MAX: (libc)General Limits.
* chmod: (libc)Setting Permissions.
* chown: (libc)File Owner.
* CIGNORE: (libc)Control Modes.
* cimagf: (libc)Operations on Complex.
* cimagl: (libc)Operations on Complex.
* cimag: (libc)Operations on Complex.
* clearenv: (libc)Environment Access.
* clearerr_unlocked: (libc)Error Recovery.
* clearerr: (libc)Error Recovery.
* CLK_TCK: (libc)Processor Time.
* CLOCAL: (libc)Control Modes.
* clock: (libc)CPU Time.
* CLOCKS_PER_SEC: (libc)CPU Time.
* clogf: (libc)Exponents and Logarithms.
* clogl: (libc)Exponents and Logarithms.
* clog: (libc)Exponents and Logarithms.
* clog10f: (libc)Exponents and Logarithms.
* clog10l: (libc)Exponents and Logarithms.
* clog10: (libc)Exponents and Logarithms.
* closedir: (libc)Reading/Closing Directory.
* closelog: (libc)closelog.
* close: (libc)Opening and Closing Files.
* COLL_WEIGHTS_MAX: (libc)Utility Limits.
* confstr: (libc)String Parameters.
* conjf: (libc)Operations on Complex.
* conjl: (libc)Operations on Complex.
* conj: (libc)Operations on Complex.
* connect: (libc)Connecting.
* copysignf: (libc)FP Bit Twiddling.
* copysignl: (libc)FP Bit Twiddling.
* copysign: (libc)FP Bit Twiddling.
* cosf: (libc)Trig Functions.
* coshf: (libc)Hyperbolic Functions.
* coshl: (libc)Hyperbolic Functions.
* cosh: (libc)Hyperbolic Functions.
* cosl: (libc)Trig Functions.
* cos: (libc)Trig Functions.
* cpowf: (libc)Exponents and Logarithms.
* cpowl: (libc)Exponents and Logarithms.
* cpow: (libc)Exponents and Logarithms.
* cprojf: (libc)Operations on Complex.
* cprojl: (libc)Operations on Complex.
* cproj: (libc)Operations on Complex.
* CPU_CLR: (libc)CPU Affinity.
* CPU_ISSET: (libc)CPU Affinity.
* CPU_SETSIZE: (libc)CPU Affinity.
* CPU_SET: (libc)CPU Affinity.
* CPU_ZERO: (libc)CPU Affinity.
* CREAD: (libc)Control Modes.
* crealf: (libc)Operations on Complex.
* creall: (libc)Operations on Complex.
* creal: (libc)Operations on Complex.
* creat: (libc)Opening and Closing Files.
* creat64: (libc)Opening and Closing Files.
* CRTS_IFLOW: (libc)Control Modes.
* crypt_r: (libc)crypt.
* crypt: (libc)crypt.
* CS5: (libc)Control Modes.
* CS6: (libc)Control Modes.
* CS7: (libc)Control Modes.
* CS8: (libc)Control Modes.
* csinf: (libc)Trig Functions.
* csinhf: (libc)Hyperbolic Functions.
* csinhl: (libc)Hyperbolic Functions.
* csinh: (libc)Hyperbolic Functions.
* csinl: (libc)Trig Functions.
* csin: (libc)Trig Functions.
* CSIZE: (libc)Control Modes.
* csqrtf: (libc)Exponents and Logarithms.
* csqrtl: (libc)Exponents and Logarithms.
* csqrt: (libc)Exponents and Logarithms.
* CSTOPB: (libc)Control Modes.
* ctanf: (libc)Trig Functions.
* ctanhf: (libc)Hyperbolic Functions.
* ctanhl: (libc)Hyperbolic Functions.
* ctanh: (libc)Hyperbolic Functions.
* ctanl: (libc)Trig Functions.
* ctan: (libc)Trig Functions.
* ctermid: (libc)Identifying the Terminal.
* ctime_r: (libc)Formatting Calendar Time.
* ctime: (libc)Formatting Calendar Time.
* cuserid: (libc)Who Logged In.
* dcgettext: (libc)Translation with gettext.
* dcngettext: (libc)Advanced gettext functions.
* DES_FAILED: (libc)DES Encryption.
* des_setparity: (libc)DES Encryption.
* dgettext: (libc)Translation with gettext.
* difftime: (libc)Elapsed Time.
* dirfd: (libc)Opening a Directory.
* dirname: (libc)Finding Tokens in a String.
* div: (libc)Integer Division.
* dngettext: (libc)Advanced gettext functions.
* drand48_r: (libc)SVID Random.
* drand48: (libc)SVID Random.
* dremf: (libc)Remainder Functions.
* dreml: (libc)Remainder Functions.
* drem: (libc)Remainder Functions.
* DTTOIF: (libc)Directory Entries.
* dup: (libc)Duplicating Descriptors.
* dup2: (libc)Duplicating Descriptors.
* E2BIG: (libc)Error Codes.
* EACCES: (libc)Error Codes.
* EADDRINUSE: (libc)Error Codes.
* EADDRNOTAVAIL: (libc)Error Codes.
* EADV: (libc)Error Codes.
* EAFNOSUPPORT: (libc)Error Codes.
* EAGAIN: (libc)Error Codes.
* EALREADY: (libc)Error Codes.
* EAUTH: (libc)Error Codes.
* EBACKGROUND: (libc)Error Codes.
* EBADE: (libc)Error Codes.
* EBADFD: (libc)Error Codes.
* EBADF: (libc)Error Codes.
* EBADMSG: (libc)Error Codes.
* EBADRPC: (libc)Error Codes.
* EBADRQC: (libc)Error Codes.
* EBADR: (libc)Error Codes.
* EBADSLT: (libc)Error Codes.
* EBFONT: (libc)Error Codes.
* EBUSY: (libc)Error Codes.
* ECANCELED: (libc)Error Codes.
* ecb_crypt: (libc)DES Encryption.
* ECHILD: (libc)Error Codes.
* ECHOCTL: (libc)Local Modes.
* ECHOE: (libc)Local Modes.
* ECHOKE: (libc)Local Modes.
* ECHOK: (libc)Local Modes.
* ECHONL: (libc)Local Modes.
* ECHOPRT: (libc)Local Modes.
* ECHO: (libc)Local Modes.
* ECHRNG: (libc)Error Codes.
* ECOMM: (libc)Error Codes.
* ECONNABORTED: (libc)Error Codes.
* ECONNREFUSED: (libc)Error Codes.
* ECONNRESET: (libc)Error Codes.
* ecvt_r: (libc)System V Number Conversion.
* ecvt: (libc)System V Number Conversion.
* EDEADLK: (libc)Error Codes.
* EDEADLOCK: (libc)Error Codes.
* EDESTADDRREQ: (libc)Error Codes.
* EDIED: (libc)Error Codes.
* EDOM: (libc)Error Codes.
* EDOTDOT: (libc)Error Codes.
* EDQUOT: (libc)Error Codes.
* ED: (libc)Error Codes.
* EEXIST: (libc)Error Codes.
* EFAULT: (libc)Error Codes.
* EFBIG: (libc)Error Codes.
* EFTYPE: (libc)Error Codes.
* EGRATUITOUS: (libc)Error Codes.
* EGREGIOUS: (libc)Error Codes.
* EHOSTDOWN: (libc)Error Codes.
* EHOSTUNREACH: (libc)Error Codes.
* EHWPOISON: (libc)Error Codes.
* EIDRM: (libc)Error Codes.
* EIEIO: (libc)Error Codes.
* EILSEQ: (libc)Error Codes.
* EINPROGRESS: (libc)Error Codes.
* EINTR: (libc)Error Codes.
* EINVAL: (libc)Error Codes.
* EIO: (libc)Error Codes.
* EISCONN: (libc)Error Codes.
* EISDIR: (libc)Error Codes.
* EISNAM: (libc)Error Codes.
* EKEYEXPIRED: (libc)Error Codes.
* EKEYREJECTED: (libc)Error Codes.
* EKEYREVOKED: (libc)Error Codes.
* EL2HLT: (libc)Error Codes.
* EL2NSYNC: (libc)Error Codes.
* EL3HLT: (libc)Error Codes.
* EL3RST: (libc)Error Codes.
* ELIBACC: (libc)Error Codes.
* ELIBBAD: (libc)Error Codes.
* ELIBEXEC: (libc)Error Codes.
* ELIBMAX: (libc)Error Codes.
* ELIBSCN: (libc)Error Codes.
* ELNRNG: (libc)Error Codes.
* ELOOP: (libc)Error Codes.
* EMEDIUMTYPE: (libc)Error Codes.
* EMFILE: (libc)Error Codes.
* EMLINK: (libc)Error Codes.
* EMSGSIZE: (libc)Error Codes.
* EMULTIHOP: (libc)Error Codes.
* ENAMETOOLONG: (libc)Error Codes.
* ENAVAIL: (libc)Error Codes.
* encrypt_r: (libc)DES Encryption.
* encrypt: (libc)DES Encryption.
* endfsent: (libc)fstab.
* endgrent: (libc)Scanning All Groups.
* endhostent: (libc)Host Names.
* endmntent: (libc)mtab.
* endnetent: (libc)Networks Database.
* endnetgrent: (libc)Lookup Netgroup.
* endprotoent: (libc)Protocols Database.
* endpwent: (libc)Scanning All Users.
* endservent: (libc)Services Database.
* endutent: (libc)Manipulating the Database.
* endutxent: (libc)XPG Functions.
* ENEEDAUTH: (libc)Error Codes.
* ENETDOWN: (libc)Error Codes.
* ENETRESET: (libc)Error Codes.
* ENETUNREACH: (libc)Error Codes.
* ENFILE: (libc)Error Codes.
* ENOANO: (libc)Error Codes.
* ENOBUFS: (libc)Error Codes.
* ENOCSI: (libc)Error Codes.
* ENODATA: (libc)Error Codes.
* ENODEV: (libc)Error Codes.
* ENOENT: (libc)Error Codes.
* ENOEXEC: (libc)Error Codes.
* ENOKEY: (libc)Error Codes.
* ENOLCK: (libc)Error Codes.
* ENOLINK: (libc)Error Codes.
* ENOMEDIUM: (libc)Error Codes.
* ENOMEM: (libc)Error Codes.
* ENOMSG: (libc)Error Codes.
* ENONET: (libc)Error Codes.
* ENOPKG: (libc)Error Codes.
* ENOPROTOOPT: (libc)Error Codes.
* ENOSPC: (libc)Error Codes.
* ENOSR: (libc)Error Codes.
* ENOSTR: (libc)Error Codes.
* ENOSYS: (libc)Error Codes.
* ENOTBLK: (libc)Error Codes.
* ENOTCONN: (libc)Error Codes.
* ENOTDIR: (libc)Error Codes.
* ENOTEMPTY: (libc)Error Codes.
* ENOTNAM: (libc)Error Codes.
* ENOTRECOVERABLE: (libc)Error Codes.
* ENOTSOCK: (libc)Error Codes.
* ENOTSUP: (libc)Error Codes.
* ENOTTY: (libc)Error Codes.
* ENOTUNIQ: (libc)Error Codes.
* envz_add: (libc)Envz Functions.
* envz_entry: (libc)Envz Functions.
* envz_get: (libc)Envz Functions.
* envz_merge: (libc)Envz Functions.
* envz_strip: (libc)Envz Functions.
* ENXIO: (libc)Error Codes.
* EOF: (libc)EOF and Errors.
* EOPNOTSUPP: (libc)Error Codes.
* EOVERFLOW: (libc)Error Codes.
* EOWNERDEAD: (libc)Error Codes.
* EPERM: (libc)Error Codes.
* EPFNOSUPPORT: (libc)Error Codes.
* EPIPE: (libc)Error Codes.
* EPROCLIM: (libc)Error Codes.
* EPROCUNAVAIL: (libc)Error Codes.
* EPROGMISMATCH: (libc)Error Codes.
* EPROGUNAVAIL: (libc)Error Codes.
* EPROTONOSUPPORT: (libc)Error Codes.
* EPROTOTYPE: (libc)Error Codes.
* EPROTO: (libc)Error Codes.
* EQUIV_CLASS_MAX: (libc)Utility Limits.
* erand48_r: (libc)SVID Random.
* erand48: (libc)SVID Random.
* ERANGE: (libc)Error Codes.
* EREMCHG: (libc)Error Codes.
* EREMOTEIO: (libc)Error Codes.
* EREMOTE: (libc)Error Codes.
* ERESTART: (libc)Error Codes.
* erfcf: (libc)Special Functions.
* erfcl: (libc)Special Functions.
* erfc: (libc)Special Functions.
* erff: (libc)Special Functions.
* ERFKILL: (libc)Error Codes.
* erfl: (libc)Special Functions.
* erf: (libc)Special Functions.
* EROFS: (libc)Error Codes.
* ERPCMISMATCH: (libc)Error Codes.
* errno: (libc)Checking for Errors.
* error_at_line: (libc)Error Messages.
* error: (libc)Error Messages.
* errx: (libc)Error Messages.
* err: (libc)Error Messages.
* ESHUTDOWN: (libc)Error Codes.
* ESOCKTNOSUPPORT: (libc)Error Codes.
* ESPIPE: (libc)Error Codes.
* ESRCH: (libc)Error Codes.
* ESRMNT: (libc)Error Codes.
* ESTALE: (libc)Error Codes.
* ESTRPIPE: (libc)Error Codes.
* ETIMEDOUT: (libc)Error Codes.
* ETIME: (libc)Error Codes.
* ETOOMANYREFS: (libc)Error Codes.
* ETXTBSY: (libc)Error Codes.
* EUCLEAN: (libc)Error Codes.
* EUNATCH: (libc)Error Codes.
* EUSERS: (libc)Error Codes.
* EWOULDBLOCK: (libc)Error Codes.
* EXDEV: (libc)Error Codes.
* execle: (libc)Executing a File.
* execlp: (libc)Executing a File.
* execl: (libc)Executing a File.
* execve: (libc)Executing a File.
* execvp: (libc)Executing a File.
* execv: (libc)Executing a File.
* EXFULL: (libc)Error Codes.
* exit: (libc)Normal Termination.
* EXIT_FAILURE: (libc)Exit Status.
* EXIT_SUCCESS: (libc)Exit Status.
* expf: (libc)Exponents and Logarithms.
* expl: (libc)Exponents and Logarithms.
* expm1f: (libc)Exponents and Logarithms.
* expm1l: (libc)Exponents and Logarithms.
* expm1: (libc)Exponents and Logarithms.
* exp: (libc)Exponents and Logarithms.
* exp10f: (libc)Exponents and Logarithms.
* exp10l: (libc)Exponents and Logarithms.
* exp10: (libc)Exponents and Logarithms.
* exp2f: (libc)Exponents and Logarithms.
* exp2l: (libc)Exponents and Logarithms.
* exp2: (libc)Exponents and Logarithms.
* EXPR_NEST_MAX: (libc)Utility Limits.
* F_DUPFD: (libc)Duplicating Descriptors.
* F_GETFD: (libc)Descriptor Flags.
* F_GETFL: (libc)Getting File Status Flags.
* F_GETLK: (libc)File Locks.
* F_GETOWN: (libc)Interrupt Input.
* F_OFD_GETLK: (libc)Open File Description Locks.
* F_OFD_SETLKW: (libc)Open File Description Locks.
* F_OFD_SETLK: (libc)Open File Description Locks.
* F_OK: (libc)Testing File Access.
* F_SETFD: (libc)Descriptor Flags.
* F_SETFL: (libc)Getting File Status Flags.
* F_SETLKW: (libc)File Locks.
* F_SETLK: (libc)File Locks.
* F_SETOWN: (libc)Interrupt Input.
* fabsf: (libc)Absolute Value.
* fabsl: (libc)Absolute Value.
* fabs: (libc)Absolute Value.
* fchdir: (libc)Working Directory.
* fchmod: (libc)Setting Permissions.
* fchown: (libc)File Owner.
* fcloseall: (libc)Closing Streams.
* fclose: (libc)Closing Streams.
* fcntl: (libc)Control Operations.
* fcvt_r: (libc)System V Number Conversion.
* fcvt: (libc)System V Number Conversion.
* FD_CLOEXEC: (libc)Descriptor Flags.
* FD_CLR: (libc)Waiting for I/O.
* FD_ISSET: (libc)Waiting for I/O.
* FD_SETSIZE: (libc)Waiting for I/O.
* FD_SET: (libc)Waiting for I/O.
* FD_ZERO: (libc)Waiting for I/O.
* fdatasync: (libc)Synchronizing I/O.
* fdimf: (libc)Misc FP Arithmetic.
* fdiml: (libc)Misc FP Arithmetic.
* fdim: (libc)Misc FP Arithmetic.
* fdopendir: (libc)Opening a Directory.
* fdopen: (libc)Descriptors and Streams.
* feclearexcept: (libc)Status bit operations.
* fedisableexcept: (libc)Control Functions.
* feenableexcept: (libc)Control Functions.
* fegetenv: (libc)Control Functions.
* fegetexceptflag: (libc)Status bit operations.
* fegetexcept: (libc)Control Functions.
* fegetround: (libc)Rounding.
* feholdexcept: (libc)Control Functions.
* feof_unlocked: (libc)EOF and Errors.
* feof: (libc)EOF and Errors.
* feraiseexcept: (libc)Status bit operations.
* ferror_unlocked: (libc)EOF and Errors.
* ferror: (libc)EOF and Errors.
* fesetenv: (libc)Control Functions.
* fesetexceptflag: (libc)Status bit operations.
* fesetround: (libc)Rounding.
* fetestexcept: (libc)Status bit operations.
* feupdateenv: (libc)Control Functions.
* fflush_unlocked: (libc)Flushing Buffers.
* fflush: (libc)Flushing Buffers.
* fgetc_unlocked: (libc)Character Input.
* fgetc: (libc)Character Input.
* fgetgrent_r: (libc)Scanning All Groups.
* fgetgrent: (libc)Scanning All Groups.
* fgetpos: (libc)Portable Positioning.
* fgetpos64: (libc)Portable Positioning.
* fgetpwent_r: (libc)Scanning All Users.
* fgetpwent: (libc)Scanning All Users.
* fgets_unlocked: (libc)Line Input.
* fgets: (libc)Line Input.
* fgetwc_unlocked: (libc)Character Input.
* fgetwc: (libc)Character Input.
* fgetws_unlocked: (libc)Line Input.
* fgetws: (libc)Line Input.
* FILENAME_MAX: (libc)Limits for Files.
* fileno_unlocked: (libc)Descriptors and Streams.
* fileno: (libc)Descriptors and Streams.
* finitef: (libc)Floating Point Classes.
* finitel: (libc)Floating Point Classes.
* finite: (libc)Floating Point Classes.
* flockfile: (libc)Streams and Threads.
* floorf: (libc)Rounding Functions.
* floorl: (libc)Rounding Functions.
* floor: (libc)Rounding Functions.
* FLUSHO: (libc)Local Modes.
* fmaf: (libc)Misc FP Arithmetic.
* fmal: (libc)Misc FP Arithmetic.
* fmaxf: (libc)Misc FP Arithmetic.
* fmaxl: (libc)Misc FP Arithmetic.
* fmax: (libc)Misc FP Arithmetic.
* fma: (libc)Misc FP Arithmetic.
* fmemopen: (libc)String Streams.
* fminf: (libc)Misc FP Arithmetic.
* fminl: (libc)Misc FP Arithmetic.
* fmin: (libc)Misc FP Arithmetic.
* fmodf: (libc)Remainder Functions.
* fmodl: (libc)Remainder Functions.
* fmod: (libc)Remainder Functions.
* fmtmsg: (libc)Printing Formatted Messages.
* fnmatch: (libc)Wildcard Matching.
* FOPEN_MAX: (libc)Opening Streams.
* fopencookie: (libc)Streams and Cookies.
* fopen: (libc)Opening Streams.
* fopen64: (libc)Opening Streams.
* forkpty: (libc)Pseudo-Terminal Pairs.
* fork: (libc)Creating a Process.
* FP_ILOGB0: (libc)Exponents and Logarithms.
* FP_ILOGBNAN: (libc)Exponents and Logarithms.
* fpathconf: (libc)Pathconf.
* fpclassify: (libc)Floating Point Classes.
* fprintf: (libc)Formatted Output Functions.
* fputc_unlocked: (libc)Simple Output.
* fputc: (libc)Simple Output.
* fputs_unlocked: (libc)Simple Output.
* fputs: (libc)Simple Output.
* fputwc_unlocked: (libc)Simple Output.
* fputwc: (libc)Simple Output.
* fputws_unlocked: (libc)Simple Output.
* fputws: (libc)Simple Output.
* fread_unlocked: (libc)Block Input/Output.
* fread: (libc)Block Input/Output.
* free: (libc)Freeing after Malloc.
* freopen: (libc)Opening Streams.
* freopen64: (libc)Opening Streams.
* frexpf: (libc)Normalization Functions.
* frexpl: (libc)Normalization Functions.
* frexp: (libc)Normalization Functions.
* fscanf: (libc)Formatted Input Functions.
* fseeko: (libc)File Positioning.
* fseeko64: (libc)File Positioning.
* fseek: (libc)File Positioning.
* fsetpos: (libc)Portable Positioning.
* fsetpos64: (libc)Portable Positioning.
* fstat: (libc)Reading Attributes.
* fstat64: (libc)Reading Attributes.
* fsync: (libc)Synchronizing I/O.
* ftello: (libc)File Positioning.
* ftello64: (libc)File Positioning.
* ftell: (libc)File Positioning.
* ftruncate: (libc)File Size.
* ftruncate64: (libc)File Size.
* ftrylockfile: (libc)Streams and Threads.
* ftw: (libc)Working with Directory Trees.
* ftw64: (libc)Working with Directory Trees.
* funlockfile: (libc)Streams and Threads.
* futimes: (libc)File Times.
* fwide: (libc)Streams and I18N.
* fwprintf: (libc)Formatted Output Functions.
* fwrite_unlocked: (libc)Block Input/Output.
* fwrite: (libc)Block Input/Output.
* fwscanf: (libc)Formatted Input Functions.
* gammaf: (libc)Special Functions.
* gammal: (libc)Special Functions.
* gamma: (libc)Special Functions.
* gcvt: (libc)System V Number Conversion.
* get_avphys_pages: (libc)Query Memory Parameters.
* get_current_dir_name: (libc)Working Directory.
* get_nprocs_conf: (libc)Processor Resources.
* get_nprocs: (libc)Processor Resources.
* get_phys_pages: (libc)Query Memory Parameters.
* getauxval: (libc)Auxiliary Vector.
* getc_unlocked: (libc)Character Input.
* getchar_unlocked: (libc)Character Input.
* getchar: (libc)Character Input.
* getcontext: (libc)System V contexts.
* getcwd: (libc)Working Directory.
* getc: (libc)Character Input.
* getdate_r: (libc)General Time String Parsing.
* getdate: (libc)General Time String Parsing.
* getdelim: (libc)Line Input.
* getdomainnname: (libc)Host Identification.
* getegid: (libc)Reading Persona.
* getenv: (libc)Environment Access.
* geteuid: (libc)Reading Persona.
* getfsent: (libc)fstab.
* getfsfile: (libc)fstab.
* getfsspec: (libc)fstab.
* getgid: (libc)Reading Persona.
* getgrent_r: (libc)Scanning All Groups.
* getgrent: (libc)Scanning All Groups.
* getgrgid_r: (libc)Lookup Group.
* getgrgid: (libc)Lookup Group.
* getgrnam_r: (libc)Lookup Group.
* getgrnam: (libc)Lookup Group.
* getgrouplist: (libc)Setting Groups.
* getgroups: (libc)Reading Persona.
* gethostbyaddr_r: (libc)Host Names.
* gethostbyaddr: (libc)Host Names.
* gethostbyname2: (libc)Host Names.
* gethostbyname_r: (libc)Host Names.
* gethostbyname: (libc)Host Names.
* gethostbyname2_r: (libc)Host Names.
* gethostent: (libc)Host Names.
* gethostid: (libc)Host Identification.
* gethostname: (libc)Host Identification.
* getitimer: (libc)Setting an Alarm.
* getline: (libc)Line Input.
* getloadavg: (libc)Processor Resources.
* getlogin: (libc)Who Logged In.
* getmntent_r: (libc)mtab.
* getmntent: (libc)mtab.
* getnetbyaddr: (libc)Networks Database.
* getnetbyname: (libc)Networks Database.
* getnetent: (libc)Networks Database.
* getnetgrent_r: (libc)Lookup Netgroup.
* getnetgrent: (libc)Lookup Netgroup.
* getopt_long_only: (libc)Getopt Long Options.
* getopt_long: (libc)Getopt Long Options.
* getopt: (libc)Using Getopt.
* getpagesize: (libc)Query Memory Parameters.
* getpass: (libc)getpass.
* getpeername: (libc)Who is Connected.
* getpgid: (libc)Process Group Functions.
* getpgrp: (libc)Process Group Functions.
* getpid: (libc)Process Identification.
* getppid: (libc)Process Identification.
* getpriority: (libc)Traditional Scheduling Functions.
* getprotobyname: (libc)Protocols Database.
* getprotobynumber: (libc)Protocols Database.
* getprotoent: (libc)Protocols Database.
* getpt: (libc)Allocation.
* getpwent_r: (libc)Scanning All Users.
* getpwent: (libc)Scanning All Users.
* getpwnam_r: (libc)Lookup User.
* getpwnam: (libc)Lookup User.
* getpwuid_r: (libc)Lookup User.
* getpwuid: (libc)Lookup User.
* getrlimit: (libc)Limits on Resources.
* getrlimit64: (libc)Limits on Resources.
* getrusage: (libc)Resource Usage.
* getservbyname: (libc)Services Database.
* getservbyport: (libc)Services Database.
* getservent: (libc)Services Database.
* getsid: (libc)Process Group Functions.
* getsockname: (libc)Reading Address.
* getsockopt: (libc)Socket Option Functions.
* getsubopt: (libc)Suboptions.
* gets: (libc)Line Input.
* gettext: (libc)Translation with gettext.
* gettimeofday: (libc)High-Resolution Calendar.
* getuid: (libc)Reading Persona.
* getumask: (libc)Setting Permissions.
* getutent_r: (libc)Manipulating the Database.
* getutent: (libc)Manipulating the Database.
* getutid_r: (libc)Manipulating the Database.
* getutid: (libc)Manipulating the Database.
* getutline_r: (libc)Manipulating the Database.
* getutline: (libc)Manipulating the Database.
* getutmpx: (libc)XPG Functions.
* getutmp: (libc)XPG Functions.
* getutxent: (libc)XPG Functions.
* getutxid: (libc)XPG Functions.
* getutxline: (libc)XPG Functions.
* getwc_unlocked: (libc)Character Input.
* getwchar_unlocked: (libc)Character Input.
* getwchar: (libc)Character Input.
* getwc: (libc)Character Input.
* getwd: (libc)Working Directory.
* getw: (libc)Character Input.
* globfree: (libc)More Flags for Globbing.
* globfree64: (libc)More Flags for Globbing.
* glob: (libc)Calling Glob.
* glob64: (libc)Calling Glob.
* gmtime_r: (libc)Broken-down Time.
* gmtime: (libc)Broken-down Time.
* grantpt: (libc)Allocation.
* gsignal: (libc)Signaling Yourself.
* gtty: (libc)BSD Terminal Modes.
* hasmntopt: (libc)mtab.
* hcreate_r: (libc)Hash Search Function.
* hcreate: (libc)Hash Search Function.
* hdestroy_r: (libc)Hash Search Function.
* hdestroy: (libc)Hash Search Function.
* hsearch_r: (libc)Hash Search Function.
* hsearch: (libc)Hash Search Function.
* htonl: (libc)Byte Order.
* htons: (libc)Byte Order.
* HUGE_VALF: (libc)Math Error Reporting.
* HUGE_VALL: (libc)Math Error Reporting.
* HUGE_VAL: (libc)Math Error Reporting.
* HUPCL: (libc)Control Modes.
* hypotf: (libc)Exponents and Logarithms.
* hypotl: (libc)Exponents and Logarithms.
* hypot: (libc)Exponents and Logarithms.
* ICANON: (libc)Local Modes.
* iconv_close: (libc)Generic Conversion Interface.
* iconv_open: (libc)Generic Conversion Interface.
* iconv: (libc)Generic Conversion Interface.
* ICRNL: (libc)Input Modes.
* IEXTEN: (libc)Local Modes.
* if_freenameindex: (libc)Interface Naming.
* if_indextoname: (libc)Interface Naming.
* if_nameindex: (libc)Interface Naming.
* if_nametoindex: (libc)Interface Naming.
* IFNAMSIZ: (libc)Interface Naming.
* IFTODT: (libc)Directory Entries.
* IGNBRK: (libc)Input Modes.
* IGNCR: (libc)Input Modes.
* IGNPAR: (libc)Input Modes.
* ilogbf: (libc)Exponents and Logarithms.
* ilogbl: (libc)Exponents and Logarithms.
* ilogb: (libc)Exponents and Logarithms.
* imaxabs: (libc)Absolute Value.
* IMAXBEL: (libc)Input Modes.
* imaxdiv: (libc)Integer Division.
* in6addr_any: (libc)Host Address Data Type.
* in6addr_loopback: (libc)Host Address Data Type.
* INADDR_ANY: (libc)Host Address Data Type.
* INADDR_BROADCAST: (libc)Host Address Data Type.
* INADDR_LOOPBACK: (libc)Host Address Data Type.
* INADDR_NONE: (libc)Host Address Data Type.
* index: (libc)Search Functions.
* inet_addr: (libc)Host Address Functions.
* inet_aton: (libc)Host Address Functions.
* inet_lnaof: (libc)Host Address Functions.
* inet_makeaddr: (libc)Host Address Functions.
* inet_netof: (libc)Host Address Functions.
* inet_network: (libc)Host Address Functions.
* inet_ntoa: (libc)Host Address Functions.
* inet_ntop: (libc)Host Address Functions.
* inet_pton: (libc)Host Address Functions.
* INFINITY: (libc)Infinity and NaN.
* initgroups: (libc)Setting Groups.
* initstate_r: (libc)BSD Random.
* initstate: (libc)BSD Random.
* INLCR: (libc)Input Modes.
* innetgr: (libc)Netgroup Membership.
* INPCK: (libc)Input Modes.
* ioctl: (libc)IOCTLs.
* IPPORT_RESERVED: (libc)Ports.
* IPPORT_USERRESERVED: (libc)Ports.
* isalnum: (libc)Classification of Characters.
* isalpha: (libc)Classification of Characters.
* isascii: (libc)Classification of Characters.
* isatty: (libc)Is It a Terminal.
* isblank: (libc)Classification of Characters.
* iscntrl: (libc)Classification of Characters.
* isdigit: (libc)Classification of Characters.
* isfinite: (libc)Floating Point Classes.
* isgraph: (libc)Classification of Characters.
* isgreaterequal: (libc)FP Comparison Functions.
* isgreater: (libc)FP Comparison Functions.
* ISIG: (libc)Local Modes.
* isinff: (libc)Floating Point Classes.
* isinfl: (libc)Floating Point Classes.
* isinf: (libc)Floating Point Classes.
* islessequal: (libc)FP Comparison Functions.
* islessgreater: (libc)FP Comparison Functions.
* isless: (libc)FP Comparison Functions.
* islower: (libc)Classification of Characters.
* isnanf: (libc)Floating Point Classes.
* isnanl: (libc)Floating Point Classes.
* isnan: (libc)Floating Point Classes.
* isnan: (libc)Floating Point Classes.
* isnormal: (libc)Floating Point Classes.
* isprint: (libc)Classification of Characters.
* ispunct: (libc)Classification of Characters.
* issignaling: (libc)Floating Point Classes.
* isspace: (libc)Classification of Characters.
* ISTRIP: (libc)Input Modes.
* isunordered: (libc)FP Comparison Functions.
* isupper: (libc)Classification of Characters.
* iswalnum: (libc)Classification of Wide Characters.
* iswalpha: (libc)Classification of Wide Characters.
* iswblank: (libc)Classification of Wide Characters.
* iswcntrl: (libc)Classification of Wide Characters.
* iswctype: (libc)Classification of Wide Characters.
* iswdigit: (libc)Classification of Wide Characters.
* iswgraph: (libc)Classification of Wide Characters.
* iswlower: (libc)Classification of Wide Characters.
* iswprint: (libc)Classification of Wide Characters.
* iswpunct: (libc)Classification of Wide Characters.
* iswspace: (libc)Classification of Wide Characters.
* iswupper: (libc)Classification of Wide Characters.
* iswxdigit: (libc)Classification of Wide Characters.
* isxdigit: (libc)Classification of Characters.
* IXANY: (libc)Input Modes.
* IXOFF: (libc)Input Modes.
* IXON: (libc)Input Modes.
* I: (libc)Complex Numbers.
* j0f: (libc)Special Functions.
* j0l: (libc)Special Functions.
* j0: (libc)Special Functions.
* j1f: (libc)Special Functions.
* j1l: (libc)Special Functions.
* j1: (libc)Special Functions.
* jnf: (libc)Special Functions.
* jnl: (libc)Special Functions.
* jn: (libc)Special Functions.
* jrand48_r: (libc)SVID Random.
* jrand48: (libc)SVID Random.
* killpg: (libc)Signaling Another Process.
* kill: (libc)Signaling Another Process.
* l64a: (libc)Encode Binary Data.
* L_ctermid: (libc)Identifying the Terminal.
* L_cuserid: (libc)Who Logged In.
* L_tmpnam: (libc)Temporary Files.
* labs: (libc)Absolute Value.
* lcong48_r: (libc)SVID Random.
* lcong48: (libc)SVID Random.
* ldexpf: (libc)Normalization Functions.
* ldexpl: (libc)Normalization Functions.
* ldexp: (libc)Normalization Functions.
* ldiv: (libc)Integer Division.
* lfind: (libc)Array Search Function.
* lgamma_r: (libc)Special Functions.
* lgammaf_r: (libc)Special Functions.
* lgammaf: (libc)Special Functions.
* lgammal_r: (libc)Special Functions.
* lgammal: (libc)Special Functions.
* lgamma: (libc)Special Functions.
* LINE_MAX: (libc)Utility Limits.
* link: (libc)Hard Links.
* LINK_MAX: (libc)Limits for Files.
* lio_listio: (libc)Asynchronous Reads/Writes.
* lio_listio64: (libc)Asynchronous Reads/Writes.
* listen: (libc)Listening.
* llabs: (libc)Absolute Value.
* lldiv: (libc)Integer Division.
* llrintf: (libc)Rounding Functions.
* llrintl: (libc)Rounding Functions.
* llrint: (libc)Rounding Functions.
* llroundf: (libc)Rounding Functions.
* llroundl: (libc)Rounding Functions.
* llround: (libc)Rounding Functions.
* localeconv: (libc)The Lame Way to Locale Data.
* localtime_r: (libc)Broken-down Time.
* localtime: (libc)Broken-down Time.
* log10f: (libc)Exponents and Logarithms.
* log10l: (libc)Exponents and Logarithms.
* log10: (libc)Exponents and Logarithms.
* log1pf: (libc)Exponents and Logarithms.
* log1pl: (libc)Exponents and Logarithms.
* log1p: (libc)Exponents and Logarithms.
* log2f: (libc)Exponents and Logarithms.
* log2l: (libc)Exponents and Logarithms.
* log2: (libc)Exponents and Logarithms.
* logbf: (libc)Exponents and Logarithms.
* logbl: (libc)Exponents and Logarithms.
* logb: (libc)Exponents and Logarithms.
* logf: (libc)Exponents and Logarithms.
* login_tty: (libc)Logging In and Out.
* login: (libc)Logging In and Out.
* logl: (libc)Exponents and Logarithms.
* logout: (libc)Logging In and Out.
* logwtmp: (libc)Logging In and Out.
* log: (libc)Exponents and Logarithms.
* longjmp: (libc)Non-Local Details.
* lrand48_r: (libc)SVID Random.
* lrand48: (libc)SVID Random.
* lrintf: (libc)Rounding Functions.
* lrintl: (libc)Rounding Functions.
* lrint: (libc)Rounding Functions.
* lroundf: (libc)Rounding Functions.
* lroundl: (libc)Rounding Functions.
* lround: (libc)Rounding Functions.
* lsearch: (libc)Array Search Function.
* lseek: (libc)File Position Primitive.
* lseek64: (libc)File Position Primitive.
* lstat: (libc)Reading Attributes.
* lstat64: (libc)Reading Attributes.
* lutimes: (libc)File Times.
* madvise: (libc)Memory-mapped I/O.
* makecontext: (libc)System V contexts.
* mallinfo: (libc)Statistics of Malloc.
* malloc: (libc)Basic Allocation.
* mallopt: (libc)Malloc Tunable Parameters.
* MAX_CANON: (libc)Limits for Files.
* MAX_INPUT: (libc)Limits for Files.
* MAXNAMLEN: (libc)Limits for Files.
* MAXSYMLINKS: (libc)Symbolic Links.
* MB_CUR_MAX: (libc)Selecting the Conversion.
* MB_LEN_MAX: (libc)Selecting the Conversion.
* mblen: (libc)Non-reentrant Character Conversion.
* mbrlen: (libc)Converting a Character.
* mbrtowc: (libc)Converting a Character.
* mbsinit: (libc)Keeping the state.
* mbsnrtowcs: (libc)Converting Strings.
* mbsrtowcs: (libc)Converting Strings.
* mbstowcs: (libc)Non-reentrant String Conversion.
* mbtowc: (libc)Non-reentrant Character Conversion.
* mcheck: (libc)Heap Consistency Checking.
* MDMBUF: (libc)Control Modes.
* memalign: (libc)Aligned Memory Blocks.
* memccpy: (libc)Copying and Concatenation.
* memchr: (libc)Search Functions.
* memcmp: (libc)String/Array Comparison.
* memcpy: (libc)Copying and Concatenation.
* memfrob: (libc)Trivial Encryption.
* memmem: (libc)Search Functions.
* memmove: (libc)Copying and Concatenation.
* mempcpy: (libc)Copying and Concatenation.
* memrchr: (libc)Search Functions.
* memset: (libc)Copying and Concatenation.
* mkdir: (libc)Creating Directories.
* mkdtemp: (libc)Temporary Files.
* mkfifo: (libc)FIFO Special Files.
* mknod: (libc)Making Special Files.
* mkstemp: (libc)Temporary Files.
* mktemp: (libc)Temporary Files.
* mktime: (libc)Broken-down Time.
* mlockall: (libc)Page Lock Functions.
* mlock: (libc)Page Lock Functions.
* mmap: (libc)Memory-mapped I/O.
* mmap64: (libc)Memory-mapped I/O.
* modff: (libc)Rounding Functions.
* modfl: (libc)Rounding Functions.
* modf: (libc)Rounding Functions.
* mount: (libc)Mount-Unmount-Remount.
* mprobe: (libc)Heap Consistency Checking.
* mrand48_r: (libc)SVID Random.
* mrand48: (libc)SVID Random.
* mremap: (libc)Memory-mapped I/O.
* MSG_DONTROUTE: (libc)Socket Data Options.
* MSG_OOB: (libc)Socket Data Options.
* MSG_PEEK: (libc)Socket Data Options.
* msync: (libc)Memory-mapped I/O.
* mtrace: (libc)Tracing malloc.
* munlockall: (libc)Page Lock Functions.
* munlock: (libc)Page Lock Functions.
* munmap: (libc)Memory-mapped I/O.
* muntrace: (libc)Tracing malloc.
* NAME_MAX: (libc)Limits for Files.
* nanf: (libc)FP Bit Twiddling.
* nanl: (libc)FP Bit Twiddling.
* nanosleep: (libc)Sleeping.
* nan: (libc)FP Bit Twiddling.
* NAN: (libc)Infinity and NaN.
* NCCS: (libc)Mode Data Types.
* nearbyintf: (libc)Rounding Functions.
* nearbyintl: (libc)Rounding Functions.
* nearbyint: (libc)Rounding Functions.
* nextafterf: (libc)FP Bit Twiddling.
* nextafterl: (libc)FP Bit Twiddling.
* nextafter: (libc)FP Bit Twiddling.
* nexttowardf: (libc)FP Bit Twiddling.
* nexttowardl: (libc)FP Bit Twiddling.
* nexttoward: (libc)FP Bit Twiddling.
* nftw: (libc)Working with Directory Trees.
* nftw64: (libc)Working with Directory Trees.
* ngettext: (libc)Advanced gettext functions.
* NGROUPS_MAX: (libc)General Limits.
* nice: (libc)Traditional Scheduling Functions.
* nl_langinfo: (libc)The Elegant and Fast Way.
* NOFLSH: (libc)Local Modes.
* NOKERNINFO: (libc)Local Modes.
* nrand48_r: (libc)SVID Random.
* nrand48: (libc)SVID Random.
* NSIG: (libc)Standard Signals.
* ntohl: (libc)Byte Order.
* ntohs: (libc)Byte Order.
* ntp_adjtime: (libc)High Accuracy Clock.
* ntp_gettime: (libc)High Accuracy Clock.
* NULL: (libc)Null Pointer Constant.
* O_ACCMODE: (libc)Access Modes.
* O_APPEND: (libc)Operating Modes.
* O_ASYNC: (libc)Operating Modes.
* O_CREAT: (libc)Open-time Flags.
* O_EXCL: (libc)Open-time Flags.
* O_EXEC: (libc)Access Modes.
* O_EXLOCK: (libc)Open-time Flags.
* O_FSYNC: (libc)Operating Modes.
* O_IGNORE_CTTY: (libc)Open-time Flags.
* O_NDELAY: (libc)Operating Modes.
* O_NOATIME: (libc)Operating Modes.
* O_NOCTTY: (libc)Open-time Flags.
* O_NOLINK: (libc)Open-time Flags.
* O_NONBLOCK: (libc)Operating Modes.
* O_NONBLOCK: (libc)Open-time Flags.
* O_NOTRANS: (libc)Open-time Flags.
* O_RDONLY: (libc)Access Modes.
* O_RDWR: (libc)Access Modes.
* O_READ: (libc)Access Modes.
* O_SHLOCK: (libc)Open-time Flags.
* O_SYNC: (libc)Operating Modes.
* O_TRUNC: (libc)Open-time Flags.
* O_WRITE: (libc)Access Modes.
* O_WRONLY: (libc)Access Modes.
* obstack_1grow_fast: (libc)Extra Fast Growing.
* obstack_1grow: (libc)Growing Objects.
* obstack_alignment_mask: (libc)Obstacks Data Alignment.
* obstack_alloc: (libc)Allocation in an Obstack.
* obstack_base: (libc)Status of an Obstack.
* obstack_blank_fast: (libc)Extra Fast Growing.
* obstack_blank: (libc)Growing Objects.
* obstack_chunk_size: (libc)Obstack Chunks.
* obstack_copy: (libc)Allocation in an Obstack.
* obstack_copy0: (libc)Allocation in an Obstack.
* obstack_finish: (libc)Growing Objects.
* obstack_free: (libc)Freeing Obstack Objects.
* obstack_grow: (libc)Growing Objects.
* obstack_grow0: (libc)Growing Objects.
* obstack_init: (libc)Preparing for Obstacks.
* obstack_int_grow_fast: (libc)Extra Fast Growing.
* obstack_int_grow: (libc)Growing Objects.
* obstack_next_free: (libc)Status of an Obstack.
* obstack_object_size: (libc)Status of an Obstack.
* obstack_object_size: (libc)Growing Objects.
* obstack_printf: (libc)Dynamic Output.
* obstack_ptr_grow_fast: (libc)Extra Fast Growing.
* obstack_ptr_grow: (libc)Growing Objects.
* obstack_room: (libc)Extra Fast Growing.
* obstack_vprintf: (libc)Variable Arguments Output.
* offsetof: (libc)Structure Measurement.
* on_exit: (libc)Cleanups on Exit.
* ONLCR: (libc)Output Modes.
* ONOEOT: (libc)Output Modes.
* open64: (libc)Opening and Closing Files.
* OPEN_MAX: (libc)General Limits.
* open_memstream: (libc)String Streams.
* opendir: (libc)Opening a Directory.
* openlog: (libc)openlog.
* openpty: (libc)Pseudo-Terminal Pairs.
* open: (libc)Opening and Closing Files.
* OPOST: (libc)Output Modes.
* OXTABS: (libc)Output Modes.
* P_tmpdir: (libc)Temporary Files.
* PA_FLAG_MASK: (libc)Parsing a Template String.
* PARENB: (libc)Control Modes.
* PARMRK: (libc)Input Modes.
* PARODD: (libc)Control Modes.
* parse_printf_format: (libc)Parsing a Template String.
* PATH_MAX: (libc)Limits for Files.
* pathconf: (libc)Pathconf.
* pause: (libc)Using Pause.
* pclose: (libc)Pipe to a Subprocess.
* PENDIN: (libc)Local Modes.
* perror: (libc)Error Messages.
* PF_FILE: (libc)Local Namespace Details.
* PF_INET: (libc)Internet Namespace.
* PF_INET6: (libc)Internet Namespace.
* PF_LOCAL: (libc)Local Namespace Details.
* PF_UNIX: (libc)Local Namespace Details.
* pipe: (libc)Creating a Pipe.
* PIPE_BUF: (libc)Limits for Files.
* popen: (libc)Pipe to a Subprocess.
* posix_memalign: (libc)Aligned Memory Blocks.
* pow10f: (libc)Exponents and Logarithms.
* pow10l: (libc)Exponents and Logarithms.
* pow10: (libc)Exponents and Logarithms.
* powf: (libc)Exponents and Logarithms.
* powl: (libc)Exponents and Logarithms.
* pow: (libc)Exponents and Logarithms.
* pread: (libc)I/O Primitives.
* pread64: (libc)I/O Primitives.
* printf_size_info: (libc)Predefined Printf Handlers.
* printf_size: (libc)Predefined Printf Handlers.
* printf: (libc)Formatted Output Functions.
* psignal: (libc)Signal Messages.
* pthread_getattr_default_np: (libc)Default Thread Attributes.
* pthread_getspecific: (libc)Thread-specific Data.
* pthread_key_create: (libc)Thread-specific Data.
* pthread_key_delete: (libc)Thread-specific Data.
* pthread_setattr_default_np: (libc)Default Thread Attributes.
* pthread_setspecific: (libc)Thread-specific Data.
* ptsname_r: (libc)Allocation.
* ptsname: (libc)Allocation.
* putc_unlocked: (libc)Simple Output.
* putchar_unlocked: (libc)Simple Output.
* putchar: (libc)Simple Output.
* putc: (libc)Simple Output.
* putenv: (libc)Environment Access.
* putpwent: (libc)Writing a User Entry.
* puts: (libc)Simple Output.
* pututline: (libc)Manipulating the Database.
* pututxline: (libc)XPG Functions.
* putwc_unlocked: (libc)Simple Output.
* putwchar_unlocked: (libc)Simple Output.
* putwchar: (libc)Simple Output.
* putwc: (libc)Simple Output.
* putw: (libc)Simple Output.
* pwrite: (libc)I/O Primitives.
* pwrite64: (libc)I/O Primitives.
* qecvt_r: (libc)System V Number Conversion.
* qecvt: (libc)System V Number Conversion.
* qfcvt_r: (libc)System V Number Conversion.
* qfcvt: (libc)System V Number Conversion.
* qgcvt: (libc)System V Number Conversion.
* qsort: (libc)Array Sort Function.
* R_OK: (libc)Testing File Access.
* raise: (libc)Signaling Yourself.
* RAND_MAX: (libc)ISO Random.
* rand_r: (libc)ISO Random.
* random_r: (libc)BSD Random.
* random: (libc)BSD Random.
* rand: (libc)ISO Random.
* rawmemchr: (libc)Search Functions.
* RE_DUP_MAX: (libc)General Limits.
* readdir64_r: (libc)Reading/Closing Directory.
* readdir64: (libc)Reading/Closing Directory.
* readdir_r: (libc)Reading/Closing Directory.
* readdir: (libc)Reading/Closing Directory.
* readlink: (libc)Symbolic Links.
* readv: (libc)Scatter-Gather.
* read: (libc)I/O Primitives.
* realloc: (libc)Changing Block Size.
* realpath: (libc)Symbolic Links.
* recvfrom: (libc)Receiving Datagrams.
* recvmsg: (libc)Receiving Datagrams.
* recv: (libc)Receiving Data.
* regcomp: (libc)POSIX Regexp Compilation.
* regerror: (libc)Regexp Cleanup.
* regexec: (libc)Matching POSIX Regexps.
* regfree: (libc)Regexp Cleanup.
* register_printf_function: (libc)Registering New Conversions.
* remainderf: (libc)Remainder Functions.
* remainderl: (libc)Remainder Functions.
* remainder: (libc)Remainder Functions.
* remove: (libc)Deleting Files.
* rename: (libc)Renaming Files.
* rewinddir: (libc)Random Access Directory.
* rewind: (libc)File Positioning.
* rindex: (libc)Search Functions.
* rintf: (libc)Rounding Functions.
* rintl: (libc)Rounding Functions.
* rint: (libc)Rounding Functions.
* RLIM_INFINITY: (libc)Limits on Resources.
* rmdir: (libc)Deleting Files.
* roundf: (libc)Rounding Functions.
* roundl: (libc)Rounding Functions.
* round: (libc)Rounding Functions.
* rpmatch: (libc)Yes-or-No Questions.
* S_IFMT: (libc)Testing File Type.
* S_ISBLK: (libc)Testing File Type.
* S_ISCHR: (libc)Testing File Type.
* S_ISDIR: (libc)Testing File Type.
* S_ISFIFO: (libc)Testing File Type.
* S_ISLNK: (libc)Testing File Type.
* S_ISREG: (libc)Testing File Type.
* S_ISSOCK: (libc)Testing File Type.
* S_TYPEISMQ: (libc)Testing File Type.
* S_TYPEISSEM: (libc)Testing File Type.
* S_TYPEISSHM: (libc)Testing File Type.
* SA_NOCLDSTOP: (libc)Flags for Sigaction.
* SA_ONSTACK: (libc)Flags for Sigaction.
* SA_RESTART: (libc)Flags for Sigaction.
* sbrk: (libc)Resizing the Data Segment.
* scalbf: (libc)Normalization Functions.
* scalblnf: (libc)Normalization Functions.
* scalblnl: (libc)Normalization Functions.
* scalbln: (libc)Normalization Functions.
* scalbl: (libc)Normalization Functions.
* scalbnf: (libc)Normalization Functions.
* scalbnl: (libc)Normalization Functions.
* scalbn: (libc)Normalization Functions.
* scalb: (libc)Normalization Functions.
* scandir: (libc)Scanning Directory Content.
* scandir64: (libc)Scanning Directory Content.
* scanf: (libc)Formatted Input Functions.
* sched_get_priority_max: (libc)Basic Scheduling Functions.
* sched_get_priority_min: (libc)Basic Scheduling Functions.
* sched_getaffinity: (libc)CPU Affinity.
* sched_getparam: (libc)Basic Scheduling Functions.
* sched_getscheduler: (libc)Basic Scheduling Functions.
* sched_rr_get_interval: (libc)Basic Scheduling Functions.
* sched_setaffinity: (libc)CPU Affinity.
* sched_setparam: (libc)Basic Scheduling Functions.
* sched_setscheduler: (libc)Basic Scheduling Functions.
* sched_yield: (libc)Basic Scheduling Functions.
* secure_getenv: (libc)Environment Access.
* seed48_r: (libc)SVID Random.
* seed48: (libc)SVID Random.
* SEEK_CUR: (libc)File Positioning.
* SEEK_END: (libc)File Positioning.
* SEEK_SET: (libc)File Positioning.
* seekdir: (libc)Random Access Directory.
* select: (libc)Waiting for I/O.
* sem_close: (libc)Semaphores.
* sem_destroy: (libc)Semaphores.
* sem_getvalue: (libc)Semaphores.
* sem_init: (libc)Semaphores.
* sem_open: (libc)Semaphores.
* sem_post: (libc)Semaphores.
* sem_timedwait: (libc)Semaphores.
* sem_trywait: (libc)Semaphores.
* sem_unlink: (libc)Semaphores.
* sem_wait: (libc)Semaphores.
* semctl: (libc)Semaphores.
* semget: (libc)Semaphores.
* semop: (libc)Semaphores.
* semtimedop: (libc)Semaphores.
* sendmsg: (libc)Receiving Datagrams.
* sendto: (libc)Sending Datagrams.
* send: (libc)Sending Data.
* setbuffer: (libc)Controlling Buffering.
* setbuf: (libc)Controlling Buffering.
* setcontext: (libc)System V contexts.
* setdomainname: (libc)Host Identification.
* setegid: (libc)Setting Groups.
* setenv: (libc)Environment Access.
* seteuid: (libc)Setting User ID.
* setfsent: (libc)fstab.
* setgid: (libc)Setting Groups.
* setgrent: (libc)Scanning All Groups.
* setgroups: (libc)Setting Groups.
* sethostent: (libc)Host Names.
* sethostid: (libc)Host Identification.
* sethostname: (libc)Host Identification.
* setitimer: (libc)Setting an Alarm.
* setjmp: (libc)Non-Local Details.
* setkey_r: (libc)DES Encryption.
* setkey: (libc)DES Encryption.
* setlinebuf: (libc)Controlling Buffering.
* setlocale: (libc)Setting the Locale.
* setlogmask: (libc)setlogmask.
* setmntent: (libc)mtab.
* setnetent: (libc)Networks Database.
* setnetgrent: (libc)Lookup Netgroup.
* setpgid: (libc)Process Group Functions.
* setpgrp: (libc)Process Group Functions.
* setpriority: (libc)Traditional Scheduling Functions.
* setprotoent: (libc)Protocols Database.
* setpwent: (libc)Scanning All Users.
* setregid: (libc)Setting Groups.
* setreuid: (libc)Setting User ID.
* setrlimit: (libc)Limits on Resources.
* setrlimit64: (libc)Limits on Resources.
* setservent: (libc)Services Database.
* setsid: (libc)Process Group Functions.
* setsockopt: (libc)Socket Option Functions.
* setstate_r: (libc)BSD Random.
* setstate: (libc)BSD Random.
* settimeofday: (libc)High-Resolution Calendar.
* setuid: (libc)Setting User ID.
* setutent: (libc)Manipulating the Database.
* setutxent: (libc)XPG Functions.
* setvbuf: (libc)Controlling Buffering.
* shm_open: (libc)Memory-mapped I/O.
* shm_unlink: (libc)Memory-mapped I/O.
* shutdown: (libc)Closing a Socket.
* SIG_ERR: (libc)Basic Signal Handling.
* SIGABRT: (libc)Program Error Signals.
* sigaction: (libc)Advanced Signal Handling.
* sigaddset: (libc)Signal Sets.
* SIGALRM: (libc)Alarm Signals.
* sigaltstack: (libc)Signal Stack.
* sigblock: (libc)BSD Signal Handling.
* SIGBUS: (libc)Program Error Signals.
* SIGCHLD: (libc)Job Control Signals.
* SIGCLD: (libc)Job Control Signals.
* SIGCONT: (libc)Job Control Signals.
* sigdelset: (libc)Signal Sets.
* sigemptyset: (libc)Signal Sets.
* SIGEMT: (libc)Program Error Signals.
* sigfillset: (libc)Signal Sets.
* SIGFPE: (libc)Program Error Signals.
* SIGHUP: (libc)Termination Signals.
* SIGILL: (libc)Program Error Signals.
* SIGINFO: (libc)Miscellaneous Signals.
* siginterrupt: (libc)BSD Signal Handling.
* SIGINT: (libc)Termination Signals.
* SIGIOT: (libc)Program Error Signals.
* SIGIO: (libc)Asynchronous I/O Signals.
* sigismember: (libc)Signal Sets.
* SIGKILL: (libc)Termination Signals.
* siglongjmp: (libc)Non-Local Exits and Signals.
* SIGLOST: (libc)Operation Error Signals.
* sigmask: (libc)BSD Signal Handling.
* signal: (libc)Basic Signal Handling.
* signbit: (libc)FP Bit Twiddling.
* significandf: (libc)Normalization Functions.
* significandl: (libc)Normalization Functions.
* significand: (libc)Normalization Functions.
* sigpause: (libc)BSD Signal Handling.
* sigpending: (libc)Checking for Pending Signals.
* SIGPIPE: (libc)Operation Error Signals.
* SIGPOLL: (libc)Asynchronous I/O Signals.
* sigprocmask: (libc)Process Signal Mask.
* SIGPROF: (libc)Alarm Signals.
* SIGQUIT: (libc)Termination Signals.
* SIGSEGV: (libc)Program Error Signals.
* sigsetjmp: (libc)Non-Local Exits and Signals.
* sigsetmask: (libc)BSD Signal Handling.
* sigstack: (libc)Signal Stack.
* SIGSTOP: (libc)Job Control Signals.
* sigsuspend: (libc)Sigsuspend.
* SIGSYS: (libc)Program Error Signals.
* SIGTERM: (libc)Termination Signals.
* SIGTRAP: (libc)Program Error Signals.
* SIGTSTP: (libc)Job Control Signals.
* SIGTTIN: (libc)Job Control Signals.
* SIGTTOU: (libc)Job Control Signals.
* SIGURG: (libc)Asynchronous I/O Signals.
* SIGUSR1: (libc)Miscellaneous Signals.
* SIGUSR2: (libc)Miscellaneous Signals.
* SIGVTALRM: (libc)Alarm Signals.
* SIGWINCH: (libc)Miscellaneous Signals.
* SIGXCPU: (libc)Operation Error Signals.
* SIGXFSZ: (libc)Operation Error Signals.
* sincosf: (libc)Trig Functions.
* sincosl: (libc)Trig Functions.
* sincos: (libc)Trig Functions.
* sinf: (libc)Trig Functions.
* sinhf: (libc)Hyperbolic Functions.
* sinhl: (libc)Hyperbolic Functions.
* sinh: (libc)Hyperbolic Functions.
* sinl: (libc)Trig Functions.
* sin: (libc)Trig Functions.
* sleep: (libc)Sleeping.
* snprintf: (libc)Formatted Output Functions.
* SOCK_DGRAM: (libc)Communication Styles.
* SOCK_RAW: (libc)Communication Styles.
* SOCK_RDM: (libc)Communication Styles.
* SOCK_SEQPACKET: (libc)Communication Styles.
* SOCK_STREAM: (libc)Communication Styles.
* socketpair: (libc)Socket Pairs.
* socket: (libc)Creating a Socket.
* SOL_SOCKET: (libc)Socket-Level Options.
* sprintf: (libc)Formatted Output Functions.
* sqrtf: (libc)Exponents and Logarithms.
* sqrtl: (libc)Exponents and Logarithms.
* sqrt: (libc)Exponents and Logarithms.
* srandom_r: (libc)BSD Random.
* srandom: (libc)BSD Random.
* srand: (libc)ISO Random.
* srand48_r: (libc)SVID Random.
* srand48: (libc)SVID Random.
* sscanf: (libc)Formatted Input Functions.
* ssignal: (libc)Basic Signal Handling.
* SSIZE_MAX: (libc)General Limits.
* stat: (libc)Reading Attributes.
* stat64: (libc)Reading Attributes.
* stime: (libc)Simple Calendar Time.
* stpcpy: (libc)Copying and Concatenation.
* stpncpy: (libc)Copying and Concatenation.
* strcasecmp: (libc)String/Array Comparison.
* strcasestr: (libc)Search Functions.
* strcat: (libc)Copying and Concatenation.
* strchrnul: (libc)Search Functions.
* strchr: (libc)Search Functions.
* strcmp: (libc)String/Array Comparison.
* strcoll: (libc)Collation Functions.
* strcpy: (libc)Copying and Concatenation.
* strcspn: (libc)Search Functions.
* strdupa: (libc)Copying and Concatenation.
* strdup: (libc)Copying and Concatenation.
* STREAM_MAX: (libc)General Limits.
* strerror_r: (libc)Error Messages.
* strerror: (libc)Error Messages.
* strfmon: (libc)Formatting Numbers.
* strfry: (libc)strfry.
* strftime: (libc)Formatting Calendar Time.
* strlen: (libc)String Length.
* strncasecmp: (libc)String/Array Comparison.
* strncat: (libc)Copying and Concatenation.
* strncmp: (libc)String/Array Comparison.
* strncpy: (libc)Copying and Concatenation.
* strndupa: (libc)Copying and Concatenation.
* strndup: (libc)Copying and Concatenation.
* strnlen: (libc)String Length.
* strpbrk: (libc)Search Functions.
* strptime: (libc)Low-Level Time String Parsing.
* strrchr: (libc)Search Functions.
* strsep: (libc)Finding Tokens in a String.
* strsignal: (libc)Signal Messages.
* strspn: (libc)Search Functions.
* strstr: (libc)Search Functions.
* strtod: (libc)Parsing of Floats.
* strtof: (libc)Parsing of Floats.
* strtoimax: (libc)Parsing of Integers.
* strtok_r: (libc)Finding Tokens in a String.
* strtok: (libc)Finding Tokens in a String.
* strtold: (libc)Parsing of Floats.
* strtoll: (libc)Parsing of Integers.
* strtol: (libc)Parsing of Integers.
* strtoq: (libc)Parsing of Integers.
* strtoull: (libc)Parsing of Integers.
* strtoul: (libc)Parsing of Integers.
* strtoumax: (libc)Parsing of Integers.
* strtouq: (libc)Parsing of Integers.
* strverscmp: (libc)String/Array Comparison.
* strxfrm: (libc)Collation Functions.
* stty: (libc)BSD Terminal Modes.
* SUN_LEN: (libc)Local Namespace Details.
* swapcontext: (libc)System V contexts.
* swprintf: (libc)Formatted Output Functions.
* swscanf: (libc)Formatted Input Functions.
* symlink: (libc)Symbolic Links.
* sync: (libc)Synchronizing I/O.
* syscall: (libc)System Calls.
* sysconf: (libc)Sysconf Definition.
* sysctl: (libc)System Parameters.
* syslog: (libc)syslog; vsyslog.
* system: (libc)Running a Command.
* sysv_signal: (libc)Basic Signal Handling.
* tanf: (libc)Trig Functions.
* tanhf: (libc)Hyperbolic Functions.
* tanhl: (libc)Hyperbolic Functions.
* tanh: (libc)Hyperbolic Functions.
* tanl: (libc)Trig Functions.
* tan: (libc)Trig Functions.
* tcdrain: (libc)Line Control.
* tcflow: (libc)Line Control.
* tcflush: (libc)Line Control.
* tcgetattr: (libc)Mode Functions.
* tcgetpgrp: (libc)Terminal Access Functions.
* tcgetsid: (libc)Terminal Access Functions.
* tcsendbreak: (libc)Line Control.
* tcsetattr: (libc)Mode Functions.
* tcsetpgrp: (libc)Terminal Access Functions.
* tdelete: (libc)Tree Search Function.
* tdestroy: (libc)Tree Search Function.
* telldir: (libc)Random Access Directory.
* tempnam: (libc)Temporary Files.
* textdomain: (libc)Locating gettext catalog.
* tfind: (libc)Tree Search Function.
* tgammaf: (libc)Special Functions.
* tgammal: (libc)Special Functions.
* tgamma: (libc)Special Functions.
* timegm: (libc)Broken-down Time.
* timelocal: (libc)Broken-down Time.
* times: (libc)Processor Time.
* time: (libc)Simple Calendar Time.
* TMP_MAX: (libc)Temporary Files.
* tmpfile: (libc)Temporary Files.
* tmpfile64: (libc)Temporary Files.
* tmpnam_r: (libc)Temporary Files.
* tmpnam: (libc)Temporary Files.
* toascii: (libc)Case Conversion.
* tolower: (libc)Case Conversion.
* TOSTOP: (libc)Local Modes.
* toupper: (libc)Case Conversion.
* towctrans: (libc)Wide Character Case Conversion.
* towlower: (libc)Wide Character Case Conversion.
* towupper: (libc)Wide Character Case Conversion.
* truncate: (libc)File Size.
* truncate64: (libc)File Size.
* truncf: (libc)Rounding Functions.
* truncl: (libc)Rounding Functions.
* trunc: (libc)Rounding Functions.
* tsearch: (libc)Tree Search Function.
* ttyname_r: (libc)Is It a Terminal.
* ttyname: (libc)Is It a Terminal.
* twalk: (libc)Tree Search Function.
* TZNAME_MAX: (libc)General Limits.
* tzset: (libc)Time Zone Functions.
* ulimit: (libc)Limits on Resources.
* umask: (libc)Setting Permissions.
* umount: (libc)Mount-Unmount-Remount.
* umount2: (libc)Mount-Unmount-Remount.
* uname: (libc)Platform Type.
* ungetc: (libc)How Unread.
* ungetwc: (libc)How Unread.
* unlink: (libc)Deleting Files.
* unlockpt: (libc)Allocation.
* unsetenv: (libc)Environment Access.
* updwtmp: (libc)Manipulating the Database.
* utimes: (libc)File Times.
* utime: (libc)File Times.
* utmpname: (libc)Manipulating the Database.
* utmpxname: (libc)XPG Functions.
* va_arg: (libc)Argument Macros.
* va_copy: (libc)Argument Macros.
* va_end: (libc)Argument Macros.
* va_start: (libc)Argument Macros.
* valloc: (libc)Aligned Memory Blocks.
* vasprintf: (libc)Variable Arguments Output.
* VDISCARD: (libc)Other Special.
* VDSUSP: (libc)Signal Characters.
* VEOF: (libc)Editing Characters.
* VEOL: (libc)Editing Characters.
* VEOL2: (libc)Editing Characters.
* VERASE: (libc)Editing Characters.
* verrx: (libc)Error Messages.
* verr: (libc)Error Messages.
* versionsort: (libc)Scanning Directory Content.
* versionsort64: (libc)Scanning Directory Content.
* vfork: (libc)Creating a Process.
* vfprintf: (libc)Variable Arguments Output.
* vfscanf: (libc)Variable Arguments Input.
* vfwprintf: (libc)Variable Arguments Output.
* vfwscanf: (libc)Variable Arguments Input.
* VINTR: (libc)Signal Characters.
* VKILL: (libc)Editing Characters.
* vlimit: (libc)Limits on Resources.
* VLNEXT: (libc)Other Special.
* VMIN: (libc)Noncanonical Input.
* vprintf: (libc)Variable Arguments Output.
* VQUIT: (libc)Signal Characters.
* VREPRINT: (libc)Editing Characters.
* vscanf: (libc)Variable Arguments Input.
* vsnprintf: (libc)Variable Arguments Output.
* vsprintf: (libc)Variable Arguments Output.
* vsscanf: (libc)Variable Arguments Input.
* VSTART: (libc)Start/Stop Characters.
* VSTATUS: (libc)Other Special.
* VSTOP: (libc)Start/Stop Characters.
* VSUSP: (libc)Signal Characters.
* vswprintf: (libc)Variable Arguments Output.
* vswscanf: (libc)Variable Arguments Input.
* vsyslog: (libc)syslog; vsyslog.
* vtimes: (libc)Resource Usage.
* VTIME: (libc)Noncanonical Input.
* vwarnx: (libc)Error Messages.
* vwarn: (libc)Error Messages.
* VWERASE: (libc)Editing Characters.
* vwprintf: (libc)Variable Arguments Output.
* vwscanf: (libc)Variable Arguments Input.
* W_OK: (libc)Testing File Access.
* waitpid: (libc)Process Completion.
* wait: (libc)Process Completion.
* wait3: (libc)BSD Wait Functions.
* wait4: (libc)Process Completion.
* warnx: (libc)Error Messages.
* warn: (libc)Error Messages.
* WCHAR_MAX: (libc)Extended Char Intro.
* WCHAR_MIN: (libc)Extended Char Intro.
* WCOREDUMP: (libc)Process Completion Status.
* wcpcpy: (libc)Copying and Concatenation.
* wcpncpy: (libc)Copying and Concatenation.
* wcrtomb: (libc)Converting a Character.
* wcscasecmp: (libc)String/Array Comparison.
* wcscat: (libc)Copying and Concatenation.
* wcschrnul: (libc)Search Functions.
* wcschr: (libc)Search Functions.
* wcscmp: (libc)String/Array Comparison.
* wcscoll: (libc)Collation Functions.
* wcscpy: (libc)Copying and Concatenation.
* wcscspn: (libc)Search Functions.
* wcsdup: (libc)Copying and Concatenation.
* wcsftime: (libc)Formatting Calendar Time.
* wcslen: (libc)String Length.
* wcsncasecmp: (libc)String/Array Comparison.
* wcsncat: (libc)Copying and Concatenation.
* wcsncmp: (libc)String/Array Comparison.
* wcsncpy: (libc)Copying and Concatenation.
* wcsnlen: (libc)String Length.
* wcsnrtombs: (libc)Converting Strings.
* wcspbrk: (libc)Search Functions.
* wcsrchr: (libc)Search Functions.
* wcsrtombs: (libc)Converting Strings.
* wcsspn: (libc)Search Functions.
* wcsstr: (libc)Search Functions.
* wcstod: (libc)Parsing of Floats.
* wcstof: (libc)Parsing of Floats.
* wcstoimax: (libc)Parsing of Integers.
* wcstok: (libc)Finding Tokens in a String.
* wcstold: (libc)Parsing of Floats.
* wcstoll: (libc)Parsing of Integers.
* wcstol: (libc)Parsing of Integers.
* wcstombs: (libc)Non-reentrant String Conversion.
* wcstoq: (libc)Parsing of Integers.
* wcstoull: (libc)Parsing of Integers.
* wcstoul: (libc)Parsing of Integers.
* wcstoumax: (libc)Parsing of Integers.
* wcstouq: (libc)Parsing of Integers.
* wcswcs: (libc)Search Functions.
* wcsxfrm: (libc)Collation Functions.
* wctob: (libc)Converting a Character.
* wctomb: (libc)Non-reentrant Character Conversion.
* wctrans: (libc)Wide Character Case Conversion.
* wctype: (libc)Classification of Wide Characters.
* WEOF: (libc)Extended Char Intro.
* WEOF: (libc)EOF and Errors.
* WEXITSTATUS: (libc)Process Completion Status.
* WIFEXITED: (libc)Process Completion Status.
* WIFSIGNALED: (libc)Process Completion Status.
* WIFSTOPPED: (libc)Process Completion Status.
* wmemchr: (libc)Search Functions.
* wmemcmp: (libc)String/Array Comparison.
* wmemcpy: (libc)Copying and Concatenation.
* wmemmove: (libc)Copying and Concatenation.
* wmempcpy: (libc)Copying and Concatenation.
* wmemset: (libc)Copying and Concatenation.
* wordexp: (libc)Calling Wordexp.
* wordfree: (libc)Calling Wordexp.
* wprintf: (libc)Formatted Output Functions.
* writev: (libc)Scatter-Gather.
* write: (libc)I/O Primitives.
* wscanf: (libc)Formatted Input Functions.
* WSTOPSIG: (libc)Process Completion Status.
* WTERMSIG: (libc)Process Completion Status.
* X_OK: (libc)Testing File Access.
* y0f: (libc)Special Functions.
* y0l: (libc)Special Functions.
* y0: (libc)Special Functions.
* y1f: (libc)Special Functions.
* y1l: (libc)Special Functions.
* y1: (libc)Special Functions.
* ynf: (libc)Special Functions.
* ynl: (libc)Special Functions.
* yn: (libc)Special Functions.

Software libraries
* Libc: (libc).                 C library.
__EOF__
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
  if [ -x /usr/bin/install-info ] ; then
    install-info --delete --info-file=usr/share/info/libc.info.gz --dir-file=usr/share/info/dir 2> /dev/null
  fi
}

# arg 1:  the old package version
post_remove() {
  /bin/true
}


operation=$1
shift

$operation $*
