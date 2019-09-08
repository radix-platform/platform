
COMPONENT_TARGETS  = $(HARDWARE_ENYBOX_X2)

NEED_ABS_PATH      = true

COMPONENT_IS_3PP   = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/U-Boot/Amlogic/S9XX

REQUIRES           = boot/kernel/x2/3.14.29-20170119

# ======= __END_OF_REQUIRES__ =======


DEFAULT_NFS_ROOT_IP_ADDR = 172.16.0.3
DEFAULT_NFS_ROOT_PATH    = "nfsroot-x2"
DEFAULT_HW_ADDR          = 2a:ab:c0:36:aa:e3


version            = 2015.01-20170107
tar_xz_archive     = $(SRC_PACKAGE_PATH)/U-Boot/Amlogic/S9XX/u-boot-aml-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/u-boot-aml-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

u_boot             = $(TARGET_BUILD_DIR)/.u_boot_done

u_boot_config      = gxm_q201_v1_defconfig

#
# zImage from Linux kernel package:
#
kernel_version     = 3.14.29
linux_zImage       = $(TARGET_DEST_DIR)/bootfs/zImage

#
# Image for U-Boot:
#
load_address       = 0x01080000
entry_point        = $(load_address)
uImage             = $(TARGET_BUILD_DIR)/uImage

#
# Boot Scripts:
#
boot_script       = $(TARGET_BUILD_DIR)/boot.script
boot_scr          = $(TARGET_BUILD_DIR)/boot.scr

boot_sd_script    = $(TARGET_BUILD_DIR)/boot.sd.script
boot_sd_scr       = $(TARGET_BUILD_DIR)/boot.sd.scr


boot_records         = $(TARGET_BUILD_DIR)/$(HARDWARE).boot-records
install_boot_records = $(TARGET_BUILD_DIR)/.boot_records_done


rootfs_mbr_script = $(CURDIR)/scripts/rootfs-partition


PATCHES = PATCHES


ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_S9XX_GLIBC)),)
ARCH = arm64
endif

USE_TARGET_DEST_DIR_SYSROOT = no


####### Targets

PKG_GROUP = boot


UBOOT_BIN_PKG_NAME                = u-boot
UBOOT_BIN_PKG_VERSION             = 2015.01
UBOOT_BIN_PKG_ARCH                = $(TOOLCHAIN)
UBOOT_BIN_PKG_DISTRO_NAME         = $(DISTRO_NAME)
UBOOT_BIN_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
UBOOT_BIN_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
UBOOT_BIN_PKG_SHORT_DESCRIPTION   = Amlogic S905 U-Boot
UBOOT_BIN_PKG_URL                 = $(BUG_URL)
UBOOT_BIN_PKG_LICENSE             = custom
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
BUILD_TARGETS     += $(uImage)
BUILD_TARGETS     += $(boot_script)
BUILD_TARGETS     += $(boot_sd_script)
BUILD_TARGETS     += $(boot_scr)
BUILD_TARGETS     += $(boot_sd_scr)
BUILD_TARGETS     += $(build_uboot_pkg)
BUILD_TARGETS     += $(install_boot_records)

PRODUCT_TARGETS    = $(products)

ROOTFS_TARGETS     = $(pkg_archive)


include ../../../../build-system/core.mk

#
# armv7-m (cortex-m3) toolchain
#
ARMV7_M_TOOLCHAIN_PATH = /opt/toolchain/arm-A9XX-eabi-newlib/1.1.4
AML_FIRMWARE_SETTINGS  = FIRMWARE_CROSS_COMPILE=$(ARMV7_M_TOOLCHAIN_PATH)/bin/arm-a9xx-eabi-


logos_path    = $(CURDIR)/logo
logo_fname    = radix-2CPU-224x96-32bpp.bmp

