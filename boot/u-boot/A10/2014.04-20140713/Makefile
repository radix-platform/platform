
COMPONENT_TARGETS = $(HARDWARE_CB1X)

NEED_ABS_PATH     = true

COMPONENT_IS_3PP  = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES   = sources/U-Boot/Allwinner/sunxi

REQUIRES          = boot/kernel/A10/3.4-20140514

# ======= __END_OF_REQUIRES__ =======


DEFAULT_NFS_ROOT_IP_ADDR = 172.16.0.3
DEFAULT_NFS_ROOT_PATH    = "nfsroot-cb1x"
DEFAULT_HW_ADDR          = 2a:ab:c0:a5:8d:ad


version         = 2014.04-20140713
tar_xz_archive  = $(SRC_PACKAGE_PATH)/U-Boot/Allwinner/sunxi/u-boot-sunxi-$(version).tar.xz
SRC_ARCHIVE     = $(tar_xz_archive)
SRC_DIR         = $(TARGET_BUILD_DIR)/u-boot-sunxi-$(version)
src_done        = $(TARGET_BUILD_DIR)/.source_done

u_boot          = $(TARGET_BUILD_DIR)/.u_boot_done

u_boot_config   = Cubieboard_config

FEX2BIN         = $(TOOLCHAIN_PATH)/bin/fex2bin
script_fex_in   = $(CURDIR)/fex/script.fex.in
script_fex      = $(TARGET_BUILD_DIR)/script.fex
script_bin      = $(TARGET_BUILD_DIR)/script.bin

boot_script_sd  = $(TARGET_BUILD_DIR)/boot.script.sd
boot_scr_sd     = $(TARGET_BUILD_DIR)/boot.scr.sd

boot_records         = $(TARGET_BUILD_DIR)/$(HARDWARE).boot-records
install_boot_records = $(TARGET_BUILD_DIR)/.boot_records_done


PATCHES = PATCHES


ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_A1X_GLIBC)),)
ARCH = arm
endif

USE_TARGET_DEST_DIR_SYSROOT = no


####### Targets

PKG_GROUP = boot


UBOOT_BIN_PKG_NAME                = u-boot
UBOOT_BIN_PKG_VERSION             = 2014.04
UBOOT_BIN_PKG_ARCH                = $(TOOLCHAIN)
UBOOT_BIN_PKG_DISTRO_NAME         = $(DISTRO_NAME)
UBOOT_BIN_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
UBOOT_BIN_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
UBOOT_BIN_PKG_SHORT_DESCRIPTION   = A10 U-Boot
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
BUILD_TARGETS     += $(script_fex)
BUILD_TARGETS     += $(script_bin)
BUILD_TARGETS     += $(boot_script_sd)
BUILD_TARGETS     += $(boot_scr_sd)
BUILD_TARGETS     += $(build_uboot_pkg)
BUILD_TARGETS     += $(install_boot_records)

PRODUCT_TARGETS    = $(products)

ROOTFS_TARGETS     = $(pkg_archive)


include ../../../../build-system/core.mk


extra  = hdmi.audio=EDID:0
extra += disp.screen0_output_mode=EDID:1920x1080p60
extra += sunxi_fb_mem_reserve=64
extra += sunxi_g2d_mem_reserve=128
extra += cma=128M
extra += sunxi_gmac.mac_str=$(DEFAULT_HW_ADDR)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

UMAKE := $(BUILD_ENVIRONMENT) $(MAKE) -C $(SRC_DIR) CROSS_COMPILE="$(CROSS_PREFIX)"

$(u_boot): $(src_done)
	$(UMAKE)  $(u_boot_config)
	$(UMAKE)
	@touch $@

