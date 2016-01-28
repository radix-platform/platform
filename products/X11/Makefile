
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_VIP1830)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH = true


include ../../build-system/constants.mk


#######
####### Boot
#######

ifeq ($(HARDWARE),$(HARDWARE_OMAP5UEVM))
REQUIRES  = hal/drivers/omap543x/wl18xx_fw/8.8.10
REQUIRES += hal/firmware/omap5-uevm/6.04.00.02
REQUIRES += boot/u-boot/omap543x/2013.04-20140216
endif

ifeq ($(HARDWARE),$(HARDWARE_CB1X))
REQUIRES += boot/u-boot/A10/2014.04-20140713
endif

ifeq ($(HARDWARE),$(HARDWARE_CB3X))
REQUIRES += boot/u-boot/A20/2015.01
endif

ifeq ($(HARDWARE),$(HARDWARE_CI20))
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
#             ├── libs/glibc/2.22
#             │   ├── libs/glibc/2.22-i18n
#             │   │   └── libs/glibc-zoneinfo/2015g ■
#             │   │
#             │   └── libs/glibc/2.22-x86_32
#             │
#            ...
#

REQUIRES += libs/glibc/2.22-zoneinfo/2015g
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/glibc/2.22-x86_32
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
#             ├── libs/libffi/3.0.13                                             │
#             │   └── libs/libffi/3.0.13-x86_32                                  │
#             │                                                                  │
#             ├── libs/libelf/0.8.13                                             │
#             │   └── libs/libelf/0.8.13-x86_32                                  │
#             │                                                                  │
#             ├── app/bzip2/1.0.6 ─────────────────┬─────────────────────────────┤
#             │   └── app/bzip2/1.0.6-x86_32       └── libs/pcre/8.38            │
#             │                                        └── libs/pcre/8.38-x86_32 │
#             ├── app/gzip/1.6                                                   │
#             │                                                                  │
#             ├── app/inputattach/1.4.7                                          │
#             │   ├── app/inputattach/1.4.7-x86_32                               │
#             │   │                                                              │
#             │   └── app/gpm/1.20.7                                             │
#             │       ├── app/gpm/1.20.7-x86_32                                  │
#             │       │                                                          │
#             │       └── libs/ncurses/5.9            ───┐                       │
#             │           ├── libs/ncurses/5.9-x86_32    ├── libs/readline/6.3 ──┘
#             │           │                              │   └── libs/readline/6.3-x86_32
#             │           └── libs/libtermcap/1.2.3   ───┘
#             │               └── libs/libtermcap/1.2.3-x86_32
#             │
#            ...
#

