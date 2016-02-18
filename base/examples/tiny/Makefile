
COMPONENT_TARGETS  = $(HARDWARE_BUILD)
COMPONENT_TARGETS += $(HARDWARE_CB1N)
COMPONENT_TARGETS += $(HARDWARE_CB3N)
COMPONENT_TARGETS += $(HARDWARE_AT91S)
COMPONENT_TARGETS += $(HARDWARE_DM64N)
COMPONENT_TARGETS += $(HARDWARE_L17UC)

#
# following targets are depended on EGLIBC:
#
# COMPONENT_TARGETS += $(HARDWARE_PC32)
# COMPONENT_TARGETS += $(HARDWARE_PC64)
# COMPONENT_TARGETS += $(HARDWARE_CB1X)
# COMPONENT_TARGETS += $(HARDWARE_DM64X)
# COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
# COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
# COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
# COMPONENT_TARGETS += $(HARDWARE_B74)


include ../../../build-system/constants.mk


# ======= __END_OF_REQUIRES__ =======


CB1N_FLAVOURS = aaa
BUILD_FLAVOURS = hello-32compat


bin_srcs = main.c

SRCS = $(bin_srcs)

bin_objs = $(addprefix $(TARGET_BUILD_DIR)/,$(bin_srcs:.c=.o))
bin_target = $(TARGET_BUILD_DIR)/main

ifeq ($(FLAVOUR),hello-32compat)
ARCH_FLAGS := -m32 -march=i486 -mtune=i686
CFLAGS  += -DFLAVOUR=32
LDFLAGS += $(ARCH_FLAGS)
endif

BUILD_TARGETS = $(bin_target)

CLEANUP_FILES += $(FLAVOUR).ttt

include ../../../build-system/core.mk

$(bin_target): $(bin_objs)
	$(LINK)
	@echo "__available_targets=$(__available_targets)"
	@echo "CFLAGS=$(CFLAGS)"

##
# Directly use $(CC) and $(LINKER):
# ==================================
#
#	$(CC) $(CFLAGS) -c -o $(TARGET_BUILD_DIR)/main.o main.c
#	$(LINKER) $(LDFLAGS) -o $(TARGET_BUILD_DIR)/main $(TARGET_BUILD_DIR)/main.o
#	@echo TARGET=$(TARGET)
#	@echo HOST=$(HOST)
#	@touch $@
