
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/GNU/EGLIBC/2.19.1

REQUIRES           = libs/eglibc/2.19.1
REQUIRES          += dev/kernel-headers
REQUIRES          += dev/gcc-runtime/4.9.1
REQUIRES          += base/radix-system

# ======= __END_OF_REQUIRES__ =======


version            = 2.19.1
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/GNU/EGLIBC/$(version)/eglibc-$(version).tar.bz2
tar_bz2_archive_ports = $(SRC_PACKAGE_PATH)/GNU/EGLIBC/2.19.1/eglibc-ports-2.19.1.tar.bz2

SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/eglibc-$(version)
src_dir_name       = eglibc-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source-done

PATCHES            = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.built
install_target     = $(TARGET_BUILD_DIR)/.installed


build_eglibc32_pkg = $(TARGET_BUILD_DIR)/.eglibc32_pkg_done


OPTIMIZATION_FLAGS  = -O3


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
EGLIBC32_PKG_NAME                = eglibc-x32
EGLIBC32_PKG_VERSION             = 2.19.1
EGLIBC32_PKG_ARCH                = $(TOOLCHAIN)
EGLIBC32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
EGLIBC32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
EGLIBC32_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
EGLIBC32_PKG_SHORT_DESCRIPTION   = Embedded GNU C libraries
EGLIBC32_PKG_URL                 = $(BUG_URL)
EGLIBC32_PKG_LICENSE             = GPLv2
EGLIBC32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(EGLIBC32_PKG_NAME)-pkg-description
EGLIBC32_PKG_DESCRIPTION_FILE_IN = $(EGLIBC32_PKG_NAME)-pkg-description.in
EGLIBC32_PKG_INSTALL_SCRIPT      = $(EGLIBC32_PKG_NAME)-pkg-install.sh

EGLIBC32_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(EGLIBC32_PKG_NAME)-package

pkg_basename     = $(EGLIBC32_PKG_NAME)-$(EGLIBC32_PKG_VERSION)-$(EGLIBC32_PKG_ARCH)-$(EGLIBC32_PKG_DISTRO_NAME)-$(EGLIBC32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_certificate  = $(call cert-name,$(pkg_archive))
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)
BUILD_TARGETS   += $(build_eglibc32_pkg)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = install_root=$(EGLIBC32_PKG)


extra_configure_switches  += --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches  += --with-headers=$(TARGET_DEST_DIR)/usr/include
extra_configure_switches  += --enable-add-ons=libidn,nptl,ports
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
	$(APPLY_PATCHES)
	@tar xjf $(tar_bz2_archive_ports) -C $(SRC_DIR)
	@mv $(SRC_DIR)/eglibc-ports-2.19.1 $(SRC_DIR)/ports
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
	@mkdir -p $(EGLIBC32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# fake LOCALES installation to allow implementation of iconv and intl into EGLIBC
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 SUPPORTED-LOCALES="" \
	                                                     localedata/install-locales $(env_sysroot)
	@touch $@

$(build_eglibc32_pkg): $(install_target)
	# Remove not needed stuff
	@rm -rf $(EGLIBC32_PKG)/etc
	@rm -rf $(EGLIBC32_PKG)/sbin
	@rm -rf $(EGLIBC32_PKG)/usr/bin
	@rm -rf $(EGLIBC32_PKG)/usr/sbin
	@rm -rf $(EGLIBC32_PKG)/usr/share
	@rm -rf $(EGLIBC32_PKG)/var
	@( cd $(EGLIBC32_PKG)/usr/include/gnu ;  cp stubs-32.h ../.. )
	@rm -rf $(EGLIBC32_PKG)/usr/include
	@( mkdir -p $(EGLIBC32_PKG)/usr/include/gnu ; \
	   mv $(EGLIBC32_PKG)/usr/stubs-32.h $(EGLIBC32_PKG)/usr/include/gnu )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(EGLIBC32_PKG))
	# ======= Strip binaries =======
	@( cd $(EGLIBC32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null ; \
	   find . | xargs file | grep "relocatable" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null ; \
	 )
	@touch $@

$(EGLIBC32_PKG_DESCRIPTION_FILE): $(EGLIBC32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(build_eglibc32_pkg) $(EGLIBC32_PKG_DESCRIPTION_FILE) $(EGLIBC32_PKG_INSTALL_SCRIPT)
	@cp $(EGLIBC32_PKG_DESCRIPTION_FILE) $(EGLIBC32_PKG)/.DESCRIPTION
	@cp $(EGLIBC32_PKG_INSTALL_SCRIPT) $(EGLIBC32_PKG)/.INSTALL
	@$(BUILD_BIN_PKG_REQUIRES) $(EGLIBC32_PKG)/.REQUIRES
	@echo "pkgname=$(EGLIBC32_PKG_NAME)"                            >  $(EGLIBC32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(EGLIBC32_PKG_VERSION)"                          >> $(EGLIBC32_PKG)/.PKGINFO ; \
	 echo "arch=$(EGLIBC32_PKG_ARCH)"                               >> $(EGLIBC32_PKG)/.PKGINFO ; \
	 echo "distroname=$(EGLIBC32_PKG_DISTRO_NAME)"                  >> $(EGLIBC32_PKG)/.PKGINFO ; \
	 echo "distrover=$(EGLIBC32_PKG_DISTRO_VERSION)"                >> $(EGLIBC32_PKG)/.PKGINFO ; \
	 echo "group=$(EGLIBC32_PKG_GROUP)"                             >> $(EGLIBC32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(EGLIBC32_PKG_SHORT_DESCRIPTION)\"" >> $(EGLIBC32_PKG)/.PKGINFO ; \
	 echo "url=$(EGLIBC32_PKG_URL)"                                 >> $(EGLIBC32_PKG)/.PKGINFO ; \
	 echo "license=$(EGLIBC32_PKG_LICENSE)"                         >> $(EGLIBC32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(EGLIBC32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
