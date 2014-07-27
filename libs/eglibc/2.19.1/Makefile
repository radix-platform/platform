
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_VIP1830)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)

#
# The rest targets links staticaly with newlib or uclibc and not requires eglibc libraties
#
# COMPONENT_TARGETS += $(HARDWARE_CB1N)
# COMPONENT_TARGETS += $(HARDWARE_AT91S)
# COMPONENT_TARGETS += $(HARDWARE_VIP1830N)
# COMPONENT_TARGETS += $(HARDWARE_L17UC)
#

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES   = sources/GNU/EGLIBC/2.19.1
SOURCE_REQUIRES  += sources/iana/tz


REQUIRES          = dev/kernel-headers
REQUIRES         += dev/gcc-runtime
REQUIRES         += base/pkgtool


version               = 2.19.1
tar_bz2_archive       = $(SRC_PACKAGE_PATH)/GNU/EGLIBC/$(version)/eglibc-$(version).tar.bz2
tar_bz2_archive_ports = $(SRC_PACKAGE_PATH)/GNU/EGLIBC/$(version)/eglibc-ports-$(version).tar.bz2

tz_version            = 2013i
tar_gz_code_archive   = $(SRC_PACKAGE_PATH)/iana/tz/tzcode$(tz_version).tar.gz
tar_gz_data_archive   = $(SRC_PACKAGE_PATH)/iana/tz/tzdata$(tz_version).tar.gz
exclude_list          = $(CURDIR)/tz-exclude.list

SRC_ARCHIVE       = $(tar_bz2_archive)
SRC_DIR           = $(TARGET_BUILD_DIR)/eglibc-$(version)
src_dir_name      = eglibc-$(version)
src_done          = $(TARGET_BUILD_DIR)/.source-done

PATCHES           = PATCHES

build_dir         = $(CURDIR)/$(TARGET_BUILD_DIR)/build
build_target      = $(CURDIR)/$(TARGET_BUILD_DIR)/.built
install_target    = $(CURDIR)/$(TARGET_BUILD_DIR)/.installed


build_eglibc_pkg  = $(CURDIR)/$(TARGET_BUILD_DIR)/.eglibc_pkg_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
EGLIBC_PKG_NAME                = eglibc
EGLIBC_PKG_VERSION             = 2.19.1
EGLIBC_PKG_ARCH                = $(TOOLCHAIN)
EGLIBC_PKG_DISTRO_NAME         = kxLab
EGLIBC_PKG_DISTRO_VERSION      = 1.0
EGLIBC_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
EGLIBC_PKG_SHORT_DESCRIPTION   = eglibc $(version) header files
EGLIBC_PKG_URL                 = $(BUG_URL)
EGLIBC_PKG_LICENSE             = GPLv2
EGLIBC_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(EGLIBC_PKG_NAME)-pkg-description
EGLIBC_PKG_DESCRIPTION_FILE_IN = $(EGLIBC_PKG_NAME)-pkg-description.in
EGLIBC_PKG_INSTALL_SCRIPT      = $(EGLIBC_PKG_NAME)-pkg-install.sh

EGLIBC_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(EGLIBC_PKG_NAME)-package

pkg_basename     = $(EGLIBC_PKG_NAME)-$(EGLIBC_PKG_VERSION)-$(EGLIBC_PKG_ARCH)-$(EGLIBC_PKG_DISTRO_NAME)-$(EGLIBC_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)
BUILD_TARGETS   += $(build_eglibc_pkg)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = install_root=$(EGLIBC_PKG)


OPTIMIZATION_FLAGS  = -O3


extra_configure_switches  += --libdir=/usr/lib$(LIBSUFFIX)
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


ifeq ($(TOOLCHAIN),$(TOOLCHAIN_DM644X_EGLIBC))
extra_configure_switches  += --without-fp
endif