u_boot_logos  = radix-2CPU-224x96.bmp
u_boot_logos += radix-2CPU-224x96-16bpp.bmp
u_boot_logos += radix-2CPU-224x96-24bpp.bmp
u_boot_logos += radix-2CPU-224x96-32bpp.bmp

hdmi_bpp            = 32
hdmi_color_index    = 32
hdmi_color_fg       = 0xffffffff

hdmi_display_width  = 1920
hdmi_display_height = 1080
hdmi_output_mode    = 1080p60hz
video_output_mode   = hdmi

#
# alternative settings:
# --------------------
# hdmi_display_width  = 1280
# hdmi_display_height =  720
# hdmi_output_mode    =  720p60hz
# video_output_mode   = hdmi
#

device_dtb = x2.dtb

#
# Extra kernel boot arguments:
#
extra  = logo=osd1,loaded,0x3d800000,$(hdmi_output_mode)
extra += consoleblank=0
extra += hdmimode=$(hdmi_output_mode)

#
# Load Addresses:
#
# loadaddr        = 0x11000000
# dtb_loadaddr    = 0x01000000
# script_loadaddr = 0x12ff0000 - allows 64k for boot scripts
# initrd_loadaddr = 0x13000000 - also for temporary loaded Logo bitmaps
#


####### Dependencies


$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

UMAKE := CONFIG_NOSOFTFLOAT=1 $(MAKE) -C $(SRC_DIR) CROSS_COMPILE="$(CROSS_PREFIX)" $(AML_FIRMWARE_SETTINGS)

$(u_boot): $(src_done)
	$(UMAKE)  $(u_boot_config)
	$(UMAKE)
	@touch $@

$(uImage): $(u_boot)
	$(SRC_DIR)/build/tools/mkimage \
	   -A $(ARCH) -O linux -T kernel -C gzip -a $(load_address) -e $(entry_point) \
	   -n $(kernel_version) -d $(linux_zImage) $@

$(boot_script): $(uImage)
	@( echo "mmcinfo"                                           > $(boot_script) && \
	   echo "ext4load mmc 1:1 0x13000000 /boot/$(logo_fname)"  >> $(boot_script) && \
	   echo "setenv display_bpp $(hdmi_bpp)"                   >> $(boot_script) && \
	   echo "setenv display_color_index $(hdmi_color_index)"   >> $(boot_script) && \
	   echo "setenv display_color_fg $(hdmi_color_fg)"         >> $(boot_script) && \
	   echo "osd open"                                         >> $(boot_script) && \
	   echo "osd clear"                                        >> $(boot_script) && \
	   echo "bmp display 0x13000000"                           >> $(boot_script) && \
	   echo "bmp scale"                                        >> $(boot_script) && \
	   echo "ext4load mmc 1:1 0x11000000 /boot/uImage"         >> $(boot_script) && \
	   echo "ext4load mmc 1:1 0x01000000 /boot/$(device_dtb)"  >> $(boot_script) && \
	   echo "setenv bootargs 'console=ttyS0,115200n8 ro root=/dev/mmcblk1p5 rootfstype=ext4 no_console_suspend $(extra)'" >> $(boot_script) && \
	   echo "bootm 0x11000000 - 0x01000000"                    >> $(boot_script) \
	 )

$(boot_scr): $(boot_script)
	$(SRC_DIR)/build/tools/mkimage -A $(ARCH) -T script -C none -n "Boot Script" -d $< $@

