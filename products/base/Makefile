
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_ORANGE_PP2E)
COMPONENT_TARGETS += $(HARDWARE_NANOPI_NEO)
COMPONENT_TARGETS += $(HARDWARE_ORANGE_PP)
COMPONENT_TARGETS += $(HARDWARE_ORANGE_PL2)
COMPONENT_TARGETS += $(HARDWARE_WECHIP_TX6)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_POIN2)
COMPONENT_TARGETS += $(HARDWARE_RK3328_CC)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_EDGE)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXV)
COMPONENT_TARGETS += $(HARDWARE_P201)
COMPONENT_TARGETS += $(HARDWARE_NEXBOX_A95X)
COMPONENT_TARGETS += $(HARDWARE_ODROID_C2)
COMPONENT_TARGETS += $(HARDWARE_P212)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_VIM)
COMPONENT_TARGETS += $(HARDWARE_Q201)
COMPONENT_TARGETS += $(HARDWARE_ENYBOX_X2)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_VIM2)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OKMX6DL_C)
COMPONENT_TARGETS += $(HARDWARE_OKMX6Q_C)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BAIKAL_T1)
COMPONENT_TARGETS += $(HARDWARE_MBC4_PC)
COMPONENT_TARGETS += $(HARDWARE_S824L)
COMPONENT_TARGETS += $(HARDWARE_VESNIN)
COMPONENT_TARGETS += $(HARDWARE_S824L_LSB)
COMPONENT_TARGETS += $(HARDWARE_VESNIN_LSB)
COMPONENT_TARGETS += $(HARDWARE_TL2WK2)
COMPONENT_TARGETS += $(HARDWARE_TL2SV2)
COMPONENT_TARGETS += $(HARDWARE_TL2WK2_LSB)
COMPONENT_TARGETS += $(HARDWARE_TL2SV2_LSB)


NEED_ABS_PATH = true


include ../../build-system/constants.mk


#######
####### Boot
#######

ifneq ($(filter $(HARDWARE),$(HARDWARE_NEXBOX_A95X)),)
REQUIRES  = boot/u-boot/a95x/2015.01-20170107
endif

ifneq ($(filter $(HARDWARE),$(HARDWARE_ODROID_C2)),)
REQUIRES  = boot/u-boot/odroid-c2/2015.01-20170224
endif

ifneq ($(filter $(HARDWARE),$(HARDWARE_KHADAS_VIM)),)
REQUIRES  = hal/drivers/amlogic/brcmap6xxx/1.201.59.x
REQUIRES += boot/u-boot/kvim/2015.01-20170107
endif

ifneq ($(filter $(HARDWARE),$(HARDWARE_ENYBOX_X2)),)
REQUIRES  = hal/drivers/amlogic/brcmap6xxx/1.201.59.x
REQUIRES += boot/u-boot/x2/2015.01-20170107
endif

ifneq ($(filter $(HARDWARE),$(HARDWARE_M201)),)
REQUIRES  = boot/u-boot/s8xx/2011.03-20160716
endif

ifneq ($(filter $(HARDWARE),$(HARDWARE_MXV)),)
REQUIRES  = boot/u-boot/s8xx/2011.03-20160716
endif

ifneq ($(filter $(HARDWARE),$(HARDWARE_NIT6Q)),)
REQUIRES  = boot/u-boot/nit6q/2015.07-20160305
endif

ifneq ($(filter $(HARDWARE),$(HARDWARE_OMAP5UEVM) $(HARDWARE_DRA7XXEVM)),)
REQUIRES  = hal/drivers/omap543x/wl18xx_fw/8.9.27
REQUIRES += boot/u-boot/omap543x/2016.01
endif

ifneq ($(filter $(HARDWARE),$(HARDWARE_CB1X)),)
REQUIRES  = boot/u-boot/A10/2014.04-20140713
endif

ifneq ($(filter $(HARDWARE),$(HARDWARE_CB3X)),)
REQUIRES  = boot/u-boot/A20/2015.01
endif

ifneq ($(filter $(HARDWARE),$(HARDWARE_CI20)),)
REQUIRES  = hal/drivers/ci20/sgx-ddk/3.18/1.14.3759903
REQUIRES += hal/firmware/ci20/brcm4330/0.0.0
REQUIRES += boot/u-boot/ci20/2013.10-20150915
endif

ifneq ($(filter $(HARDWARE),$(HARDWARE_BAIKAL_T1)),)
REQUIRES  = boot/u-boot/bt1/2014.10-4.08.84
endif

ifneq ($(filter $(HARDWARE),$(HARDWARE_PC32) $(HARDWARE_PC64)),)
REQUIRES  = boot/lilo/x86/24.1
endif


#######
####### The System
#######

#
# .
# └── base/radix-system
#     └── dev/kernel-headers
#         └── dev/gcc-runtime
#             ├── libs/glibc/2.28
#             │   ├── libs/glibc/2.28-i18n
#             │   │   └── libs/glibc-zoneinfo/2019c ■
#             │   │
#             │   ├── libs/glibc/2.28-ppc32
#             │   ├── libs/glibc/2.28-sparc32
#             │   └── libs/glibc/2.28-x86_32
#             │
#            ...
#

REQUIRES += libs/glibc/2.28-zoneinfo/2019c
ifneq ($(filter $(HARDWARE),$(HARDWARE_S824L)  $(HARDWARE_VESNIN) \
                            $(HARDWARE_TL2WK2) $(HARDWARE_TL2SV2)),)
REQUIRES += libs/glibc/2.28-ppc32
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_MBC4_PC)),)
REQUIRES += libs/glibc/2.28-sparc32
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC64)),)
REQUIRES += libs/glibc/2.28-x86_32
endif