$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@tar xjf $(tar_bz2_archive_ports) -C $(SRC_DIR)
	@mv $(SRC_DIR)/eglibc-ports-$(version) $(SRC_DIR)/ports
	@tar --exclude-from=$(exclude_list) -xzf $(tar_gz_code_archive) -C $(SRC_DIR)/timezone
	@tar --exclude-from=$(exclude_list) -xzf $(tar_gz_data_archive) -C $(SRC_DIR)/timezone
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@echo "slibdir=/lib$(LIBSUFFIX)" >> $(build_dir)/configparms
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(env_sysroot) ../$(src_dir_name)/configure \
	  --prefix=/usr                \
	  --build=$(BUILD)             \
	  --host=$(TARGET)             \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(EGLIBC_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# fake LOCALES installation to allow implementation of iconv and intl into EGLIBC
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 SUPPORTED-LOCALES="" \
	                                                     localedata/install-locales $(env_sysroot)
	@touch $@

$(build_eglibc_pkg): $(install_target)
	@rm -f $(EGLIBC_PKG)/usr/share/info/dir
	@gzip -9 $(EGLIBC_PKG)/usr/share/info/*
	@mkdir -p $(EGLIBC_PKG)/usr/doc/eglibc-$(version)
	@cp -a  $(SRC_DIR)/COPYING* $(SRC_DIR)/LICENSES \
	        $(EGLIBC_PKG)/usr/doc/eglibc-$(version)
	@mkdir -p $(EGLIBC_PKG)/usr/share/doc/eglibc-$(version)
	@cp -a  $(SRC_DIR)/BUGS $(SRC_DIR)/CONFORMANCE $(SRC_DIR)/COPYING*  \
	        $(SRC_DIR)/ChangeLog* $(SRC_DIR)/EGLIBC* $(SRC_DIR)/INSTALL \
	        $(SRC_DIR)/LICENSES $(SRC_DIR)/NAMESPACE $(SRC_DIR)/NEWS $(SRC_DIR)/README \
	        $(EGLIBC_PKG)/usr/share/doc/eglibc-$(version)
	@mkdir -p $(EGLIBC_PKG)/usr/share/doc/eglibc-$(version)/ports
	@cp -a  $(SRC_DIR)/ports/ChangeLog* $(SRC_DIR)/ports/README \
	        $(EGLIBC_PKG)/usr/share/doc/eglibc-$(version)/ports
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(EGLIBC_PKG) && cp -rf * $(TARGET_DEST_DIR)
	@( cd $(EGLIBC_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null ; \
	   find . | xargs file | grep "relocatable" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null ; \
	 )
	@touch $@

$(EGLIBC_PKG_DESCRIPTION_FILE): $(EGLIBC_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(build_eglibc_pkg) $(EGLIBC_PKG_DESCRIPTION_FILE) $(EGLIBC_PKG_INSTALL_SCRIPT)
	@cp $(EGLIBC_PKG_DESCRIPTION_FILE) $(EGLIBC_PKG)/.DESCRIPTION
	@cp $(EGLIBC_PKG_INSTALL_SCRIPT) $(EGLIBC_PKG)/.INSTALL
	@$(BUILD_BIN_PKG_REQUIRES) $(EGLIBC_PKG)/.REQUIRES
	@echo "pkgname=$(EGLIBC_PKG_NAME)"                            >  $(EGLIBC_PKG)/.PKGINFO ; \
	 echo "pkgver=$(EGLIBC_PKG_VERSION)"                          >> $(EGLIBC_PKG)/.PKGINFO ; \
	 echo "arch=$(EGLIBC_PKG_ARCH)"                               >> $(EGLIBC_PKG)/.PKGINFO ; \
	 echo "distroname=$(EGLIBC_PKG_DISTRO_NAME)"                  >> $(EGLIBC_PKG)/.PKGINFO ; \
	 echo "distrover=$(EGLIBC_PKG_DISTRO_VERSION)"                >> $(EGLIBC_PKG)/.PKGINFO ; \
	 echo "group=$(EGLIBC_PKG_GROUP)"                             >> $(EGLIBC_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(EGLIBC_PKG_SHORT_DESCRIPTION)\"" >> $(EGLIBC_PKG)/.PKGINFO ; \
	 echo "url=$(EGLIBC_PKG_URL)"                                 >> $(EGLIBC_PKG)/.PKGINFO ; \
	 echo "license=$(EGLIBC_PKG_LICENSE)"                         >> $(EGLIBC_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(EGLIBC_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
