
COMPONENT_TARGETS = $(HARDWARE_OMAP5UEVM)

NEED_ABS_PATH     = true

COMPONENT_IS_3PP  = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES   = sources/U-Boot/omap5-glsdk

REQUIRES          = boot/kernel/omap543x/3.8.y-20140222


DEFAULT_NFS_ROOT_IP_ADDR =  172.16.0.3
DEFAULT_NFS_ROOT_PATH    = "nfsroot-omap5-uevm"
DEFAULT_HW_ADDR          =  2a:ab:c0:97:84:9d


version           = 2013.04-20140216
tar_bz2_archive   = $(SRC_PACKAGE_PATH)/U-Boot/omap5-glsdk/u-boot-omap-$(version).tar.bz2
SRC_ARCHIVE       = $(tar_bz2_archive)
SRC_DIR           = $(TARGET_BUILD_DIR)/u-boot-omap-$(version)
src_done          = $(TARGET_BUILD_DIR)/.source_done

build_dir         = $(TARGET_BUILD_DIR)/build
u_boot            = $(build_dir)/.u_boot_done

u_boot_config     = omap5_uevm_config

boot_script_nfs   = $(TARGET_BUILD_DIR)/boor.script.nfs
boot_scr_nfs      = $(TARGET_BUILD_DIR)/boor.scr.nfs

boot_script_sd   = $(TARGET_BUILD_DIR)/boor.script.sd
boot_scr_sd      = $(TARGET_BUILD_DIR)/boor.scr.sd

boot_script_emmc = $(TARGET_BUILD_DIR)/boor.script.emmc
boot_scr_emmc    = $(TARGET_BUILD_DIR)/boor.scr.emmc


PATCHES = PATCHES


ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_OMAP543X_EGLIBC)),)
ARCH = arm
endif

USE_TARGET_DEST_DIR_SYSROOT = no

device_tree_name  = omap5-uevm.dtb


####### Targets

PKG_GROUP = boot


UBOOT_BIN_PKG_NAME                = u-boot
UBOOT_BIN_PKG_VERSION             = 2013.04-20140216
UBOOT_BIN_PKG_ARCH                = $(TOOLCHAIN)
UBOOT_BIN_PKG_DISTRO_NAME         = kxLab
UBOOT_BIN_PKG_DISTRO_VERSION      = 1.0
UBOOT_BIN_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
UBOOT_BIN_PKG_SHORT_DESCRIPTION   = OMAP5 U-Boot $(version)
UBOOT_BIN_PKG_URL                 = $(BUG_URL)
UBOOT_BIN_PKG_LICENSE             = GPLv2
UBOOT_BIN_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(UBOOT_BIN_PKG_NAME)-pkg-description
UBOOT_BIN_PKG_DESCRIPTION_FILE_IN = $(UBOOT_BIN_PKG_NAME)-pkg-description.in
UBOOT_BIN_PKG_INSTALL_SCRIPT      = $(UBOOT_BIN_PKG_NAME)-pkg-install.sh

UBOOT_BIN_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(UBOOT_BIN_PKG_NAME)-package

build_uboot_pkg    = $(TARGET_BUILD_DIR)/.u_boot_pkg_done

pkg_basename       = $(UBOOT_BIN_PKG_NAME)-$(UBOOT_BIN_PKG_VERSION)-$(UBOOT_BIN_PKG_ARCH)-$(UBOOT_BIN_PKG_DISTRO_NAME)-$(UBOOT_BIN_PKG_DISTRO_VERSION)

pkg_archive        = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature      = $(call sign-name,$(pkg_archive))
pkg_description    = $(call desc-name,$(pkg_archive))
products           = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS      = $(u_boot)
BUILD_TARGETS     += $(boot_script_nfs)
BUILD_TARGETS     += $(boot_script_sd)
BUILD_TARGETS     += $(boot_script_emmc)
BUILD_TARGETS     += $(boot_scr_nfs)
BUILD_TARGETS     += $(boot_scr_sd)
BUILD_TARGETS     += $(boot_scr_emmc)
BUILD_TARGETS     += $(build_uboot_pkg)

PRODUCT_TARGETS    = $(products)

ROOTFS_TARGETS     = $(pkg_archive)


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

$(boot_script_nfs): $(u_boot)
	@( echo "mmc part" > $(boot_script_nfs) && \
	   echo "fatload mmc 0:1 0x825f0000 omap5-uevm.dtb" >> $(boot_script_nfs) && \
	   echo "fatload mmc 0:1 0x80300000 uImage" >> $(boot_script_nfs) && \
	   echo "setenv bootargs 'root=/dev/nfs nfsroot=$(DEFAULT_NFS_ROOT_IP_ADDR):/$(DEFAULT_NFS_ROOT_PATH) console=ttyO2,115200n8 earlyprintk rw ip=dhcp omapdrm.num_crtc=2 consoleblank=0'" >> $(boot_script_nfs) && \
	   echo "setenv fdt_high 0x84000000" >> $(boot_script_nfs) && \
	   echo "bootm 0x80300000 - 0x825f0000" >> $(boot_script_nfs) )

