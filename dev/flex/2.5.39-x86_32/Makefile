
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/d/flex

REQUIRES           = dev/flex/2.5.39

# ======= __END_OF_REQUIRES__ =======


version            = 2.5.39
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/d/flex/flex-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/flex-$(version)
src_dir_name       = flex-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = dev
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
FLEX_32_PKG_NAME                = flex-x32
FLEX_32_PKG_VERSION             = 2.5.39
FLEX_32_PKG_ARCH                = $(TOOLCHAIN)
FLEX_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
FLEX_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
FLEX_32_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
FLEX_32_PKG_SHORT_DESCRIPTION   = fast lexical analyzer generator
FLEX_32_PKG_URL                 = $(BUG_URL)
FLEX_32_PKG_LICENSE             = BSD
FLEX_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(FLEX_32_PKG_NAME)-pkg-description
FLEX_32_PKG_DESCRIPTION_FILE_IN = $(FLEX_32_PKG_NAME)-pkg-description.in
FLEX_32_PKG_INSTALL_SCRIPT      = $(FLEX_32_PKG_NAME)-pkg-install.sh

FLEX_32_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(FLEX_32_PKG_NAME)-package

pkg_basename     = $(FLEX_32_PKG_NAME)-$(FLEX_32_PKG_VERSION)-$(FLEX_32_PKG_ARCH)-$(FLEX_32_PKG_DISTRO_NAME)-$(FLEX_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(FLEX_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(FLEX_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@( cd $(FLEX_32_PKG)/usr/bin ; \
	   ln -sf flex lex ; \
	 )
	@mkdir -p $(FLEX_32_PKG)/usr/bin/32
	@( cd $(FLEX_32_PKG)/usr/bin ; \
	   find . -type f | xargs mv -t 32 ; \
	   find . -type l | xargs mv -t 32 ; \
	 )
	@rm -rf $(FLEX_32_PKG)/usr/include
	@rm -rf $(FLEX_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(FLEX_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libfl.la libfl_pic.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(FLEX_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libfl.la libfl_pic.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libfl.la libfl_pic.la \
	 )
	# ======= Strip binaries =======
	@( cd $(FLEX_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(FLEX_32_PKG_DESCRIPTION_FILE): $(FLEX_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(FLEX_32_PKG_DESCRIPTION_FILE) $(FLEX_32_PKG_INSTALL_SCRIPT)
	@cp $(FLEX_32_PKG_DESCRIPTION_FILE) $(FLEX_32_PKG)/.DESCRIPTION
	@cp $(FLEX_32_PKG_INSTALL_SCRIPT) $(FLEX_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(FLEX_32_PKG)/.REQUIRES
	@echo "pkgname=$(FLEX_32_PKG_NAME)"                            >  $(FLEX_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(FLEX_32_PKG_VERSION)"                          >> $(FLEX_32_PKG)/.PKGINFO ; \
	 echo "arch=$(FLEX_32_PKG_ARCH)"                               >> $(FLEX_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(FLEX_32_PKG_DISTRO_NAME)"                  >> $(FLEX_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(FLEX_32_PKG_DISTRO_VERSION)"                >> $(FLEX_32_PKG)/.PKGINFO ; \
	 echo "group=$(FLEX_32_PKG_GROUP)"                             >> $(FLEX_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(FLEX_32_PKG_SHORT_DESCRIPTION)\"" >> $(FLEX_32_PKG)/.PKGINFO ; \
	 echo "url=$(FLEX_32_PKG_URL)"                                 >> $(FLEX_32_PKG)/.PKGINFO ; \
	 echo "license=$(FLEX_32_PKG_LICENSE)"                         >> $(FLEX_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(FLEX_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
