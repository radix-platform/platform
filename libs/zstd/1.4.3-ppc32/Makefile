
COMPONENT_TARGETS  = $(HARDWARE_S824L)
COMPONENT_TARGETS += $(HARDWARE_VESNIN)
COMPONENT_TARGETS += $(HARDWARE_TL2WK2)
COMPONENT_TARGETS += $(HARDWARE_TL2SV2)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_PPC32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/zstd

REQUIRES           = libs/zstd/1.4.3
REQUIRES          += libs/lz4/1.9.2-ppc32
REQUIRES          += libs/zlib/1.2.8-ppc32
REQUIRES          += app/xz/5.2.4-ppc32

# ======= __END_OF_REQUIRES__ =======


version            = 1.4.3
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/l/zstd/zstd-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/zstd-$(version)
src_dir_name       = zstd-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
ZSTD_32_PKG_NAME                = zstd-x32
ZSTD_32_PKG_VERSION             = 1.4.3
ZSTD_32_PKG_ARCH                = $(TOOLCHAIN)
ZSTD_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
ZSTD_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
ZSTD_32_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
ZSTD_32_PKG_SHORT_DESCRIPTION   = real-time compression algorithm
ZSTD_32_PKG_URL                 = $(BUG_URL)
ZSTD_32_PKG_LICENSE             = GPLv2
ZSTD_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(ZSTD_32_PKG_NAME)-pkg-description
ZSTD_32_PKG_DESCRIPTION_FILE_IN = $(ZSTD_32_PKG_NAME)-pkg-description.in
ZSTD_32_PKG_INSTALL_SCRIPT      = $(ZSTD_32_PKG_NAME)-pkg-install.sh

ZSTD_32_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(ZSTD_32_PKG_NAME)-package

pkg_basename     = $(ZSTD_32_PKG_NAME)-$(ZSTD_32_PKG_VERSION)-$(ZSTD_32_PKG_ARCH)-$(ZSTD_32_PKG_DISTRO_NAME)-$(ZSTD_32_PKG_DISTRO_VERSION)

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


env_sysroot  = DESTDIR=$(ZSTD_32_PKG)


configure_switches  = prefix=/usr
configure_switches += libdir=/usr/lib$(MULTILIB_PPC32_SUFFIX)
configure_switches += mandir=/usr/share/man
configure_switches += bindir=/usr/bin/32


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -C contrib/pzstd
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(ZSTD_32_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) $(configure_switches) -j1 install $(env_sysroot)
	@cd $(SRC_DIR) && install -Dm755 contrib/pzstd/pzstd $(ZSTD_32_PKG)/usr/bin/32/pzstd
ifneq ($(__ENABLE_STATIC__),yes)
	@rm -f $(ZSTD_32_PKG)/usr/lib$(MULTILIB_PPC32_SUFFIX)/*.a
endif
	@rm -rf $(ZSTD_32_PKG)/usr/include
	@rm -rf $(ZSTD_32_PKG)/usr/share
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(ZSTD_32_PKG))
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_PPC32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libzstd.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(ZSTD_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifeq ($(__ENABLE_STATIC__),yes)
	@( cd $(ZSTD_32_PKG) ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null ; \
	 )
endif
	@touch $@

$(ZSTD_32_PKG_DESCRIPTION_FILE): $(ZSTD_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(ZSTD_32_PKG_DESCRIPTION_FILE) $(ZSTD_32_PKG_INSTALL_SCRIPT)
	@cp $(ZSTD_32_PKG_DESCRIPTION_FILE) $(ZSTD_32_PKG)/.DESCRIPTION
	@cp $(ZSTD_32_PKG_INSTALL_SCRIPT) $(ZSTD_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(ZSTD_32_PKG)/.REQUIRES
	@echo "pkgname=$(ZSTD_32_PKG_NAME)"                            >  $(ZSTD_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(ZSTD_32_PKG_VERSION)"                          >> $(ZSTD_32_PKG)/.PKGINFO ; \
	 echo "arch=$(ZSTD_32_PKG_ARCH)"                               >> $(ZSTD_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(ZSTD_32_PKG_DISTRO_NAME)"                  >> $(ZSTD_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(ZSTD_32_PKG_DISTRO_VERSION)"                >> $(ZSTD_32_PKG)/.PKGINFO ; \
	 echo "group=$(ZSTD_32_PKG_GROUP)"                             >> $(ZSTD_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(ZSTD_32_PKG_SHORT_DESCRIPTION)\"" >> $(ZSTD_32_PKG)/.PKGINFO ; \
	 echo "url=$(ZSTD_32_PKG_URL)"                                 >> $(ZSTD_32_PKG)/.PKGINFO ; \
	 echo "license=$(ZSTD_32_PKG_LICENSE)"                         >> $(ZSTD_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(ZSTD_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
