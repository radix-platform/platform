
COMPONENT_TARGETS = $(HARDWARE_OMAP5UEVM)

NEED_ABS_PATH     = true

COMPONENT_IS_3PP  = true


include ../../../../../build-system/constants.mk


SOURCE_REQUIRES   = sources/hal/drivers/omap543x/wl18xx/wl18xx
SOURCE_REQUIRES  += sources/hal/drivers/omap543x/wl18xx/compat-wireless
SOURCE_REQUIRES  += sources/hal/drivers/omap543x/wl18xx/compat

REQUIRES          = hal/drivers/omap543x/sgx-ddk/1.9.0.11

# ======= __END_OF_REQUIRES__ =======


version           = ol_r8.a8.10
kernel_version    = 3.8.y-20140222
modules_version   = 3.8.13
tar_bz2_archive   = $(SRC_PACKAGE_PATH)/hal/drivers/omap543x/wl18xx/wl18xx/wl18xx-$(version).tar.bz2
SRC_ARCHIVE       = $(tar_bz2_archive)
SRC_DIR           = $(TARGET_BUILD_DIR)/wl18xx-$(version)
src_done          = $(TARGET_BUILD_DIR)/.source_done

w_compat_archive  = $(SRC_PACKAGE_PATH)/hal/drivers/omap543x/wl18xx/compat-wireless/compat-wireless-$(version).tar.bz2
w_compat_src_dir  = $(TARGET_BUILD_DIR)/compat-wireless-$(version)
compat_archive    = $(SRC_PACKAGE_PATH)/hal/drivers/omap543x/wl18xx/compat/compat-$(version).tar.bz2
compat_src_dir    = $(TARGET_BUILD_DIR)/compat-$(version)

w_compat_src_done = $(TARGET_BUILD_DIR)/.wireless_compat_source_done
compat_src_done   = $(TARGET_BUILD_DIR)/.compat_source_done

sources_updated   = $(TARGET_BUILD_DIR)/.sources_updated
driver_selected   = $(TARGET_BUILD_DIR)/.driver_selected

build_dir         = $(CURDIR)/$(TARGET_BUILD_DIR)/build

kernel_sources    = $(TARGET_DEST_DIR)/usr/src/linux-glsdk-$(kernel_version)

build_wl18xx_pkg  = $(TARGET_BUILD_DIR)/.wl18xx_pkg_done

modules_done      = $(build_dir)/.modules_done


PATCHES = PATCHES


ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_OMAP543X_GLIBC)),)
ARCH = arm
endif

extra_update_environment  = GIT_TREE=$(CURDIR)/$(SRC_DIR)
extra_update_environment += GIT_COMPAT_TREE=$(CURDIR)/$(compat_src_dir)

extra_build_environment   = KLIB_BUILD=$(kernel_sources)
extra_build_environment  += KLIB=$(TARGET_DEST_DIR)
extra_build_environment  += INSTALL_MOD_PATH=$(TARGET_DEST_DIR)
extra_build_environment  += DESTDIR=$(TARGET_DEST_DIR)
extra_build_environment  += __CROSS_INSTALL__=1

USE_TARGET_DEST_DIR_SYSROOT = no


####### Targets

PKG_GROUP = boot


WL18XX_BIN_PKG_NAME                = wl18xx
WL18XX_BIN_PKG_VERSION             = 8.8.10
WL18XX_BIN_PKG_ARCH                = $(TOOLCHAIN)
WL18XX_BIN_PKG_DISTRO_NAME         = $(DISTRO_NAME)
WL18XX_BIN_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
WL18XX_BIN_PKG_GROUP               = $(PKG_GROUP)
###                                 |---handy-ruler-------------------------------|
WL18XX_BIN_PKG_SHORT_DESCRIPTION   = wl18xx wireless support for Linux kernel
WL18XX_BIN_PKG_URL                 = $(BUG_URL)
WL18XX_BIN_PKG_LICENSE             = GPLv2
WL18XX_BIN_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(WL18XX_BIN_PKG_NAME)-pkg-description
WL18XX_BIN_PKG_DESCRIPTION_FILE_IN = $(WL18XX_BIN_PKG_NAME)-pkg-description.in
WL18XX_BIN_PKG_INSTALL_SCRIPT      = $(TARGET_BUILD_DIR)/$(WL18XX_BIN_PKG_NAME)-pkg-install.sh
WL18XX_BIN_PKG_INSTALL_SCRIPT_IN   = $(WL18XX_BIN_PKG_NAME)-pkg-install.sh.in

WL18XX_BIN_PKG   = $(CURDIR)/$(TARGET_BUILD_DIR)/$(WL18XX_BIN_PKG_NAME)-package

pkg_basename     = $(WL18XX_BIN_PKG_NAME)-$(WL18XX_BIN_PKG_VERSION)-$(WL18XX_BIN_PKG_ARCH)-$(WL18XX_BIN_PKG_DISTRO_NAME)-$(WL18XX_BIN_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(modules_done)
BUILD_TARGETS   += $(build_wl18xx_pkg)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../../build-system/core.mk


####### Dependencies

$(w_compat_src_done): $(w_compat_archive)
	@echo "Expanding $(w_compat_archive)"
	@tar xjf $(w_compat_archive) -C $(TARGET_BUILD_DIR)
	@touch $@

$(compat_src_done): $(compat_archive)
	@echo "Expanding $(compat_archive)"
	@tar xjf $(compat_archive) -C $(TARGET_BUILD_DIR)
	@touch $@

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP) $(compat_src_done) $(w_compat_src_done)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(sources_updated): $(src_done)
	@-( cd $(CURDIR)/$(w_compat_src_dir) ; $(extra_update_environment) ./scripts/admin-update.sh > /dev/null 2>&1 )
	@touch $@

