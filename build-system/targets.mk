# include once
ifndef TARGETS_MK


include $(BUILDSYSTEM)/constants.mk


#######
####### Config:
#######

ifneq ($(wildcard $(BUILDSYSTEM)/build-config.mk),)
include $(BUILDSYSTEM)/build-config.mk
else
include $(BUILDSYSTEM)/build-config.mk.template
endif

# Reading build-config.mk:

ifneq ($(BUILD_PC32),true)
BUILD_PC32 :=
endif
ifneq ($(BUILD_PC64),true)
BUILD_PC64 :=
endif
ifneq ($(BUILD_CB1N),true)
BUILD_CB1N :=
endif
ifneq ($(BUILD_CB1X),true)
BUILD_CB1X :=
endif
ifneq ($(BUILD_GUARD),true)
BUILD_GUARD :=
endif
ifneq ($(BUILD_VIP1830N),true)
BUILD_VIP1830N :=
endif
ifneq ($(BUILD_VIP1830),true)
BUILD_VIP1830 :=
endif
ifneq ($(BUILD_L17UC),true)
BUILD_L17UC :=
endif
ifneq ($(BUILD_BEAGLE),true)
BUILD_BEAGLE :=
endif
ifneq ($(BUILD_OMAP5UEVM),true)
BUILD_OMAP5UEVM :=
endif
ifneq ($(BUILD_DRA7XXEVM),true)
BUILD_DRA7XXEVM :=
endif
ifneq ($(BUILD_B74),true)
BUILD_B74 :=
endif


# If no TOOLCHAIN set
ifeq ($(TOOLCHAIN),)

# COMPONENT_TARGETS must have a value specified in the Makefile
ifeq ($(COMPONENT_TARGETS),)
$(error Error: COMPONENT_TARGETS must have a value)
endif

# End if no TARGET set
endif

# Filter out disabled targets

ifeq ($(BUILD_PC32),)
COMPONENT_TARGETS := $(filter-out $(TARGET_PC32),$(COMPONENT_TARGETS))
I686_EGLIBC_HARDWARE_VARIANTS := $(filter-out $(TARGET_PC32),$(I686_EGLIBC_HARDWARE_VARIANTS))
endif
ifeq ($(BUILD_PC64),)
COMPONENT_TARGETS := $(filter-out $(TARGET_PC64),$(COMPONENT_TARGETS))
X86_64_EGLIBC_HARDWARE_VARIANTS := $(filter-out $(TARGET_PC64),$(X86_64_EGLIBC_HARDWARE_VARIANTS))
endif
ifeq ($(BUILD_CB1N),)
COMPONENT_TARGETS := $(filter-out $(TARGET_CB1N),$(COMPONENT_TARGETS))
A1X_NEWLIB_HARDWARE_VARIANTS := $(filter-out $(TARGET_CB1N),$(A1X_NEWLIB_HARDWARE_VARIANTS))
endif
ifeq ($(BUILD_CB1X),)
COMPONENT_TARGETS := $(filter-out $(TARGET_CB1X),$(COMPONENT_TARGETS))
A1X_EGLIBC_HARDWARE_VARIANTS := $(filter-out $(TARGET_CB1X),$(A1X_EGLIBC_HARDWARE_VARIANTS))
endif
ifeq ($(BUILD_GUARD),)
COMPONENT_TARGETS := $(filter-out $(TARGET_GUARD),$(COMPONENT_TARGETS))
AT91SAM7S_NEWLIB_HARDWARE_VARIANTS := $(filter-out $(TARGET_GUARD),$(AT91SAM7S_NEWLIB_HARDWARE_VARIANTS))
endif
ifeq ($(BUILD_VIP1830N),)
COMPONENT_TARGETS := $(filter-out $(TARGET_VIP1830N),$(COMPONENT_TARGETS))
DM644X_NEWLIB_HARDWARE_VARIANTS := $(filter-out $(TARGET_VIP1830N),$(DM644X_NEWLIB_HARDWARE_VARIANTS))
endif
ifeq ($(BUILD_VIP1830),)
COMPONENT_TARGETS := $(filter-out $(TARGET_VIP1830),$(COMPONENT_TARGETS))
DM644X_EGLIBC_HARDWARE_VARIANTS := $(filter-out $(TARGET_VIP1830),$(DM644X_EGLIBC_HARDWARE_VARIANTS))
endif
ifeq ($(BUILD_L17UC),)
COMPONENT_TARGETS := $(filter-out $(TARGET_L17UC),$(COMPONENT_TARGETS))
LPC17XX_UCLIBC_HARDWARE_VARIANTS := $(filter-out $(TARGET_L17UC),$(LPC17XX_UCLIBC_HARDWARE_VARIANTS))
endif
ifeq ($(BUILD_BEAGLE),)
COMPONENT_TARGETS := $(filter-out $(TARGET_BEAGLE),$(COMPONENT_TARGETS))
OMAP35X_EGLIBC_HARDWARE_VARIANTS := $(filter-out $(TARGET_BEAGLE),$(OMAP35X_EGLIBC_HARDWARE_VARIANTS))
endif
ifeq ($(BUILD_OMAP5UEVM),)
COMPONENT_TARGETS := $(filter-out $(TARGET_OMAP5UEVM),$(COMPONENT_TARGETS))
OMAP543X_EGLIBC_HARDWARE_VARIANTS := $(filter-out $(TARGET_OMAP5UEVM),$(OMAP543X_EGLIBC_HARDWARE_VARIANTS))
endif
ifeq ($(BUILD_DRA7XXEVM),)
COMPONENT_TARGETS := $(filter-out $(TARGET_DRA7XXEVM),$(COMPONENT_TARGETS))
OMAP543X_EGLIBC_HARDWARE_VARIANTS := $(filter-out $(TARGET_DRA7XXEVM),$(OMAP543X_EGLIBC_HARDWARE_VARIANTS))
endif
ifeq ($(BUILD_B74),)
COMPONENT_TARGETS := $(filter-out $(TARGET_B74),$(COMPONENT_TARGETS))
BCM74X_EGLIBC_HARDWARE_VARIANTS := $(filter-out $(TARGET_B74),$(BCM74X_EGLIBC_HARDWARE_VARIANTS))
endif