#            ...
#             │   ┌──────────────────────────────────────────────────────────────┐
#             │   │                                                              │
#             ├── libs/zlib/1.2.8 ─────────────────────────────────┐             │
#             │   │                                                │             │
#             │   ├── libs/zlib/1.2.8-ppc32 ──── if ppc64 ────┐    │             │
#             │   ├── libs/zlib/1.2.8-sparc32 ── if sparc64 ──┤    │             │
#             │   ├── libs/zlib/1.2.8-x86_32 ─── if x86_64 ───┤    │             │
#             │   │                                           │    │             │
#             │   └── dev/binutils/2.31.1 ────────────────────┘    │             │
#             │       └── dev/gcc/6.5.0                            │             │
#             │                                                    │             │
#             ├── app/xz/5.2.4               ─────┬────────────────┘             │
#             │   ├── app/xz/5.2.4-ppc32          └── app/kmod/26                │
#             │   ├── app/xz/5.2.4-sparc32            ├── app/kmod/26-ppc32      │
#             │   └── app/xz/5.2.4-x86_32             ├── app/kmod/26-sparc32    │
#             │                                       └── app/kmod/26-x86_32     │
#             ├── libs/libffi/3.2.1                                              │
#             │   ├── libs/libffi/3.2.1-ppc32                                    │
#             │   ├── libs/libffi/3.2.1-sparc32                                  │
#             │   └── libs/libffi/3.2.1-x86_32                                   │
#             │                                                                  │
#             ├── libs/libelf/0.8.13                                             │
#             │   ├── libs/libelf/0.8.13-ppc32                                   │
#             │   ├── libs/libelf/0.8.13-sparc32                                 │
#             │   └── libs/libelf/0.8.13-x86_32                                  │
#             │                                                                  │
#             ├── app/bzip2/1.0.6 ───────────────┬───────────────────────────────┤
#             │   ├── app/bzip2/1.0.6-ppc32      └── libs/pcre/8.43              │
#             │   ├── app/bzip2/1.0.6-sparc32        ├── libs/pcre/8.43-ppc32    │
#             │   └── app/bzip2/1.0.6-x86_32         ├── libs/pcre/8.43-sparc32  │
#             │                                      └── libs/pcre/8.43-x86_32   │
#             ├── app/gzip/1.10                                                  │
#             │                                                                  │
#             ├── app/inputattach/1.4.9                                          │
#             │   ├── app/inputattach/1.4.9-ppc32                                │
#             │   ├── app/inputattach/1.4.9-sparc32                              │
#             │   ├── app/inputattach/1.4.9-x86_32                               │
#             │   │                                                              │
#             │   └── app/gpm/1.20.7                                             │
#             │       ├── app/gpm/1.20.7-ppc32                                   │
#             │       ├── app/gpm/1.20.7-sparc32                                 │
#             │       ├── app/gpm/1.20.7-x86_32                                  │
#             │       │                                                          │
#             │       └── libs/ncurses/6.1            ────── libs/readline/8.0 ──┘
#             │           ├── libs/ncurses/6.1-ppc32         ├── libs/readline/8.0-ppc32
#             │           ├── libs/ncurses/6.1-sparc32       ├── libs/readline/8.0-sparc32
#             │           └── libs/ncurses/6.1-x86_32        └── libs/readline/8.0-x86_32
#             │
#            ...
#

#            ...
#             │      ...
#             │       │
#             │       ├── app/gettext/0.20.1
#             │      ...
#            ...
#

#            ...
#             │
#             ├── libs/gmp/6.1.2 ────────────────┐
#             │   ├── libs/gmp/6.1.2-ppc32       │
#             │   ├── libs/gmp/6.1.2-sparc32     │
#             │   ├── libs/gmp/6.1.2-x86_32      │
#             │   │                              ├── libs/mpc/1.1.0
#             │   ├── libs/mpfr/4.0.1 ───────────┘   ├── libs/mpc/1.1.0-ppc32
#             │   │   ├── libs/mpfr/4.0.1-ppc32      ├── libs/mpc/1.1.0-sparc32
#             │   │   ├── libs/mpfr/4.0.1-sparc32    └── libs/mpc/1.1.0-x86_32
#             │   │   └── libs/mpfr/4.0.1-x86_32
#             │   │
#             │   ├── libs/isl/0.18
#             │   │   ├── libs/isl/0.18-ppc32
#             │   │   ├── libs/isl/0.18-sparc32
#             │   │   └── libs/isl/0.18-x86_32
#             │   │
#             │   ├── app/cloog/0.18.4 ■ ─────────────┐
#             │   │   ├── app/cloog/0.18.4-ppc32      │
#             │   │   ├── app/cloog/0.18.4-sparc32    │
#             │   │   └── app/cloog/0.18.4-x86_32     │
#             │   │                                   ├── GCC do not use these stuff but you
#             │   └── libs/ppl/1.2 ■                  │   can uncomment following REQUIRES.
#             │       ├── libs/ppl/1.2-ppc32 ─────────┤
#             │       ├── libs/ppl/1.2-sparc32 ───────┤
#             │       └── libs/ppl/1.2-x86_32 ────────┘
#             │
#            ...

#######
####### additional libs for bootstrap GCC:
#######
REQUIRES += app/cloog/0.18.4
ifneq ($(filter $(HARDWARE),$(HARDWARE_S824L)  $(HARDWARE_VESNIN) \
                            $(HARDWARE_TL2WK2) $(HARDWARE_TL2SV2)),)
REQUIRES += app/cloog/0.18.4-ppc32
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_MBC4_PC)),)
REQUIRES += app/cloog/0.18.4-sparc32
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC64)),)
REQUIRES += app/cloog/0.18.4-x86_32
endif

REQUIRES += libs/ppl/1.2
ifneq ($(filter $(HARDWARE),$(HARDWARE_S824L)  $(HARDWARE_VESNIN) \
                            $(HARDWARE_TL2WK2) $(HARDWARE_TL2SV2)),)