#            ...
#             │      ...
#             │       │
#             │       ├── app/gettext/0.18.3.2
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
#             ├── libs/libtasn1/3.4
#             │   └── libs/libtasn1/3.4-x86_32
#             │
#             ├── libs/libidn/1.28
#             │   └── libs/libidn/1.28-x86_32
#             │
#             ├── libs/libunistring/0.9.3
#             │   └── libs/libunistring/0.9.3-x86_32
#             │
#             ├── libs/lzo/2.08
#             │   └── libs/lzo/2.08-x86_32
#             │
#             ├── dev/libtool/2.4.2
#             │   └── dev/libtool/2.4.2-x86_32
#             │
#             ├── libs/gc/7.2d
#             │   └── libs/gc/7.2d-x86_32
#             │
#             ├── libs/keyutils/1.5.9 ■
#             │   └── libs/keyutils/1.5.9-x86_32
#             │
#             ├── app/ncompress/4.2.4.4 ■
#             │
#             ├── libs/expat/2.1.0
#             │   └── libs/expat/2.1.0-x86_32
#             │
#             ├── app/utempter/1.1.6 ■
#             │   └── app/utempter/1.1.6-x86_32
#             │
#             ├── dev/flex/2.5.39
#             │   └── dev/flex/2.5.39-x86_32
#             │
#             ├── dev/bison/2.7 ■
#             │   └── dev/bison/2.7-x86_32
#             │
#             │      ...
#             │       ├───────────────────────────────────── libs/readline/6.3
#             │       │                                      └── libs/readline/6.3-x86_32
#             │       │
#             │       ├── dev/lua/5.2.3 ■
#             │      ...  └── dev/lua/5.2.3-x86_32
#             │
#             │      ...
#             │       ├───────────────────────────────────── libs/gmp/6.1.0
#             │       │                                      └── libs/gmp/6.1.0-x86_32
#             │       ├───────────────────────────────────── libs/zlib/1.2.8
#             │       │                                      └── libs/zlib/1.2.8-x86_32
#             │       │
#             │       ├── net/openssl/1.0.2d
#             │       │   ├── net/openssl/1.0.2d-x86_32
#             │       │   │
#             │       │   ├── libs/libevent/2.0.21 ■
#             │       │   │   └── libs/libevent/2.0.21-x86_32
#             │       │  ...
#             │      ...
#             │
#             │      ...
#             │       ├── app/db/6.1.19
#             │      ...  └── app/db/6.1.19-x86_32
#             │
#             │
#             ├── libs/gdbm/1.11
#             │   └── libs/gdbm/1.11-x86_32
#             │
#             │      ...
#             │       ├───────────────────────────────────┬── libs/zlib/1.2.8
#             │       │                                   ├── app/xz/5.2.2
#             │       ├── dev/python2/2.7.11              ├── libs/libffi/3.0.13
#             │       │   └── dev/python2/2.7.11-x86_32   ├── libs/readline/6.3
#             │      ...                                  ├── libs/expat/2.1.0
#             │                                           └── net/openssl/1.0.2d
#             │      ...
#             │       ├────────────────────────────────────── libs/gdbm/1.11
#             │       ├── dev/perl/5.22.1
#             │       │   └── dev/perl/5.22.1-x86_32
#             │      ...
#             │
#             │      ...
#             │       ├───────────────────────────────────┬── libs/libtermcap/1.2.3
#             │       │                                   ├── dev/flex/2.5.39
#             │       ├── app/bsd-games/2.17 ■            └── net/openssl/1.0.2d
#             │       │
#             │      ...
#             │
#             │      ...
#             │       ├────────────────────────────────────── libs/ncurses/5.9
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
#             ├── dev/check/0.9.13
#             │   └── dev/check/0.9.13-x86_32
#             │
#             ├── app/ctags/5.8
#             │   └── app/ctags/5.8-x86_32
#             │
#             │      ...
#             │       │
#             │       ├── secure/cracklib/2.9.1 ────────────────────────── dev/python2/2.7.11
#             │       │   ├── secure/cracklib/2.9.1-x86_32
#             │      ...  │
#             │           └── secure/pam/1.1.8 ─────────────────────────── dev/flex/2.5.39
#             │               ├── secure/pam/1.1.8-x86_32
#             │               │
#             │               └── secure/pam_unix2/2.9.1
#             │                   ├── secure/pam_unix2/2.9.1-x86_32
#             │                   │
#             │                   ├── app/kbd/2.0.2 ■ ──────────────────── dev/check/0.9.13
#             │                   │   └── app/kbd/2.0.2-x86_32
#             │                  ...
#             │      ...
#             │       ├────────────────────────────────────────────────┬── libs/ncurses/5.9
#             │       │                                                ├── dev/libtool/2.4.2
#             │       ├── app/dialog/1.2-20140112 ■                    └── app/ctags/5.8
#             │       │   └── app/dialog/1.2-20140112-x86_32
#             │      ...
#             │
#             │      ...
#             │       ├───────────────────────────────────┬── libs/readline/6.3
#             │       │                                   └── app/gettext/0.18.3.2
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
REQUIRES += dev/bison/2.7
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += dev/bison/2.7-x86_32
endif
REQUIRES += dev/lua/5.2.3
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += dev/lua/5.2.3-x86_32
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

REQUIRES += app/kbd/2.0.2
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/kbd/2.0.2-x86_32
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
REQUIRES += app/xfsdump/3.1.3
REQUIRES += app/btrfs-progs/3.16
REQUIRES += app/reiserfsprogs/3.6.24
REQUIRES += app/dosfstools/3.0.26
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
REQUIRES += app/usbutils/007
REQUIRES += app/eudev/1.9
REQUIRES += app/lvm2/2.02.132
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/lvm2/2.02.132-x86_32
endif
REQUIRES += app/cpio/2.11
REQUIRES += app/ed/1.9
REQUIRES += app/getty-ps/2.1.0b
REQUIRES += app/hdparm/9.43
REQUIRES += app/less/451
REQUIRES += app/lha/114i
REQUIRES += app/logrotate/3.8.7
REQUIRES += app/gettext/0.18.3.2-tools