# Remove duplicates:
COMPONENT_TARGETS := $(sort $(COMPONENT_TARGETS))


ifeq ($(filter $(TARGET_NOARCH),$(COMPONENT_TARGETS)),)
NOARCH_HARDWARE_VARIANTS := $(filter-out $(TARGET_NOARCH),$(NOARCH_HARDWARE_VARIANTS))
endif
ifeq ($(filter $(TARGET_HOST),$(COMPONENT_TARGETS)),)
BUILD_HARDWARE_VARIANTS := $(filter-out $(TARGET_HOST),$(BUILD_HARDWARE_VARIANTS))
endif
ifeq ($(filter $(TARGET_PC32),$(COMPONENT_TARGETS)),)
I686_EGLIBC_HARDWARE_VARIANTS := $(filter-out $(TARGET_PC32),$(I686_EGLIBC_HARDWARE_VARIANTS))
endif
ifeq ($(filter $(TARGET_PC64),$(COMPONENT_TARGETS)),)
X86_64_EGLIBC_HARDWARE_VARIANTS := $(filter-out $(TARGET_PC64),$(X86_64_EGLIBC_HARDWARE_VARIANTS))
endif
ifeq ($(filter $(TARGET_CB1N),$(COMPONENT_TARGETS)),)
A1X_NEWLIB_HARDWARE_VARIANTS := $(filter-out $(TARGET_CB1N),$(A1X_NEWLIB_HARDWARE_VARIANTS))
endif
ifeq ($(filter $(TARGET_CB1X),$(COMPONENT_TARGETS)),)
A1X_EGLIBC_HARDWARE_VARIANTS := $(filter-out $(TARGET_CB1X),$(A1X_EGLIBC_HARDWARE_VARIANTS))
endif
ifeq ($(filter $(TARGET_GUARD),$(COMPONENT_TARGETS)),)
AT91SAM7S_NEWLIB_HARDWARE_VARIANTS := $(filter-out $(TARGET_GUARD),$(AT91SAM7S_NEWLIB_HARDWARE_VARIANTS))
endif
ifeq ($(filter $(TARGET_VIP1830N),$(COMPONENT_TARGETS)),)
DM644X_NEWLIB_HARDWARE_VARIANTS := $(filter-out $(TARGET_VIP1830N),$(DM644X_NEWLIB_HARDWARE_VARIANTS))
endif
ifeq ($(filter $(TARGET_VIP1830),$(COMPONENT_TARGETS)),)
DM644X_EGLIBC_HARDWARE_VARIANTS := $(filter-out $(TARGET_VIP1830),$(DM644X_EGLIBC_HARDWARE_VARIANTS))
endif
ifeq ($(filter $(TARGET_L17UC),$(COMPONENT_TARGETS)),)
LPC17XX_UCLIBC_HARDWARE_VARIANTS := $(filter-out $(TARGET_L17UC),$(LPC17XX_UCLIBC_HARDWARE_VARIANTS))
endif
ifeq ($(filter $(TARGET_BEAGLE),$(COMPONENT_TARGETS)),)
OMAP35X_EGLIBC_HARDWARE_VARIANTS := $(filter-out $(TARGET_BEAGLE),$(OMAP35X_EGLIBC_HARDWARE_VARIANTS))
endif
ifeq ($(filter $(TARGET_OMAP5UEVM),$(COMPONENT_TARGETS)),)
OMAP543X_EGLIBC_HARDWARE_VARIANTS := $(filter-out $(TARGET_OMAP5UEVM),$(OMAP543X_EGLIBC_HARDWARE_VARIANTS))
endif
ifeq ($(filter $(TARGET_DRA7XXEVM),$(COMPONENT_TARGETS)),)
OMAP543X_EGLIBC_HARDWARE_VARIANTS := $(filter-out $(TARGET_DRA7XXEVM),$(OMAP543X_EGLIBC_HARDWARE_VARIANTS))
endif
ifeq ($(filter $(TARGET_B74),$(COMPONENT_TARGETS)),)
BCM74X_EGLIBC_HARDWARE_VARIANTS := $(filter-out $(TARGET_B74),$(BCM74X_EGLIBC_HARDWARE_VARIANTS))
endif



#######
####### Targets setup:
#######

ifeq ($(filter $(TARGET_NOARCH),$(COMPONENT_TARGETS)),)
COMPONENT_TOOLCHAINS := $(filter-out $(NOARCH_TOOLCHAIN_NAME),$(COMPONENT_TOOLCHAINS))
endif

ifeq ($(filter $(TARGET_HOST),$(COMPONENT_TARGETS)),)
COMPONENT_TOOLCHAINS := $(filter-out $(BUILD_TOOLCHAIN_NAME),$(COMPONENT_TOOLCHAINS))
endif

