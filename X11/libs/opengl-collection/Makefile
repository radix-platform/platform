
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_VIP1830)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)


NEED_ABS_PATH      = true

COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


#
# Do not require mesa twice when we build 32bit compatible packages:
# =================================================================
#
# NOTE:
#  We use filter utility because in the future we will use this mechanism
#  to create 32bit compat packages for other architectures. for example,
#  ARM 32 compat for ARM aarch64 platform.
#
ifeq ($(filter true,$(CREATE_X86_32_PACKAGE)),)
REQUIRES += X11/libs/mesa/10.3.4
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC64)),)
REQUIRES += X11/libs/mesa/10.3.4-x86_32
endif


ifneq ($(filter $(HARDWARE),$(HARDWARE_CB1X)),)
REQUIRES += X11/libs/sunxi-mali/3.0.4.0
endif


# ======= __END_OF_REQUIRES__ =======


install_target     = $(TARGET_BUILD_DIR)/.install_done


BUILD_TARGETS      = $(install_target)


include ../../../build-system/core.mk


$(install_target):
	@touch $@
