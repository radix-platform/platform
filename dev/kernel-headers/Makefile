
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXQ)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true

COMPONENT_IS_3PP   = true


include ../../build-system/constants.mk


ifneq ($(filter $(HARDWARE),$(HARDWARE_PC32) $(HARDWARE_PC64)),)
REQUIRES           = dev/kernel/x86/4.4.3-headers
endif

ifneq ($(filter $(HARDWARE),$(HARDWARE_CB1X)),)
REQUIRES           = dev/kernel/a1x/3.4-20140514-headers
endif

ifneq ($(filter $(HARDWARE),$(HARDWARE_CB2X) $(HARDWARE_CB3X)),)
REQUIRES           = dev/kernel/a2x/3.4-20150315-headers
endif

ifneq ($(filter $(HARDWARE),$(HARDWARE_FFRK3288)),)
REQUIRES           = dev/kernel/firefly/3.10-20151231-headers
endif

ifneq ($(filter $(HARDWARE),$(HARDWARE_M201)),)
REQUIRES           = dev/kernel/s805/3.10.33-20150117-headers
endif

ifneq ($(filter $(HARDWARE),$(HARDWARE_MXQ)),)
REQUIRES           = dev/kernel/s805/3.10.103-20160830-headers
endif

ifneq ($(filter $(HARDWARE),$(HARDWARE_NIT6Q)),)
REQUIRES           = dev/kernel/nit6q/3.14.28-20160304-headers
endif

ifneq ($(filter $(HARDWARE),$(HARDWARE_OMAP5UEVM) $(HARDWARE_DRA7XXEVM)),)
REQUIRES           = dev/kernel/omap543x/3.14.57-20151211-headers
endif

ifneq ($(filter $(HARDWARE),$(HARDWARE_CI20)),)
REQUIRES           = dev/kernel/ci20/3.18-20160210-headers
endif

ifneq ($(filter $(HARDWARE),$(HARDWARE_BT1)),)
REQUIRES           = dev/kernel/bt1/4.1.18-headers
endif


# ======= __END_OF_REQUIRES__ =======


install_target     = $(TARGET_BUILD_DIR)/.install_done


BUILD_TARGETS      = $(install_target)


include ../../build-system/core.mk


$(install_target):
	@touch $@
