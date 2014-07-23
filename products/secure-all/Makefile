
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_VIP1830)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)


NEED_ABS_PATH = true


include ../../build-system/constants.mk


#######
####### Board Support Packages
#######

ifeq ($(HARDWARE),$(HARDWARE_OMAP5UEVM))
REQUIRES  = hal/3pp/omap/wl18xx_fw
REQUIRES += boot/u-boot/omap543x/2013.04-20140216
endif

#######
####### The System
#######

REQUIRES += libs/eglibc/2.19.1-zoneinfo
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/eglibc/2.19.1-x86_32
endif
REQUIRES += dev/binutils/2.24
REQUIRES += dev/gcc/4.8.2
REQUIRES += dev/libtool/2.4.2
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += dev/libtool/2.4.2-x86_32
endif

#######
####### Module Init Tools and Core libs:
#######
REQUIRES += app/kmod/16
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/kmod/16-x86_32
endif
REQUIRES += libs/libffi/3.0.13
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/libffi/3.0.13-x86_32
endif
REQUIRES += libs/libelf/0.8.13
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/libelf/0.8.13-x86_32
endif
REQUIRES += libs/libtasn1/3.4
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/libtasn1/3.4-x86_32
endif
REQUIRES += libs/libidn/1.28
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/libidn/1.28-x86_32
endif
REQUIRES += libs/libunistring/0.9.3
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/libunistring/0.9.3-x86_32
endif
REQUIRES += libs/keyutils/1.5.9
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/keyutils/1.5.9-x86_32
endif
REQUIRES += libs/gc/7.2d
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/gc/7.2d-x86_32
endif
REQUIRES += app/gzip/1.6
REQUIRES += app/ncompress/4.2.4.4
REQUIRES += libs/libtermcap/1.2.3
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/libtermcap/1.2.3-x86_32
endif
REQUIRES += libs/readline/6.3
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/readline/6.3-x86_32
endif
REQUIRES += libs/expat/2.1.0
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/expat/2.1.0-x86_32
endif
REQUIRES += app/gettext/0.18.3.2
REQUIRES += libs/pcre/8.34
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/pcre/8.34-x86_32
endif

REQUIRES += libs/mpc/1.0.2
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/mpc/1.0.2-x86_32
endif
REQUIRES += dev/flex/2.5.39
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += dev/flex/2.5.39-x86_32
endif
REQUIRES += dev/bison/2.7
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += dev/bison/2.7-x86_32
endif
REQUIRES += dev/lua/5.2.3
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += dev/lua/5.2.3-x86_32
endif
REQUIRES += net/openssl/1.0.1g
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += net/openssl/1.0.1g-x86_32
endif
REQUIRES += dev/python2/2.7.6
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += dev/python2/2.7.6-x86_32
endif
REQUIRES += app/db/6.1.19
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/db/6.1.19-x86_32
endif
REQUIRES += libs/gdbm/1.11
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/gdbm/1.11-x86_32
endif
REQUIRES += dev/perl/5.18.2
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += dev/perl/5.18.2-x86_32
endif
REQUIRES += libs/aspell/0.60.6.1
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/aspell/0.60.6.1-x86_32
endif

REQUIRES += libs/dict/aspell6-ca/2.1.5-1
REQUIRES += libs/dict/aspell6-de/2.1
REQUIRES += libs/dict/aspell6-en/7.1-0
REQUIRES += libs/dict/aspell6-es/1.11-2
REQUIRES += libs/dict/aspell6-fi/0.7-0
REQUIRES += libs/dict/aspell6-fr/0.50-3
REQUIRES += libs/dict/aspell6-it/2.2
REQUIRES += libs/dict/aspell6-ru/0.99f7-1

REQUIRES += dev/check/0.9.13
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += dev/check/0.9.13-x86_32
endif
REQUIRES += app/kbd/2.0.2
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/kbd/2.0.2-x86_32
endif

REQUIRES += app/ctags/5.8
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/ctags/5.8-x86_32
endif

REQUIRES += app/dialog/1.2-20140112
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/dialog/1.2-20140112-x86_32
endif



#######
####### Secure:
#######
REQUIRES += secure/cracklib/2.9.1
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += secure/cracklib/2.9.1-x86_32
endif
REQUIRES += secure/pam/1.1.8
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += secure/pam/1.1.8-x86_32
endif
REQUIRES += secure/pam_unix2/2.9.1
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += secure/pam_unix2/2.9.1-x86_32
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
REQUIRES += app/bash/4.3
REQUIRES += app/coreutils/8.22
REQUIRES += app/diffutils/3.3
REQUIRES += app/findutils/4.4.2
REQUIRES += app/sed/4.2.2
REQUIRES += app/grep/2.18
REQUIRES += app/sysvinit/2.88
REQUIRES += app/sysvinit-functions/8.54
REQUIRES += app/util-linux/2.24.1
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/util-linux/2.24.1-x86_32
endif
REQUIRES += app/acl/2.2.52
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/acl/2.2.52-x86_32
endif

