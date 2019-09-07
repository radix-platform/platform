
COMPONENT_TARGETS  = $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)

NEED_ABS_PATH      = true

COMPONENT_IS_3PP   = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES   = sources/U-Boot/TI/omap5/glsdk

REQUIRES          = boot/kernel/omap543x/3.14.57-20151211

# ======= __END_OF_REQUIRES__ =======


DEFAULT_NFS_ROOT_IP_ADDR =  172.16.0.3
DEFAULT_NFS_ROOT_PATH    = "nfsroot-$(HARDWARE)"
DEFAULT_HW_ADDR          =  2a:ab:c0:97:84:9d


version           = 2014.07-20160225
tar_xz_archive    = $(SRC_PACKAGE_PATH)/U-Boot/TI/omap5/glsdk/u-boot-omap-$(version).tar.xz
SRC_ARCHIVE       = $(tar_xz_archive)
SRC_DIR           = $(TARGET_BUILD_DIR)/u-boot-omap-$(version)
src_done          = $(TARGET_BUILD_DIR)/.source_done

u_boot            = $(TARGET_BUILD_DIR)/.u_boot_done

ifneq ($(filter $(HARDWARE),$(HARDWARE_OMAP5UEVM)),)
u_boot_config     = omap5_uevm_config
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_DRA7XXEVM)),)
u_boot_config     = dra7xx_evm_config
endif

boot_script_nfs   = $(TARGET_BUILD_DIR)/boot.script.nfs
boot_scr_nfs      = $(TARGET_BUILD_DIR)/boot.scr.nfs

boot_script_sd    = $(TARGET_BUILD_DIR)/boot.script.sd
boot_scr_sd       = $(TARGET_BUILD_DIR)/boot.scr.sd

boot_script_emmc  = $(TARGET_BUILD_DIR)/boot.script.emmc
boot_scr_emmc     = $(TARGET_BUILD_DIR)/boot.scr.emmc

boot_records         = $(TARGET_BUILD_DIR)/$(HARDWARE).boot-records
boot_fat32fs         = $(TARGET_BUILD_DIR)/$(HARDWARE).fat32fs
install_boot_records = $(TARGET_BUILD_DIR)/.boot_records_done


PATCHES = PATCHES


ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_OMAP543X_GLIBC)),)
ARCH = arm
endif

USE_TARGET_DEST_DIR_SYSROOT = no


####### Targets

PKG_GROUP = boot


UBOOT_BIN_PKG_NAME                = u-boot
UBOOT_BIN_PKG_VERSION             = 2014.07
UBOOT_BIN_PKG_ARCH                = $(TOOLCHAIN)
UBOOT_BIN_PKG_DISTRO_NAME         = $(DISTRO_NAME)
UBOOT_BIN_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
UBOOT_BIN_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
UBOOT_BIN_PKG_SHORT_DESCRIPTION   = $(HW_SPEC) U-Boot
UBOOT_BIN_PKG_URL                 = $(BUG_URL)
UBOOT_BIN_PKG_LICENSE             = GPLv2
UBOOT_BIN_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(UBOOT_BIN_PKG_NAME)-pkg-description
UBOOT_BIN_PKG_DESCRIPTION_FILE_IN = $(UBOOT_BIN_PKG_NAME)-pkg-description.in
UBOOT_BIN_PKG_INSTALL_SCRIPT      = $(UBOOT_BIN_PKG_NAME)-pkg-install.sh

UBOOT_BIN_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(UBOOT_BIN_PKG_NAME)-package

build_uboot_pkg    = $(TARGET_BUILD_DIR)/.u_boot_pkg_done

pkg_basename       = $(UBOOT_BIN_PKG_NAME)-$(UBOOT_BIN_PKG_VERSION)-$(UBOOT_BIN_PKG_ARCH)-$(UBOOT_BIN_PKG_DISTRO_NAME)-$(UBOOT_BIN_PKG_DISTRO_VERSION)

pkg_archive        = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_certificate  = $(call cert-name,$(pkg_archive))
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
BUILD_TARGETS     += $(install_boot_records)

PRODUCT_TARGETS    = $(products)

