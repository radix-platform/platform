
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

REQUIRES          += app/kmod/16
REQUIRES          += libs/libffi/3.0.13
REQUIRES          += libs/libelf/0.8.13
REQUIRES          += app/gzip/1.6
REQUIRES          += app/ncompress/4.2.4.4
REQUIRES          += libs/libtermcap/1.2.3
REQUIRES          += libs/readline/6.3
REQUIRES          += app/gettext/0.18.3.2

REQUIRES          += libs/pcre/8.34
REQUIRES          += app/bash/4.3
REQUIRES          += app/coreutils/8.22
REQUIRES          += app/diffutils/3.3
REQUIRES          += app/findutils/4.4.2

#
# additional:
#
# REQUIRES          += libs/mpc/1.0.2
# REQUIRES          += app/cloog/0.18.2
# REQUIRES          += libs/ppl/1.1



install_target     = $(TARGET_BUILD_DIR)/.install_done


BUILD_TARGETS    = $(install_target)


include ../../build-system/core.mk


$(install_target):
	@touch $@