ifeq ($(filter $(TARGET_PC32),$(COMPONENT_TARGETS)),)
COMPONENT_TOOLCHAINS := $(filter-out $(I686_EGLIBC_TOOLCHAIN_NAME),$(COMPONENT_TOOLCHAINS))
endif

ifeq ($(filter $(TARGET_PC64),$(COMPONENT_TARGETS)),)
COMPONENT_TOOLCHAINS := $(filter-out $(X86_64_EGLIBC_TOOLCHAIN_NAME),$(COMPONENT_TOOLCHAINS))
endif

ifeq ($(filter $(TARGET_CB1N),$(COMPONENT_TARGETS)),)
COMPONENT_TOOLCHAINS := $(filter-out $(A1X_NEWLIB_TOOLCHAIN_NAME),$(COMPONENT_TOOLCHAINS))
endif

ifeq ($(filter $(TARGET_CB1X),$(COMPONENT_TARGETS)),)
COMPONENT_TOOLCHAINS := $(filter-out $(A1X_EGLIBC_TOOLCHAIN_NAME),$(COMPONENT_TOOLCHAINS))
endif

ifeq ($(filter $(TARGET_GUARD),$(COMPONENT_TARGETS)),)
COMPONENT_TOOLCHAINS := $(filter-out $(AT91SAM7S_NEWLIB_TOOLCHAIN_NAME),$(COMPONENT_TOOLCHAINS))
endif

ifeq ($(filter $(TARGET_VIP1830N),$(COMPONENT_TARGETS)),)
COMPONENT_TOOLCHAINS := $(filter-out $(DM644X_NEWLIB_TOOLCHAIN_NAME),$(COMPONENT_TOOLCHAINS))
endif

ifeq ($(filter $(TARGET_VIP1830),$(COMPONENT_TARGETS)),)
COMPONENT_TOOLCHAINS := $(filter-out $(DM644X_EGLIBC_TOOLCHAIN_NAME),$(COMPONENT_TOOLCHAINS))
endif

ifeq ($(filter $(TARGET_L17UC),$(COMPONENT_TARGETS)),)
COMPONENT_TOOLCHAINS := $(filter-out $(LPC17XX_UCLIBC_TOOLCHAIN_NAME),$(COMPONENT_TOOLCHAINS))
endif

ifeq ($(filter $(TARGET_BEAGLE),$(COMPONENT_TARGETS)),)
COMPONENT_TOOLCHAINS := $(filter-out $(OMAP35X_EGLIBC_TOOLCHAIN_NAME),$(COMPONENT_TOOLCHAINS))
endif

ifeq ($(filter $(TARGET_OMAP5UEVM) $(TARGET_DRA7XXEVM),$(COMPONENT_TARGETS)),)
COMPONENT_TOOLCHAINS := $(filter-out $(OMAP543X_EGLIBC_TOOLCHAIN_NAME),$(COMPONENT_TOOLCHAINS))
endif

ifeq ($(filter $(TARGET_B74),$(COMPONENT_TARGETS)),)
COMPONENT_TOOLCHAINS := $(filter-out $(BCM74X_EGLIBC_TOOLCHAIN_NAME),$(COMPONENT_TOOLCHAINS))
endif


#
# TARGET, TOOLCHAIN_PATH variables should be set up for each makefile
#

ifeq ($(TOOLCHAIN),$(NOARCH_TOOLCHAIN_NAME))
TOOLCHAIN_DIR  = $(NOARCH_TOOLCHAIN_DIR)
TOOLCHAIN_PATH = $(NOARCH_TOOLCHAIN_PATH)
TARGET         = $(NOARCH_TARGET)
endif

ifeq ($(TOOLCHAIN),$(BUILD_TOOLCHAIN_NAME))
TOOLCHAIN_DIR  = $(BUILD_TOOLCHAIN_DIR)
TOOLCHAIN_PATH = $(BUILD_TOOLCHAIN_PATH)
TARGET         = $(BUILD_TARGET)
CC             = $(BUILD_CC)
CXX            = $(BUILD_CXX)
AS             = $(BUILD_AS)
AR             = $(BUILD_AR)
LD             = $(BUILD_LD)
RANLIB         = $(BUILD_RANLIB)
SIZE           = $(BUILD_SIZE)
STRIP          = $(BUILD_STRIP)
OBJCOPY        = $(BUILD_OBJCOPY)
NM             = $(BUILD_NM)
endif

ifeq ($(TOOLCHAIN),$(I686_EGLIBC_TOOLCHAIN_NAME))
TOOLCHAIN_DIR  = $(I686_EGLIBC_TOOLCHAIN_DIR)
TOOLCHAIN_PATH = $(I686_EGLIBC_TOOLCHAIN_PATH)
TARGET         = $(I686_EGLIBC_TARGET)
CC             = $(I686_EGLIBC_CC)
CXX            = $(I686_EGLIBC_CXX)
AS             = $(I686_EGLIBC_AS)
AR             = $(I686_EGLIBC_AR)
LD             = $(I686_EGLIBC_LD)
RANLIB         = $(I686_EGLIBC_RANLIB)
SIZE           = $(I686_EGLIBC_SIZE)
STRIP          = $(I686_EGLIBC_STRIP)
OBJCOPY        = $(I686_EGLIBC_OBJCOPY)
NM             = $(I686_EGLIBC_NM)
CROSS_PREFIX   = $(TOOLCHAIN_PATH)/bin/$(TARGET)-
endif

