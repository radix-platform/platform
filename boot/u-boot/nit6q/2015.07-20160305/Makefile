
COMPONENT_TARGETS  = $(HARDWARE_NIT6Q)

NEED_ABS_PATH      = true

COMPONENT_IS_3PP   = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES   = sources/U-Boot/Boundary/Nit6Q

REQUIRES          = boot/kernel/nit6q/3.14.28-20160304

# ======= __END_OF_REQUIRES__ =======


DEFAULT_NFS_ROOT_IP_ADDR =  172.16.0.3
DEFAULT_NFS_ROOT_PATH    = "nfsroot-$(HARDWARE)"
DEFAULT_HW_ADDR          =  2a:ab:c0:90:96:ba


version           = 2015.07-20160305
tar_xz_archive    = $(SRC_PACKAGE_PATH)/U-Boot/Boundary/Nit6Q/u-boot-imx6-$(version).tar.xz
SRC_ARCHIVE       = $(tar_xz_archive)
SRC_DIR           = $(TARGET_BUILD_DIR)/u-boot-imx6-$(version)
src_done          = $(TARGET_BUILD_DIR)/.source_done

u_boot            = $(TARGET_BUILD_DIR)/.u_boot_done

ifneq ($(filter $(HARDWARE),$(HARDWARE_NIT6Q)),)
u_boot_name       = nitrogen6q
u_boot_config     = $(u_boot_name)_defconfig
endif

upgrade_src_script   = scripts/6x_upgrade
upgrade_script       = $(TARGET_BUILD_DIR)/6x_upgrade

boot_src_script      = scripts/6x_bootscript
boot_script          = $(TARGET_BUILD_DIR)/6x_bootscript

boot_records         = $(TARGET_BUILD_DIR)/$(HARDWARE).boot-records
boot_fat32fs         = $(TARGET_BUILD_DIR)/$(HARDWARE).fat32fs
install_boot_records = $(TARGET_BUILD_DIR)/.boot_records_done


PATCHES = PATCHES


ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_IMX6_GLIBC)),)
ARCH = arm
endif

USE_TARGET_DEST_DIR_SYSROOT = no


####### Targets

PKG_GROUP = boot


UBOOT_BIN_PKG_NAME                = u-boot
UBOOT_BIN_PKG_VERSION             = 2015.07
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

ifneq ($(filter $(HARDWARE),$(HARDWARE_NIT6Q)),)
device_dtbs  = imx6dl-nit6xlite.dtb
device_dtbs += imx6dl-nitrogen6_vm-magstripe.dtb
device_dtbs += imx6dl-nitrogen6_vm.dtb
device_dtbs += imx6dl-nitrogen6x.dtb
device_dtbs += imx6q-nitrogen6_max.dtb
device_dtbs += imx6q-nitrogen6x.dtb
device_dtbs += imx6q-sabrelite.dtb
endif


$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

UMAKE := $(BUILD_ENVIRONMENT) $(MAKE) -C $(SRC_DIR) CROSS_COMPILE="$(CROSS_PREFIX)"

$(u_boot): $(src_done)
	$(UMAKE)  $(u_boot_config)
	$(UMAKE)
	@touch $@

$(upgrade_script): $(upgrade_src_script) $(u_boot)
	$(SRC_DIR)/tools/mkimage -A $(ARCH) -O linux -T script -C none -a 0 -e 0 -n 'upgrade script' -d $< $@

$(boot_script): $(boot_src_script) $(u_boot)
	$(SRC_DIR)/tools/mkimage -A $(ARCH) -O linux -T script -C none -a 0 -e 0 -n 'boot script' -d $< $@

$(build_uboot_pkg): $(u_boot) $(upgrade_script) $(boot_script)
	@mkdir -p $(TARGET_DEST_DIR)/bootfs
	@mkdir -p $(UBOOT_BIN_PKG)/boot
	# ======= Copy U-Boot images: =======
	@cp -a $(upgrade_script)  $(TARGET_DEST_DIR)/bootfs
	@cp -a $(upgrade_script)  $(UBOOT_BIN_PKG)/boot
	@cp -a $(boot_script)  $(TARGET_DEST_DIR)/bootfs
	@cp -a $(boot_script)  $(UBOOT_BIN_PKG)/boot
	@cd $(SRC_DIR) && \
	  cp -a u-boot.imx $(TARGET_DEST_DIR)/bootfs/u-boot.$(u_boot_name) && \
	  cp -a u-boot.imx $(UBOOT_BIN_PKG)/boot/u-boot.$(u_boot_name)
	@mkdir -p $(UBOOT_BIN_PKG)/usr/doc/u-boot-$(version)
	@cp -a $(SRC_DIR)/Licenses $(SRC_DIR)/MAINTAINERS $(SRC_DIR)/README \
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
	@$(MCOPY) -i $@ $(TARGET_DEST_DIR)/bootfs/u-boot.$(u_boot_name) ::/
	@$(MCOPY) -i $@ $(upgrade_script)                               ::/
	@$(MCOPY) -i $@ $(boot_script)                                  ::/
	@for dtb in $(device_dtbs) ; do \
	   $(MCOPY) -i $@ $(TARGET_DEST_DIR)/bootfs/$$dtb ::/ ; \
	 done
	@$(MCOPY) -i $@ $(TARGET_DEST_DIR)/bootfs/uImage                ::/
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

$(pkg_certificate) : $(pkg_archive) ;
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
