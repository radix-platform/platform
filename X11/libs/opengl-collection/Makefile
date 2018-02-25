
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_POIN2)
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
REQUIRES += X11/libs/mesa/11.2.2
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC64)),)
REQUIRES += X11/libs/mesa/11.2.2-x86_32
endif


ifneq ($(filter $(HARDWARE),$(HARDWARE_CB1X)),)
REQUIRES += X11/libs/sunxi-mali/3.0.4.0
endif

ifneq ($(filter $(HARDWARE),$(HARDWARE_CI20)),)
REQUIRES += X11/libs/ci20-sgx-um/1.14.3759903
endif

ifneq ($(filter $(HARDWARE),$(HARDWARE_M201)),)
REQUIRES += X11/libs/aml-mali/4.0.1.0
endif

ifneq ($(filter $(HARDWARE),$(HARDWARE_MXV)),)
REQUIRES += X11/libs/aml-mali/5.0.1.0
endif

ifneq ($(filter $(HARDWARE),$(HARDWARE_P201) $(HARDWARE_NEXBOX_A95X)),)
REQUIRES += X11/libs/aml-mali/5.1.1.0
endif

ifneq ($(filter $(HARDWARE),                 $(HARDWARE_ODROID_C2)  \
                            $(HARDWARE_P212) $(HARDWARE_KHADAS_VIM) \
                            $(HARDWARE_Q201) $(HARDWARE_ENYBOX_X2)),)
REQUIRES += X11/libs/aml-mali/6.1.1.0
endif


# ======= __END_OF_REQUIRES__ =======


install_target     = $(TARGET_BUILD_DIR)/.install_done


BUILD_TARGETS      = $(install_target)


include ../../../build-system/core.mk


$(install_target):
	@touch $@