REQUIRES += libs/ppl/1.2-ppc32
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_MBC4_PC)),)
REQUIRES += libs/ppl/1.2-sparc32
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC64)),)
REQUIRES += libs/ppl/1.2-x86_32
endif


REQUIRES += libs/mpc/1.1.0
ifneq ($(filter $(HARDWARE),$(HARDWARE_S824L)  $(HARDWARE_VESNIN) \
                            $(HARDWARE_TL2WK2) $(HARDWARE_TL2SV2)),)
REQUIRES += libs/mpc/1.1.0-ppc32
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_MBC4_PC)),)
REQUIRES += libs/mpc/1.1.0-sparc32
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC64)),)
REQUIRES += libs/mpc/1.1.0-x86_32
endif

#            ...
#             │  ...
#             │   │
#             │   └── dev/binutils/2.31.1
#             │       │
#             │       ├── dev/gcc/6.5.0 ──────────┬── libs/mpc/1.1.0
#             │       │                           └── libs/isl/0.18
#            ...     ...


#            ...     ...
#             │       │
#             │       └── dev/gcc-java/6.5.0 ─────┬── app/fastjar/0.98
#             │                                   ├── X11/libs/gtk+2/2.24.25
#            ...                                  ├── ...
#                                                 ├── ...
#                                                ...