$(driver_selected): $(sources_updated)
	@(echo 'static const char *wl18xx_git_head = "$(version)";' > \
	    $(CURDIR)/$(w_compat_src_dir)/drivers/net/wireless/ti/wl18xx/version.h )
	@(echo 'static const char *wlcore_timestamp = __TIMESTAMP__;' > \
	    $(CURDIR)/$(w_compat_src_dir)/drivers/net/wireless/ti/wlcore/version.h ; \
	  echo 'static const char *wlcore_git_head = "$(version)";' >> \
	    $(CURDIR)/$(w_compat_src_dir)/drivers/net/wireless/ti/wlcore/version.h )
	@( cp $(CURDIR)/configs/$(version).compat_base $(CURDIR)/$(w_compat_src_dir)/.compat_base )
	@( cp $(CURDIR)/configs/$(version).compat_base_tree $(CURDIR)/$(w_compat_src_dir)/.compat_base_tree )
	@( cp $(CURDIR)/configs/$(version).compat_base_tree_version $(CURDIR)/$(w_compat_src_dir)/.compat_base_tree_version )
	@( cp $(CURDIR)/configs/$(version).compat_version $(CURDIR)/$(w_compat_src_dir)/.compat_version )
	@( cp $(CURDIR)/configs/$(version).config $(CURDIR)/$(w_compat_src_dir)/.config )
	@-(cd $(CURDIR)/$(w_compat_src_dir) ; $(extra_update_environment) ./scripts/driver-select wl18xx  > /dev/null 2>&1)
	@touch $@


LMAKE := $(BUILD_ENVIRONMENT) $(MAKE) -C $(w_compat_src_dir) ARCH=$(ARCH) CROSS_COMPILE="$(CROSS_PREFIX)" $(extra_build_environment) V=$(if $(VERBOSE),1,0)

# add to LMAKE: CONFIG_DEBUG_SECTION_MISMATCH=y for more detailed log.

$(modules_done): $(driver_selected)
	@mkdir -p $(build_dir)
	@mkdir -p $(TARGET_DEST_DIR)/usr/sbin
	@mkdir -p $(TARGET_DEST_DIR)/usr/lib/compat-drivers
	$(LMAKE) modules
	$(LMAKE) install
	@touch $@

$(build_wl18xx_pkg): $(modules_done)
	@mkdir -p $(WL18XX_BIN_PKG)/lib/modules/$(modules_version)
	# Copy modules and firmware (without links to sources):
	@cd $(TARGET_DEST_DIR)/lib/modules/$(modules_version) && \
	  cp -rf updates $(WL18XX_BIN_PKG)/lib/modules/$(modules_version)
	@mkdir -p $(WL18XX_BIN_PKG)/usr/doc/wl18xx-$(version)
	@cp -a $(SRC_DIR)/COPYING \
	       $(WL18XX_BIN_PKG)/usr/doc/wl18xx-$(version)
	@touch $@

$(WL18XX_BIN_PKG_DESCRIPTION_FILE): $(WL18XX_BIN_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(WL18XX_BIN_PKG_INSTALL_SCRIPT): $(WL18XX_BIN_PKG_INSTALL_SCRIPT_IN)
	@cat $< | $(SED) -e "s/@MODULES_VERSION@/$(modules_version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(build_wl18xx_pkg) $(WL18XX_BIN_PKG_DESCRIPTION_FILE) $(WL18XX_BIN_PKG_INSTALL_SCRIPT)
	@cp $(WL18XX_BIN_PKG_DESCRIPTION_FILE) $(WL18XX_BIN_PKG)/.DESCRIPTION
	@cp $(WL18XX_BIN_PKG_INSTALL_SCRIPT) $(WL18XX_BIN_PKG)/.INSTALL
	@chmod a+x $(WL18XX_BIN_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(WL18XX_BIN_PKG)/.REQUIRES
	@echo "pkgname=$(WL18XX_BIN_PKG_NAME)"                            >  $(WL18XX_BIN_PKG)/.PKGINFO ; \
	 echo "pkgver=$(WL18XX_BIN_PKG_VERSION)"                          >> $(WL18XX_BIN_PKG)/.PKGINFO ; \
	 echo "arch=$(WL18XX_BIN_PKG_ARCH)"                               >> $(WL18XX_BIN_PKG)/.PKGINFO ; \
	 echo "distroname=$(WL18XX_BIN_PKG_DISTRO_NAME)"                  >> $(WL18XX_BIN_PKG)/.PKGINFO ; \
	 echo "distrover=$(WL18XX_BIN_PKG_DISTRO_VERSION)"                >> $(WL18XX_BIN_PKG)/.PKGINFO ; \
	 echo "group=$(WL18XX_BIN_PKG_GROUP)"                             >> $(WL18XX_BIN_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(WL18XX_BIN_PKG_SHORT_DESCRIPTION)\"" >> $(WL18XX_BIN_PKG)/.PKGINFO ; \
	 echo "url=$(WL18XX_BIN_PKG_URL)"                                 >> $(WL18XX_BIN_PKG)/.PKGINFO ; \
	 echo "license=$(WL18XX_BIN_PKG_LICENSE)"                         >> $(WL18XX_BIN_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(WL18XX_BIN_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