ROOTFS_TARGETS     = $(pkg_archive)


include ../../../../build-system/core.mk


####### Dependencies

ifneq ($(filter $(HARDWARE),$(HARDWARE_OMAP5UEVM)),)
console_dev       = ttyO2
device_tree_name  = omap5-uevm.dtb
device_dtbs       = omap5-uevm.dtb
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_DRA7XXEVM)),)
console_dev       = ttyO0
device_tree_name  = dra7-evm.dtb
device_dtbs       = dra7-evm-lcd10.dtb
device_dtbs      += dra7-evm-lcd7.dtb
device_dtbs      += dra7-evm-vision.dtb
device_dtbs      += dra7-evm.dtb
device_dtbs      += dra72-evm-lcd10.dtb
device_dtbs      += dra72-evm-lcd7.dtb
device_dtbs      += dra72-evm-vision.dtb
device_dtbs      += dra72-evm.dtb
endif

extra  = rw
extra += rootwait
extra += earlyprintk
extra += fixrtc
extra += omapdrm.num_crtc=2
extra += consoleblank=0
extra += cma=64M
extra += rootfstype=ext4
extra += snd.slots_reserved=1,1


$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

UMAKE := $(BUILD_ENVIRONMENT) $(MAKE) -C $(SRC_DIR) CROSS_COMPILE="$(CROSS_PREFIX)"

$(u_boot): $(src_done)
	$(UMAKE)  $(u_boot_config)
	$(UMAKE)
	@touch $@

$(boot_script_nfs): $(u_boot)
	@( echo "mmc part"  > $(boot_script_nfs) && \
	   echo "fatload mmc 0:1 0x88000000 $(device_tree_name)" >> $(boot_script_nfs) && \
	   echo "fatload mmc 0:1 0x82000000 uImage" >> $(boot_script_nfs) && \
	   echo "setenv bootargs 'root=/dev/nfs nfsroot=$(DEFAULT_NFS_ROOT_IP_ADDR):/$(DEFAULT_NFS_ROOT_PATH) console=$(console_dev),115200n8 ip=dhcp $(extra)'" >> $(boot_script_nfs) && \
	   echo "bootm 0x82000000 - 0x88000000" >> $(boot_script_nfs) )

$(boot_script_sd): $(u_boot)
	@( echo "mmc part"  > $(boot_script_sd) && \
	   echo "fatload mmc 0:1 0x88000000 $(device_tree_name)" >> $(boot_script_sd) && \
	   echo "fatload mmc 0:1 0x82000000 uImage" >> $(boot_script_sd) && \
	   echo "setenv bootargs 'elevator=noop console=$(console_dev),115200n8 root=/dev/mmcblk0p2 $(extra)'" >> $(boot_script_sd) && \
	   echo "bootm 0x82000000 - 0x88000000" >> $(boot_script_sd) )

$(boot_script_emmc): $(u_boot)
	@( echo "mmc part"  > $(boot_script_emmc) && \
	   echo "fatload mmc 1:1 0x88000000 $(device_tree_name)" >> $(boot_script_emmc) && \
	   echo "fatload mmc 1:1 0x82000000 uImage" >> $(boot_script_emmc) && \
	   echo "setenv bootargs 'elevator=noop console=$(console_dev),115200n8 root=/dev/mmcblk0p2 $(extra)'" >> $(boot_script_emmc) && \
	   echo "bootm 0x82000000 - 0x88000000" >> $(boot_script_emmc) )

$(boot_scr_nfs): $(boot_script_nfs)
	$(SRC_DIR)/tools/mkimage -A $(ARCH) -T script -C none -n "Boot Image" -d $< $@

$(boot_scr_sd): $(boot_script_sd)
	$(SRC_DIR)/tools/mkimage -A $(ARCH) -T script -C none -n "Boot Image" -d $< $@

$(boot_scr_emmc): $(boot_script_emmc)
	$(SRC_DIR)/tools/mkimage -A $(ARCH) -T script -C none -n "Boot Image" -d $< $@