REQUIRES += secure/libcgroup/0.41
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += secure/libcgroup/0.41-x86_32
endif

REQUIRES += app/sdparm/1.08


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

REQUIRES += net/iputils/s20121221
REQUIRES += net/ethtool/3.12
REQUIRES += net/inetd/1.79
REQUIRES += net/openssh/6.6p1


REQUIRES += net/libnl/1.1.4
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += net/libnl/1.1.4-x86_32
endif

REQUIRES += net/tcpdump/4.6.2

REQUIRES += net/libmbim/1.10.0
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += net/libmbim/1.10.0-x86_32
endif
REQUIRES += net/libqmi/1.10.4
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += net/libqmi/1.10.4-x86_32
endif
REQUIRES += net/ipset/6.21
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += net/ipset/6.21-x86_32
endif
REQUIRES += net/libnetfilter_log/1.0.1
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += net/libnetfilter_log/1.0.1-x86_32
endif

REQUIRES += net/conntrack-tools/1.4.2
REQUIRES += net/dhcp/4.3.1

REQUIRES += net/gpgme/1.6.0
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += net/gpgme/1.6.0-x86_32
endif

REQUIRES += net/bind/9.10.1
REQUIRES += net/wget/1.16
REQUIRES += net/whois/5.2.1

REQUIRES += net/rfkill/0.5
REQUIRES += net/bridge-utils/1.5
REQUIRES += net/crda/3.18
REQUIRES += net/wireless-tools/29

REQUIRES += libs/dbus-python/1.2.0
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/dbus-python/1.2.0-x86_32
endif

REQUIRES += net/wpa_supplicant/2.3
REQUIRES += net/dnsmasq/2.72
REQUIRES += net/ebtables/2.0.10-4
REQUIRES += net/iftop/1.0pre4
REQUIRES += net/iptraf-ng/1.1.4


#######
####### Development tools:
#######
REQUIRES += dev/llvm/3.7.1
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += dev/llvm/3.7.1-x86_32
endif
REQUIRES += dev/cmake/2.8.12.2
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

REQUIRES += libs/libtiff/4.0.3
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/libtiff/4.0.3-x86_32
endif
REQUIRES += libs/icu4c/54.1
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/icu4c/54.1-x86_32
endif
REQUIRES += libs/libpipeline/1.4.0
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/libpipeline/1.4.0-x86_32
endif
REQUIRES += app/sqlite/3.8.7.1
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/sqlite/3.8.7.1-x86_32
endif
REQUIRES += libs/taglib/1.9.1
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/taglib/1.9.1-x86_32
endif
REQUIRES += libs/zeromq/4.0.5
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/zeromq/4.0.5-x86_32
endif

#            ...     ...
#             │       │
#             │       ├── net/nspr/4.10.8
#             │       │   ├── net/nspr/4.10.8-x86_32
#             │       │   │
#             │       │   ├── net/nss/3.19.2 ■  ────────────────────── app/sqlite/3.8.7.1
#             │       │   │   └── net/nss/3.19.2-x86_32  ──────────────┴── app/sqlite/3.8.7.1-x86_32
#             │       │  ...
#            ...     ...

REQUIRES += net/nss/3.19.2
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += net/nss/3.19.2-x86_32
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

REQUIRES += app/mc/4.8.12
REQUIRES += app/tmux/1.9a
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
####### Python2.7 modules:
#######

REQUIRES += dev/python-modules/pip2/7.1.2
REQUIRES += libs/pyrex/0.9.9



#######
####### Media packages:
#######

REQUIRES += app/alsa-utils/1.0.28

REQUIRES += app/mpg123/1.20.1
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/mpg123/1.20.1-x86_32
endif

