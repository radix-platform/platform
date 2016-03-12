
COMPONENT_TARGETS = $(HARDWARE_OMAP5UEVM)

NEED_ABS_PATH     = true

COMPONENT_IS_3PP  = true


include ../../../../../build-system/constants.mk


SOURCE_REQUIRES   = sources/hal/drivers/omap543x/wireless/wl18xx_fw

REQUIRES          = hal/drivers/omap543x/wl18xx/8.8.10

# ======= __END_OF_REQUIRES__ =======


version           = ol_r8.a8.10
tar_bz2_archive   = $(SRC_PACKAGE_PATH)/hal/drivers/omap543x/wireless/wl18xx_fw/wl18xx_fw-$(version).tar.bz2
SRC_ARCHIVE       = $(tar_bz2_archive)
SRC_DIR           = $(TARGET_BUILD_DIR)/wl18xx_fw-$(version)
src_done          = $(TARGET_BUILD_DIR)/.source_done


PATCHES = PATCHES


####### Targets

PKG_GROUP = boot


WL18FW_BIN_PKG_NAME                = wl18fw
WL18FW_BIN_PKG_VERSION             = 8.8.10
WL18FW_BIN_PKG_ARCH                = $(TOOLCHAIN)
WL18FW_BIN_PKG_DISTRO_NAME         = $(DISTRO_NAME)
WL18FW_BIN_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
WL18FW_BIN_PKG_GROUP               = $(PKG_GROUP)
###                                 |---handy-ruler-------------------------------|
WL18FW_BIN_PKG_SHORT_DESCRIPTION   = Firmware for TI wl18xx devices
WL18FW_BIN_PKG_URL                 = $(BUG_URL)
WL18FW_BIN_PKG_LICENSE             = GPLv2
WL18FW_BIN_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(WL18FW_BIN_PKG_NAME)-pkg-description
WL18FW_BIN_PKG_DESCRIPTION_FILE_IN = $(WL18FW_BIN_PKG_NAME)-pkg-description.in
WL18FW_BIN_PKG_INSTALL_SCRIPT      = $(WL18FW_BIN_PKG_NAME)-pkg-install.sh

WL18FW_BIN_PKG   = $(CURDIR)/$(TARGET_BUILD_DIR)/$(WL18FW_BIN_PKG_NAME)-package

build_wl18fw_pkg = $(TARGET_BUILD_DIR)/.wl18fw_pkg_done

pkg_basename     = $(WL18FW_BIN_PKG_NAME)-$(WL18FW_BIN_PKG_VERSION)-$(WL18FW_BIN_PKG_ARCH)-$(WL18FW_BIN_PKG_DISTRO_NAME)-$(WL18FW_BIN_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_wl18fw_pkg)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../../build-system/core.mk


####### Dependencies


$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_wl18fw_pkg): $(src_done)
	@mkdir -p $(WL18FW_BIN_PKG)/lib/firmware
	@mkdir -p $(WL18FW_BIN_PKG)/etc/firmware/ti-connectivity
	# Copy firmware:
	@chmod a-x $(SRC_DIR)/wl18xx-fw-2.bin
	@cp -a $(SRC_DIR)/wl18xx-fw-2.bin \
	       $(WL18FW_BIN_PKG)/lib/firmware
	@cp -a $(SRC_DIR)/wl18xx-fw-2.bin \
	       $(WL18FW_BIN_PKG)/etc/firmware/ti-connectivity
	@mkdir -p $(TARGET_DEST_DIR)/lib/firmware
	@mkdir -p $(TARGET_DEST_DIR)/etc/firmware/ti-connectivity
	@cp -a $(SRC_DIR)/wl18xx-fw-2.bin \
	       $(TARGET_DEST_DIR)/lib/firmware
	@cp -a $(SRC_DIR)/wl18xx-fw-2.bin \
	       $(TARGET_DEST_DIR)/etc/firmware/ti-connectivity
	@mkdir -p $(WL18FW_BIN_PKG)/usr/doc/wl18fw-$(version)
	@cp -a $(SRC_DIR)/Android.mk $(SRC_DIR)/LICENCE \
	       $(WL18FW_BIN_PKG)/usr/doc/wl18fw-$(version)
	@touch $@

$(WL18FW_BIN_PKG_DESCRIPTION_FILE): $(WL18FW_BIN_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(build_wl18fw_pkg) $(WL18FW_BIN_PKG_DESCRIPTION_FILE) $(WL18FW_BIN_PKG_INSTALL_SCRIPT)
	@cp $(WL18FW_BIN_PKG_DESCRIPTION_FILE) $(WL18FW_BIN_PKG)/.DESCRIPTION
	@cp $(WL18FW_BIN_PKG_INSTALL_SCRIPT) $(WL18FW_BIN_PKG)/.INSTALL
	@chmod a+x $(WL18FW_BIN_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(WL18FW_BIN_PKG)/.REQUIRES
	@echo "pkgname=$(WL18FW_BIN_PKG_NAME)"                            >  $(WL18FW_BIN_PKG)/.PKGINFO ; \
	 echo "pkgver=$(WL18FW_BIN_PKG_VERSION)"                          >> $(WL18FW_BIN_PKG)/.PKGINFO ; \
	 echo "arch=$(WL18FW_BIN_PKG_ARCH)"                               >> $(WL18FW_BIN_PKG)/.PKGINFO ; \
	 echo "distroname=$(WL18FW_BIN_PKG_DISTRO_NAME)"                  >> $(WL18FW_BIN_PKG)/.PKGINFO ; \
	 echo "distrover=$(WL18FW_BIN_PKG_DISTRO_VERSION)"                >> $(WL18FW_BIN_PKG)/.PKGINFO ; \
	 echo "group=$(WL18FW_BIN_PKG_GROUP)"                             >> $(WL18FW_BIN_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(WL18FW_BIN_PKG_SHORT_DESCRIPTION)\"" >> $(WL18FW_BIN_PKG)/.PKGINFO ; \
	 echo "url=$(WL18FW_BIN_PKG_URL)"                                 >> $(WL18FW_BIN_PKG)/.PKGINFO ; \
	 echo "license=$(WL18FW_BIN_PKG_LICENSE)"                         >> $(WL18FW_BIN_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(WL18FW_BIN_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
