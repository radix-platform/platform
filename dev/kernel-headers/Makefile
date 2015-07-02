
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


NEED_ABS_PATH      = true

COMPONENT_IS_3PP   = true


include ../../build-system/constants.mk


ifneq ($(filter $(HARDWARE),$(HARDWARE_PC32) $(HARDWARE_PC64)),)
REQUIRES           = dev/kernel/x86/3.10.17-headers
endif

ifeq ($(HARDWARE),$(HARDWARE_CB1X))
REQUIRES           = dev/kernel/a1x/3.4-20140514-headers
endif

ifeq ($(HARDWARE),$(HARDWARE_CB3X))
REQUIRES           = dev/kernel/a2x/3.4-20150315-headers
endif

ifeq ($(HARDWARE),$(HARDWARE_FFRK3288))
REQUIRES           = dev/kernel/firefly/3.10-20150417-headers
endif

ifeq ($(HARDWARE),$(HARDWARE_VIP1830))
REQUIRES           = dev/kernel/dm644x/2.6.36-headers
endif

ifeq ($(HARDWARE),$(HARDWARE_BEAGLE))
REQUIRES           = dev/kernel/omap35x/2.6.36-headers
endif

ifeq ($(HARDWARE),$(HARDWARE_OMAP5UEVM))
REQUIRES           = dev/kernel/omap543x/3.8.y-20140222-headers
endif

ifeq ($(HARDWARE),$(HARDWARE_B74))
REQUIRES           = dev/kernel/bcm74x/2.6.36-headers
endif

ifeq ($(HARDWARE),$(HARDWARE_CI20))
REQUIRES           = dev/kernel/ci20/3.18-20150313-headers
endif


# ======= __END_OF_REQUIRES__ =======


install_target     = $(TARGET_BUILD_DIR)/.install_done


BUILD_TARGETS      = $(install_target)


include ../../build-system/core.mk


$(install_target):
	@touch $@
