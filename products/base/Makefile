
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH = true


include ../../build-system/constants.mk


#######
####### Boot
#######

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

ifneq ($(filter $(HARDWARE),$(HARDWARE_PC32) $(HARDWARE_PC64)),)
REQUIRES  = boot/lilo/x86/24.1
endif


#######
####### The System
#######

#
# .
# └── base/pkgtool
#     └── dev/kernel-headers
#         └── dev/gcc-runtime
#             ├── libs/glibc/2.23
#             │   ├── libs/glibc/2.23-i18n
#             │   │   └── libs/glibc-zoneinfo/2016a ■
#             │   │
#             │   └── libs/glibc/2.23-x86_32
#             │
#            ...
#

REQUIRES += libs/glibc/2.23-zoneinfo/2016a
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/glibc/2.23-x86_32
endif

#            ...
#             │   ┌──────────────────────────────────────────────────────────────┐
#             │   │                                                              │
#             ├── libs/zlib/1.2.8 ─────────────────────────┐                     │
#             │   ├── libs/zlib/1.2.8-x86_32 ───────────┐  │                     │
#             │   │                                     │  │                     │
#             │   └── dev/binutils/2.25.1 ── if x86_64 ─┘  │                     │
#             │       └── dev/gcc/5.3.0                    │                     │
#             │                                            │                     │
#             ├── app/xz/5.2.2               ─────┬────────┘                     │
#             │   └── app/xz/5.2.2-x86_32         └── app/kmod/22                │
#             │                                       └── app/kmod/22-x86_32     │
#             ├── libs/libffi/3.2.1                                              │
#             │   └── libs/libffi/3.2.1-x86_32                                   │
#             │                                                                  │
#             ├── libs/libelf/0.8.13                                             │
#             │   └── libs/libelf/0.8.13-x86_32                                  │
#             │                                                                  │
#             ├── app/bzip2/1.0.6 ─────────────────┬─────────────────────────────┤
#             │   └── app/bzip2/1.0.6-x86_32       └── libs/pcre/8.38            │
#             │                                        └── libs/pcre/8.38-x86_32 │
#             ├── app/gzip/1.6                                                   │
#             │                                                                  │
#             ├── app/inputattach/1.4.9                                          │
#             │   ├── app/inputattach/1.4.9-x86_32                               │
#             │   │                                                              │
#             │   └── app/gpm/1.20.7                                             │
#             │       ├── app/gpm/1.20.7-x86_32                                  │
#             │       │                                                          │
#             │       └── libs/ncurses/6.0            ───┐                       │
#             │           ├── libs/ncurses/6.0-x86_32    ├── libs/readline/6.3 ──┘
#             │           │                              │   └── libs/readline/6.3-x86_32
#             │           └── libs/libtermcap/1.2.3   ───┘
#             │               └── libs/libtermcap/1.2.3-x86_32
#             │
#            ...
#

#            ...
#             │      ...
#             │       │
#             │       ├── app/gettext/0.19.7
#             │      ...
#            ...
#

#            ...
#             │
#             ├── libs/gmp/6.1.0 ────────────────┐
#             │   ├── libs/gmp/6.1.0-x86_32      │
#             │   │                              ├── libs/mpc/1.0.3
#             │   ├── libs/mpfr/3.1.3 ───────────┘   └── libs/mpc/1.0.3-x86_32
#             │   │   └── libs/mpfr/3.1.3-x86_32
#             │   │
#             │   ├── libs/isl/0.16.1
#             │   │   └── libs/isl/0.16.1-x86_32
#             │   │
#             │   ├── app/cloog/0.18.4 ■ ─────────────┐
#             │   │   └── app/cloog/0.18.4-x86_32     │
#             │   │                                   ├── GCC do not use these stuff but you
#             │   └── libs/ppl/1.1 ■                  │   can uncomment following REQUIRES.
#             │       └── libs/ppl/1.1-x86_32 ────────┘
#             │
#            ...

#######
####### additional libs for bootstrap GCC:
#######
REQUIRES += app/cloog/0.18.4
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/cloog/0.18.4-x86_32
endif
REQUIRES += libs/ppl/1.1
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/ppl/1.1-x86_32
endif

REQUIRES += libs/mpc/1.0.3
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/mpc/1.0.3-x86_32
endif

