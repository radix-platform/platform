
COMPONENT_TARGETS = $(TARGET_OMAP5EVM)

NEEDS_ABS_PATHS = true

COMPONENT_IS_3PP = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES  += $(SRC_PACKAGE_DIR)/U-Boot/omap5

REQUIRES          = boot/kernel/omap543x/3.8.13


version           = 6AJ.1.2-RC3
tar_bz2_archive   = $(SRC_PACKAGE_PATH)/U-Boot/omap5/u-boot-omap-$(version).tar.bz2
SRC_ARCHIVE       = $(tar_bz2_archive)
SRC_DIR           = $(TARGET_BUILD_DIR)/u-boot-omap-$(version)
src_done          = $(SRC_DIR)/.source_done

build_dir         = $(CURDIR)/$(TARGET_BUILD_DIR)/build
u_boot            = $(build_dir)/.u_boot_done

u_boot_config     = omap5_uevm_config


PATCHES = PATCHES


ifneq ($(filter $(TOOLCHAIN),$(OMAP543X_EGLIBC_TOOLCHAIN_NAME)),)
ARCH = arm
endif


####### Targets


UBOOT_BIN_PKG_NAME                = u-boot
UBOOT_BIN_PKG_VERSION             = 6AJ.1.2-RC3
ifeq ($(HARDWARE),$(TARGET_HOST))
UBOOT_BIN_PKG_ARCH                = $(shell uname -m)
else
UBOOT_BIN_PKG_ARCH                = $(TOOLCHAIN)
endif
UBOOT_BIN_PKG_DISTRO_NAME         = kxLab
UBOOT_BIN_PKG_DISTRO_VERSION      = 1.0
UBOOT_BIN_PKG_GROUP               = boot
###                                 |---handy-ruler-------------------------------|
UBOOT_BIN_PKG_SHORT_DESCRIPTION   = OMAP5 U-Boot $(version)
UBOOT_BIN_PKG_URL                 = http://www.kxLab.com
UBOOT_BIN_PKG_LICENSE             = GPLv2
UBOOT_BIN_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(UBOOT_BIN_PKG_NAME)-pkg-description
UBOOT_BIN_PKG_DESCRIPTION_FILE_IN = $(UBOOT_BIN_PKG_NAME)-pkg-description.in
UBOOT_BIN_PKG_INSTALL_SCRIPT      = $(UBOOT_BIN_PKG_NAME)-pkg-install.sh

UBOOT_BIN_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(UBOOT_BIN_PKG_NAME)-package

build_uboot_pkg  = $(TARGET_BUILD_DIR)/.u_boot_pkg_done

pkg_basename     = $(UBOOT_BIN_PKG_NAME)-$(UBOOT_BIN_PKG_VERSION)-$(UBOOT_BIN_PKG_ARCH)-$(UBOOT_BIN_PKG_DISTRO_NAME)-$(UBOOT_BIN_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(UBOOT_BIN_PKG_GROUP)/$(pkg_basename).tgz

BUILD_TARGETS    = $(build_uboot_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(UBOOT_BIN_PKG_GROUP)

CLEANUP_FILES   += $(SRC_DIR)


include ../../../../build-system/core.mk


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

UMAKE := $(BUILD_ENVIRONMENT) $(MAKE) -C $(SRC_DIR) CROSS_COMPILE="$(CROSS_PREFIX)"

$(u_boot): $(src_done)
	@mkdir -p $(build_dir)
	$(UMAKE)  $(u_boot_config)
	$(UMAKE)
	@touch $@

$(UBOOT_BIN_PKG_DESCRIPTION_FILE): $(UBOOT_BIN_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(build_uboot_pkg): $(u_boot) $(UBOOT_BIN_PKG_DESCRIPTION_FILE) $(UBOOT_BIN_PKG_INSTALL_SCRIPT)
	@mkdir -p $(TARGET_DEST_DIR)/bootfs
	@mkdir -p $(UBOOT_BIN_PKG)/boot
	# Copy U-Boot images:
	@cp -a $(CURDIR)/bootparams/boot.scr \
	       $(CURDIR)/bootparams/omap5-uevm.dtb $(TARGET_DEST_DIR)/bootfs
	@cp -a $(CURDIR)/bootparams/boot.scr \
	       $(CURDIR)/bootparams/omap5-uevm.dtb $(UBOOT_BIN_PKG)/boot
	@cd $(SRC_DIR) && \
	  cp -a MLO u-boot u-boot.bin u-boot.img u-boot.lds u-boot.map u-boot.srec $(TARGET_DEST_DIR)/bootfs && \
	  cp -a MLO u-boot u-boot.bin u-boot.img u-boot.lds u-boot.map u-boot.srec $(UBOOT_BIN_PKG)/boot
	@mkdir -p $(UBOOT_BIN_PKG)/usr/doc/u-boot-$(version)
	@cp -a $(SRC_DIR)/COPYING $(SRC_DIR)/CREDITS $(SRC_DIR)/README* $(SRC_DIR)/boards.cfg \
	       $(UBOOT_BIN_PKG)/usr/doc/u-boot-$(version)
	@cp $(UBOOT_BIN_PKG_DESCRIPTION_FILE) $(UBOOT_BIN_PKG)/.DESCRIPTION
	@cp $(UBOOT_BIN_PKG_INSTALL_SCRIPT) $(UBOOT_BIN_PKG)/.INSTALL
	@chmod a+x $(UBOOT_BIN_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(UBOOT_BIN_PKG)/.REQUIRES
	@echo "pkgname=$(UBOOT_BIN_PKG_NAME)"                            >  $(UBOOT_BIN_PKG)/.PKGINFO ; \
	 echo "pkgver=$(UBOOT_BIN_PKG_VERSION)"                          >> $(UBOOT_BIN_PKG)/.PKGINFO ; \
	 echo "arch=$(UBOOT_BIN_PKG_ARCH)"                               >> $(UBOOT_BIN_PKG)/.PKGINFO ; \
	 echo "distroname=$(UBOOT_BIN_PKG_DISTRO_NAME)"                  >> $(UBOOT_BIN_PKG)/.PKGINFO ; \
	 echo "distrover=$(UBOOT_BIN_PKG_DISTRO_VERSION)"                >> $(UBOOT_BIN_PKG)/.PKGINFO ; \
	 echo "group=$(UBOOT_BIN_PKG_GROUP)"                             >> $(UBOOT_BIN_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(UBOOT_BIN_PKG_SHORT_DESCRIPTION)\"" >> $(UBOOT_BIN_PKG)/.PKGINFO ; \
	 echo "url=$(UBOOT_BIN_PKG_URL)"                                 >> $(UBOOT_BIN_PKG)/.PKGINFO ; \
	 echo "license=$(UBOOT_BIN_PKG_LICENSE)"                         >> $(UBOOT_BIN_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(UBOOT_BIN_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@
