
COMPONENT_TARGETS += $(TARGET_HOST)
COMPONENT_TARGETS += $(TARGET_PC32)
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


ifneq ($(filter $(HARDWARE),$(TARGET_HOST) $(TARGET_PC32) $(TARGET_PC64)),)
REQUIRES           = dev/kernel/x86/3.10.17-headers
endif

ifeq ($(HARDWARE),$(TARGET_CB1X))
REQUIRES           = dev/kernel/a1x/3.0.52-r2-headers
endif

ifeq ($(HARDWARE),$(TARGET_VIP1830))
REQUIRES           = dev/kernel/dm644x/2.6.36-headers
endif

ifeq ($(HARDWARE),$(TARGET_BEAGLE))
REQUIRES           = dev/kernel/omap35x/2.6.36-headers
endif

ifeq ($(HARDWARE),$(TARGET_OMAP5UEVM))
REQUIRES           = dev/kernel/omap543x/3.8.y-20140222-headers
endif

ifeq ($(HARDWARE),$(TARGET_B74))
REQUIRES           = dev/kernel/bcm74x/2.6.36-headers
endif

REQUIRES          += base/pkgtool


install_target     = $(TARGET_BUILD_DIR)/.install_done


BUILD_TARGETS    = $(install_target)


include ../../build-system/core.mk


$(install_target):
	@touch $@