#            ...
#             │  ...
#             │   │
#             │   └── dev/binutils/2.25.1
#             │       │
#             │       ├── dev/gcc/5.3.0 ──────────┬── libs/mpc/1.0.3
#             │       │                           └── libs/isl/0.16.1
#            ...     ...


#            ...     ...
#             │       │
#             │       └── dev/gcc-java/5.3.0 ─────┬── app/fastjar/0.98
#             │                                   ├── X11/libs/gtk+2/2.24.25
#            ...                                  ├── ...
#                                                 ├── ...
#                                                ...

#            ...
#             │
#             ├── libs/libtasn1/4.7
#             │   └── libs/libtasn1/4.7-x86_32
#             │
#             ├── libs/libidn/1.28
#             │   └── libs/libidn/1.28-x86_32
#             │
#             ├── libs/libunistring/0.9.3
#             │   └── libs/libunistring/0.9.3-x86_32
#             │
#             ├── libs/lzo/2.09
#             │   └── libs/lzo/2.09-x86_32
#             │
#             ├── dev/libtool/2.4.2
#             │   └── dev/libtool/2.4.2-x86_32
#             │
#             ├── libs/gc/7.4.2
#             │   └── libs/gc/7.4.2-x86_32
#             │
#             ├── libs/keyutils/1.5.9 ■
#             │   └── libs/keyutils/1.5.9-x86_32
#             │
#             ├── app/ncompress/4.2.4.4 ■
#             │
#             ├── libs/expat/2.1.1
#             │   └── libs/expat/2.1.1-x86_32
#             │
#             ├── app/utempter/1.1.6 ■
#             │   └── app/utempter/1.1.6-x86_32
#             │
#             ├── dev/flex/2.6.0
#             │   └── dev/flex/2.6.0-x86_32
#             │
#             ├── dev/bison/3.0.4 ■
#             │   └── dev/bison/3.0.4-x86_32
#             │
#             │      ...
#             │       ├───────────────────────────────────── libs/readline/6.3
#             │       │                                      └── libs/readline/6.3-x86_32
#             │       │
#             │       ├── dev/lua/5.3.2 ■
#             │      ...  └── dev/lua/5.3.2-x86_32
#             │
#             │      ...
#             │       ├───────────────────────────────────── libs/gmp/6.1.0
#             │       │                                      └── libs/gmp/6.1.0-x86_32
#             │       ├───────────────────────────────────── libs/zlib/1.2.8
#             │       │                                      └── libs/zlib/1.2.8-x86_32
#             │       │
#             │       ├── net/openssl/1.0.2f
#             │       │   ├── net/openssl/1.0.2f-x86_32
#             │       │   │
#             │       │   ├── libs/libevent/2.0.22 ■
#             │       │   │   └── libs/libevent/2.0.22-x86_32
#             │       │  ...
#             │      ...
#             │
#             │      ...
#             │       ├── app/db/6.1.26
#             │      ...  └── app/db/6.1.26-x86_32
#             │
#             │
#             ├── libs/gdbm/1.11
#             │   └── libs/gdbm/1.11-x86_32
#             │
#             │      ...
#             │       ├───────────────────────────────────┬── libs/zlib/1.2.8
#             │       │                                   ├── app/xz/5.2.2
#             │       ├── dev/python2/2.7.11              ├── libs/libffi/3.2.1
#             │       │   └── dev/python2/2.7.11-x86_32   ├── libs/readline/6.3
#             │      ...                                  ├── libs/expat/2.1.1
#             │                                           └── net/openssl/1.0.2f
#             │      ...
#             │       ├────────────────────────────────────── libs/gdbm/1.11
#             │       ├── dev/perl/5.22.1
#             │       │   └── dev/perl/5.22.1-x86_32
#             │      ...
#             │
#             │      ...
#             │       ├───────────────────────────────────┬── libs/libtermcap/1.2.3
#             │       │                                   ├── dev/flex/2.6.0
#             │       ├── app/bsd-games/2.17 ■            └── net/openssl/1.0.2f
#             │       │
#             │      ...
#             │
#             │      ...
#             │       ├────────────────────────────────────── libs/ncurses/6.0
#             │       │
#             │       ├── libs/aspell/0.60.6.1
#             │      ...  ├── libs/aspell/0.60.6.1-x86_32
#             │           │
#             │           ├── libs/dict/aspell6-ca/2.1.5-1  ■
#             │           ├── libs/dict/aspell6-de/2.1      ■
#             │           ├── libs/dict/aspell6-en/7.1-0    ■
#             │           ├── libs/dict/aspell6-es/1.11-2   ■
#             │           ├── libs/dict/aspell6-fi/0.7-0    ■
#             │           ├── libs/dict/aspell6-fr/0.50-3   ■
#             │           ├── libs/dict/aspell6-it/2.2      ■
#             │           └── libs/dict/aspell6-ru/0.99f7-1 ■
#             │
#             │
#             ├── dev/check/0.10.0
#             │   └── dev/check/0.10.0-x86_32
#             │
#             ├── app/ctags/5.8
#             │   └── app/ctags/5.8-x86_32
#             │
#             │      ...
#             │       │
#             │       ├── secure/cracklib/2.9.5 ────────────────────────── dev/python2/2.7.11
#             │       │   ├── secure/cracklib/2.9.5-x86_32
#             │      ...  │
#             │           └── secure/pam/1.1.8 ─────────────────────────── dev/flex/2.6.0
#             │               ├── secure/pam/1.1.8-x86_32
#             │               │
#             │               └── secure/pam_unix2/2.9.1
#             │                   ├── secure/pam_unix2/2.9.1-x86_32
#             │                   │
#             │                   ├── app/kbd/2.0.3 ■ ──────────────────── dev/check/0.10.0
#             │                   │   └── app/kbd/2.0.3-x86_32
#             │                  ...
#             │      ...
#             │       ├────────────────────────────────────────────────┬── libs/ncurses/6.0
#             │       │                                                ├── dev/libtool/2.4.2
#             │       ├── app/dialog/1.2-20140112 ■                    └── app/ctags/5.8
#             │       │   └── app/dialog/1.2-20140112-x86_32
#             │      ...
#             │
#             │      ...
#             │       ├───────────────────────────────────┬── libs/readline/6.3
#             │       │                                   └── app/gettext/0.19.7
#             │       ├── app/bash/4.3 ■
#             │       │
#             │      ...
#            ...

