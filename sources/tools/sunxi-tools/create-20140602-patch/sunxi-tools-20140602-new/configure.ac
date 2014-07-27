#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.68])
AC_INIT([sunxi-tools], [1.0], [https://github.com/linux-sunxi/sunxi-tools])
AC_CONFIG_SRCDIR([fel-copy.c])

AC_CANONICAL_SYSTEM

# automake initialisation and check for minimal automake API version 1.9
AM_INIT_AUTOMAKE([1.9])

AC_CANONICAL_HOST

# Checks for programs.
AC_PROG_CC
AC_PROG_CPP
AM_PROG_AS

AC_CHECK_PROGS(CC_FOR_BUILD, gcc cc)
AC_CHECK_PROGS(CXX_FOR_BUILD, g++)
AC_CHECK_PROGS(OBJCOPY, objcopy)
AC_CHECK_PROGS(NM, nm)

AC_SUBST([CCC_FOR_BUILD])
AC_SUBST([CXX_FOR_BUILD])
AC_SUBST([OBJCOPY])
AC_SUBST([NM])

case "$host_cpu" in
  arm*)
    THUMB_CFLAGS="$THUMB_CFLAGS -mno-thumb-interwork"
    ;;
esac

AC_SUBST([THUMB_CFLAGS])


AC_PROG_LN_S
AC_PROG_MKDIR_P


AC_FUNC_MALLOC

# Checks for libraries.
PKG_CHECK_MODULES([LIBUSB], libusb-1.0 >= 1.0.0,, AC_MSG_ERROR([*** Required libusb-1.0 >= 1.0.0 not installed ***]))

# Checks for header files.
AC_CHECK_HEADERS([fcntl.h stddef.h stdint.h stdlib.h string.h sys/ioctl.h sys/mount.h unistd.h])

# Checks for typedefs, structures, and compiler characteristics.
AC_C_INLINE
AC_TYPE_INT32_T
AC_TYPE_SIZE_T
AC_TYPE_SSIZE_T
AC_TYPE_UINT16_T
AC_TYPE_UINT32_T
AC_TYPE_UINT8_T

# Checks for library functions.
AC_FUNC_MALLOC
AC_FUNC_MMAP
AC_FUNC_REALLOC
AC_CHECK_FUNCS([memset munmap strchr strerror strtol strtoul])

AC_CONFIG_FILES([Makefile])
AC_OUTPUT
