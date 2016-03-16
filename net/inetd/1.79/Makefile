
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/n/inetd

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.3.0
else
REQUIRES           = libs/glibc/2.23
endif

# ======= __END_OF_REQUIRES__ =======


version            = 1.79
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/n/inetd/inetd-OpenBSD-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/inetd
src_dir_name       = inetd
src_done           = $(TARGET_BUILD_DIR)/.source-done


PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


inetd_readme_file  = $(CURDIR)/doc/README
inetd_config_file  = $(CURDIR)/config/inetd.conf.new
inetd_script_file  = $(CURDIR)/config/rc.d/rc.inetd.new


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
INETD_PKG_NAME                = inetd
INETD_PKG_VERSION             = 1.79
INETD_PKG_ARCH                = $(TOOLCHAIN)
INETD_PKG_DISTRO_NAME         = $(DISTRO_NAME)
INETD_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
INETD_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
INETD_PKG_SHORT_DESCRIPTION   = Internet super-server
INETD_PKG_URL                 = $(BUG_URL)
INETD_PKG_LICENSE             = BSD
INETD_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(INETD_PKG_NAME)-pkg-description
INETD_PKG_DESCRIPTION_FILE_IN = $(INETD_PKG_NAME)-pkg-description.in
INETD_PKG_INSTALL_SCRIPT      = $(INETD_PKG_NAME)-pkg-install.sh

INETD_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(INETD_PKG_NAME)-package

pkg_basename     = $(INETD_PKG_NAME)-$(INETD_PKG_VERSION)-$(INETD_PKG_ARCH)-$(INETD_PKG_DISTRO_NAME)-$(INETD_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


inetd_CFLAGS = -isystem $(TARGET_DEST_DIR)/usr/include $(OPTIMIZATION_FLAGS) $(ARCH_FLAGS) $(HW_FLAGS)
inetd_environment = CFLAGS="$(inetd_CFLAGS) -D__USE_BSD=1 -Wno-error=deprecated-declarations"


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(inetd_environment) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(INETD_PKG)/etc/rc.d
	@mkdir -p $(INETD_PKG)/usr/sbin
	@mkdir -p $(INETD_PKG)/usr/share/man/man8
	@mkdir -p $(INETD_PKG)/usr/share/doc/inetd-OpenBSD-$(version)
	@( cd $(SRC_DIR) ; \
	   cat inetd > $(INETD_PKG)/usr/sbin/inetd ; \
	   chmod 755 $(INETD_PKG)/usr/sbin/* ; \
	   cat inetd.8 | gzip -9c > $(INETD_PKG)/usr/share/man/man8/inetd.8.gz ; \
	 )
	@cp -a $(inetd_readme_file) $(INETD_PKG)/usr/share/doc/inetd-OpenBSD-$(version)
	@cp -a $(inetd_config_file) $(INETD_PKG)/etc
	@cp -a $(inetd_script_file) $(INETD_PKG)/etc/rc.d
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(INETD_PKG))
	# ======= Strip binaries =======
	@( cd $(INETD_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(INETD_PKG_DESCRIPTION_FILE): $(INETD_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(INETD_PKG_DESCRIPTION_FILE) $(INETD_PKG_INSTALL_SCRIPT)
	@cp $(INETD_PKG_DESCRIPTION_FILE) $(INETD_PKG)/.DESCRIPTION
	@cp $(INETD_PKG_INSTALL_SCRIPT) $(INETD_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(INETD_PKG)/.REQUIRES
	@echo "pkgname=$(INETD_PKG_NAME)"                            >  $(INETD_PKG)/.PKGINFO ; \
	 echo "pkgver=$(INETD_PKG_VERSION)"                          >> $(INETD_PKG)/.PKGINFO ; \
	 echo "arch=$(INETD_PKG_ARCH)"                               >> $(INETD_PKG)/.PKGINFO ; \
	 echo "distroname=$(INETD_PKG_DISTRO_NAME)"                  >> $(INETD_PKG)/.PKGINFO ; \
	 echo "distrover=$(INETD_PKG_DISTRO_VERSION)"                >> $(INETD_PKG)/.PKGINFO ; \
	 echo "group=$(INETD_PKG_GROUP)"                             >> $(INETD_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(INETD_PKG_SHORT_DESCRIPTION)\"" >> $(INETD_PKG)/.PKGINFO ; \
	 echo "url=$(INETD_PKG_URL)"                                 >> $(INETD_PKG)/.PKGINFO ; \
	 echo "license=$(INETD_PKG_LICENSE)"                         >> $(INETD_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(INETD_PKG)  && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
