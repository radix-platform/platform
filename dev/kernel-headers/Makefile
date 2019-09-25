
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_ORANGE_PP2E)
COMPONENT_TARGETS += $(HARDWARE_NANOPI_NEO)
COMPONENT_TARGETS += $(HARDWARE_ORANGE_PP)
COMPONENT_TARGETS += $(HARDWARE_ORANGE_PL2)
COMPONENT_TARGETS += $(HARDWARE_WECHIP_TX6)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_POIN2)
COMPONENT_TARGETS += $(HARDWARE_RK3328_CC)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_EDGE)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXV)
COMPONENT_TARGETS += $(HARDWARE_P201)
COMPONENT_TARGETS += $(HARDWARE_NEXBOX_A95X)
COMPONENT_TARGETS += $(HARDWARE_ODROID_C2)
COMPONENT_TARGETS += $(HARDWARE_P212)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_VIM)
COMPONENT_TARGETS += $(HARDWARE_Q201)
COMPONENT_TARGETS += $(HARDWARE_ENYBOX_X2)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_VIM2)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OKMX6DL_C)
COMPONENT_TARGETS += $(HARDWARE_OKMX6Q_C)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BAIKAL_T1)
COMPONENT_TARGETS += $(HARDWARE_MBC4_PC)
COMPONENT_TARGETS += $(HARDWARE_S824L)
COMPONENT_TARGETS += $(HARDWARE_VESNIN)
COMPONENT_TARGETS += $(HARDWARE_S824L_LSB)
COMPONENT_TARGETS += $(HARDWARE_VESNIN_LSB)
COMPONENT_TARGETS += $(HARDWARE_TL2WK2)
COMPONENT_TARGETS += $(HARDWARE_TL2SV2)
COMPONENT_TARGETS += $(HARDWARE_TL2WK2_LSB)
COMPONENT_TARGETS += $(HARDWARE_TL2SV2_LSB)


NEED_ABS_PATH      = true

COMPONENT_IS_3PP   = true


include ../../build-system/constants.mk


ifneq ($(filter $(HARDWARE),$(HARDWARE_PC32) $(HARDWARE_PC64)),)
REQUIRES           = dev/kernel/x86/4.19.3-headers
endif

ifneq ($(filter $(HARDWARE),$(HARDWARE_CB1X)),)
REQUIRES           = dev/kernel/a1x/3.4-20140514-headers
endif

ifneq ($(filter $(HARDWARE),$(HARDWARE_CB2X) $(HARDWARE_CB3X)),)
REQUIRES           = dev/kernel/a2x/3.4-20150315-headers
endif

ifneq ($(filter $(HARDWARE),$(HARDWARE_ORANGE_PP2E) \
                            $(HARDWARE_NANOPI_NEO)),)
REQUIRES           = dev/kernel/h3/4.14.52-20180918-headers
endif

ifneq ($(filter $(HARDWARE),$(HARDWARE_ORANGE_PP)  \
                            $(HARDWARE_ORANGE_PL2) \
                            $(HARDWARE_WECHIP_TX6)),)
REQUIRES           = dev/kernel/h5/4.14.52-20180628-headers
endif

ifneq ($(filter $(HARDWARE),$(HARDWARE_FFRK3288) \
                            $(HARDWARE_POIN2)),)
REQUIRES           = dev/kernel/firefly/3.10-20161107-headers
endif

ifneq ($(filter $(HARDWARE),$(HARDWARE_RK3328_CC)),)
REQUIRES           = dev/kernel/rk3328-cc/4.4.154-20181101-headers
endif

ifneq ($(filter $(HARDWARE),$(HARDWARE_KHADAS_EDGE)),)
REQUIRES           = dev/kernel/khadas-edge/4.4.154-20181101-headers
endif

ifneq ($(filter $(HARDWARE),$(HARDWARE_M201)),)
REQUIRES           = dev/kernel/s8xx/3.10.33-20160716-headers
endif

ifneq ($(filter $(HARDWARE),$(HARDWARE_MXV)),)
REQUIRES           = dev/kernel/s8xx/3.10.103-20160830-headers
endif

ifneq ($(filter $(HARDWARE),$(HARDWARE_P201)        \
                            $(HARDWARE_NEXBOX_A95X) \
                            $(HARDWARE_P212)        \
                            $(HARDWARE_ENYBOX_X2)   \
                            $(HARDWARE_KHADAS_VIM2)),)
REQUIRES           = dev/kernel/s9xx/3.14.29-20160818-headers
endif

ifneq ($(filter $(HARDWARE),$(HARDWARE_ODROID_C2)),)
REQUIRES           = dev/kernel/odroid-c2/3.14.79-20170131-headers
endif

ifneq ($(filter $(HARDWARE),$(HARDWARE_KHADAS_VIM)),)
REQUIRES           = dev/kernel/kvim/3.14.29-20170119-headers
endif

ifneq ($(filter $(HARDWARE),$(HARDWARE_NIT6Q)),)
REQUIRES           = dev/kernel/nit6q/4.14.98-20190925-headers
endif

ifneq ($(filter $(HARDWARE),$(HARDWARE_OKMX6DL_C) $(HARDWARE_OKMX6Q_C)),)
REQUIRES           = dev/kernel/okmx6x/4.14.98-20190418-headers
endif

ifneq ($(filter $(HARDWARE),$(HARDWARE_OMAP5UEVM) $(HARDWARE_DRA7XXEVM)),)
REQUIRES           = dev/kernel/omap543x/3.14.57-20151211-headers
endif

ifneq ($(filter $(HARDWARE),$(HARDWARE_CI20)),)
REQUIRES           = dev/kernel/ci20/3.18-20160210-headers
endif

ifneq ($(filter $(HARDWARE),$(HARDWARE_BAIKAL_T1)),)
REQUIRES           = dev/kernel/bt1/4.4.145-4.15.115-headers
endif

ifneq ($(filter $(HARDWARE),$(HARDWARE_MBC4_PC)),)
REQUIRES           = dev/kernel/r1000/4.19.3-headers
endif

ifneq ($(filter $(HARDWARE),$(HARDWARE_S824L)      \
                            $(HARDWARE_VESNIN)     \
                            $(HARDWARE_S824L_LSB)  \
                            $(HARDWARE_VESNIN_LSB)),)
REQUIRES           = dev/kernel/power8/4.19.3-headers
endif

ifneq ($(filter $(HARDWARE),$(HARDWARE_TL2WK2)     \
                            $(HARDWARE_TL2SV2)     \
                            $(HARDWARE_TL2WK2_LSB) \
                            $(HARDWARE_TL2SV2_LSB)),)
REQUIRES           = dev/kernel/power9/4.19.3-headers
endif


# ======= __END_OF_REQUIRES__ =======


install_target     = $(TARGET_BUILD_DIR)/.install_done


BUILD_TARGETS      = $(install_target)


include ../../build-system/core.mk


$(install_target):
	@touch $@