ifeq ($(TOOLCHAIN),$(X86_64_EGLIBC_TOOLCHAIN_NAME))
TOOLCHAIN_DIR  = $(X86_64_EGLIBC_TOOLCHAIN_DIR)
TOOLCHAIN_PATH = $(X86_64_EGLIBC_TOOLCHAIN_PATH)
TARGET         = $(X86_64_EGLIBC_TARGET)
CC             = $(X86_64_EGLIBC_CC)
CXX            = $(X86_64_EGLIBC_CXX)
AS             = $(X86_64_EGLIBC_AS)
AR             = $(X86_64_EGLIBC_AR)
LD             = $(X86_64_EGLIBC_LD)
RANLIB         = $(X86_64_EGLIBC_RANLIB)
SIZE           = $(X86_64_EGLIBC_SIZE)
STRIP          = $(X86_64_EGLIBC_STRIP)
OBJCOPY        = $(X86_64_EGLIBC_OBJCOPY)
NM             = $(X86_64_EGLIBC_NM)
CROSS_PREFIX   = $(TOOLCHAIN_PATH)/bin/$(TARGET)-
endif

ifeq ($(TOOLCHAIN),$(A1X_NEWLIB_TOOLCHAIN_NAME))
TOOLCHAIN_DIR  = $(A1X_NEWLIB_TOOLCHAIN_DIR)
TOOLCHAIN_PATH = $(A1X_NEWLIB_TOOLCHAIN_PATH)
TARGET         = $(A1X_NEWLIB_TARGET)
CC             = $(A1X_NEWLIB_CC)
CXX            = $(A1X_NEWLIB_CXX)
AS             = $(A1X_NEWLIB_AS)
AR             = $(A1X_NEWLIB_AR)
LD             = $(A1X_NEWLIB_LD)
RANLIB         = $(A1X_NEWLIB_RANLIB)
SIZE           = $(A1X_NEWLIB_SIZE)
STRIP          = $(A1X_NEWLIB_STRIP)
OBJCOPY        = $(A1X_NEWLIB_OBJCOPY)
NM             = $(A1X_NEWLIB_NM)
CROSS_PREFIX   = $(TOOLCHAIN_PATH)/bin/$(TARGET)-
endif

ifeq ($(TOOLCHAIN),$(A1X_EGLIBC_TOOLCHAIN_NAME))
TOOLCHAIN_DIR  = $(A1X_EGLIBC_TOOLCHAIN_DIR)
TOOLCHAIN_PATH = $(A1X_EGLIBC_TOOLCHAIN_PATH)
TARGET         = $(A1X_EGLIBC_TARGET)
CC             = $(A1X_EGLIBC_CC)
CXX            = $(A1X_EGLIBC_CXX)
AS             = $(A1X_EGLIBC_AS)
AR             = $(A1X_EGLIBC_AR)
LD             = $(A1X_EGLIBC_LD)
RANLIB         = $(A1X_EGLIBC_RANLIB)
SIZE           = $(A1X_EGLIBC_SIZE)
STRIP          = $(A1X_EGLIBC_STRIP)
OBJCOPY        = $(A1X_EGLIBC_OBJCOPY)
NM             = $(A1X_EGLIBC_NM)
CROSS_PREFIX   = $(TOOLCHAIN_PATH)/bin/$(TARGET)-
endif

ifeq ($(TOOLCHAIN),$(AT91SAM7S_NEWLIB_TOOLCHAIN_NAME))
TOOLCHAIN_DIR  = $(AT91SAM7S_NEWLIB_TOOLCHAIN_DIR)
TOOLCHAIN_PATH = $(AT91SAM7S_NEWLIB_TOOLCHAIN_PATH)
TARGET         = $(AT91SAM7S_NEWLIB_TARGET)
CC             = $(AT91SAM7S_NEWLIB_CC)
CXX            = $(AT91SAM7S_NEWLIB_CXX)
AS             = $(AT91SAM7S_NEWLIB_AS)
AR             = $(AT91SAM7S_NEWLIB_AR)
LD             = $(AT91SAM7S_NEWLIB_LD)
RANLIB         = $(AT91SAM7S_NEWLIB_RANLIB)
SIZE           = $(AT91SAM7S_NEWLIB_SIZE)
STRIP          = $(AT91SAM7S_NEWLIB_STRIP)
OBJCOPY        = $(AT91SAM7S_NEWLIB_OBJCOPY)
NM             = $(AT91SAM7S_NEWLIB_NM)
CROSS_PREFIX   = $(TOOLCHAIN_PATH)/bin/$(TARGET)-
endif

ifeq ($(TOOLCHAIN),$(DM644X_NEWLIB_TOOLCHAIN_NAME))
TOOLCHAIN_DIR  = $(DM644X_NEWLIB_TOOLCHAIN_DIR)
TOOLCHAIN_PATH = $(DM644X_NEWLIB_TOOLCHAIN_PATH)
TARGET         = $(DM644X_NEWLIB_TARGET)
CC             = $(DM644X_NEWLIB_CC)
CXX            = $(DM644X_NEWLIB_CXX)
AS             = $(DM644X_NEWLIB_AS)
AR             = $(DM644X_NEWLIB_AR)
LD             = $(DM644X_NEWLIB_LD)
RANLIB         = $(DM644X_NEWLIB_RANLIB)
SIZE           = $(DM644X_NEWLIB_SIZE)
STRIP          = $(DM644X_NEWLIB_STRIP)
OBJCOPY        = $(DM644X_NEWLIB_OBJCOPY)
NM             = $(DM644X_NEWLIB_NM)
CROSS_PREFIX   = $(TOOLCHAIN_PATH)/bin/$(TARGET)-
endif