REQUIRES += libs/fdk-aac/0.1.3
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/fdk-aac/0.1.3-x86_32
endif
REQUIRES += libs/vo-aacenc/0.1.3
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/vo-aacenc/0.1.3-x86_32
endif
REQUIRES += libs/vo-amrwbenc/0.1.3
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/vo-amrwbenc/0.1.3-x86_32
endif
REQUIRES += libs/opus/1.1
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/opus/1.1-x86_32
endif
REQUIRES += libs/portaudio/19-20140130
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/portaudio/19-20140130-x86_32
endif
REQUIRES += app/cdparanoia/10.2
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/cdparanoia/10.2-x86_32
endif
REQUIRES += libs/libvpx/1.4.0
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/libvpx/1.4.0-x86_32
endif

REQUIRES += app/vorbis-tools/1.4.0

REQUIRES += app/sox/14.4.1
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/sox/14.4.1-x86_32
endif

REQUIRES += app/icecast/2.4.1
REQUIRES += app/ices/2.0.2


####################################################################################################
#
# X.Org:
# =====
#
# Mike Gancarz: The UNIX Philosophy [http://en.wikipedia.org/wiki/Unix_philosophy]:
# --------------------------------------------------------------------------------
#
# In 1994, Mike Gancarz (a member of the team that designed the X Window System),
# drew on his own experience with Unix, as well as discussions with fellow programmers
# and people in other fields who depended on Unix, to produce The UNIX Philosophy
# which sums it up in 9 paramount precepts:
#
#    1. Small is beautiful.
#    2. Make each program do one thing well.
#    3. Build a prototype as soon as possible.
#    4. Choose portability over efficiency.
#    5. Store data in flat text files.
#    6. Use software leverage to your advantage.
#    7. Use shell scripts to increase leverage and portability.
#    8. Avoid captive user interfaces.
#    9. Make every program a filter.
#
# Unfortunately X.Org and, most of all, freedesktop.org violates the first two principles.
# Now in the Linux environment there are packages that are trying to absorb everything.
# So we have to more meticulously regulate dependencies and make use all sorts of compromises
# to achieve the desired functionality at an earlier stage of distribution assembly as it is
# possible. Next work will be serve as an example of intricate inter-packet dependencies.
#
####################################################################################################


#######
####### X11 X.org packages:
#######
#
# X.org doc:
#
REQUIRES += X11/X.org/doc/xorg-sgml-doctools/1.11

#
# X.org proto & some utils:
#
REQUIRES += X11/X.org/proto-headers
REQUIRES += X11/X.org/util/makedepend/1.0.5
REQUIRES += X11/X.org/util/gccmakedep/1.0.3

#
# X.org data:
#
REQUIRES += X11/X.org/data/xbitmaps/1.1.1
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/data/xbitmaps/1.1.1-x86_32
endif
REQUIRES += X11/X.org/data/xcursor-themes/1.0.4
REQUIRES += X11/X.org/data/xkeyboard-config/2.13

#
# X.org lib: [ order: libXau, libXdmcp ] required by xcb
#

#
# X.org xcb:
#
# order:
#        xcb-proto, libxcb, xcb-util, xcb-util-image, xcb-util-renderutil,
#        xcb-util-cursor, xcb-util-keysyms, xcb-util-wm, xpyb, libpthread-stubs
#
#REQUIRES += X11/X.org/xcb/xcb-util-cursor/0.1.1
#ifeq ($(HARDWARE),$(HARDWARE_PC64))
#REQUIRES += X11/X.org/xcb/xcb-util-cursor/0.1.1-x86_32
#endif
#REQUIRES += X11/X.org/xcb/xcb-util-keysyms/0.4.0
#ifeq ($(HARDWARE),$(HARDWARE_PC64))
#REQUIRES += X11/X.org/xcb/xcb-util-keysyms/0.4.0-x86_32
#endif
#REQUIRES += X11/X.org/xcb/xcb-util-wm/0.4.1
#ifeq ($(HARDWARE),$(HARDWARE_PC64))
#REQUIRES += X11/X.org/xcb/xcb-util-wm/0.4.1-x86_32
#endif
REQUIRES += X11/X.org/xcb/xpyb/1.3.1
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/xcb/xpyb/1.3.1-x86_32
endif
REQUIRES += X11/X.org/xcb/libpthread-stubs/0.3
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/xcb/libpthread-stubs/0.3-x86_32
endif