#######
####### File Systems support:
#######
REQUIRES += app/xfsprogs/3.1.11
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/xfsprogs/3.1.11-x86_32
endif
REQUIRES += app/xfsdump/3.1.3
REQUIRES += app/e2fsprogs/1.42.9
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/e2fsprogs/1.42.9-x86_32
endif
REQUIRES += app/reiserfsprogs/3.6.24
REQUIRES += app/dosfstools/3.0.26
REQUIRES += app/jfsutils/1.1.15
REQUIRES += app/sysfsutils/2.1.0

#######
####### Shadow, system log, procps:
#######
REQUIRES += secure/shadow/4.2.1
REQUIRES += app/sysklogd/1.5
REQUIRES += app/procps/3.2.8

#######
####### Packages:
#######
REQUIRES += libs/libgamin/0.1.10
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/libgamin/0.1.10-x86_32
endif
REQUIRES += libs/glib2/2.40.0
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/glib2/2.40.0-x86_32
endif
REQUIRES += app/gamin/0.1.10
REQUIRES += libs/libusb/1.0.9
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/libusb/1.0.9-x86_32
endif
REQUIRES += app/usbutils/007
REQUIRES += app/pciutils/3.2.1
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/pciutils/3.2.1-x86_32
endif
###
### NOTE: app/udev - is built without introspection (because
###                  gobject-introspection cannot be cross compiled)
###
REQUIRES += app/udev/182
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/udev/182-x86_32
endif
REQUIRES += app/tar/1.27.1
REQUIRES += app/cpio/2.11
REQUIRES += app/ed/1.9
REQUIRES += app/file/5.19
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += app/file/5.19-x86_32
endif
REQUIRES += app/gawk/4.1.1
REQUIRES += app/getty-ps/2.1.0b
REQUIRES += app/hdparm/9.43
REQUIRES += app/less/451
REQUIRES += app/lha/114i

REQUIRES += app/dcron/4.5
REQUIRES += app/logrotate/3.8.7

REQUIRES += secure/libcgroup/0.41
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += secure/libcgroup/0.41-x86_32
endif

#######
####### SCSI:
#######
REQUIRES += libs/sg3_utils/1.39
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/sg3_utils/1.39-x86_32
endif
REQUIRES += app/sdparm/1.08




#######
####### Networking:
#######
REQUIRES += net/tcp_wrappers/7.6
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

REQUIRES += net/dhcpcd/6.4.2

REQUIRES += net/p11-kit/0.20.2
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += net/p11-kit/0.20.2-x86_32
endif
REQUIRES += net/nettle/2.7.1
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += net/nettle/2.7.1-x86_32
endif
REQUIRES += dev/guile/2.0.9
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += dev/guile/2.0.9-x86_32
endif
REQUIRES += net/gnutls/3.1.22
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += net/gnutls/3.1.22-x86_32
endif

REQUIRES += net/iputils/s20121221
REQUIRES += net/ethtool/3.12
REQUIRES += net/inetd/1.79
REQUIRES += net/openssh/6.6p1

REQUIRES += net/libgpg-error/1.12
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += net/libgpg-error/1.12-x86_32
endif
REQUIRES += net/libassuan/2.1.1
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += net/libassuan/2.1.1-x86_32
endif
REQUIRES += net/libksba/1.3.0
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += net/libksba/1.3.0-x86_32
endif
REQUIRES += libs/pth/2.0.7
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/pth/2.0.7-x86_32
endif
REQUIRES += net/libgcrypt/1.6.1
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += net/libgcrypt/1.6.1-x86_32
endif


REQUIRES += app/vim/7.4-373

REQUIRES += libs/libpng/libpng14/1.4.13
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/libpng/libpng14/1.4.13-x86_32
endif

REQUIRES += libs/slang/2.2.4
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES += libs/slang/2.2.4-x86_32
endif

REQUIRES += app/mc/4.8.12


#######
####### Additional DEV packages:
#######

#######
####### additional libs for bootstrap GCC:
#######
# REQUIRES += app/cloog/0.18.2
# REQUIRES += libs/ppl/1.1


install_target     = $(TARGET_BUILD_DIR)/.install_done


BUILD_TARGETS    = $(install_target)


include ../../build-system/core.mk


$(install_target):
	@touch $@