ifeq ($(TOOLCHAIN),$(DM644X_EGLIBC_TOOLCHAIN_NAME))
TOOLCHAIN_DIR  = $(DM644X_EGLIBC_TOOLCHAIN_DIR)
TOOLCHAIN_PATH = $(DM644X_EGLIBC_TOOLCHAIN_PATH)
TARGET         = $(DM644X_EGLIBC_TARGET)
CC             = $(DM644X_EGLIBC_CC)
CXX            = $(DM644X_EGLIBC_CXX)
AS             = $(DM644X_EGLIBC_AS)
AR             = $(DM644X_EGLIBC_AR)
LD             = $(DM644X_EGLIBC_LD)
RANLIB         = $(DM644X_EGLIBC_RANLIB)
SIZE           = $(DM644X_EGLIBC_SIZE)
STRIP          = $(DM644X_EGLIBC_STRIP)
OBJCOPY        = $(DM644X_EGLIBC_OBJCOPY)
NM             = $(DM644X_EGLIBC_NM)
CROSS_PREFIX   = $(TOOLCHAIN_PATH)/bin/$(TARGET)-
endif

ifeq ($(TOOLCHAIN),$(LPC17XX_UCLIBC_TOOLCHAIN_NAME))
TOOLCHAIN_DIR  = $(LPC17XX_UCLIBC_TOOLCHAIN_DIR)
TOOLCHAIN_PATH = $(LPC17XX_UCLIBC_TOOLCHAIN_PATH)
TARGET         = $(LPC17XX_UCLIBC_TARGET)
CC             = $(LPC17XX_UCLIBC_CC)
CXX            = $(LPC17XX_UCLIBC_CXX)
AS             = $(LPC17XX_UCLIBC_AS)
AR             = $(LPC17XX_UCLIBC_AR)
LD             = $(LPC17XX_UCLIBC_LD)
RANLIB         = $(LPC17XX_UCLIBC_RANLIB)
SIZE           = $(LPC17XX_UCLIBC_SIZE)
STRIP          = $(LPC17XX_UCLIBC_STRIP)
OBJCOPY        = $(LPC17XX_UCLIBC_OBJCOPY)
NM             = $(LPC17XX_UCLIBC_NM)
CROSS_PREFIX   = $(TOOLCHAIN_PATH)/bin/$(TARGET)-
endif

ifeq ($(TOOLCHAIN),$(OMAP35X_EGLIBC_TOOLCHAIN_NAME))
TOOLCHAIN_DIR  = $(OMAP35X_EGLIBC_TOOLCHAIN_DIR)
TOOLCHAIN_PATH = $(OMAP35X_EGLIBC_TOOLCHAIN_PATH)
TARGET         = $(OMAP35X_EGLIBC_TARGET)
CC             = $(OMAP35X_EGLIBC_CC)
CXX            = $(OMAP35X_EGLIBC_CXX)
AS             = $(OMAP35X_EGLIBC_AS)
AR             = $(OMAP35X_EGLIBC_AR)
LD             = $(OMAP35X_EGLIBC_LD)
RANLIB         = $(OMAP35X_EGLIBC_RANLIB)
SIZE           = $(OMAP35X_EGLIBC_SIZE)
STRIP          = $(OMAP35X_EGLIBC_STRIP)
OBJCOPY        = $(OMAP35X_EGLIBC_OBJCOPY)
NM             = $(OMAP35X_EGLIBC_NM)
CROSS_PREFIX   = $(TOOLCHAIN_PATH)/bin/$(TARGET)-
endif

ifeq ($(TOOLCHAIN),$(OMAP543X_EGLIBC_TOOLCHAIN_NAME))
TOOLCHAIN_DIR  = $(OMAP543X_EGLIBC_TOOLCHAIN_DIR)
TOOLCHAIN_PATH = $(OMAP543X_EGLIBC_TOOLCHAIN_PATH)
TARGET         = $(OMAP543X_EGLIBC_TARGET)
CC             = $(OMAP543X_EGLIBC_CC)
CXX            = $(OMAP543X_EGLIBC_CXX)
AS             = $(OMAP543X_EGLIBC_AS)
AR             = $(OMAP543X_EGLIBC_AR)
LD             = $(OMAP543X_EGLIBC_LD)
RANLIB         = $(OMAP543X_EGLIBC_RANLIB)
SIZE           = $(OMAP543X_EGLIBC_SIZE)
STRIP          = $(OMAP543X_EGLIBC_STRIP)
OBJCOPY        = $(OMAP543X_EGLIBC_OBJCOPY)
NM             = $(OMAP543X_EGLIBC_NM)
CROSS_PREFIX   = $(TOOLCHAIN_PATH)/bin/$(TARGET)-
endif