#            ...
#             │
#             ├── libs/libtasn1/4.14
#             │   ├── libs/libtasn1/4.14-ppc32
#             │   ├── libs/libtasn1/4.14-sparc32
#             │   └── libs/libtasn1/4.14-x86_32
#             │
#             ├── libs/libidn/1.28
#             │   ├── libs/libidn/1.28-ppc32
#             │   ├── libs/libidn/1.28-sparc32
#             │   └── libs/libidn/1.28-x86_32
#             │
#             ├── libs/libunistring/0.9.10
#             │   ├── libs/libunistring/0.9.10-ppc32
#             │   ├── libs/libunistring/0.9.10-sparc32
#             │   └── libs/libunistring/0.9.10-x86_32
#             │
#             ├── libs/lzo/2.10
#             │   ├── libs/lzo/2.10-ppc32
#             │   ├── libs/lzo/2.10-sparc32
#             │   └── libs/lzo/2.10-x86_32
#             │
#             ├── dev/libtool/2.4.6
#             │   ├── dev/libtool/2.4.6-ppc32
#             │   ├── dev/libtool/2.4.6-sparc32
#             │   └── dev/libtool/2.4.6-x86_32
#             │
#             ├── libs/gc/8.0.4
#             │   ├── libs/gc/8.0.4-ppc32
#             │   ├── libs/gc/8.0.4-sparc32
#             │   └── libs/gc/8.0.4-x86_32
#             │
#             ├── libs/keyutils/1.5.9 ■
#             │   ├── libs/keyutils/1.5.9-ppc32
#             │   ├── libs/keyutils/1.5.9-sparc32
#             │   └── libs/keyutils/1.5.9-x86_32
#             │
#             ├── app/ncompress/4.2.4.4 ■
#             │
#             ├── libs/expat/2.2.9
#             │   ├── libs/expat/2.2.9-ppc32
#             │   ├── libs/expat/2.2.9-sparc32
#             │   └── libs/expat/2.2.9-x86_32
#             │
#             ├── app/utempter/1.1.6 ■
#             │   ├── app/utempter/1.1.6-x86_32
#             │   ├── app/utempter/1.1.6-x86_32
#             │   └── app/utempter/1.1.6-x86_32
#             │
#             ├── dev/flex/2.6.0
#             │   ├── dev/flex/2.6.0-ppc32
#             │   ├── dev/flex/2.6.0-sparc32
#             │   └── dev/flex/2.6.0-x86_32
#             │
#             ├── dev/bison/3.4.2 ■
#             │   ├── dev/bison/3.4.2-ppc32
#             │   ├── dev/bison/3.4.2-sparc32
#             │   └── dev/bison/3.4.2-x86_32
#             │
#             │      ...
#             │       ├───────────────────────────────────── libs/readline/8.0
#             │       │                                      ├── libs/readline/8.0-ppc32
#             │       │                                      ├── libs/readline/8.0-sparc32
#             │       │                                      └── libs/readline/8.0-x86_32
#             │       │
#             │       ├── dev/lua/5.3.5 ■
#             │      ...  ├── dev/lua/5.3.5-ppc32
#             │           ├── dev/lua/5.3.5-sparc32
#             │           └── dev/lua/5.3.5-x86_32
#             │
#             │      ...
#             │       ├───────────────────────────────────── libs/gmp/6.1.2
#             │       │                                      ├── libs/gmp/6.1.2-ppc32
#             │       │                                      ├── libs/gmp/6.1.2-sparc32
#             │       │                                      └── libs/gmp/6.1.2-x86_32
#             │       │
#             │       ├───────────────────────────────────── libs/zlib/1.2.8
#             │       │                                      ├── libs/zlib/1.2.8-ppc32
#             │       │                                      ├── libs/zlib/1.2.8-sparc32
#             │       │                                      └── libs/zlib/1.2.8-x86_32
#             │       │
#             │       ├── net/openssl10/1.0.2t ■
#             │       │   ├── net/openssl10/1.0.2t-ppc32
#             │       │   ├── net/openssl10/1.0.2t-sparc32
#             │       │   └── net/openssl10/1.0.2t-x86_32
#             │       │
#             │       ├── net/openssl/1.1.1d
#             │       │   ├── net/openssl/1.1.1d-ppc32
#             │       │   ├── net/openssl/1.1.1d-sparc32
#             │       │   ├── net/openssl/1.1.1d-x86_32
#             │       │   │
#             │       │   ├── libs/libevent/2.1.11 ■
#             │       │   │   ├── libs/libevent/2.1.11-ppc32
#             │       │   │   ├── libs/libevent/2.1.11-sparc32
#             │       │   │   └── libs/libevent/2.1.11-x86_32
#             │       │  ...
#             │      ...
#             │
#             │      ...
#             │       ├── app/db/6.1.26
#             │      ...  ├── app/db/6.1.26-ppc32
#             │           ├── app/db/6.1.26-sparc32
#             │           └── app/db/6.1.26-x86_32
#             │
#             │
#             ├── libs/gdbm/1.11
#             │   ├── libs/gdbm/1.11-ppc32
#             │   ├── libs/gdbm/1.11-sparc32
#             │   └── libs/gdbm/1.11-x86_32
#             │
#             │      ...
#             │       ├───────────────────────────────────┬── libs/zlib/1.2.8
#             │       │                                   ├── app/xz/5.2.4
#             │       ├── dev/python2/2.7.16              ├── libs/libffi/3.2.1
#             │       │   ├── dev/python2/2.7.16-ppc32    ├── libs/readline/8.0
#             │       │   ├── dev/python2/2.7.16-sparc32  ├── libs/expat/2.2.9
#             │       │   └── dev/python2/2.7.16-x86_32   └── net/openssl/1.1.1d
#             │      ...
#             │
#             │      ...
#             │       ├────────────────────────────────────── libs/gdbm/1.11
#             │       ├── dev/perl/5.30.0
#             │       │   ├── dev/perl/5.30.0-ppc32
#             │      ...  ├── dev/perl/5.30.0-sparc32
#             │           └── dev/perl/5.30.0-x86_32
#             │
#             │
#             │      ...
#             │       ├───────────────────────────────────┬── libs/ncurses/6.1
#             │       │                                   ├── dev/flex/2.6.0
#             │       ├── app/bsd-games/2.17 ■            └── net/openssl/1.1.1d
#             │       │
#             │      ...
#             │
#             │      ...
#             │       ├────────────────────────────────────── libs/ncurses/6.1
#             │       │
#             │       ├── libs/aspell/0.60.8
#             │      ...  ├── libs/aspell/0.60.8-ppc32
#             │           ├── libs/aspell/0.60.8-sparc32
#             │           ├── libs/aspell/0.60.8-x86_32
#             │           │
#             │           ├── libs/dict/aspell6-ca/2.1.5-1      ■
#             │           ├── libs/dict/aspell6-de/20161207-7-0 ■
#             │           ├── libs/dict/aspell6-en/2019.10.06-0 ■
#             │           ├── libs/dict/aspell6-es/1.11-2       ■
#             │           ├── libs/dict/aspell6-fi/0.7-0        ■
#             │           ├── libs/dict/aspell6-fr/0.50-3       ■
#             │           ├── libs/dict/aspell6-it/2.2          ■
#             │           └── libs/dict/aspell6-ru/0.99f7-1     ■
#             │
#             │
#             ├── dev/check/0.13.0
#             │   ├── dev/check/0.13.0-ppc32
#             │   ├── dev/check/0.13.0-sparc32
#             │   └── dev/check/0.13.0-x86_32
#             │
#             ├── app/ctags/5.8
#             │   ├── app/ctags/5.8-ppc32
#             │   ├── app/ctags/5.8-sparc32
#             │   └── app/ctags/5.8-x86_32
#             │
#             │      ...
#             │       │
#             │       ├── secure/cracklib/2.9.5 ────────────────────────── dev/python2/2.7.16
#             │       │   ├── secure/cracklib/2.9.5-ppc32
#             │      ...  ├── secure/cracklib/2.9.5-sparc32
#             │           ├── secure/cracklib/2.9.5-x86_32
#             │           │
#             │           └── secure/pam/1.1.8 ────────────────────────┬── dev/flex/2.6.0
#             │               ├── secure/pam/1.1.8-ppc32               └── net/libtirpc/1.1.4
#             │               ├── secure/pam/1.1.8-sparc32
#             │               ├── secure/pam/1.1.8-x86_32
#             │               │
#             │               └── secure/pam_unix2/2.9.1
#             │                   ├── secure/pam_unix2/2.9.1-ppc32
#             │                   ├── secure/pam_unix2/2.9.1-sparc32
#             │                   ├── secure/pam_unix2/2.9.1-x86_32
#             │                   │
#             │                   ├── app/kbd/2.2.0 ■ ──────────────────── dev/check/0.13.0
#             │                   │   ├── app/kbd/2.2.0-ppc32
#             │                  ...  ├── app/kbd/2.2.0-sparc32
#             │                       └── app/kbd/2.2.0-x86_32
#             │
#             │      ...
#             │       ├────────────────────────────────────────────────┬── libs/ncurses/6.1
#             │       │                                                ├── dev/libtool/2.4.6
#             │       ├── app/dialog/1.3-20190808 ■                    └── app/ctags/5.8
#             │       │   ├── app/dialog/1.3-20190808-ppc32
#             │      ...  ├── app/dialog/1.3-20190808-sparc32
#             │           └── app/dialog/1.3-20190808-x86_32
#             │
#             │
#             │      ...
#             │       ├───────────────────────────────────┬── libs/readline/8.0
#             │       │                                   └── app/gettext/0.20.1
#             │       ├── app/bash/5.0 ■
#             │       │
#             │      ...
#            ...

####################################################################################################
#
# The tree presented above demonstrates dependencies of packages. I will not continue drawing
# as it is time consuming. I think this information is sufficient to start porting the system.
#
####################################################################################################


REQUIRES += libs/keyutils/1.5.9
ifneq ($(filter $(HARDWARE),$(HARDWARE_S824L)  $(HARDWARE_VESNIN) \
                            $(HARDWARE_TL2WK2) $(HARDWARE_TL2SV2)),)
