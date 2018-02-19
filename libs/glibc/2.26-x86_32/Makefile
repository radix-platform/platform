
COMPONENT_TARGETS   = $(HARDWARE_PC64)

NEED_ABS_PATH       = true
COMPONENT_IS_3PP    = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES     = sources/GNU/glibc/2.26
SOURCE_REQUIRES    += sources/iana/tz

REQUIRES            = libs/glibc/2.26
REQUIRES           += dev/kernel-headers
REQUIRES           += dev/gcc-runtime/7.2.0

# ======= __END_OF_REQUIRES__ =======


version             = 2.26
tar_xz_archive      = $(SRC_PACKAGE_PATH)/GNU/glibc/$(version)/glibc-$(version).tar.xz

tz_version          = 2018c
tar_gz_code_archive = $(SRC_PACKAGE_PATH)/iana/tz/tzcode$(tz_version).tar.gz
tar_gz_data_archive = $(SRC_PACKAGE_PATH)/iana/tz/tzdata$(tz_version).tar.gz
exclude_list        = $(CURDIR)/tz-exclude.list

SRC_ARCHIVE         = $(tar_xz_archive)
SRC_DIR             = $(TARGET_BUILD_DIR)/glibc-$(version)
src_dir_name        = glibc-$(version)
src_done            = $(TARGET_BUILD_DIR)/.source-done

PATCHES             = PATCHES

build_dir           = $(TARGET_BUILD_DIR)/build
build_target        = $(TARGET_BUILD_DIR)/.built
install_target      = $(TARGET_BUILD_DIR)/.installed


build_glibc32_pkg   = $(TARGET_BUILD_DIR)/.glibc32_pkg_done


OPTIMIZATION_FLAGS  = -O3


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
GLIBC_32_PKG_NAME                = glibc-x32
GLIBC_32_PKG_VERSION             = 2.26
GLIBC_32_PKG_ARCH                = $(TOOLCHAIN)
GLIBC_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
GLIBC_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
GLIBC_32_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
GLIBC_32_PKG_SHORT_DESCRIPTION   = GNU C libraries
GLIBC_32_PKG_URL                 = $(BUG_URL)
GLIBC_32_PKG_LICENSE             = GPLv2
GLIBC_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GLIBC_32_PKG_NAME)-pkg-description
GLIBC_32_PKG_DESCRIPTION_FILE_IN = $(GLIBC_32_PKG_NAME)-pkg-description.in
GLIBC_32_PKG_INSTALL_SCRIPT      = $(GLIBC_32_PKG_NAME)-pkg-install.sh

GLIBC_32_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GLIBC_32_PKG_NAME)-package

pkg_basename     = $(GLIBC_32_PKG_NAME)-$(GLIBC_32_PKG_VERSION)-$(GLIBC_32_PKG_ARCH)-$(GLIBC_32_PKG_DISTRO_NAME)-$(GLIBC_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)
BUILD_TARGETS   += $(build_glibc32_pkg)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = install_root=$(GLIBC_32_PKG)


extra_configure_switches  += --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches  += --with-headers=$(TARGET_DEST_DIR)/usr/include
extra_configure_switches  += --with-binutils=$(TOOLCHAIN_PATH)/bin
extra_configure_switches  += --enable-kernel=2.6.36
extra_configure_switches  += --enable-obsolete-rpc
extra_configure_switches  += --disable-profile
extra_configure_switches  += --disable-rpath
extra_configure_switches  += --without-gd
extra_configure_switches  += --without-cvs
extra_configure_switches  += --with-tls
extra_configure_switches  += --with-__thread



$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	@tar --exclude-from=$(exclude_list) -xzf $(tar_gz_code_archive) -C $(SRC_DIR)/timezone
	@tar --exclude-from=$(exclude_list) -xzf $(tar_gz_data_archive) -C $(SRC_DIR)/timezone
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@echo "slibdir=/lib$(MULTILIB_X86_32_SUFFIX)" >> $(build_dir)/configparms
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(env_sysroot) ../$(src_dir_name)/configure \
	  --prefix=/usr                \
	  --build=$(BUILD)             \
	  --host=$(TARGET32)           \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(GLIBC_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= fake LOCALES installation to allow implementation of iconv and intl into GLIBC =======
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 SUPPORTED-LOCALES="" \
	                                                     localedata/install-locales $(env_sysroot)
	@touch $@

$(build_glibc32_pkg): $(install_target)
	# ======= Remove not needed stuff =======
	@rm -rf $(GLIBC_32_PKG)/etc
	@rm -rf $(GLIBC_32_PKG)/sbin
	@rm -rf $(GLIBC_32_PKG)/usr/bin
	@rm -rf $(GLIBC_32_PKG)/usr/sbin
	@rm -rf $(GLIBC_32_PKG)/usr/share
	@rm -rf $(GLIBC_32_PKG)/var
	@( cd $(GLIBC_32_PKG)/usr/include/gnu ;  cp lib-names-32.h stubs-32.h ../.. )
	@rm -rf $(GLIBC_32_PKG)/usr/include
	@( mkdir -p $(GLIBC_32_PKG)/usr/include/gnu ; \
	   mv $(GLIBC_32_PKG)/usr/lib-names-32.h $(GLIBC_32_PKG)/usr/include/gnu ; \
	   mv $(GLIBC_32_PKG)/usr/stubs-32.h     $(GLIBC_32_PKG)/usr/include/gnu ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(GLIBC_32_PKG))
	# ======= Strip binaries =======
	@( cd $(GLIBC_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null ; \
	   find . | xargs file | grep "relocatable" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null ; \
	 )
	@touch $@

$(GLIBC_32_PKG_DESCRIPTION_FILE): $(GLIBC_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(build_glibc32_pkg) $(GLIBC_32_PKG_DESCRIPTION_FILE) $(GLIBC_32_PKG_INSTALL_SCRIPT)
	@cp $(GLIBC_32_PKG_DESCRIPTION_FILE) $(GLIBC_32_PKG)/.DESCRIPTION
	@cp $(GLIBC_32_PKG_INSTALL_SCRIPT) $(GLIBC_32_PKG)/.INSTALL
	@$(BUILD_BIN_PKG_REQUIRES) $(GLIBC_32_PKG)/.REQUIRES
	@echo "pkgname=$(GLIBC_32_PKG_NAME)"                            >  $(GLIBC_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GLIBC_32_PKG_VERSION)"                          >> $(GLIBC_32_PKG)/.PKGINFO ; \
	 echo "arch=$(GLIBC_32_PKG_ARCH)"                               >> $(GLIBC_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(GLIBC_32_PKG_DISTRO_NAME)"                  >> $(GLIBC_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(GLIBC_32_PKG_DISTRO_VERSION)"                >> $(GLIBC_32_PKG)/.PKGINFO ; \
	 echo "group=$(GLIBC_32_PKG_GROUP)"                             >> $(GLIBC_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GLIBC_32_PKG_SHORT_DESCRIPTION)\"" >> $(GLIBC_32_PKG)/.PKGINFO ; \
	 echo "url=$(GLIBC_32_PKG_URL)"                                 >> $(GLIBC_32_PKG)/.PKGINFO ; \
	 echo "license=$(GLIBC_32_PKG_LICENSE)"                         >> $(GLIBC_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(GLIBC_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
