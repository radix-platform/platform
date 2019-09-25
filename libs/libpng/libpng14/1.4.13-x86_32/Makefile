
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/libpng/libpng14

REQUIRES           = libs/libpng/libpng14/1.4.13

# ======= __END_OF_REQUIRES__ =======


version            = 1.4.13
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/libpng/libpng14/libpng-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libpng-$(version)
src_dir_name       = libpng-$(version)
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
LIBPNG_32_PKG_NAME                = libpng14-x32
LIBPNG_32_PKG_VERSION             = 1.4.13
LIBPNG_32_PKG_ARCH                = $(TOOLCHAIN)
LIBPNG_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBPNG_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBPNG_32_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
LIBPNG_32_PKG_SHORT_DESCRIPTION   = Portable Network Graphics library
LIBPNG_32_PKG_URL                 = $(BUG_URL)
LIBPNG_32_PKG_LICENSE             = custom:libpng
LIBPNG_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBPNG_32_PKG_NAME)-pkg-description
LIBPNG_32_PKG_DESCRIPTION_FILE_IN = $(LIBPNG_32_PKG_NAME)-pkg-description.in
LIBPNG_32_PKG_INSTALL_SCRIPT      = $(LIBPNG_32_PKG_NAME)-pkg-install.sh

LIBPNG_32_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBPNG_32_PKG_NAME)-package

pkg_basename     = $(LIBPNG_32_PKG_NAME)-$(LIBPNG_32_PKG_VERSION)-$(LIBPNG_32_PKG_ARCH)-$(LIBPNG_32_PKG_DISTRO_NAME)-$(LIBPNG_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_certificate  = $(call cert-name,$(pkg_archive))
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../build-system/core.mk


env_sysroot  = DESTDIR=$(LIBPNG_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --bindir=/usr/bin/32


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
	@mkdir -p $(LIBPNG_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(LIBPNG_32_PKG)/usr/include
	@rm -rf $(LIBPNG_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBPNG_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libpng14.la  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBPNG_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libpng14.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libpng14.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libpng14.pc \
	 )
	# ====== tune libpng14-config script for development ======
	@( cd $(TARGET_DEST_DIR)/usr/bin/32 ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libpng14-config \
	 )
	# ====== Strip binaries ======
	@( cd $(LIBPNG_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBPNG_32_PKG_DESCRIPTION_FILE): $(LIBPNG_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBPNG_32_PKG_DESCRIPTION_FILE) $(LIBPNG_32_PKG_INSTALL_SCRIPT)
	@cp $(LIBPNG_32_PKG_DESCRIPTION_FILE) $(LIBPNG_32_PKG)/.DESCRIPTION
	@cp $(LIBPNG_32_PKG_INSTALL_SCRIPT) $(LIBPNG_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBPNG_32_PKG)/.REQUIRES
	@echo "pkgname=$(LIBPNG_32_PKG_NAME)"                            >  $(LIBPNG_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBPNG_32_PKG_VERSION)"                          >> $(LIBPNG_32_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBPNG_32_PKG_ARCH)"                               >> $(LIBPNG_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBPNG_32_PKG_DISTRO_NAME)"                  >> $(LIBPNG_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBPNG_32_PKG_DISTRO_VERSION)"                >> $(LIBPNG_32_PKG)/.PKGINFO ; \
	 echo "group=$(LIBPNG_32_PKG_GROUP)"                             >> $(LIBPNG_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBPNG_32_PKG_SHORT_DESCRIPTION)\"" >> $(LIBPNG_32_PKG)/.PKGINFO ; \
	 echo "url=$(LIBPNG_32_PKG_URL)"                                 >> $(LIBPNG_32_PKG)/.PKGINFO ; \
	 echo "license=$(LIBPNG_32_PKG_LICENSE)"                         >> $(LIBPNG_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LIBPNG_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