#
# X.org lib (continue):
#
# order:
#        xtrans, libX11, pixman, libXext, libXrender, libfontenc, libFS,
#        libICE, libSM, libXScrnSaver, libXt, libXpm, libXmu, libXaw, libXaw3d,
#        libXfixes, libXcm, libXcomposite, libXcursor, libXdamage, libXevie,
#        libXfontcache, libXi, liXinerama, libXp, libXrandr, libXres, libXtst,
#        libXv, libXvMC, libXxf86dga, libXxf86misc, libXxf86vm, libdmx,
#        libpciaccess, libxkbfile, libxshmfence
#
#REQUIRES += X11/X.org/lib/pixman/0.32.6
#ifeq ($(HARDWARE),$(HARDWARE_PC64))
#REQUIRES += X11/X.org/lib/pixman/0.32.6-x86_32
#endif
REQUIRES += X11/X.org/lib/libfontenc/1.1.2
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/lib/libfontenc/1.1.2-x86_32
endif
REQUIRES += X11/X.org/lib/libFS/1.0.6
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/lib/libFS/1.0.6-x86_32
endif
REQUIRES += X11/X.org/lib/libXScrnSaver/1.2.2
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/lib/libXScrnSaver/1.2.2-x86_32
endif
#REQUIRES += X11/X.org/lib/libXaw/1.0.12
#ifeq ($(HARDWARE),$(HARDWARE_PC64))
#REQUIRES += X11/X.org/lib/libXaw/1.0.12-x86_32
#endif
REQUIRES += X11/X.org/lib/libXaw3d/1.6.2
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/lib/libXaw3d/1.6.2-x86_32
endif
REQUIRES += X11/X.org/lib/libXcm/0.5.3
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/lib/libXcm/0.5.3-x86_32
endif
REQUIRES += X11/X.org/lib/libXcomposite/0.4.4
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/lib/libXcomposite/0.4.4-x86_32
endif
#REQUIRES += X11/X.org/lib/libXcursor/1.1.14
#ifeq ($(HARDWARE),$(HARDWARE_PC64))
#REQUIRES += X11/X.org/lib/libXcursor/1.1.14-x86_32
#endif
REQUIRES += X11/X.org/lib/libXdamage/1.1.4
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/lib/libXdamage/1.1.4-x86_32
endif
REQUIRES += X11/X.org/lib/libXevie/1.0.3
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/lib/libXevie/1.0.3-x86_32
endif
REQUIRES += X11/X.org/lib/libXfontcache/1.0.5
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/lib/libXfontcache/1.0.5-x86_32
endif
#REQUIRES += X11/X.org/lib/libXinerama/1.1.3
#ifeq ($(HARDWARE),$(HARDWARE_PC64))
#REQUIRES += X11/X.org/lib/libXinerama/1.1.3-x86_32
#endif
REQUIRES += X11/X.org/lib/libXp/1.0.2
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/lib/libXp/1.0.2-x86_32
endif
#REQUIRES += X11/X.org/lib/libXrandr/1.4.2
#ifeq ($(HARDWARE),$(HARDWARE_PC64))
#REQUIRES += X11/X.org/lib/libXrandr/1.4.2-x86_32
#endif
REQUIRES += X11/X.org/lib/libXres/1.0.7
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/lib/libXres/1.0.7-x86_32
endif
REQUIRES += X11/X.org/lib/libXtst/1.2.2
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/lib/libXtst/1.2.2-x86_32
endif
REQUIRES += X11/X.org/lib/libXvMC/1.0.8
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/lib/libXvMC/1.0.8-x86_32
endif
REQUIRES += X11/X.org/lib/libXxf86dga/1.1.4
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/lib/libXxf86dga/1.1.4-x86_32
endif
REQUIRES += X11/X.org/lib/libXxf86misc/1.0.3
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/lib/libXxf86misc/1.0.3-x86_32
endif
#REQUIRES += X11/X.org/lib/libXxf86vm/1.1.3
#ifeq ($(HARDWARE),$(HARDWARE_PC64))
#REQUIRES += X11/X.org/lib/libXxf86vm/1.1.3-x86_32
#endif
REQUIRES += X11/X.org/lib/libdmx/1.1.3
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/lib/libdmx/1.1.3-x86_32
endif
REQUIRES += X11/X.org/lib/libpciaccess/0.13.2
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/X.org/lib/libpciaccess/0.13.2-x86_32
endif
#REQUIRES += X11/X.org/lib/libxkbfile/1.0.8
#ifeq ($(HARDWARE),$(HARDWARE_PC64))
#REQUIRES += X11/X.org/lib/libxkbfile/1.0.8-x86_32
#endif
#REQUIRES += X11/X.org/lib/libxshmfence/1.1
#ifeq ($(HARDWARE),$(HARDWARE_PC64))
#REQUIRES += X11/X.org/lib/libxshmfence/1.1-x86_32
#endif