REQUIRES += libs/keyutils/1.5.9-ppc32
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_MBC4_PC)),)
REQUIRES += libs/keyutils/1.5.9-sparc32
endif
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/keyutils/1.5.9-x86_32
endif

REQUIRES += app/ncompress/4.2.4.4

REQUIRES += app/utempter/1.1.6
ifneq ($(filter $(HARDWARE),$(HARDWARE_S824L)  $(HARDWARE_VESNIN) \
                            $(HARDWARE_TL2WK2) $(HARDWARE_TL2SV2)),)
REQUIRES += app/utempter/1.1.6-ppc32
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_MBC4_PC)),)
REQUIRES += app/utempter/1.1.6-sparc32
endif
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/utempter/1.1.6-x86_32
endif

REQUIRES += dev/bison/3.4.2
ifneq ($(filter $(HARDWARE),$(HARDWARE_S824L)  $(HARDWARE_VESNIN) \
                            $(HARDWARE_TL2WK2) $(HARDWARE_TL2SV2)),)
REQUIRES += dev/bison/3.4.2-ppc32
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_MBC4_PC)),)
REQUIRES += dev/bison/3.4.2-sparc32
endif
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += dev/bison/3.4.2-x86_32
endif

REQUIRES += dev/lua/5.3.5
ifneq ($(filter $(HARDWARE),$(HARDWARE_S824L)  $(HARDWARE_VESNIN) \
                            $(HARDWARE_TL2WK2) $(HARDWARE_TL2SV2)),)
REQUIRES += dev/lua/5.3.5-ppc32
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_MBC4_PC)),)
REQUIRES += dev/lua/5.3.5-sparc32
endif
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += dev/lua/5.3.5-x86_32
endif

REQUIRES += app/bsd-games/2.17


#######
####### Dictionaries for aspell:
#######
REQUIRES += libs/dict/aspell6-ca/2.1.5-1
REQUIRES += libs/dict/aspell6-de/20161207-7-0
REQUIRES += libs/dict/aspell6-en/2019.10.06-0
REQUIRES += libs/dict/aspell6-es/1.11-2
REQUIRES += libs/dict/aspell6-fi/0.7-0
REQUIRES += libs/dict/aspell6-fr/0.50-3
REQUIRES += libs/dict/aspell6-it/2.2
REQUIRES += libs/dict/aspell6-ru/0.99f7-1
ifneq ($(filter $(HARDWARE),$(HARDWARE_S824L)  $(HARDWARE_VESNIN) \
                            $(HARDWARE_TL2WK2) $(HARDWARE_TL2SV2)),)
REQUIRES += libs/aspell/0.60.8-ppc32
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_MBC4_PC)),)
REQUIRES += libs/aspell/0.60.8-sparc32
endif
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/aspell/0.60.8-x86_32
endif

REQUIRES += app/kbd/2.2.0
ifneq ($(filter $(HARDWARE),$(HARDWARE_S824L)  $(HARDWARE_VESNIN) \
                            $(HARDWARE_TL2WK2) $(HARDWARE_TL2SV2)),)
REQUIRES += app/kbd/2.2.0-ppc32
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_MBC4_PC)),)
REQUIRES += app/kbd/2.2.0-sparc32
endif
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/kbd/2.2.0-x86_32
endif

ifneq ($(filter $(HARDWARE),$(HARDWARE_M201) $(HARDWARE_MXV)),)
REQUIRES += app/remotecfg/1.0.0
endif

#######
####### Dictionaries for /usr/share/dict (see FHS):
#######
REQUIRES += share/dict/scowl/2019.10.06
REQUIRES += share/dict/words-ca/2.1.5-1
REQUIRES += share/dict/words-de/2.1
REQUIRES += share/dict/words-en_CA/2019.10.06
REQUIRES += share/dict/words-en_CA-huge/2019.10.06
REQUIRES += share/dict/words-en_CA-insane/2019.10.06
REQUIRES += share/dict/words-en_CA-large/2019.10.06
REQUIRES += share/dict/words-en_CA-small/2019.10.06
REQUIRES += share/dict/words-en_GB/2019.10.06
REQUIRES += share/dict/words-en_GB-huge/2019.10.06
REQUIRES += share/dict/words-en_GB-insane/2019.10.06
REQUIRES += share/dict/words-en_GB-large/2019.10.06
REQUIRES += share/dict/words-en_GB-small/2019.10.06
REQUIRES += share/dict/words-en_US/2019.10.06
REQUIRES += share/dict/words-en_US-huge/2019.10.06
REQUIRES += share/dict/words-en_US-insane/2019.10.06
REQUIRES += share/dict/words-en_US-large/2019.10.06
REQUIRES += share/dict/words-en_US-small/2019.10.06
REQUIRES += share/dict/words-es/1.11-2
REQUIRES += share/dict/words-fi/0.7-0
REQUIRES += share/dict/words-fr/0.50-3
REQUIRES += share/dict/words-it/2.2
REQUIRES += share/dict/words-ru/0.99f7-1


#######
####### Core Utilites and SysVInit:
#######
REQUIRES += app/coreutils/8.31
REQUIRES += app/sharutils/4.15.2
REQUIRES += app/grep/3.3
REQUIRES += app/texinfo/6.7
REQUIRES += dev/gperf/3.1
REQUIRES += app/sysvinit/2.97
ifneq ($(filter $(HARDWARE),$(HARDWARE_S824L)  $(HARDWARE_VESNIN) \
                            $(HARDWARE_TL2WK2) $(HARDWARE_TL2SV2)),)
REQUIRES += libs/popt/1.16-ppc32
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_MBC4_PC)),)
REQUIRES += libs/popt/1.16-sparc32
endif
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/popt/1.16-x86_32
endif
REQUIRES += app/sysvinit-functions/8.54


