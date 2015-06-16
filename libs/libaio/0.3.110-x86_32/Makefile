
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/libaio

REQUIRES           = libs/libaio/0.3.110
REQUIRES          += libs/glibc/2.21-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 0.3.110
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/l/libaio/libaio-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libaio-$(version)
src_dir_name       = libaio-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LIBAIO_32_PKG_NAME                = libaio-x32
LIBAIO_32_PKG_VERSION             = 0.3.110
LIBAIO_32_PKG_ARCH                = $(TOOLCHAIN)
LIBAIO_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBAIO_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBAIO_32_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
LIBAIO_32_PKG_SHORT_DESCRIPTION   = asynchronous I/O library
LIBAIO_32_PKG_URL                 = $(BUG_URL)
LIBAIO_32_PKG_LICENSE             = LGPLv2
LIBAIO_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBAIO_32_PKG_NAME)-pkg-description
LIBAIO_32_PKG_DESCRIPTION_FILE_IN = $(LIBAIO_32_PKG_NAME)-pkg-description.in
LIBAIO_32_PKG_INSTALL_SCRIPT      = $(LIBAIO_32_PKG_NAME)-pkg-install.sh

LIBAIO_32_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBAIO_32_PKG_NAME)-package

pkg_basename     = $(LIBAIO_32_PKG_NAME)-$(LIBAIO_32_PKG_VERSION)-$(LIBAIO_32_PKG_ARCH)-$(LIBAIO_32_PKG_DISTRO_NAME)-$(LIBAIO_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = prefix=$(LIBAIO_32_PKG)/usr libdir=$(LIBAIO_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LIBAIO_32_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) $(env_sysroot) install
	@rm -rf $(LIBAIO_32_PKG)/usr/include
	@mkdir -p $(LIBAIO_32_PKG)/lib$(MULTILIB_X86_32_SUFFIX)
	@( cd $(LIBAIO_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in lib*.so.?.* ; do \
	     mv $$file ../../lib$(MULTILIB_X86_32_SUFFIX) ; \
	     ln -sf ../../lib$(MULTILIB_X86_32_SUFFIX)/$$file . ; \
	   done ; \
	   cp -a lib*.so.? ../../lib$(MULTILIB_X86_32_SUFFIX) ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBAIO_32_PKG))
	# ======= Strip binaries =======
	@( cd $(LIBAIO_32_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBAIO_32_PKG_DESCRIPTION_FILE): $(LIBAIO_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBAIO_32_PKG_DESCRIPTION_FILE) $(LIBAIO_32_PKG_INSTALL_SCRIPT)
	@cp $(LIBAIO_32_PKG_DESCRIPTION_FILE) $(LIBAIO_32_PKG)/.DESCRIPTION
	@cp $(LIBAIO_32_PKG_INSTALL_SCRIPT) $(LIBAIO_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBAIO_32_PKG)/.REQUIRES
	@echo "pkgname=$(LIBAIO_32_PKG_NAME)"                            >  $(LIBAIO_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBAIO_32_PKG_VERSION)"                          >> $(LIBAIO_32_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBAIO_32_PKG_ARCH)"                               >> $(LIBAIO_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBAIO_32_PKG_DISTRO_NAME)"                  >> $(LIBAIO_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBAIO_32_PKG_DISTRO_VERSION)"                >> $(LIBAIO_32_PKG)/.PKGINFO ; \
	 echo "group=$(LIBAIO_32_PKG_GROUP)"                             >> $(LIBAIO_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBAIO_32_PKG_SHORT_DESCRIPTION)\"" >> $(LIBAIO_32_PKG)/.PKGINFO ; \
	 echo "url=$(LIBAIO_32_PKG_URL)"                                 >> $(LIBAIO_32_PKG)/.PKGINFO ; \
	 echo "license=$(LIBAIO_32_PKG_LICENSE)"                         >> $(LIBAIO_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBAIO_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
