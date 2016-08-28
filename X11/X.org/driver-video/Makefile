
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true

COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk



REQUIRES += X11/X.org/driver/xf86-video-dummy/0.3.7
REQUIRES += X11/X.org/driver/xf86-video-fbdev/0.4.4
REQUIRES += X11/X.org/driver/xf86-video-modesetting/0.9.0
REQUIRES += X11/X.org/driver/xf86-video-v4l/0.2.0
REQUIRES += X11/X.org/driver/xf86-video-vesa/2.3.4

ifneq ($(filter $(HARDWARE),$(HARDWARE_PC64) $(HARDWARE_PC32)),)
REQUIRES += X11/X.org/driver/xf86-video-intel/2.99.917.1
REQUIRES += X11/X.org/driver/xf86-video-vmware/13.1.0
endif

ifneq ($(filter $(HARDWARE),$(HARDWARE_CB1X)),)
REQUIRES += X11/X.org/driver/xf86-video-fbturbo/r3p0-04rel0/0.4.0
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_CB1X)),)
REQUIRES += X11/X.org/driver/xf86-video-mali/DX/r3p0-04rel0/0.4.2
endif


# ======= __END_OF_REQUIRES__ =======


install_target     = $(TARGET_BUILD_DIR)/.install_done


BUILD_TARGETS      = $(install_target)


include ../../../build-system/core.mk


$(install_target):
	@touch $@