#######
####### File Systems support:
#######
REQUIRES += app/xfsdump/3.1.8
ifneq ($(filter $(HARDWARE),$(HARDWARE_S824L)  $(HARDWARE_VESNIN) \
                            $(HARDWARE_TL2WK2) $(HARDWARE_TL2SV2)),)
REQUIRES += libs/dmapi/2.2.12-ppc32
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_MBC4_PC)),)
REQUIRES += libs/dmapi/2.2.12-sparc32
endif
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/dmapi/2.2.12-x86_32
endif

REQUIRES += app/btrfs-progs/5.3
ifneq ($(filter $(HARDWARE),$(HARDWARE_S824L)  $(HARDWARE_VESNIN) \
                            $(HARDWARE_TL2WK2) $(HARDWARE_TL2SV2)),)
REQUIRES += app/e2fsprogs/1.45.4-ppc32
REQUIRES += libs/zstd/1.4.3-ppc32
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_MBC4_PC)),)
REQUIRES += app/e2fsprogs/1.45.4-sparc32
REQUIRES += libs/zstd/1.4.3-sparc32
endif
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/e2fsprogs/1.45.4-x86_32
REQUIRES += libs/zstd/1.4.3-x86_32
endif

REQUIRES += app/reiserfsprogs/3.6.27
REQUIRES += app/dosfstools/4.1
REQUIRES += app/jfsutils/1.1.15
REQUIRES += app/sysfsutils/2.1.0
REQUIRES += app/mtools/4.0.18


#######
####### Shadow, system log, procps:
#######
REQUIRES += secure/shadow/4.2.1
REQUIRES += app/sysklogd/1.5.1
REQUIRES += app/procps-ng/3.3.15
ifneq ($(filter $(HARDWARE),$(HARDWARE_S824L)  $(HARDWARE_VESNIN) \
                            $(HARDWARE_TL2WK2) $(HARDWARE_TL2SV2)),)
REQUIRES += app/procps-ng/3.3.15-ppc32
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_MBC4_PC)),)
REQUIRES += app/procps-ng/3.3.15-sparc32
endif
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/procps-ng/3.3.15-x86_32
endif


#######
####### Packages:
#######
REQUIRES += app/gamin/0.1.10

REQUIRES += app/usbutils/012
ifneq ($(filter $(HARDWARE),$(HARDWARE_S824L)  $(HARDWARE_VESNIN) \
                            $(HARDWARE_TL2WK2) $(HARDWARE_TL2SV2)),)
REQUIRES += libs/libusb-compat/0.1.7-ppc32
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_MBC4_PC)),)
REQUIRES += libs/libusb-compat/0.1.7-sparc32
endif
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/libusb-compat/0.1.7-x86_32
endif

REQUIRES += app/eudev/3.2.8
REQUIRES += app/lvm2/2.03.06
ifneq ($(filter $(HARDWARE),$(HARDWARE_S824L)  $(HARDWARE_VESNIN) \
                            $(HARDWARE_TL2WK2) $(HARDWARE_TL2SV2)),)
REQUIRES += app/lvm2/2.03.06-ppc32
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_MBC4_PC)),)
REQUIRES += app/lvm2/2.03.06-sparc32
endif
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/lvm2/2.03.06-x86_32
endif
REQUIRES += app/cpio/2.12
REQUIRES += app/ed/1.15
REQUIRES += app/getty-ps/2.1.1
REQUIRES += app/hdparm/9.58
REQUIRES += app/less/551
REQUIRES += app/logrotate/3.15.1
REQUIRES += app/gettext/0.20.1-tools


ifneq ($(filter $(HARDWARE),$(HARDWARE_S824L)  $(HARDWARE_VESNIN) \
                            $(HARDWARE_TL2WK2) $(HARDWARE_TL2SV2)),)
REQUIRES += app/dialog/1.3-20190808-ppc32
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_MBC4_PC)),)
REQUIRES += app/dialog/1.3-20190808-sparc32
endif
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/dialog/1.3-20190808-x86_32
endif


REQUIRES += secure/libcgroup/0.41
ifneq ($(filter $(HARDWARE),$(HARDWARE_S824L)  $(HARDWARE_VESNIN) \
                            $(HARDWARE_TL2WK2) $(HARDWARE_TL2SV2)),)
REQUIRES += secure/libcgroup/0.41-ppc32
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_MBC4_PC)),)
REQUIRES += secure/libcgroup/0.41-sparc32
endif
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += secure/libcgroup/0.41-x86_32
endif

REQUIRES += libs/libstrophe/0.9.3
ifneq ($(filter $(HARDWARE),$(HARDWARE_S824L)  $(HARDWARE_VESNIN) \
                            $(HARDWARE_TL2WK2) $(HARDWARE_TL2SV2)),)
REQUIRES += libs/libstrophe/0.9.3-ppc32
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_MBC4_PC)),)
REQUIRES += libs/libstrophe/0.9.3-sparc32
endif
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/libstrophe/0.9.3-x86_32
endif

REQUIRES += app/sdparm/1.10
ifneq ($(filter $(HARDWARE),$(HARDWARE_S824L)  $(HARDWARE_VESNIN) \
                            $(HARDWARE_TL2WK2) $(HARDWARE_TL2SV2)),)
REQUIRES += libs/sg3_utils/1.44-ppc32
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_MBC4_PC)),)
REQUIRES += libs/sg3_utils/1.44-sparc32
endif
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/sg3_utils/1.44-x86_32
endif


#######
####### Networking:
#######
REQUIRES += net/openssl10/1.0.2t
ifneq ($(filter $(HARDWARE),$(HARDWARE_S824L)  $(HARDWARE_VESNIN) \
                            $(HARDWARE_TL2WK2) $(HARDWARE_TL2SV2)),)
REQUIRES += net/openssl10/1.0.2t-ppc32
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_MBC4_PC)),)
REQUIRES += net/openssl10/1.0.2t-sparc32
endif
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += net/openssl10/1.0.2t-x86_32
endif