$(boot_sd_script): $(uImage)
	@( echo "mmcinfo"                                           > $(boot_sd_script) && \
	   echo "ext4load mmc 0:1 0x13000000 /boot/$(logo_fname)"  >> $(boot_sd_script) && \
	   echo "setenv display_bpp $(hdmi_bpp)"                   >> $(boot_sd_script) && \
	   echo "setenv display_color_index $(hdmi_color_index)"   >> $(boot_sd_script) && \
	   echo "setenv display_color_fg $(hdmi_color_fg)"         >> $(boot_sd_script) && \
	   echo "osd open"                                         >> $(boot_sd_script) && \
	   echo "osd clear"                                        >> $(boot_sd_script) && \
	   echo "bmp display 0x13000000"                           >> $(boot_sd_script) && \
	   echo "bmp scale"                                        >> $(boot_sd_script) && \
	   echo "ext4load mmc 0:1 0x11000000 /boot/uImage"         >> $(boot_sd_script) && \
	   echo "ext4load mmc 0:1 0x01000000 /boot/$(device_dtb)"  >> $(boot_sd_script) && \
	   echo "setenv bootargs 'console=ttyS0,115200n8 ro root=/dev/mmcblk0p1 rootfstype=ext4 no_console_suspend $(extra)'" >> $(boot_sd_script) && \
	   echo "bootm 0x11000000 - 0x01000000"                    >> $(boot_sd_script) \
	 )

$(boot_sd_scr): $(boot_sd_script)
	$(SRC_DIR)/build/tools/mkimage -A $(ARCH) -T script -C none -n "Boot Script" -d $< $@

$(build_uboot_pkg): $(boot_scr) $(boot_sd_scr)
	@mkdir -p $(TARGET_DEST_DIR)/bootfs
	@mkdir -p $(UBOOT_BIN_PKG)/boot
	# ======= install U-Boot images =======
	@cp -a $(uImage) $(boot_scr) $(boot_sd_scr) $(UBOOT_BIN_PKG)/boot
	@for logo in $(u_boot_logos) ; do \
	   cp -a $(logos_path)/$$logo $(UBOOT_BIN_PKG)/boot ; \
	 done
	# ======= install eMMC U-Boot =======
	@cp -a $(SRC_DIR)/fip/u-boot.bin $(UBOOT_BIN_PKG)/boot/u-boot.bin
	@chmod 644 $(UBOOT_BIN_PKG)/boot/u-boot.bin
	# ======= install SD Card U-Boot =======
	@cp -a $(SRC_DIR)/fip/u-boot.bin.sd.bin $(UBOOT_BIN_PKG)/boot/u-boot.sd.bin
	@chmod 644 $(UBOOT_BIN_PKG)/boot/u-boot.sd.bin
	# ======= copy U-Boot images and binaries into devenv =======
	@cp -a $(uImage) $(boot_scr) $(boot_sd_scr) $(TARGET_DEST_DIR)/bootfs
	@for logo in $(u_boot_logos) ; do \
	   cp -a $(logos_path)/$$logo $(TARGET_DEST_DIR)/bootfs ; \
	 done
	@for binary in u-boot.bin u-boot.sd.bin ; do \
	   cp -a $(UBOOT_BIN_PKG)/boot/$$binary $(TARGET_DEST_DIR)/bootfs ; \
	 done
	# ======= install rootfs-partition script =======
	@cat $(rootfs_mbr_script) > $(UBOOT_BIN_PKG)/boot/rootfs-partition
	# ======= Install Documentation =======
	@mkdir -p $(UBOOT_BIN_PKG)/usr/doc/u-boot-aml-$(version)
	@cp -a $(SRC_DIR)/Licenses $(SRC_DIR)/MAINTAINERS $(SRC_DIR)/README \
	       $(UBOOT_BIN_PKG)/usr/doc/u-boot-aml-$(version)
	@touch $@

$(boot_records): $(build_uboot_pkg)
	@$(DD) if=/dev/zero of=$@ bs=512 count=2048 conv=notrunc
	# ======= Setup u-boot into unallocated space of disk image =======
	@$(DD) if=$(UBOOT_BIN_PKG)/boot/u-boot.sd.bin of=$@ bs=1 count=442       conv=notrunc
	@$(DD) if=$(UBOOT_BIN_PKG)/boot/u-boot.sd.bin of=$@ bs=512 skip=1 seek=1 conv=notrunc
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
