
COMPONENT_TARGETS  = $(HARDWARE_MBC4_PC)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_SPARC32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/libelf

REQUIRES           = libs/libelf/0.8.13
REQUIRES          += libs/glibc/2.28-sparc32

# ======= __END_OF_REQUIRES__ =======


version            = 0.8.13
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/libelf/libelf-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libelf-$(version)
src_dir_name       = libelf-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LIBELF32_PKG_NAME                = libelf-x32
LIBELF32_PKG_VERSION             = 0.8.13
LIBELF32_PKG_ARCH                = $(TOOLCHAIN)
LIBELF32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBELF32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBELF32_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
LIBELF32_PKG_SHORT_DESCRIPTION   = ELF object file access library
LIBELF32_PKG_URL                 = $(BUG_URL)
LIBELF32_PKG_LICENSE             = GPLv2
LIBELF32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBELF32_PKG_NAME)-pkg-description
LIBELF32_PKG_DESCRIPTION_FILE_IN = $(LIBELF32_PKG_NAME)-pkg-description.in
LIBELF32_PKG_INSTALL_SCRIPT      = $(LIBELF32_PKG_NAME)-pkg-install.sh

LIBELF32_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBELF32_PKG_NAME)-package

pkg_basename     = $(LIBELF32_PKG_NAME)-$(LIBELF32_PKG_VERSION)-$(LIBELF32_PKG_ARCH)-$(LIBELF32_PKG_DISTRO_NAME)-$(LIBELF32_PKG_DISTRO_VERSION)

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


env_sysroot  = instroot=$(LIBELF32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_SPARC32_SUFFIX)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --disable-compat
ifeq ($(__ENABLE_STATIC__),yes)
extra_configure_switches += --enable-static=yes
else
extra_configure_switches += --enable-static=no
endif
extra_configure_switches += --enable-shared=yes


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
	@mkdir -p $(LIBELF32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
ifneq ($(__ENABLE_STATIC__),yes)
	@rm -f $(LIBELF32_PKG)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/*.a
endif
	@rm -rf $(LIBELF32_PKG)/usr/include
	@rm -rf $(LIBELF32_PKG)/usr/share
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBELF32_PKG))
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libelf.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBELF32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifeq ($(__ENABLE_STATIC__),yes)
	@( cd $(LIBELF32_PKG) ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null ; \
	 )
endif
	@touch $@

$(LIBELF32_PKG_DESCRIPTION_FILE): $(LIBELF32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBELF32_PKG_DESCRIPTION_FILE) $(LIBELF32_PKG_INSTALL_SCRIPT)
	@cp $(LIBELF32_PKG_DESCRIPTION_FILE) $(LIBELF32_PKG)/.DESCRIPTION
	@cp $(LIBELF32_PKG_INSTALL_SCRIPT) $(LIBELF32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBELF32_PKG)/.REQUIRES
	@echo "pkgname=$(LIBELF32_PKG_NAME)"                            >  $(LIBELF32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBELF32_PKG_VERSION)"                          >> $(LIBELF32_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBELF32_PKG_ARCH)"                               >> $(LIBELF32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBELF32_PKG_DISTRO_NAME)"                  >> $(LIBELF32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBELF32_PKG_DISTRO_VERSION)"                >> $(LIBELF32_PKG)/.PKGINFO ; \
	 echo "group=$(LIBELF32_PKG_GROUP)"                             >> $(LIBELF32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBELF32_PKG_SHORT_DESCRIPTION)\"" >> $(LIBELF32_PKG)/.PKGINFO ; \
	 echo "url=$(LIBELF32_PKG_URL)"                                 >> $(LIBELF32_PKG)/.PKGINFO ; \
	 echo "license=$(LIBELF32_PKG_LICENSE)"                         >> $(LIBELF32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LIBELF32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