ifeq ($(TOOLCHAIN),$(BCM74X_EGLIBC_TOOLCHAIN_NAME))
TOOLCHAIN_DIR  = $(BCM74X_EGLIBC_TOOLCHAIN_DIR)
TOOLCHAIN_PATH = $(BCM74X_EGLIBC_TOOLCHAIN_PATH)
TARGET         = $(BCM74X_EGLIBC_TARGET)
CC             = $(BCM74X_EGLIBC_CC)
CXX            = $(BCM74X_EGLIBC_CXX)
AS             = $(BCM74X_EGLIBC_AS)
AR             = $(BCM74X_EGLIBC_AR)
LD             = $(BCM74X_EGLIBC_LD)
RANLIB         = $(BCM74X_EGLIBC_RANLIB)
SIZE           = $(BCM74X_EGLIBC_SIZE)
STRIP          = $(BCM74X_EGLIBC_STRIP)
OBJCOPY        = $(BCM74X_EGLIBC_OBJCOPY)
NM             = $(BCM74X_EGLIBC_NM)
CROSS_PREFIX   = $(TOOLCHAIN_PATH)/bin/$(TARGET)-
endif

#######
####### Configuration:
#######

# Build environment:

DEST_DIR_ABS           = $(TOP_BUILD_DIR_ABS)/dist

ifeq ($(NEED_ABS_PATH),)
DEST_DIR               = $(TOP_BUILD_DIR)/dist
else
DEST_DIR               = $(DEST_DIR_ABS)
endif



#######
####### Default PREFIX: is $(TOP_BUILD_DIR)/dist
#######

PREFIX ?= $(DEST_DIR)


#######
####### Install DIRs (for SCRIPT_, BIN_, ... TARGETS) [should be always ABS]:
#######
TARGET_DEST_DIR   = $(DEST_DIR_ABS)/$(addprefix ., $(TOOLCHAIN))/$(HARDWARE)
PRODUCTS_DEST_DIR = $(DEST_DIR_ABS)/products/$(TOOLCHAIN)/$(HARDWARE)
ROOTFS_DEST_DIR   = $(DEST_DIR_ABS)/rootfs/$(TOOLCHAIN)/$(HARDWARE)



#######
####### Architecture depended compiler flags:
#######


INCPATH += -I.

TARGET_INCPATH += -I$(TARGET_DEST_DIR)/usr/include
ROOTFS_INCPATH += -I$(ROOTFS_DEST_DIR)/usr/include


OPTIMIZATION_FLAGS ?= -O2


ifeq ($(TOOLCHAIN),$(I686_EGLIBC_TOOLCHAIN_NAME))
ARCH_FLAGS ?= -m32 -march=i486 -mtune=i686
endif


ifeq ($(TOOLCHAIN),$(A1X_NEWLIB_TOOLCHAIN_NAME))
HW_FLAGS   += -D__ALLWINNER_1N__=1
endif

ifeq ($(TOOLCHAIN),$(A1X_EGLIBC_TOOLCHAIN_NAME))
ARCH_FLAGS ?= -march=armv7-a -mtune=cortex-a8 -mfloat-abi=softfp -mfpu=vfpv3 -mabi=aapcs-linux -fomit-frame-pointer
HW_FLAGS   += -D__ALLWINNER_1X__=1
endif

ifeq ($(TOOLCHAIN),$(AT91SAM7S_NEWLIB_TOOLCHAIN_NAME))
HW_FLAGS   += -D__AT91SAM7S__=1
endif

ifeq ($(TOOLCHAIN),$(DM644X_EGLIBC_TOOLCHAIN_NAME))
ARCH_FLAGS ?= -march=armv5te -mtune=arm926ej-s -mabi=aapcs-linux -fomit-frame-pointer
HW_FLAGS   += -D__DM644X__=1
endif

ifeq ($(TOOLCHAIN),$(DM644X_NEWLIB_TOOLCHAIN_NAME))
HW_FLAGS   += -D__TMS320DM644X__=1
endif

ifeq ($(TOOLCHAIN),$(LPC17XX_UCLIBC_TOOLCHAIN_NAME))
HW_FLAGS   += -D__LPC17XX__=1
endif

ifeq ($(TOOLCHAIN),$(OMAP35X_EGLIBC_TOOLCHAIN_NAME))
ARCH_FLAGS ?= -march=armv7-a -mtune=cortex-a8 -mfloat-abi=softfp -mfpu=neon -mabi=aapcs-linux -fomit-frame-pointer
HW_FLAGS   += -D__OMAP35X__=1
endif

ifeq ($(TOOLCHAIN),$(OMAP543X_EGLIBC_TOOLCHAIN_NAME))
ARCH_FLAGS ?= -march=armv7-a -mtune=cortex-a15 -mfloat-abi=softfp -mfpu=neon-vfpv4 -mabi=aapcs-linux -fomit-frame-pointer
HW_FLAGS   += -D__OMAP543X__=1
endif

ifeq ($(TOOLCHAIN),$(BCM74X_EGLIBC_TOOLCHAIN_NAME))
HW_FLAGS   += -D__BCM74X__=1
endif


# Target definition
ifneq ($(filter $(I686_EGLIBC_TOOLCHAIN_NAME),$(COMPONENT_TOOLCHAINS)),)
ifeq ($(HARDWARE),$(TARGET_PC32))
HW_FLAGS   += -D__TARGET__=$(TARGET_ID_PC32)
endif
endif

ifneq ($(filter $(X86_64_EGLIBC_TOOLCHAIN_NAME),$(COMPONENT_TOOLCHAINS)),)
ifeq ($(HARDWARE),$(TARGET_PC64))
HW_FLAGS   += -D__TARGET__=$(TARGET_ID_PC64)
endif
endif

ifneq ($(filter $(A1X_NEWLIB_TOOLCHAIN_NAME),$(COMPONENT_TOOLCHAINS)),)
ifeq ($(HARDWARE),$(TARGET_CB1N))
HW_FLAGS   += -D__TARGET__=$(TARGET_ID_CB1N)
endif
endif