#######
####### Now we have to return to fontconfig, harfbuzz, cairo, Mesa and then
####### we will return to libXft, libXfont.
#######

# order: X11/libs/libdrm, Wayland/wayland

#REQUIRES += X11/libs/libdrm/2.4.64
#ifeq ($(HARDWARE),$(HARDWARE_PC64))
#REQUIRES += X11/libs/libdrm/2.4.64-x86_32
#endif

#REQUIRES += Wayland/wayland/1.6.0
#ifeq ($(HARDWARE),$(HARDWARE_PC64))
#REQUIRES += Wayland/wayland/1.6.0-x86_32
#endif

# order: libs/libomxil-bellagio, X11/libs/mesa

#
# Mesa3d, Mali drivers, etc...
#
# cb1x/cb3x order: hal/dri2, hal/ump/DX/3.0.4.0
# NOTE: because of crashes r3p0-04rel0 on Cubietruck we exclude HARDWAE_CB3X
#       from opengl-collection and build full mesa for CB3X board !
#       It will affects X11 drivers also.
#
REQUIRES += X11/libs/opengl-collection

#
# order: env/freetype, X11/libs/fontconfig, libs/cairo, libs/harfbuzz,
#        libs/freetype, X11/libs/netpbm, X11/app/dbus-x11-launch

REQUIRES += libs/freetype/2.5.3
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/freetype/2.5.3-x86_32
endif
REQUIRES += X11/libs/netpbm/10.68.01
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/libs/netpbm/10.68.01-x86_32
endif
#REQUIRES += X11/app/dbus-x11-launch/1.8.10
#ifeq ($(HARDWARE),$(HARDWARE_PC64))
#REQUIRES += X11/app/dbus-x11-launch/1.8.10-x86_32
#endif


#
# X.org lib (continue):
#
# order: X11/X.org/lib/libXft, X11/X.org/lib/libXfont
#
#REQUIRES += X11/X.org/lib/libXft/2.3.2
#ifeq ($(HARDWARE),$(HARDWARE_PC64))
#REQUIRES += X11/X.org/lib/libXft/2.3.2-x86_32
#endif
#REQUIRES += X11/X.org/lib/libXfont/1.5.0
#ifeq ($(HARDWARE),$(HARDWARE_PC64))
#REQUIRES += X11/X.org/lib/libXfont/1.5.0-x86_32
#endif


#######
####### X.org applications:
#######
REQUIRES += X11/X.org/app-collection

REQUIRES += X11/X.org/app/xdm/1.1.11


#######
####### X.org fonts:
#######
REQUIRES += X11/X.org/font-collection

REQUIRES += X11/X.org/font/font-util/1.3.0


#######
####### Xwayland support:
#######

# order: X11/libs/libepoxy

#REQUIRES += X11/libs/libepoxy/1.2
#ifeq ($(HARDWARE),$(HARDWARE_PC64))
#REQUIRES += X11/libs/libepoxy/1.2-x86_32
#endif

#######
####### weston support:
#######
REQUIRES += X11/libs/libinput/0.7.0
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/libs/libinput/0.7.0-x86_32
endif


#######
####### X.org server:
#######
ifneq ($(filter $(HARDWARE),$(HARDWARE_CB1X) $(HARDWARE_CB3X)),)
REQUIRES += X11/X.org/xserver/xorg-server/1.16.2
else
REQUIRES += X11/X.org/xserver/xorg-server/1.16.4
endif

#######
####### X.org drivers:
#######
REQUIRES += X11/X.org/driver-input
REQUIRES += X11/X.org/driver-video


