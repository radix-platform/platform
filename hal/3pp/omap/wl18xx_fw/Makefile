
COMPONENT_TARGETS = $(TARGET_OMAP5EVM)

NEEDS_ABS_PATHS = true

COMPONENT_IS_3PP = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES  += $(SRC_PACKAGE_DIR)/hal/omap/wl18xx_fw

REQUIRES          = hal/3pp/omap/wl18xx

version           = ol_r8.a8.10
tar_bz2_archive   = $(SRC_PACKAGE_PATH)/hal/omap/wl18xx_fw/wl18xx_fw-$(version).tar.bz2
SRC_ARCHIVE       = $(tar_bz2_archive)
SRC_DIR           = $(TARGET_BUILD_DIR)/wl18xx_fw-$(version)
src_done          = $(TARGET_BUILD_DIR)/.source_done


PATCHES = PATCHES


####### Targets


WL18FW_BIN_PKG_NAME                = wl18fw
WL18FW_BIN_PKG_VERSION             = ol_r8.a8.10
ifeq ($(HARDWARE),$(TARGET_HOST))
WL18FW_BIN_PKG_ARCH                = $(shell uname -m)
else
WL18FW_BIN_PKG_ARCH                = $(TOOLCHAIN)
endif
WL18FW_BIN_PKG_DISTRO_NAME         = kxLab
WL18FW_BIN_PKG_DISTRO_VERSION      = 1.0
WL18FW_BIN_PKG_GROUP               = boot
###                                 |---handy-ruler-------------------------------|
WL18FW_BIN_PKG_SHORT_DESCRIPTION   = wl18xx $(version) firmware
WL18FW_BIN_PKG_URL                 = http://www.kxLab.com
WL18FW_BIN_PKG_LICENSE             = GPLv2
WL18FW_BIN_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(WL18FW_BIN_PKG_NAME)-pkg-description
WL18FW_BIN_PKG_DESCRIPTION_FILE_IN = $(WL18FW_BIN_PKG_NAME)-pkg-description.in
WL18FW_BIN_PKG_INSTALL_SCRIPT      = $(WL18FW_BIN_PKG_NAME)-pkg-install.sh

WL18FW_BIN_PKG   = $(CURDIR)/$(TARGET_BUILD_DIR)/$(WL18FW_BIN_PKG_NAME)-package

build_wl18fw_pkg = $(TARGET_BUILD_DIR)/.wl18fw_pkg_done

pkg_basename     = $(WL18FW_BIN_PKG_NAME)-$(WL18FW_BIN_PKG_VERSION)-$(WL18FW_BIN_PKG_ARCH)-$(WL18FW_BIN_PKG_DISTRO_NAME)-$(WL18FW_BIN_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(WL18FW_BIN_PKG_GROUP)/$(pkg_basename).tgz

BUILD_TARGETS    = $(build_wl18fw_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(WL18FW_BIN_PKG_GROUP)


include ../../../../build-system/core.mk


####### Dependencies


$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@


$(WL18FW_BIN_PKG_DESCRIPTION_FILE): $(WL18FW_BIN_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@


$(build_wl18fw_pkg): $(src_done) $(WL18FW_BIN_PKG_DESCRIPTION_FILE) $(WL18FW_BIN_PKG_INSTALL_SCRIPT)
	@mkdir -p $(WL18FW_BIN_PKG)/lib/firmware
	@mkdir -p $(WL18FW_BIN_PKG)/etc/firmware/ti-connectivity
	# Copy firmware:
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
	@touch $@
