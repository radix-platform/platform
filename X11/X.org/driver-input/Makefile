
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


include ../../../build-system/constants.mk



REQUIRES += X11/X.org/driver/xf86-input-acecad/1.5.0
REQUIRES += X11/X.org/driver/xf86-input-aiptek/1.4.1
REQUIRES += X11/X.org/driver/xf86-input-joystick/1.6.2
REQUIRES += X11/X.org/driver/xf86-input-keyboard/1.8.1
REQUIRES += X11/X.org/driver/xf86-input-mouse/1.9.1
REQUIRES += X11/X.org/driver/xf86-input-penmount/1.5.0

REQUIRES += X11/X.org/driver/xf86-input-evdev/2.10.2
REQUIRES += X11/X.org/driver/xf86-input-synaptics/1.8.99.1
#
# NOTE: xf86-input-libinput - is a replacement  of  evdev + synaptics
#       to use this driver you have to install  60-libinput.conf from
#       /usr/share/doc/xf86-input-libinput-0.19.0/conf directory into
#       /usr/share/X11/xorg.conf.d/ .
#
REQUIRES += X11/X.org/driver/xf86-input-libinput/0.19.0

REQUIRES += X11/X.org/driver/xf86-input-void/1.4.1

ifneq ($(filter $(HARDWARE),$(HARDWARE_PC64) $(HARDWARE_PC32)),)
REQUIRES += X11/X.org/driver/xf86-input-vmmouse/13.1.0
endif


# ======= __END_OF_REQUIRES__ =======


install_target     = $(TARGET_BUILD_DIR)/.install_done


BUILD_TARGETS      = $(install_target)


include ../../../build-system/core.mk


$(install_target):
	@touch $@