#######
####### X.org doc (last):
#######
REQUIRES += X11/X.org/doc/xorg-docs/1.7

#######
####### End of X11 X.org packages.
#######


#######
####### 3pp X fonts:
#######
REQUIRES += X11/font/dejavu-fonts-ttf/2.34
REQUIRES += X11/font/thaixfonts/1.2.6


#######
####### X applications:
#######
REQUIRES += X11/app/xterm/313
REQUIRES += libs/giflib/5.1.0
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/giflib/5.1.0-x86_32
endif
REQUIRES += X11/app/WindowMaker/0.95.6


#######
####### GTK+ libs & Desktop environment:
#######

#
# order: libs/atk, libs/libdatrie, libs/libthai, libs/pango, app/cups, libs/lcms2,
#        app/ghostscript, app/qpdf, X11/libs/gdk-pixbuf2, libs/libcroco, dev/vala,
#        X11/libs/librsvg, libs/libspectre, X11/libs/cairo, X11/libs/harfbuzz
#
#REQUIRES += libs/atk/2.15.1
#ifeq ($(HARDWARE),$(HARDWARE_PC64))
#REQUIRES += libs/atk/2.15.1-x86_32
#endif
#REQUIRES += libs/pango/1.36.8
#ifeq ($(HARDWARE),$(HARDWARE_PC64))
#REQUIRES += libs/pango/1.36.8-x86_32
#endif

REQUIRES += app/ghostscript-fonts-std/8.11

REQUIRES += app/qpdf/5.1.2
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/qpdf/5.1.2-x86_32
endif
#REQUIRES += X11/libs/gdk-pixbuf2/2.31.1
#ifeq ($(HARDWARE),$(HARDWARE_PC64))
#REQUIRES += X11/libs/gdk-pixbuf2/2.31.1-x86_32
#endif
#REQUIRES += libs/libcroco/0.6.8
#ifeq ($(HARDWARE),$(HARDWARE_PC64))
#REQUIRES += libs/libcroco/0.6.8-x86_32
#endif
#REQUIRES += X11/libs/librsvg/2.40.5
#ifeq ($(HARDWARE),$(HARDWARE_PC64))
#REQUIRES += X11/libs/librsvg/2.40.5-x86_32
#endif
#REQUIRES += X11/libs/cairo/1.14.0
#ifeq ($(HARDWARE),$(HARDWARE_PC64))
#REQUIRES += X11/libs/cairo/1.14.0-x86_32
#endif
REQUIRES += X11/libs/harfbuzz/0.9.36
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/libs/harfbuzz/0.9.36-x86_32
endif

#
# order: X11/app/desktop-file-utils, X11/libs/hicolor-icon-theme,
#        X11/app/xdg-utils, X11/app/xdg-user-dirs
#
REQUIRES += X11/app/desktop-file-utils/0.22
REQUIRES += X11/libs/hicolor-icon-theme/0.14
REQUIRES += X11/app/xdg-user-dirs/0.15

#
# order: libs/gstreamer0, libs/libmng, libs/libvisual, libs/gst-plugins-base0,
#        libs/gstreamer, libs/gst-plugins-base
#
REQUIRES += libs/gstreamer0/0.10.36
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/gstreamer0/0.10.36-x86_32
endif
#REQUIRES += libs/libmng/2.0.2
#ifeq ($(HARDWARE),$(HARDWARE_PC64))
#REQUIRES += libs/libmng/2.0.2-x86_32
#endif
#REQUIRES += libs/libvisual/0.4.0
#ifeq ($(HARDWARE),$(HARDWARE_PC64))
#REQUIRES += libs/libvisual/0.4.0-x86_32
#endif
REQUIRES += libs/gst-plugins-base0/0.10.36
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/gst-plugins-base0/0.10.36-x86_32
endif

REQUIRES += libs/gstreamer/1.4.5
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/gstreamer/1.4.5-x86_32
endif
REQUIRES += libs/gst-plugins-base/1.4.5
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/gst-plugins-base/1.4.5-x86_32
endif


#######
####### Development:
#######

#
# order: dev/vala, libs/hwloc, libs/openmpi, libs/boost
#
REQUIRES += dev/vala/0.26.1
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += dev/vala/0.26.1-x86_32
endif
#REQUIRES += libs/boost/1.57.0
#ifeq ($(HARDWARE),$(HARDWARE_PC64))
#REQUIRES += libs/boost/1.57.0-x86_32
#endif


