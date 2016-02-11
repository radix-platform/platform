
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true

COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk



REQUIRES += X11/X.org/font/encodings/1.0.4
REQUIRES += X11/X.org/font/font-adobe-100dpi/1.0.3
REQUIRES += X11/X.org/font/font-adobe-75dpi/1.0.3
REQUIRES += X11/X.org/font/font-adobe-utopia-100dpi/1.0.4
REQUIRES += X11/X.org/font/font-adobe-utopia-75dpi/1.0.4
REQUIRES += X11/X.org/font/font-adobe-utopia-type1/1.0.4
REQUIRES += X11/X.org/font/font-alias/1.0.3
REQUIRES += X11/X.org/font/font-arabic-misc/1.0.3
REQUIRES += X11/X.org/font/font-bh-100dpi/1.0.3
REQUIRES += X11/X.org/font/font-bh-75dpi/1.0.3
REQUIRES += X11/X.org/font/font-bh-lucidatypewriter-100dpi/1.0.3
REQUIRES += X11/X.org/font/font-bh-lucidatypewriter-75dpi/1.0.3
REQUIRES += X11/X.org/font/font-bh-ttf/1.0.3
REQUIRES += X11/X.org/font/font-bh-type1/1.0.3
REQUIRES += X11/X.org/font/font-bitstream-100dpi/1.0.3
REQUIRES += X11/X.org/font/font-bitstream-75dpi/1.0.3
REQUIRES += X11/X.org/font/font-bitstream-speedo/1.0.2
REQUIRES += X11/X.org/font/font-bitstream-type1/1.0.3
REQUIRES += X11/X.org/font/font-cronyx-cyrillic/1.0.3
REQUIRES += X11/X.org/font/font-cursor-misc/1.0.3
REQUIRES += X11/X.org/font/font-daewoo-misc/1.0.3
REQUIRES += X11/X.org/font/font-dec-misc/1.0.3
REQUIRES += X11/X.org/font/font-ibm-type1/1.0.3
REQUIRES += X11/X.org/font/font-isas-misc/1.0.3
REQUIRES += X11/X.org/font/font-jis-misc/1.0.3
REQUIRES += X11/X.org/font/font-micro-misc/1.0.3
REQUIRES += X11/X.org/font/font-misc-cyrillic/1.0.3
REQUIRES += X11/X.org/font/font-misc-ethiopic/1.0.3
REQUIRES += X11/X.org/font/font-misc-meltho/1.0.3
REQUIRES += X11/X.org/font/font-misc-misc/1.1.2
REQUIRES += X11/X.org/font/font-mutt-misc/1.0.3
REQUIRES += X11/X.org/font/font-schumacher-misc/1.1.2
REQUIRES += X11/X.org/font/font-screen-cyrillic/1.0.4
REQUIRES += X11/X.org/font/font-sony-misc/1.0.3
REQUIRES += X11/X.org/font/font-sun-misc/1.0.3
REQUIRES += X11/X.org/font/font-winitzki-cyrillic/1.0.3
REQUIRES += X11/X.org/font/font-xfree86-type1/1.0.4


# ======= __END_OF_REQUIRES__ =======


install_target     = $(TARGET_BUILD_DIR)/.install_done


BUILD_TARGETS      = $(install_target)


include ../../../build-system/core.mk


$(install_target):
	@touch $@