$(boot_script_sd): $(u_boot)
	@( echo "mmc part" > $(boot_script_sd) && \
	   echo "fatload mmc 0:1 0x825f0000 omap5-uevm.dtb" >> $(boot_script_sd) && \
	   echo "fatload mmc 0:1 0x80300000 uImage" >> $(boot_script_sd) && \
	   echo "setenv bootargs 'elevator=noop console=ttyO2,115200n8 root=/dev/mmcblk0p2 rw rootwait earlyprintk fixrtc ip=dhcp omapdrm.num_crtc=2 consoleblank=0'" >> $(boot_script_sd) && \
	   echo "setenv fdt_high 0x84000000" >> $(boot_script_sd) && \
	   echo "bootm 0x80300000 - 0x825f0000" >> $(boot_script_sd) )

$(boot_script_emmc): $(u_boot)
	@( echo "mmc part" > $(boot_script_emmc) && \
	   echo "fatload mmc 1:1 0x825f0000 omap5-uevm.dtb" >> $(boot_script_emmc) && \
	   echo "fatload mmc 1:1 0x80300000 uImage" >> $(boot_script_emmc) && \
	   echo "setenv bootargs 'elevator=noop console=ttyO2,115200n8 root=/dev/mmcblk0p2 rw rootwait earlyprintk fixrtc ip=dhcp omapdrm.num_crtc=2 consoleblank=0'" >> $(boot_script_emmc) && \
	   echo "setenv fdt_high 0x84000000" >> $(boot_script_emmc) && \
	   echo "bootm 0x80300000 - 0x825f0000" >> $(boot_script_emmc) )

$(boot_scr_nfs): $(boot_script_nfs)
	$(SRC_DIR)/tools/mkimage -A $(ARCH) -T script -C none -n "Boot Image" -d $< $@

$(boot_scr_sd): $(boot_script_sd)
	$(SRC_DIR)/tools/mkimage -A $(ARCH) -T script -C none -n "Boot Image" -d $< $@

$(boot_scr_emmc): $(boot_script_emmc)
	$(SRC_DIR)/tools/mkimage -A $(ARCH) -T script -C none -n "Boot Image" -d $< $@

$(build_uboot_pkg): $(u_boot) $(boot_scr_nfs) $(boot_scr_sd) $(boot_scr_emmc)
	@mkdir -p $(TARGET_DEST_DIR)/bootfs
	@mkdir -p $(UBOOT_BIN_PKG)/boot
	# Copy U-Boot images:
	@cp -a $(boot_scr_nfs)  $(TARGET_DEST_DIR)/bootfs
	@cp -a $(boot_scr_nfs)  $(UBOOT_BIN_PKG)/boot
	@cp -a $(boot_scr_sd)   $(TARGET_DEST_DIR)/bootfs
	@cp -a $(boot_scr_sd)   $(TARGET_DEST_DIR)/bootfs/boot.scr
	@cp -a $(boot_scr_sd)   $(UBOOT_BIN_PKG)/boot
	@cp -a $(boot_scr_sd)   $(UBOOT_BIN_PKG)/boot/boot.scr
	@cp -a $(boot_scr_emmc) $(TARGET_DEST_DIR)/bootfs
	@cp -a $(boot_scr_emmc) $(UBOOT_BIN_PKG)/boot
	@cd $(SRC_DIR) && \
	  cp -a MLO u-boot u-boot.bin u-boot.img u-boot.lds u-boot.map u-boot.srec $(TARGET_DEST_DIR)/bootfs && \
	  cp -a MLO u-boot u-boot.bin u-boot.img u-boot.lds u-boot.map u-boot.srec $(UBOOT_BIN_PKG)/boot
	@mkdir -p $(UBOOT_BIN_PKG)/usr/doc/u-boot-$(version)
	@cp -a $(SRC_DIR)/COPYING $(SRC_DIR)/CREDITS $(SRC_DIR)/README* $(SRC_DIR)/boards.cfg \
	       $(UBOOT_BIN_PKG)/usr/doc/u-boot-$(version)
	@touch $@

$(UBOOT_BIN_PKG_DESCRIPTION_FILE): $(UBOOT_BIN_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(build_uboot_pkg) $(UBOOT_BIN_PKG_DESCRIPTION_FILE) $(UBOOT_BIN_PKG_INSTALL_SCRIPT)
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
