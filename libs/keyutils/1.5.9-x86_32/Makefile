
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/keyutils

REQUIRES           = libs/keyutils/1.5.9

# ======= __END_OF_REQUIRES__ =======


version            = 1.5.9
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/l/keyutils/keyutils-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/keyutils-$(version)
src_dir_name       = keyutils-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
KEYUTILS_32_PKG_NAME                = keyutils-x32
KEYUTILS_32_PKG_VERSION             = 1.5.9
KEYUTILS_32_PKG_ARCH                = $(TOOLCHAIN)
KEYUTILS_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
KEYUTILS_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
KEYUTILS_32_PKG_GROUP               = $(PKG_GROUP)
###                                  |---handy-ruler-------------------------------|
KEYUTILS_32_PKG_SHORT_DESCRIPTION   = Kernel key management utilities
KEYUTILS_32_PKG_URL                 = $(BUG_URL)
KEYUTILS_32_PKG_LICENSE             = LGPLv2
KEYUTILS_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(KEYUTILS_32_PKG_NAME)-pkg-description
KEYUTILS_32_PKG_DESCRIPTION_FILE_IN = $(KEYUTILS_32_PKG_NAME)-pkg-description.in
KEYUTILS_32_PKG_INSTALL_SCRIPT      = $(KEYUTILS_32_PKG_NAME)-pkg-install.sh

KEYUTILS_32_PKG  = $(CURDIR)/$(TARGET_BUILD_DIR)/$(KEYUTILS_32_PKG_NAME)-package

pkg_basename     = $(KEYUTILS_32_PKG_NAME)-$(KEYUTILS_32_PKG_VERSION)-$(KEYUTILS_32_PKG_ARCH)-$(KEYUTILS_32_PKG_DISTRO_NAME)-$(KEYUTILS_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_certificate  = $(call cert-name,$(pkg_archive))
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(KEYUTILS_32_PKG)
env_build    = SBINDIR='/sbin' BINDIR='/bin' \
               LIBDIR='/lib$(MULTILIB_X86_32_SUFFIX)' \
               USRLIBDIR='/usr/lib$(MULTILIB_X86_32_SUFFIX)'


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(env_build) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(KEYUTILS_32_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_build) $(env_sysroot)
	@( cd $(KEYUTILS_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   rm -f lib*.so ; \
	   ln -sf ../../lib$(MULTILIB_X86_32_SUFFIX)/lib*.so.?.? . ; \
	   ln -sf lib*.so.?.? libkeyutils.so.1 ; \
	   ln -sf lib*.so.? libkeyutils.so     ; \
	 )
	@rm -rf $(KEYUTILS_32_PKG)/bin
	@rm -rf $(KEYUTILS_32_PKG)/etc
	@rm -rf $(KEYUTILS_32_PKG)/sbin
	@rm -rf $(KEYUTILS_32_PKG)/usr/include
	@rm -rf $(KEYUTILS_32_PKG)/usr/share
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(KEYUTILS_32_PKG))
	# ======= Strip binaries =======
	@( cd $(KEYUTILS_32_PKG) ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(KEYUTILS_32_PKG_DESCRIPTION_FILE): $(KEYUTILS_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(KEYUTILS_32_PKG_DESCRIPTION_FILE) $(KEYUTILS_32_PKG_INSTALL_SCRIPT)
	@cp $(KEYUTILS_32_PKG_DESCRIPTION_FILE) $(KEYUTILS_32_PKG)/.DESCRIPTION
	@cp $(KEYUTILS_32_PKG_INSTALL_SCRIPT) $(KEYUTILS_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(KEYUTILS_32_PKG)/.REQUIRES
	@echo "pkgname=$(KEYUTILS_32_PKG_NAME)"                            >  $(KEYUTILS_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(KEYUTILS_32_PKG_VERSION)"                          >> $(KEYUTILS_32_PKG)/.PKGINFO ; \
	 echo "arch=$(KEYUTILS_32_PKG_ARCH)"                               >> $(KEYUTILS_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(KEYUTILS_32_PKG_DISTRO_NAME)"                  >> $(KEYUTILS_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(KEYUTILS_32_PKG_DISTRO_VERSION)"                >> $(KEYUTILS_32_PKG)/.PKGINFO ; \
	 echo "group=$(KEYUTILS_32_PKG_GROUP)"                             >> $(KEYUTILS_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(KEYUTILS_32_PKG_SHORT_DESCRIPTION)\"" >> $(KEYUTILS_32_PKG)/.PKGINFO ; \
	 echo "url=$(KEYUTILS_32_PKG_URL)"                                 >> $(KEYUTILS_32_PKG)/.PKGINFO ; \
	 echo "license=$(KEYUTILS_32_PKG_LICENSE)"                         >> $(KEYUTILS_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(KEYUTILS_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
