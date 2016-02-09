
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_DM64X)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true

COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk



REQUIRES += X11/X.org/driver/xf86-input-acecad/1.5.0
REQUIRES += X11/X.org/driver/xf86-input-aiptek/1.4.1
REQUIRES += X11/X.org/driver/xf86-input-evdev/2.9.0
REQUIRES += X11/X.org/driver/xf86-input-joystick/1.6.2
REQUIRES += X11/X.org/driver/xf86-input-keyboard/1.8.0
REQUIRES += X11/X.org/driver/xf86-input-mouse/1.9.1
REQUIRES += X11/X.org/driver/xf86-input-penmount/1.5.0
REQUIRES += X11/X.org/driver/xf86-input-synaptics/1.8.1

REQUIRES += X11/X.org/driver/xf86-input-void/1.4.0

ifneq ($(filter $(HARDWARE),$(HARDWARE_PC64) $(HARDWARE_PC32)),)
REQUIRES += X11/X.org/driver/xf86-input-vmmouse/13.0.0
endif


# ======= __END_OF_REQUIRES__ =======


install_target     = $(TARGET_BUILD_DIR)/.install_done


BUILD_TARGETS      = $(install_target)


include ../../../build-system/core.mk


$(install_target):
	@touch $@