#######
####### Database:
#######

#
# order: libs/libaio, app/mariadb, libs/libiodbc
#

#REQUIRES += libs/libaio/0.3.110
#ifeq ($(HARDWARE),$(HARDWARE_PC64))
#REQUIRES += libs/libaio/0.3.110-x86_32
#endif
REQUIRES += app/mariadb/5.5.41
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/mariadb/5.5.41-x86_32
endif

REQUIRES += libs/libiodbc/3.52.9
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/libiodbc/3.52.9-x86_32
endif


#######
####### Perl5 modules:
#######

REQUIRES += dev/perl-modules/perl-dbd-mysql/4.032



#######
####### Qt, GTK+, ...:
#######

#
# order: X11/libs/qt4, X11/libs/qt5, libs/poppler, X11/libs/gtk+2,
#        libs/log4cplus, X11/libs/glu, X11/libs/glew, X11/libs/freeglut,
#        X11/libs/startup-notification
#

#REQUIRES += X11/libs/qt4/4.8.6
#ifeq ($(HARDWARE),$(HARDWARE_PC64))
#REQUIRES += X11/libs/qt4/4.8.6-x86_32
#endif
REQUIRES += X11/libs/qt5/5.4.0
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/libs/qt5/5.4.0-x86_32
endif

#REQUIRES += libs/poppler/0.29.0
#ifeq ($(HARDWARE),$(HARDWARE_PC64))
#REQUIRES += libs/poppler/0.29.0-x86_32
#endif

REQUIRES += X11/libs/gtk+2/2.24.25
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/libs/gtk+2/2.24.25-x86_32
endif

REQUIRES += X11/app/glade2/2.12.2
REQUIRES += X11/libs/gtk-engines/2.20.2
REQUIRES += X11/app/lxappearance/0.6.1

#
# order: net/avahi-daemon, X11/libs/libglade, libs/pygobject, libs/pycairo, libs/pygtk
#
REQUIRES += X11/app/avahi-ui/0.6.31
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/app/avahi-ui/0.6.31-x86_32
endif

#
# order: app/cups-filters, app/foomatic-db, app/foomatic-db-engine,
#        libs/libieee1284, libs/libexif, libs/libgphoto2, libs/v4l-utils,
#        app/sane/backends
#
REQUIRES += app/hplip/3.15.9


REQUIRES += libs/log4cplus/1.2.0
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/log4cplus/1.2.0-x86_32
endif

REQUIRES += X11/libs/glew/1.12.0
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/libs/glew/1.12.0-x86_32
endif
REQUIRES += X11/libs/freeglut/2.8.1
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/libs/freeglut/2.8.1-x86_32
endif
REQUIRES += X11/libs/startup-notification/0.12
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += X11/libs/startup-notification/0.12-x86_32
endif


#######
####### Video streaming packages:
#######

#
# order: libs/aalib, libs/libraw1394, libs/libiec61883, libs/libavc1394,
#        libs/imlib, libs/imlib2, libs/libcaca
#

REQUIRES += libs/aalib/1.4.0
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/aalib/1.4.0-x86_32
endif

#REQUIRES += libs/libraw1394/2.1.0
#ifeq ($(HARDWARE),$(HARDWARE_PC64))
#REQUIRES += libs/libraw1394/2.1.0-x86_32
#endif
REQUIRES += libs/libiec61883/1.2.0
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/libiec61883/1.2.0-x86_32
endif
REQUIRES += libs/libavc1394/0.5.4
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/libavc1394/0.5.4-x86_32
endif

REQUIRES += libs/imlib/1.9.15
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/imlib/1.9.15-x86_32
endif
REQUIRES += libs/imlib2/1.4.6
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/imlib2/1.4.6-x86_32
endif

REQUIRES += libs/libcaca/0.99.19
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/libcaca/0.99.19-x86_32
endif


# ======= __END_OF_REQUIRES__ =======


install_target     = $(TARGET_BUILD_DIR)/.install_done


BUILD_TARGETS    = $(install_target)


include ../../build-system/core.mk


$(install_target):
	@touch $@