ifneq ($(filter $(A1X_EGLIBC_TOOLCHAIN_NAME),$(COMPONENT_TOOLCHAINS)),)
ifeq ($(HARDWARE),$(TARGET_CB1X))
HW_FLAGS   += -D__TARGET__=$(TARGET_ID_CB1X)
endif
endif

ifneq ($(filter $(AT91SAM7S_NEWLIB_TOOLCHAIN_NAME),$(COMPONENT_TOOLCHAINS)),)
ifeq ($(HARDWARE),$(TARGET_GUARD))
HW_FLAGS   += -D__TARGET__=$(TARGET_ID_GUARD)
endif
endif

ifneq ($(filter $(DM644X_NEWLIB_TOOLCHAIN_NAME),$(COMPONENT_TOOLCHAINS)),)
ifeq ($(HARDWARE),$(TARGET_VIP1830N))
HW_FLAGS   += -D__TARGET__=$(TARGET_ID_VIP1830N)
endif
endif

ifneq ($(filter $(DM644X_EGLIBC_TOOLCHAIN_NAME),$(COMPONENT_TOOLCHAINS)),)
ifeq ($(HARDWARE),$(TARGET_VIP1830))
HW_FLAGS   += -D__TARGET__=$(TARGET_ID_VIP1830)
endif
endif

ifneq ($(filter $(LPC17XX_UCLIBC_TOOLCHAIN_NAME),$(COMPONENT_TOOLCHAINS)),)
ifeq ($(HARDWARE),$(TARGET_L17UC))
HW_FLAGS   += -D__TARGET__=$(TARGET_ID_L17UC)
endif
endif

ifneq ($(filter $(OMAP35X_EGLIBC_TOOLCHAIN_NAME),$(COMPONENT_TOOLCHAINS)),)
ifeq ($(HARDWARE),$(TARGET_BEAGLE))
HW_FLAGS   += -D__TARGET__=$(TARGET_ID_BEAGLE)
endif
endif

ifneq ($(filter $(OMAP543X_EGLIBC_TOOLCHAIN_NAME),$(COMPONENT_TOOLCHAINS)),)
ifeq ($(HARDWARE),$(TARGET_OMAP5UEVM))
HW_FLAGS   += -D__TARGET__=$(TARGET_ID_OMAP5UEVM)
endif
ifeq ($(HARDWARE),$(TARGET_DRA7XXEVM))
HW_FLAGS   += -D__TARGET__=$(TARGET_ID_DRA7XXEVM)
endif
endif

ifneq ($(filter $(BCM74X_EGLIBC_TOOLCHAIN_NAME),$(COMPONENT_TOOLCHAINS)),)
ifeq ($(HARDWARE),$(TARGET_B74))
HW_FLAGS   += -D__TARGET__=$(TARGET_ID_B74)
endif
endif


# All targets
ifneq ($(filter $(I686_EGLIBC_TOOLCHAIN_NAME),$(COMPONENT_TOOLCHAINS)),)
HW_FLAGS   += -DPC32=$(TARGET_ID_PC32)
endif

ifneq ($(filter $(X86_64_EGLIBC_TOOLCHAIN_NAME),$(COMPONENT_TOOLCHAINS)),)
HW_FLAGS   += -DPC64=$(TARGET_ID_PC64)
endif

ifneq ($(filter $(A1X_NEWLIB_TOOLCHAIN_NAME),$(COMPONENT_TOOLCHAINS)),)
HW_FLAGS   += -DCB1N=$(TARGET_ID_CB1N)
endif

ifneq ($(filter $(A1X_EGLIBC_TOOLCHAIN_NAME),$(COMPONENT_TOOLCHAINS)),)
HW_FLAGS   += -DCB1X=$(TARGET_ID_CB1X)
endif

ifneq ($(filter $(AT91SAM7S_NEWLIB_TOOLCHAIN_NAME),$(COMPONENT_TOOLCHAINS)),)
HW_FLAGS   += -DGUARD=$(TARGET_ID_GUARD)
endif

ifneq ($(filter $(DM644X_NEWLIB_TOOLCHAIN_NAME),$(COMPONENT_TOOLCHAINS)),)
HW_FLAGS   += -DVIP1830N=$(TARGET_ID_VIP1830N)
endif

ifneq ($(filter $(DM644X_EGLIBC_TOOLCHAIN_NAME),$(COMPONENT_TOOLCHAINS)),)
HW_FLAGS   += -DVIP1830=$(TARGET_ID_VIP1830)
endif

ifneq ($(filter $(LPC17XX_UCLIBC_TOOLCHAIN_NAME),$(COMPONENT_TOOLCHAINS)),)
HW_FLAGS   += -DL17UC=$(TARGET_ID_L17UC)
endif

ifneq ($(filter $(OMAP35X_EGLIBC_TOOLCHAIN_NAME),$(COMPONENT_TOOLCHAINS)),)
HW_FLAGS   += -DBEAGLE=$(TARGET_ID_BEAGLE)
endif

ifneq ($(filter $(OMAP543X_EGLIBC_TOOLCHAIN_NAME),$(COMPONENT_TOOLCHAINS)),)
HW_FLAGS   += -DOMAP5UEVM=$(TARGET_ID_OMAP5UEVM)
HW_FLAGS   += -DDRA7XXEVM=$(TARGET_ID_DRA7XXEVM)
endif

