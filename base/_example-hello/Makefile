
COMPONENT_TARGETS  = $(TARGET_HOST)
COMPONENT_TARGETS += $(TARGET_PC32)
COMPONENT_TARGETS += $(TARGET_PC64)
# COMPONENT_TARGETS += $(TARGET_CB1N)
COMPONENT_TARGETS += $(TARGET_CB1X)
# COMPONENT_TARGETS += $(TARGET_GUARD)
# COMPONENT_TARGETS += $(TARGET_VIP1830N)
# COMPONENT_TARGETS += $(TARGET_VIP1830)
# COMPONENT_TARGETS += $(TARGET_L17UC)
# COMPONENT_TARGETS += $(TARGET_BEAGLE)
COMPONENT_TARGETS += $(TARGET_OMAP5UEVM)
# COMPONENT_TARGETS += $(TARGET_B74)


PC64_FLAVOURS = hello hello-32compat

include ../../build-system/constants.mk

bin_srcs = main.c

SRCS = $(bin_srcs)

bin_objs = $(addprefix $(TARGET_BUILD_DIR)/,$(bin_srcs:.c=.o))
bin_target = $(TARGET_BUILD_DIR)/main

ifeq ($(FLAVOUR),hello-32compat)
ARCH_FLAGS := -m32 -march=i486 -mtune=i686
LDFLAGS += $(ARCH_FLAGS)
endif

BUILD_TARGETS = $(bin_target)

CLEANUP_FILES += $(FLAVOUR).ttt

include ../../build-system/core.mk

$(bin_target): $(bin_objs)
	$(LINK)
#
# Directly use $(CC) and $(LINKER):
# ==================================
#
#	$(CC) $(CFLAGS) -c -o $(TARGET_BUILD_DIR)/main.o main.c
#	$(LINKER) $(LDFLAGS) -o $(TARGET_BUILD_DIR)/main $(TARGET_BUILD_DIR)/main.o
#	@echo TARGET=$(TARGET)
#	@echo HOST=$(HOST)
#	@touch $@