$(script_fex): $(script_fex_in) $(u_boot)
	# ======= Set dynamic HW address =======
	@( mac=`echo $(DEFAULT_HW_ADDR) | sed -e 's/://g'`   ; \
	   cat $< | sed -e "\$$s/$$/\n/"                     | \
	            sed -e "\$$s/$$/\n[dynamic]/"            | \
	            sed -e "\$$s/$$/\nMAC = \"$$mac\"/" > $@ ; \
	 )

$(script_bin): $(script_fex)
	# ======= Create script.bin =======
	@$(FEX2BIN) $< $@

$(boot_script_sd): $(u_boot) $(script_bin)
	@( echo "fatload mmc 0 0x43000000 script.bin || ext2load mmc 0 0x43000000 boot/script.bin"       > $(boot_script_sd) && \
	   echo "fatload mmc 0 0x48000000 uImage || ext2load mmc 0 0x48000000 boot/uImage"              >> $(boot_script_sd) && \
	   echo "setenv bootargs 'console=ttyS0,115200 root=/dev/mmcblk0p1 rootwait panic=10 ${extra}'" >> $(boot_script_sd) && \
	   echo "bootm 0x48000000"                                                                      >> $(boot_script_sd) \
	 )

$(boot_scr_sd): $(boot_script_sd)
	$(SRC_DIR)/tools/mkimage -A $(ARCH) -T script -C none -n "Boot Image" -d $< $@

$(build_uboot_pkg): $(boot_scr_sd)
	@mkdir -p $(TARGET_DEST_DIR)/bootfs
	@mkdir -p $(UBOOT_BIN_PKG)/boot
	# ======= Copy U-Boot images =======
	@cp -a $(script_bin)    $(TARGET_DEST_DIR)/bootfs
	@cp -a $(script_bin)    $(UBOOT_BIN_PKG)/boot
	@cp -a $(boot_scr_sd)   $(TARGET_DEST_DIR)/bootfs
	@cp -a $(boot_scr_sd)   $(TARGET_DEST_DIR)/bootfs/boot.scr
	@cp -a $(boot_scr_sd)   $(UBOOT_BIN_PKG)/boot
	@cp -a $(boot_scr_sd)   $(UBOOT_BIN_PKG)/boot/boot.scr
	@cd $(SRC_DIR) && \
	  cp -a spl/sunxi-spl.bin u-boot-sunxi-with-spl.bin u-boot.{bin,img,lds,map} $(TARGET_DEST_DIR)/bootfs && \
	  cp -a spl/sunxi-spl.bin u-boot-sunxi-with-spl.bin u-boot.{bin,img,lds,map} $(UBOOT_BIN_PKG)/boot
	@( cd $(UBOOT_BIN_PKG)/boot ; \
	   chmod a-x u-boot.bin ; \
	 )
	@mkdir -p $(UBOOT_BIN_PKG)/usr/doc/u-boot-sunxi-$(version)
	@cp -a $(SRC_DIR)/Licenses $(SRC_DIR)/CREDITS $(SRC_DIR)/README $(SRC_DIR)/boards.cfg \
	       $(UBOOT_BIN_PKG)/usr/doc/u-boot-sunxi-$(version)
	@touch $@

$(boot_records): $(build_uboot_pkg)
	@$(DD) if=/dev/zero of=$@ bs=512 count=2048 conv=notrunc
	# ======= Setup u-boot-spl & u-boot into unallocated space of disk image =======
	@$(DD) if=$(UBOOT_BIN_PKG)/boot/u-boot-sunxi-with-spl.bin of=$@ bs=1024 seek=8 conv=notrunc
	@touch $@

$(install_boot_records): $(boot_records)
	@$(BUILDSYSTEM)/install_targets         \
	   --destination=$(PRODUCTS_DEST_DIR)   \
	   --toolchain=$(TOOLCHAIN)             \
	   --hardware=$(HARDWARE)               \
	   --flavour=$(FLAVOUR)                 \
	   $^
	@touch $@

$(UBOOT_BIN_PKG_DESCRIPTION_FILE): $(UBOOT_BIN_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

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