$(build_uboot_pkg): $(u_boot) $(boot_scr_nfs) $(boot_scr_sd) $(boot_scr_emmc)
	@mkdir -p $(TARGET_DEST_DIR)/bootfs
	@mkdir -p $(UBOOT_BIN_PKG)/boot
	# ======= Copy U-Boot images: =======
	@cp -a $(boot_scr_nfs)  $(TARGET_DEST_DIR)/bootfs
	@cp -a $(boot_scr_nfs)  $(UBOOT_BIN_PKG)/boot
	@cp -a $(boot_scr_sd)   $(TARGET_DEST_DIR)/bootfs
	@cp -a $(boot_scr_sd)   $(TARGET_DEST_DIR)/bootfs/boot.scr
	@cp -a $(boot_scr_sd)   $(UBOOT_BIN_PKG)/boot
	@cp -a $(boot_scr_sd)   $(UBOOT_BIN_PKG)/boot/boot.scr
	@cp -a $(boot_scr_emmc) $(TARGET_DEST_DIR)/bootfs
	@cp -a $(boot_scr_emmc) $(UBOOT_BIN_PKG)/boot
	@cd $(SRC_DIR) && \
	  cp -a MLO u-boot.img $(TARGET_DEST_DIR)/bootfs && \
	  cp -a MLO u-boot.img $(UBOOT_BIN_PKG)/boot
	@mkdir -p $(UBOOT_BIN_PKG)/usr/doc/u-boot-$(version)
	@cp -a $(SRC_DIR)/Licenses $(SRC_DIR)/CREDITS $(SRC_DIR)/README $(SRC_DIR)/boards.cfg \
	       $(UBOOT_BIN_PKG)/usr/doc/u-boot-$(version)
	@touch $@

$(boot_records): $(build_uboot_pkg)
	@$(DD) if=/dev/zero of=$@ bs=512 count=2048 conv=notrunc
	# ======= Setup empty boot-records because FS boot mode =======
	@touch $@

$(boot_fat32fs): $(build_uboot_pkg)
	@$(DD) if=/dev/zero of=$@ bs=1M count=511
	# ======= Create FAT32 boot partition image =======
	@$(MKDOSFS) -F 32 -n bootfs $@
	@$(MCOPY) -i $@ $(TARGET_DEST_DIR)/bootfs/MLO            ::/
	@$(MCOPY) -i $@ $(TARGET_DEST_DIR)/bootfs/u-boot.img     ::/
	@$(MCOPY) -i $@ $(TARGET_DEST_DIR)/bootfs/boot.scr       ::/
	@$(MCOPY) -i $@ $(TARGET_DEST_DIR)/bootfs/boot.scr.emmc  ::/
	@$(MCOPY) -i $@ $(TARGET_DEST_DIR)/bootfs/boot.scr.nfs   ::/
	@$(MCOPY) -i $@ $(TARGET_DEST_DIR)/bootfs/boot.scr.sd    ::/
	@for dtb in $(device_dtbs) ; do \
	   $(MCOPY) -i $@ $(TARGET_DEST_DIR)/bootfs/$$dtb ::/ ; \
	 done
	@$(MCOPY) -i $@ $(TARGET_DEST_DIR)/bootfs/uImage         ::/
	@$(DOSFSCK) -a $@
	@touch $@

$(install_boot_records): $(boot_records) $(boot_fat32fs)
	@$(BUILDSYSTEM)/install_targets         \
	   --destination=$(PRODUCTS_DEST_DIR)   \
	   --toolchain=$(TOOLCHAIN)             \
	   --hardware=$(HARDWARE)               \
	   --flavour=$(FLAVOUR)                 \
	   $^
	@touch $@

$(UBOOT_BIN_PKG_DESCRIPTION_FILE): $(UBOOT_BIN_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(UBOOT_BIN_PKG_VERSION)/g" | \
	          $(SED) -e "s/@HARDWARE_SPEC@/$(HW_SPEC)/g"> $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_boot_records) $(UBOOT_BIN_PKG_DESCRIPTION_FILE) $(UBOOT_BIN_PKG_INSTALL_SCRIPT)
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
	@$(PSEUDO) sh -c "cd $(UBOOT_BIN_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
