
COMPONENT_TARGETS = $(TARGET_HOST)


REQUIRES  = build-system/3pp/fakeroot/0.18
REQUIRES += build-system/progs


config_makefile = build-config.mk

BUILD_TARGETS = $(config_makefile)

CLEANUP_FILES  = $(config_makefile)
CLEANUP_FILES += $(CURDIR)/sbin


# CORE Makefile:

include core.mk


$(config_makefile): $(config_makefile).template
	@echo "Creating $(config_makefile) ..."
	@cp $(config_makefile).template $@

