
COMPONENT_TARGETS  = $(TARGET_PC32)
COMPONENT_TARGETS += $(TARGET_PC64)
COMPONENT_TARGETS += $(TARGET_CB1X)
COMPONENT_TARGETS += $(TARGET_VIP1830)
COMPONENT_TARGETS += $(TARGET_BEAGLE)
COMPONENT_TARGETS += $(TARGET_OMAP5UEVM)
COMPONENT_TARGETS += $(TARGET_B74)

#
# The rest targets links staticaly and not requires gcc runtime libraties
#
# COMPONENT_TARGETS += $(TARGET_CB1N)
# COMPONENT_TARGETS += $(TARGET_GUARD)
# COMPONENT_TARGETS += $(TARGET_VIP1830N)
# COMPONENT_TARGETS += $(TARGET_L17UC)
#


NEED_ABS_PATH      = true

COMPONENT_IS_3PP   = true


include ../../build-system/constants.mk



ifeq ($(HARDWARE),$(TARGET_OMAP5UEVM))
REQUIRES           = hal/3pp/omap/wl18xx_fw
REQUIRES          += boot/u-boot/omap543x/2013.04-20140216
endif

REQUIRES          += libs/eglibc/2.18.1-zoneinfo
REQUIRES          += dev/binutils/2.24
REQUIRES          += dev/gcc/4.8.2

#
# Module Init Tools and Core libs:
#
REQUIRES          += app/kmod/16
REQUIRES          += libs/libffi/3.0.13
REQUIRES          += libs/libelf/0.8.13
REQUIRES          += app/gzip/1.6
REQUIRES          += app/ncompress/4.2.4.4
REQUIRES          += libs/libtermcap/1.2.3
REQUIRES          += libs/readline/6.3
REQUIRES          += app/gettext/0.18.3.2
REQUIRES          += libs/pcre/8.34

#
# Core Utilites and SysVInit:
#
REQUIRES          += app/bash/4.3
REQUIRES          += app/coreutils/8.22
REQUIRES          += app/diffutils/3.3
REQUIRES          += app/findutils/4.4.2
REQUIRES          += app/sed/4.2.2
REQUIRES          += app/grep/2.18
REQUIRES          += app/sysvinit/2.88
REQUIRES          += app/sysvinit-functions/8.54
REQUIRES          += app/util-linux/2.24.1
REQUIRES          += app/acl/2.2.52

#
# File Systems support:
#
REQUIRES          += app/xfsprogs/3.1.11
REQUIRES          += app/xfsdump/3.1.3
REQUIRES          += app/e2fsprogs/1.42.9
REQUIRES          += app/reiserfsprogs/3.6.24
REQUIRES          += app/dosfstools/3.0.26
REQUIRES          += app/jfsutils/1.1.15
REQUIRES          += app/sysfsutils/2.1.0

REQUIRES          += app/shadow/4.1.5.1
REQUIRES          += app/sysklogd/1.5
REQUIRES          += app/procps/3.2.8


#
# Additional packages:
#
REQUIRES          += libs/expat/2.1.0
REQUIRES          += libs/libgamin/0.1.10
REQUIRES          += libs/glib2/2.40.0
REQUIRES          += app/gamin/0.1.10
REQUIRES          += libs/libusb/1.0.9
REQUIRES          += app/usbutils/007
REQUIRES          += app/pciutils/3.2.1
# NOTE: app/udev - is built without introspection (because gobject-introspection cannot be cross compiled)
REQUIRES          += app/udev/182


#
# Networking:
#
REQUIRES          += net/openssl/1.0.1f
REQUIRES          += net/libgpg-error/1.12
REQUIRES          += net/libassuan/2.1.1
REQUIRES          += net/libksba/1.3.0

REQUIRES          += net/tcp_wrappers/7.6
REQUIRES          += net/icmpinfo/1.11

#
# Additional DEV packages:
#
# === python depends on openssl ===
REQUIRES          += dev/python2/2.7.6



#
# additional libs for bootstrap GCC:
#
# REQUIRES          += libs/mpc/1.0.2
# REQUIRES          += app/cloog/0.18.2
# REQUIRES          += libs/ppl/1.1



install_target     = $(TARGET_BUILD_DIR)/.install_done


BUILD_TARGETS    = $(install_target)


include ../../build-system/core.mk


$(install_target):
	@touch $@