####################################################################################################
#
# The tree presented above demonstrates dependencies of packages. I will not continue drawing
# as it is time consuming. I think this information is sufficient to start porting system.
#
####################################################################################################


REQUIRES += libs/keyutils/1.5.9
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/keyutils/1.5.9-x86_32
endif
REQUIRES += app/ncompress/4.2.4.4
REQUIRES += app/utempter/1.1.6
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/utempter/1.1.6-x86_32
endif
REQUIRES += dev/bison/3.0.4
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += dev/bison/3.0.4-x86_32
endif
REQUIRES += dev/lua/5.3.2
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += dev/lua/5.3.2-x86_32
endif

REQUIRES += app/bsd-games/2.17


#######
####### Dictionaries for aspell:
#######
REQUIRES += libs/dict/aspell6-ca/2.1.5-1
REQUIRES += libs/dict/aspell6-de/2.1
REQUIRES += libs/dict/aspell6-en/7.1-0
REQUIRES += libs/dict/aspell6-es/1.11-2
REQUIRES += libs/dict/aspell6-fi/0.7-0
REQUIRES += libs/dict/aspell6-fr/0.50-3
REQUIRES += libs/dict/aspell6-it/2.2
REQUIRES += libs/dict/aspell6-ru/0.99f7-1
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/aspell/0.60.6.1-x86_32
endif

REQUIRES += app/kbd/2.0.3
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/kbd/2.0.3-x86_32
endif

#######
####### Dictionaries for /usr/share/dict (see FHS):
#######
REQUIRES += share/dict/scowl/7.1
REQUIRES += share/dict/words-ca/2.1.5-1
REQUIRES += share/dict/words-de/2.1
REQUIRES += share/dict/words-en_CA/7.1
REQUIRES += share/dict/words-en_CA-huge/7.1
REQUIRES += share/dict/words-en_CA-insane/7.1
REQUIRES += share/dict/words-en_CA-large/7.1
REQUIRES += share/dict/words-en_CA-small/7.1
REQUIRES += share/dict/words-en_GB/7.1
REQUIRES += share/dict/words-en_GB-huge/7.1
REQUIRES += share/dict/words-en_GB-insane/7.1
REQUIRES += share/dict/words-en_GB-large/7.1
REQUIRES += share/dict/words-en_GB-small/7.1
REQUIRES += share/dict/words-en_US/7.1
REQUIRES += share/dict/words-en_US-huge/7.1
REQUIRES += share/dict/words-en_US-insane/7.1
REQUIRES += share/dict/words-en_US-large/7.1
REQUIRES += share/dict/words-en_US-small/7.1
REQUIRES += share/dict/words-es/1.11-2
REQUIRES += share/dict/words-fi/0.7-0
REQUIRES += share/dict/words-fr/0.50-3
REQUIRES += share/dict/words-it/2.2
REQUIRES += share/dict/words-ru/0.99f7-1