REQUIRES += net/libtirpc/1.1.4
ifneq ($(filter $(HARDWARE),$(HARDWARE_S824L)  $(HARDWARE_VESNIN) \
                            $(HARDWARE_TL2WK2) $(HARDWARE_TL2SV2)),)
REQUIRES += net/libtirpc/1.1.4-ppc32
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_MBC4_PC)),)
REQUIRES += net/libtirpc/1.1.4-sparc32
endif
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += net/libtirpc/1.1.4-x86_32
endif

REQUIRES += net/icmpinfo/1.11
REQUIRES += net/net-tools/1.60
REQUIRES += net/netdate/4
REQUIRES += net/biff+comsat/0.17
REQUIRES += net/bsd-finger/0.17
REQUIRES += net/netkit-bootparamd/0.17
REQUIRES += net/netkit-ftp/0.17
REQUIRES += net/netkit-ntalk/0.17
REQUIRES += net/netkit-routed/0.17
REQUIRES += net/netkit-rsh/0.17
REQUIRES += net/netkit-rusers/0.17
REQUIRES += net/netkit-rwall/0.17
REQUIRES += net/netkit-rwho/0.17
REQUIRES += net/netkit-telnet/0.17
REQUIRES += net/netkit-timed/0.17
REQUIRES += net/netwrite/0.17
REQUIRES += net/tftp-hpa/5.2

REQUIRES += net/dhcpcd/6.10.1

REQUIRES += net/iputils/s20151218
REQUIRES += net/ethtool/5.3
REQUIRES += net/inetd/1.79
REQUIRES += net/openssh/8.1p1
ifneq ($(filter $(HARDWARE),$(HARDWARE_S824L)  $(HARDWARE_VESNIN) \
                            $(HARDWARE_TL2WK2) $(HARDWARE_TL2SV2)),)
REQUIRES += libs/libedit/20191025-3.1-ppc32
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_MBC4_PC)),)
REQUIRES += libs/libedit/20191025-3.1-sparc32
endif
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/libedit/20191025-3.1-x86_32
endif

REQUIRES += net/tcpdump/4.7.4

REQUIRES += net/libmbim/1.12.4
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += net/libmbim/1.12.4-x86_32
endif
REQUIRES += net/libqmi/1.14.2
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += net/libqmi/1.14.2-x86_32
endif
REQUIRES += net/ipset/6.29
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += net/ipset/6.29-x86_32
endif

REQUIRES += net/libnetfilter_log/1.0.1
REQUIRES += net/conntrack-tools/1.4.5
ifneq ($(filter $(HARDWARE),$(HARDWARE_S824L)  $(HARDWARE_VESNIN) \
                            $(HARDWARE_TL2WK2) $(HARDWARE_TL2SV2)),)
REQUIRES += net/libnetfilter_acct/1.0.3-ppc32
REQUIRES += net/libnetfilter_conntrack/1.0.7-ppc32
REQUIRES += net/libnetfilter_cthelper/1.0.0-ppc32
REQUIRES += net/libnetfilter_cttimeout/1.0.0-ppc32
REQUIRES += net/libnetfilter_log/1.0.1-ppc32
REQUIRES += net/libnetfilter_queue/1.0.3-ppc32
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_MBC4_PC)),)
REQUIRES += net/libnetfilter_acct/1.0.3-sparc32
REQUIRES += net/libnetfilter_conntrack/1.0.7-sparc32
REQUIRES += net/libnetfilter_cthelper/1.0.0-sparc32
REQUIRES += net/libnetfilter_cttimeout/1.0.0-sparc32
REQUIRES += net/libnetfilter_log/1.0.1-sparc32
REQUIRES += net/libnetfilter_queue/1.0.3-sparc32
endif
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += net/libnetfilter_acct/1.0.3-x86_32
REQUIRES += net/libnetfilter_conntrack/1.0.7-x86_32
REQUIRES += net/libnetfilter_cthelper/1.0.0-x86_32
REQUIRES += net/libnetfilter_cttimeout/1.0.0-x86_32
REQUIRES += net/libnetfilter_log/1.0.1-x86_32
REQUIRES += net/libnetfilter_queue/1.0.3-x86_32
endif

REQUIRES += net/dhcp/4.3.4

REQUIRES += net/gpgme/1.13.1
ifneq ($(filter $(HARDWARE),$(HARDWARE_S824L)  $(HARDWARE_VESNIN) \
                            $(HARDWARE_TL2WK2) $(HARDWARE_TL2SV2)),)
REQUIRES += net/gpgme/1.13.1-ppc32
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_MBC4_PC)),)
REQUIRES += net/gpgme/1.13.1-sparc32
endif
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += net/gpgme/1.13.1-x86_32
endif

#
# pkgtools requires dialog and GnuPG2
#
REQUIRES += app/pkgtols/0.1.3


REQUIRES += net/bind/9.10.4
REQUIRES += net/wget/1.16
REQUIRES += net/whois/5.2.12

REQUIRES += net/rfkill/0.5
REQUIRES += net/bridge-utils/1.5
REQUIRES += net/crda/3.18
REQUIRES += net/wireless-tools/29

REQUIRES += libs/dbus-python/1.2.4
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/dbus-python/1.2.4-x86_32
endif

REQUIRES += net/wpa_supplicant/2.5
REQUIRES += net/dnsmasq/2.75
REQUIRES += net/ebtables/2.0.10-4
REQUIRES += net/iftop/1.0pre4
REQUIRES += net/iptraf-ng/1.1.4
REQUIRES += net/iperf3/3.1.3

REQUIRES += net/bluez/5.42
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += net/bluez/5.42-x86_32
endif


