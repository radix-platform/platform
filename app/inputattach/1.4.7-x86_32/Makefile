
COMPONENT_TARGETS += $(TARGET_HOST)
COMPONENT_TARGETS += $(TARGET_PC64)

NEED_ABS_PATH      = true

COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES         = $(SRC_PACKAGE_DIR)/packages/a/linuxconsole

REQUIRES                = libs/eglibc/2.18.1


version                 = 1.4.7
tar_bz2_archive         = $(SRC_PACKAGE_PATH)/packages/a/linuxconsole/linuxconsoletools-$(version).tar.bz2
SRC_ARCHIVE             = $(tar_bz2_archive)
SRC_DIR                 = $(TARGET_BUILD_DIR)/linuxconsoletools-$(version)
src_done                = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target            = $(TARGET_BUILD_DIR)/.build_done
install_target          = $(TARGET_BUILD_DIR)/.install_done
build_inputattach32_pkg = $(TARGET_BUILD_DIR)/.inputattach32_pkg_done


####### Targets

PKG_GROUP = app
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
INPUTATTACH32_PKG_NAME                = inputattach32
INPUTATTACH32_PKG_VERSION             = 1.4.7
ifeq ($(HARDWARE),$(TARGET_HOST))
INPUTATTACH32_PKG_ARCH                = $(shell uname -m)
else
INPUTATTACH32_PKG_ARCH                = $(TOOLCHAIN)
endif
INPUTATTACH32_PKG_DISTRO_NAME         = kxLab
INPUTATTACH32_PKG_DISTRO_VERSION      = 1.0
INPUTATTACH32_PKG_GROUP               = $(PKG_GROUP)
###                                    |---handy-ruler-------------------------------|
INPUTATTACH32_PKG_SHORT_DESCRIPTION   = inputattach32 $(version)
INPUTATTACH32_PKG_URL                 = http://www.kxLab.com
INPUTATTACH32_PKG_LICENSE             = GPLv2
INPUTATTACH32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(INPUTATTACH32_PKG_NAME)-pkg-description
INPUTATTACH32_PKG_DESCRIPTION_FILE_IN = $(INPUTATTACH32_PKG_NAME)-pkg-description.in
INPUTATTACH32_PKG_INSTALL_SCRIPT      = $(INPUTATTACH32_PKG_NAME)-pkg-install.sh

INPUTATTACH32_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(INPUTATTACH32_PKG_NAME)-package

pkg_basename     = $(INPUTATTACH32_PKG_NAME)-$(INPUTATTACH32_PKG_VERSION)-$(INPUTATTACH32_PKG_ARCH)-$(INPUTATTACH32_PKG_DISTRO_NAME)-$(INPUTATTACH32_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(INPUTATTACH32_PKG_GROUP)/$(pkg_basename).tgz


BUILD_TARGETS    = $(build_inputattach32_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../build-system/core.mk


OPTIMIZATION_FLAGS = -O3

ARCH_FLAGS         = -m32 -g -O3 -march=i486 -mtune=i686

ifeq ($(TOOLCHAIN),$(X86_64_EGLIBC_TOOLCHAIN_NAME))
LIBSUFFIX          = 32
else
LIBSUFFIX          =
endif


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR)/utils && $(BUILD_ENVIRONMENT) $(CC) inputattach.c -o inputattach
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(INPUTATTACH32_PKG)/usr/bin/32
	@cd $(SRC_DIR)/utils && cp -a inputattach $(INPUTATTACH32_PKG)/usr/bin/32
	@chmod 755 $(INPUTATTACH32_PKG)/usr/bin/32/*
	# Install the same to $(TARGET_DEST_DIR)
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(INPUTATTACH32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	@(cd $(INPUTATTACH32_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null \
	 )
	@touch $@

$(INPUTATTACH32_PKG_DESCRIPTION_FILE): $(INPUTATTACH32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(build_inputattach32_pkg): $(install_target) $(INPUTATTACH32_PKG_DESCRIPTION_FILE)
	@cp $(INPUTATTACH32_PKG_DESCRIPTION_FILE) $(INPUTATTACH32_PKG)/.DESCRIPTION
	@cp $(INPUTATTACH32_PKG_INSTALL_SCRIPT) $(INPUTATTACH32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(INPUTATTACH32_PKG)/.REQUIRES
	@echo "pkgname=$(INPUTATTACH32_PKG_NAME)"                            >  $(INPUTATTACH32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(INPUTATTACH32_PKG_VERSION)"                          >> $(INPUTATTACH32_PKG)/.PKGINFO ; \
	 echo "arch=$(INPUTATTACH32_PKG_ARCH)"                               >> $(INPUTATTACH32_PKG)/.PKGINFO ; \
	 echo "distroname=$(INPUTATTACH32_PKG_DISTRO_NAME)"                  >> $(INPUTATTACH32_PKG)/.PKGINFO ; \
	 echo "distrover=$(INPUTATTACH32_PKG_DISTRO_VERSION)"                >> $(INPUTATTACH32_PKG)/.PKGINFO ; \
	 echo "group=$(INPUTATTACH32_PKG_GROUP)"                             >> $(INPUTATTACH32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(INPUTATTACH32_PKG_SHORT_DESCRIPTION)\"" >> $(INPUTATTACH32_PKG)/.PKGINFO ; \
	 echo "url=$(INPUTATTACH32_PKG_URL)"                                 >> $(INPUTATTACH32_PKG)/.PKGINFO ; \
	 echo "license=$(INPUTATTACH32_PKG_LICENSE)"                         >> $(INPUTATTACH32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(INPUTATTACH32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@