#######
####### Core Utilites and SysVInit:
#######
REQUIRES += app/coreutils/8.22
REQUIRES += app/sharutils/4.15.2
REQUIRES += app/grep/2.18
REQUIRES += app/texinfo/5.2
REQUIRES += dev/gperf/3.0.4
REQUIRES += app/sysvinit/2.88
REQUIRES += app/sysvinit-functions/8.54


#######
####### File Systems support:
#######
REQUIRES += app/xfsdump/3.1.6
REQUIRES += app/btrfs-progs/4.4
REQUIRES += app/reiserfsprogs/3.6.24
REQUIRES += app/dosfstools/3.0.28
REQUIRES += app/jfsutils/1.1.15
REQUIRES += app/sysfsutils/2.1.0
REQUIRES += app/mtools/4.0.18


#######
####### Shadow, system log, procps:
#######
REQUIRES += secure/shadow/4.2.1
REQUIRES += app/sysklogd/1.5
REQUIRES += app/procps/3.2.8


#######
####### Packages:
#######
REQUIRES += app/gamin/0.1.10
REQUIRES += app/usbutils/008
REQUIRES += app/eudev/3.1.5
REQUIRES += app/lvm2/2.02.141
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/lvm2/2.02.141-x86_32
endif
REQUIRES += app/cpio/2.11
REQUIRES += app/ed/1.9
REQUIRES += app/getty-ps/2.1.1
REQUIRES += app/hdparm/9.48
REQUIRES += app/less/451
REQUIRES += app/lha/114i
REQUIRES += app/logrotate/3.9.1
REQUIRES += app/gettext/0.19.7-tools

REQUIRES += secure/libcgroup/0.41
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += secure/libcgroup/0.41-x86_32
endif

REQUIRES += app/sdparm/1.09


#######
####### Networking:
#######
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
REQUIRES += net/ethtool/4.5
REQUIRES += net/inetd/1.79
REQUIRES += net/openssh/7.2p1


REQUIRES += net/libnl/1.1.4
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += net/libnl/1.1.4-x86_32
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
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += net/libnetfilter_log/1.0.1-x86_32
endif

REQUIRES += net/conntrack-tools/1.4.3
REQUIRES += net/dhcp/4.3.4

REQUIRES += net/gpgme/1.6.0
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += net/gpgme/1.6.0-x86_32
endif

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


#######
####### Development tools:
#######
REQUIRES += dev/llvm/3.8.0
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += dev/llvm/3.8.0-x86_32
endif
REQUIRES += dev/cmake/3.5.2
REQUIRES += dev/make/4.0
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
REQUIRES += libs/icu4c/55.1
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/icu4c/55.1-x86_32
endif
REQUIRES += libs/libpipeline/1.4.1
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/libpipeline/1.4.1-x86_32
endif
REQUIRES += app/sqlite/3.12.2.0
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/sqlite/3.12.2.0-x86_32
endif
REQUIRES += libs/taglib/1.10
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/taglib/1.10-x86_32
endif
REQUIRES += libs/libaio/0.3.110
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/libaio/0.3.110-x86_32
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
#             │       │   ├── net/nss/3.23 ■  ────────────────────── app/sqlite/3.12.2.0
#             │       │   │   └── net/nss/3.23-x86_32  ──────────────┴── app/sqlite/3.12.2.0-x86_32
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

REQUIRES += app/mc/4.8.15
REQUIRES += app/tmux/2.0
REQUIRES += app/chrpath/0.16
REQUIRES += app/patch/2.7
REQUIRES += app/which/2.20
REQUIRES += app/bin/4.4

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
REQUIRES += libs/portaudio/19-20140130
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/portaudio/19-20140130-x86_32
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


# ======= __END_OF_REQUIRES__ =======


install_target     = $(TARGET_BUILD_DIR)/.install_done


BUILD_TARGETS    = $(install_target)


include ../../build-system/core.mk


$(install_target):
	@touch $@