#######
####### Development tools:
#######
REQUIRES += dev/llvm/3.8.0
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += dev/llvm/3.8.0-x86_32
endif
REQUIRES += dev/cmake/3.5.2
REQUIRES += dev/make/4.2.1
REQUIRES += dev/autoconf-archive/2014.02.28
REQUIRES += dev/pkg-config/0.28


#######
####### DocBook & Linux DOC packages:
#######
REQUIRES += app/xmlto/0.0.26


#######
####### Base utilites:
#######

REQUIRES += app/vim/7.4-1156

REQUIRES += libs/libtiff/4.0.6
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/libtiff/4.0.6-x86_32
endif

REQUIRES += libs/icu4c/65.1
ifneq ($(filter $(HARDWARE),$(HARDWARE_S824L)  $(HARDWARE_VESNIN) \
                            $(HARDWARE_TL2WK2) $(HARDWARE_TL2SV2)),)
REQUIRES += libs/icu4c/65.1-ppc32
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_MBC4_PC)),)
REQUIRES += libs/icu4c/65.1-sparc32
endif
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/icu4c/65.1-x86_32
endif

REQUIRES += libs/libpipeline/1.4.1
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/libpipeline/1.4.1-x86_32
endif

REQUIRES += app/sqlite/3.26.0.0
ifneq ($(filter $(HARDWARE),$(HARDWARE_S824L)  $(HARDWARE_VESNIN) \
                            $(HARDWARE_TL2WK2) $(HARDWARE_TL2SV2)),)
REQUIRES += app/sqlite/3.26.0.0-ppc32
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_MBC4_PC)),)
REQUIRES += app/sqlite/3.26.0.0-sparc32
endif
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/sqlite/3.26.0.0-x86_32
endif

REQUIRES += libs/taglib/1.10
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/taglib/1.10-x86_32
endif
REQUIRES += libs/zeromq/4.1.4
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/zeromq/4.1.4-x86_32
endif

#            ...     ...
#             │       │
#             │       ├── net/nspr/4.12
#             │       │   ├── net/nspr/4.12-x86_32
#             │       │   │
#             │       │   ├── net/nss/3.23 ■  ────────────────────── app/sqlite/3.26.0.0
#             │       │   │   └── net/nss/3.23-x86_32  ──────────────┴── app/sqlite/3.26.0.0-x86_32
#             │       │  ...
#            ...     ...

REQUIRES += net/nss/3.23
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += net/nss/3.23-x86_32
endif

REQUIRES += net/net-snmp/5.7.3

#
# order: libs/libdaemon, app/dbus, libs/glib2, libs/dbus-glib, libs/dbus-python, secure/libcap,
#        libs/gdbm
#
REQUIRES += net/avahi-daemon/0.6.31
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += net/avahi-daemon/0.6.31-x86_32
endif

REQUIRES += net/ntp/4.2.8p8


REQUIRES += app/mc/4.8.16
REQUIRES += app/tmux/2.0
REQUIRES += app/chrpath/0.16
REQUIRES += app/patch/2.7
REQUIRES += app/which/2.20
REQUIRES += app/bin/4.9

REQUIRES += app/enscript/1.6.6


#######
####### Perl5 modules:
#######

# foomatic-db-engine dependencies:
REQUIRES += dev/perl-modules/perl-clone/0.38
REQUIRES += dev/perl-modules/perl-dbi/1.634
REQUIRES += dev/perl-modules/perl-xml-libxml/2.0122

# common purpose modules:
REQUIRES += dev/perl-modules/perl-xml-simple/2.20
REQUIRES += dev/perl-modules/perl-uri/1.69
REQUIRES += dev/perl-modules/perl-gettext/1.06


#######
####### Development:
#######

REQUIRES += dev/xmltoman/0.4

REQUIRES += dev/vala/0.32.0
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += dev/vala/0.32.0-x86_32
endif

REQUIRES += dev/orc/0.4.26.1
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += dev/orc/0.4.26.1-x86_32
endif


#######
####### Python2.7 modules:
#######

REQUIRES += dev/python-modules/pip2/8.1.1
REQUIRES += libs/pyrex/0.9.9

#######
####### Python3.5 modules:
#######

REQUIRES += dev/python-modules/pip3/8.1.1



#######
####### Database:
#######

REQUIRES += app/postgresql/9.6.0
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/postgresql/9.6.0-x86_32
endif



#######
####### Media packages:
#######

REQUIRES += app/alsa-utils/1.1.1

REQUIRES += app/mpg123/1.23.3
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/mpg123/1.23.3-x86_32
endif

REQUIRES += libs/fdk-aac/0.1.4
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/fdk-aac/0.1.4-x86_32
endif
REQUIRES += libs/vo-aacenc/0.1.3
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/vo-aacenc/0.1.3-x86_32
endif
REQUIRES += libs/vo-amrwbenc/0.1.3
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/vo-amrwbenc/0.1.3-x86_32
endif
REQUIRES += libs/opus/1.1.2
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/opus/1.1.2-x86_32
endif
REQUIRES += app/cdparanoia/10.2
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/cdparanoia/10.2-x86_32
endif
REQUIRES += libs/libvpx/1.5.0
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/libvpx/1.5.0-x86_32
endif

REQUIRES += app/vorbis-tools/1.4.0

REQUIRES += app/sox/14.4.2
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/sox/14.4.2-x86_32
endif

REQUIRES += app/icecast/2.4.3
REQUIRES += app/ices/2.0.2

REQUIRES += app/openjpeg2/2.1.2
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/openjpeg2/2.1.2-x86_32
endif

REQUIRES += app/dcadec/0.2.0
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/dcadec/0.2.0-x86_32
endif


# ======= __END_OF_REQUIRES__ =======


install_target     = $(TARGET_BUILD_DIR)/.install_done


BUILD_TARGETS    = $(install_target)


include ../../build-system/core.mk


$(install_target):
	@touch $@
