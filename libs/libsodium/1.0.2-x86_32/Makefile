
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/libsodium

REQUIRES           = libs/libsodium/1.0.2

# ======= __END_OF_REQUIRES__ =======


version            = 1.0.2
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/l/libsodium/libsodium-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libsodium-$(version)
src_dir_name       = libsodium-$(version)
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
LIBSODIUM_32_PKG_NAME                = libsodium-x32
LIBSODIUM_32_PKG_VERSION             = 1.0.2
LIBSODIUM_32_PKG_ARCH                = $(TOOLCHAIN)
LIBSODIUM_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBSODIUM_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBSODIUM_32_PKG_GROUP               = $(PKG_GROUP)
###                                   |---handy-ruler-------------------------------|
LIBSODIUM_32_PKG_SHORT_DESCRIPTION   = easy-to-use crypto library
LIBSODIUM_32_PKG_URL                 = $(BUG_URL)
LIBSODIUM_32_PKG_LICENSE             = custom
LIBSODIUM_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBSODIUM_32_PKG_NAME)-pkg-description
LIBSODIUM_32_PKG_DESCRIPTION_FILE_IN = $(LIBSODIUM_32_PKG_NAME)-pkg-description.in
LIBSODIUM_32_PKG_INSTALL_SCRIPT      = $(LIBSODIUM_32_PKG_NAME)-pkg-install.sh

LIBSODIUM_32_PKG = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBSODIUM_32_PKG_NAME)-package

pkg_basename     = $(LIBSODIUM_32_PKG_NAME)-$(LIBSODIUM_32_PKG_VERSION)-$(LIBSODIUM_32_PKG_ARCH)-$(LIBSODIUM_32_PKG_DISTRO_NAME)-$(LIBSODIUM_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(LIBSODIUM_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


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
	@mkdir -p $(LIBSODIUM_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(LIBSODIUM_32_PKG)/usr/include
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBSODIUM_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libsodium.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBSODIUM_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libsodium.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libsodium.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libsodium.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBSODIUM_32_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBSODIUM_32_PKG_DESCRIPTION_FILE): $(LIBSODIUM_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBSODIUM_32_PKG_DESCRIPTION_FILE) $(LIBSODIUM_32_PKG_INSTALL_SCRIPT)
	@cp $(LIBSODIUM_32_PKG_DESCRIPTION_FILE) $(LIBSODIUM_32_PKG)/.DESCRIPTION
	@cp $(LIBSODIUM_32_PKG_INSTALL_SCRIPT) $(LIBSODIUM_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBSODIUM_32_PKG)/.REQUIRES
	@echo "pkgname=$(LIBSODIUM_32_PKG_NAME)"                            >  $(LIBSODIUM_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBSODIUM_32_PKG_VERSION)"                          >> $(LIBSODIUM_32_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBSODIUM_32_PKG_ARCH)"                               >> $(LIBSODIUM_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBSODIUM_32_PKG_DISTRO_NAME)"                  >> $(LIBSODIUM_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBSODIUM_32_PKG_DISTRO_VERSION)"                >> $(LIBSODIUM_32_PKG)/.PKGINFO ; \
	 echo "group=$(LIBSODIUM_32_PKG_GROUP)"                             >> $(LIBSODIUM_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBSODIUM_32_PKG_SHORT_DESCRIPTION)\"" >> $(LIBSODIUM_32_PKG)/.PKGINFO ; \
	 echo "url=$(LIBSODIUM_32_PKG_URL)"                                 >> $(LIBSODIUM_32_PKG)/.PKGINFO ; \
	 echo "license=$(LIBSODIUM_32_PKG_LICENSE)"                         >> $(LIBSODIUM_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LIBSODIUM_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