ifneq ($(filter $(BCM74X_EGLIBC_TOOLCHAIN_NAME),$(COMPONENT_TOOLCHAINS)),)
HW_FLAGS   += -DB74=$(TARGET_ID_B74)
endif


#######
####### Toolchain include path:
#######

TOOLCHAIN_INCPATH += -I$(TOOLCHAIN_PATH)/$(TARGET)/sys-root/usr/include


#######
####### Library include path:
#######

#
# Default LIBSUFFIX
#

#
# NOTE: LIBSUFFIX=64 is valid for Slackware64 distro where native libraries are placed in /usr/lib64 directory
#       for example ubuntu has /usr/lib for x86_64 libraries and /usr/lib32 for x86_32 libraries as well as
#       our X86_64-eglibc toolchain.
# TODO: Create the canonical-distro script such as $(BULDSYSTEM)/canonical-build we have.
#
ifeq ($(TOOLCHAIN),$(BUILD_TOOLCHAIN_NAME))
LIBSUFFIX ?= 64
endif

ifeq ($(TOOLCHAIN),$(X86_64_EGLIBC_TOOLCHAIN_NAME))
MULTILIB_X86_32_SUFFIX ?= 32
endif

#
# BUILD_CC lib SUFFIX
#
BUILD_MULTILIB_X86_32_SUFFIX = $(shell echo $(shell gcc -m32 -print-multi-os-directory) | sed -e 's/\(^.*lib\)\([0-9]*\)/\2/')
BUILD_MULTILIB_SUFFIX = $(shell echo $(shell gcc -print-multi-os-directory) | sed -e 's/\(^.*lib\)\([0-9]*\)/\2/')


####################################################### temp
#LIBPATH += -L$(TOOLCHAIN_PATH)/lib/gcc/$(TARGET)/4.5.1

#__lib_dir = $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)

#LIBPATH += -L$(TOOLCHAIN_PATH)/$(TARGET)/lib$(LIBSUFFIX)
#LIBPATH += -L$(TOOLCHAIN_PATH)/$(TARGET)/sys-root/lib$(LIBSUFFIX)
#LIBPATH += -L$(TOOLCHAIN_PATH)/$(TARGET)/sys-root/usr/lib$(LIBSUFFIX)

#LIBPATH += -L$(__lib_dir)

#RPATH += -Wl,-rpath-link,$(__lib_dir)

#LDFLAGS += $(LIBPATH)
#LDFLAGS += $(RPATH)
#LDFLAGS += -Wl,--no-add-needed
#LDFLAGS += -Wl,-O1

LDFLAGS += -L$(TARGET_DEST_DIR)/lib$(LIBSUFFIX) -L$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)



# Compilation flags
COMMON_FLAGS = $(INCPATH) $(TARGET_INCPATH) -g $(OPTIMIZATION_FLAGS) $(ARCH_FLAGS) $(HW_FLAGS)

CFLAGS    += $(COMMON_FLAGS)
CXXFLAGS  += $(COMMON_FLAGS)

#
# We cannot garrantee that HOST gcc supports --sysroot=DIR option
#

# Linkers
ifeq ($(TOOLCHAIN),$(BUILD_TOOLCHAIN_NAME))
CC_LINKER  = $(CC)
CXX_LINKER = $(CXX)
else
CC_LINKER  = $(CC) --sysroot=$(TARGET_DEST_DIR)
CXX_LINKER = $(CXX) --sysroot=$(TARGET_DEST_DIR)
endif

#######
####### Development environments
#######


BUILD_ENVIRONMENT  = PATH=$(PATH):$(TOOLCHAIN_PATH)/bin

ifeq ($(TOOLCHAIN),$(BUILD_TOOLCHAIN_NAME))
BUILD_ENVIRONMENT += CC="$(CC)" CXX="$(CXX)" LD="$(LD)"
else
BUILD_ENVIRONMENT += CC="$(CC) --sysroot=$(TARGET_DEST_DIR)"
BUILD_ENVIRONMENT += CXX="$(CXX) --sysroot=$(TARGET_DEST_DIR)"
BUILD_ENVIRONMENT += LD="$(LD) --sysroot=$(TARGET_DEST_DIR)"
endif

BUILD_ENVIRONMENT += AS="$(AS)" AR="$(AR)" RANLIB="$(RANLIB)" SIZE="$(SIZE)" STRIP="$(STRIP)" OBJCOPY="$(OBJCOPY)" NM="$(NM)"
BUILD_ENVIRONMENT += BUILD_CC="$(BUILD_CC)" BUILD_CXX="$(BUILD_CXX)" BUILD_AS="$(BUILD_AS)" BUILD_AR="$(BUILD_AR)" BUILD_LD="$(BUILD_LD)" BUILD_RANLIB="$(BUILD_RANLIB)" BUILD_SIZE="$(BUILD_SIZE)" BUILD_STRIP="$(BUILD_STRIP)" BUILD_OBJCOPY="$(BUILD_OBJCOPY)" BUILD_NM="$(BUILD_NM)"
BUILD_ENVIRONMENT += CFLAGS="$(CFLAGS)" CXXFLAGS="$(CXXFLAGS)" CPPFLAGS="$(CPPFLAGS)"
BUILD_ENVIRONMENT += LDFLAGS="$(LDFLAGS)"
#
#  PKG_CONFIG_PATH - directories to add to pkg-config's search path
#
BUILD_ENVIRONMENT += PKG_CONFIG_PATH="$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig:$(PKG_CONFIG_PATH)"



TARGETS_MK=1
endif

