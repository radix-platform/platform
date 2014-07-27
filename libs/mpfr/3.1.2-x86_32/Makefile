
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/GNU/mpfr

REQUIRES           = libs/mpfr/3.1.2
REQUIRES          += libs/gmp/5.1.3-x86_32


version            = 3.1.2
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/GNU/mpfr/mpfr-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/mpfr-$(version)
src_dir_name       = mpfr-$(version)
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
MPFR32_PKG_NAME                = mpfr-x32
MPFR32_PKG_VERSION             = 3.1.2
MPFR32_PKG_ARCH                = $(TOOLCHAIN)
MPFR32_PKG_DISTRO_NAME         = kxLab
MPFR32_PKG_DISTRO_VERSION      = 1.0
MPFR32_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
MPFR32_PKG_SHORT_DESCRIPTION   = mpfr-x32 $(version)
MPFR32_PKG_URL                 = $(BUG_URL)
MPFR32_PKG_LICENSE             = GPLv2
MPFR32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(MPFR32_PKG_NAME)-pkg-description
MPFR32_PKG_DESCRIPTION_FILE_IN = $(MPFR32_PKG_NAME)-pkg-description.in
MPFR32_PKG_INSTALL_SCRIPT      = $(MPFR32_PKG_NAME)-pkg-install.sh

MPFR32_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(MPFR32_PKG_NAME)-package

pkg_basename     = $(MPFR32_PKG_NAME)-$(MPFR32_PKG_VERSION)-$(MPFR32_PKG_ARCH)-$(MPFR32_PKG_DISTRO_NAME)-$(MPFR32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(MPFR32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --enable-static=yes
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
	@mkdir -p $(MPFR32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@rm -rf $(MPFR32_PKG)/usr/include
	@rm -rf $(MPFR32_PKG)/usr/share
	# remove toolchain path from target libtool *.la files and
	@( cd $(MPFR32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	  sed -i "s,$(TARGET_DEST_DIR),,g" libmpfr.la  \
	 )
	# Install the same to $(TARGET_DEST_DIR)
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(MPFR32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# tune libtool *.la search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libmpfr.la ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libmpfr.la \
	 )
	@(cd $(MPFR32_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(MPFR32_PKG_DESCRIPTION_FILE): $(MPFR32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(MPFR32_PKG_DESCRIPTION_FILE) $(MPFR32_PKG_INSTALL_SCRIPT)
	@cp $(MPFR32_PKG_DESCRIPTION_FILE) $(MPFR32_PKG)/.DESCRIPTION
	@cp $(MPFR32_PKG_INSTALL_SCRIPT) $(MPFR32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(MPFR32_PKG)/.REQUIRES
	@echo "pkgname=$(MPFR32_PKG_NAME)"                            >  $(MPFR32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(MPFR32_PKG_VERSION)"                          >> $(MPFR32_PKG)/.PKGINFO ; \
	 echo "arch=$(MPFR32_PKG_ARCH)"                               >> $(MPFR32_PKG)/.PKGINFO ; \
	 echo "distroname=$(MPFR32_PKG_DISTRO_NAME)"                  >> $(MPFR32_PKG)/.PKGINFO ; \
	 echo "distrover=$(MPFR32_PKG_DISTRO_VERSION)"                >> $(MPFR32_PKG)/.PKGINFO ; \
	 echo "group=$(MPFR32_PKG_GROUP)"                             >> $(MPFR32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(MPFR32_PKG_SHORT_DESCRIPTION)\"" >> $(MPFR32_PKG)/.PKGINFO ; \
	 echo "url=$(MPFR32_PKG_URL)"                                 >> $(MPFR32_PKG)/.PKGINFO ; \
	 echo "license=$(MPFR32_PKG_LICENSE)"                         >> $(MPFR32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(MPFR32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
