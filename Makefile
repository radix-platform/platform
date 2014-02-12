
COMPONENT_TARGETS = $(TARGET_HOST)

# Always include build-system/core.mk using relative path:
include build-system/core.mk

#
# This Makefile created to allow targets which defined by build-system,
# for example, cleaning all thee directories which contain Makefiles
# for building any TOOLCHAINS components can be done by following
# command:
#
# $ make global_clean 
#
