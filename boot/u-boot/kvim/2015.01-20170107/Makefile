
COMPONENT_TARGETS  = $(HARDWARE_P212)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_VIM)

NEED_ABS_PATH     = true

COMPONENT_IS_3PP  = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES   = sources/U-Boot/Khadas/S905X

REQUIRES          = boot/kernel/kvim/3.14.29-20170107

# ======= __END_OF_REQUIRES__ =======


DEFAULT_NFS_ROOT_IP_ADDR = 172.16.0.3
DEFAULT_NFS_ROOT_PATH    = "nfsroot-khadas-vim"
DEFAULT_HW_ADDR          = 2a:ab:c0:7e:f2:c1


version         = 2015.01-20170107
tar_xz_archive  = $(SRC_PACKAGE_PATH)/U-Boot/Khadas/S905X/u-boot-khadas-$(version).tar.xz
SRC_ARCHIVE     = $(tar_xz_archive)
SRC_DIR         = $(TARGET_BUILD_DIR)/u-boot-khadas-$(version)
src_done        = $(TARGET_BUILD_DIR)/.source_done

u_boot          = $(TARGET_BUILD_DIR)/.u_boot_done

u_boot_config   = kvim_defconfig

#
# Images from Linux kernel package:
#
kernel_version  = 3.14.29

linux_Image     = $(TARGET_DEST_DIR)/bootfs/Image
linux_Image_gz  = $(TARGET_DEST_DIR)/bootfs/Image.gz
linux_Image_lzo = $(TARGET_DEST_DIR)/bootfs/Image.lzo

linux_images    = Image Image.gz Image.lzo

#
# Images for U-Boot:
#
uimage_load_address = 0x01080000

uImage          = $(TARGET_BUILD_DIR)/uImage
uImage_gz       = $(TARGET_BUILD_DIR)/uImage.gz
uImage_lzo      = $(TARGET_BUILD_DIR)/uImage.lzo

linux_uimages   = uImage uImage.gz uImage.lzo

#
# Boot Scripts:
#
boot_script_sd  = $(TARGET_BUILD_DIR)/boot.script.sd
boot_scr_sd     = $(TARGET_BUILD_DIR)/boot.scr.sd

boot_records         = $(TARGET_BUILD_DIR)/$(HARDWARE).boot-records
boot_fat32fs         = $(TARGET_BUILD_DIR)/$(HARDWARE).fat32fs
install_boot_records = $(TARGET_BUILD_DIR)/.boot_records_done


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
UBOOT_BIN_PKG_SHORT_DESCRIPTION   = Khadas VIM S905X U-Boot
UBOOT_BIN_PKG_URL                 = $(BUG_URL)
UBOOT_BIN_PKG_LICENSE             = custom
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
BUILD_TARGETS     += $(uImage)
BUILD_TARGETS     += $(uImage_gz)
BUILD_TARGETS     += $(uImage_lzo)
BUILD_TARGETS     += $(boot_script_sd)
BUILD_TARGETS     += $(boot_scr_sd)
BUILD_TARGETS     += $(build_uboot_pkg)
BUILD_TARGETS     += $(install_boot_records)

PRODUCT_TARGETS    = $(products)

ROOTFS_TARGETS     = $(pkg_archive)


include ../../../../build-system/core.mk

#
# armv7-m (cortex-m3) toolchain
#
ARMV7_M_TOOLCHAIN_PATH = /opt/toolchain/arm-A9XX-eabi-newlib/1.1.2

AML_FIRMWARE_SETTINGS  = FIRMWARE_CROSS_COMPILE=$(ARMV7_M_TOOLCHAIN_PATH)/bin/arm-a9xx-eabi-


u_boot_binaries  = u-boot.bin
u_boot_binaries += u-boot.bin.encrypt
u_boot_binaries += u-boot.bin.encrypt.efuse
u_boot_binaries += u-boot.bin.encrypt.sd.bin
u_boot_binaries += u-boot.bin.encrypt.usb.bl2
u_boot_binaries += u-boot.bin.encrypt.usb.tpl
u_boot_binaries += u-boot.bin.sd.bin
u_boot_binaries += u-boot.bin.usb.bl2
u_boot_binaries += u-boot.bin.usb.tpl



logos_path    = $(CURDIR)/logo
logo_fname    = radix-2CPU-224x96-32bpp.bmp

u_boot_logos  = radix-2CPU-224x96.bmp
u_boot_logos += radix-2CPU-224x96-16bpp.bmp
u_boot_logos += radix-2CPU-224x96-24bpp.bmp
u_boot_logos += radix-2CPU-224x96-32bpp.bmp

hdmi_display_width  = 1920
hdmi_display_height = 1080
hdmi_output_mode    = 1080p
video_output_mode   = hdmi

#
# alternative settings:
# --------------------
# hdmi_display_width  = 1280
# hdmi_display_height =  720
# hdmi_output_mode    =  720p
# video_output_mode   = hdmi
#

device_dtb      = kvim.dtb

#
# Extra kernel boot arguments:
#
extra  = logo=osd1,loaded,0x3d800000,$(hdmi_output_mode),full
extra += consoleblank=0
#extra += fsck.fix=yes
#extra += fsck.repair=yes
#extra += net.ifnames=0

#extra += vdaccfg=0xa001
#extra += cvbsmode=576cvbs
#extra += hdmimode=$(hdmi_output_mode)
#extra += hdmitx=cec0xf
#extra += vout=$(video_output_mode)
#extra += m_bpp=32
#extra += mac=$(DEFAULT_HW_ADDR)


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
	   -A $(ARCH) -O linux -T kernel -C none \
	   -a $(uimage_load_address) -e $(uimage_load_address) \
	   -n $(kernel_version) -d $(linux_Image) $@

$(uImage_gz): $(u_boot)
	$(SRC_DIR)/build/tools/mkimage \
	   -A $(ARCH) -O linux -T kernel -C gzip \
	   -a $(uimage_load_address) -e $(uimage_load_address) \
	   -n $(kernel_version) -d $(linux_Image_gz) $@

$(uImage_lzo): $(u_boot)
	$(SRC_DIR)/build/tools/mkimage \
	   -A $(ARCH) -O linux -T kernel -C lzo \
	   -a $(uimage_load_address) -e $(uimage_load_address) \
	   -n $(kernel_version) -d $(linux_Image_lzo) $@

$(boot_script_sd): $(uImage) $(uImage_gz) $(uImage_lzo)
	@( echo "mmcinfo"                                           > $(boot_script_sd) && \
	   echo "fatload mmc 0:1 0x01080000 $(logo_fname)"         >> $(boot_script_sd) && \
	   echo "setenv display_width $(hdmi_display_width)"       >> $(boot_script_sd) && \
	   echo "setenv display_height $(hdmi_display_height)"     >> $(boot_script_sd) && \
	   echo "setenv hdmimode $(hdmi_output_mode)"              >> $(boot_script_sd) && \
	   echo "setenv outputmode $(hdmi_output_mode)"            >> $(boot_script_sd) && \
	   echo "video dev open $(hdmi_output_mode)"               >> $(boot_script_sd) && \
	   echo "bmp display 0x01080000"                           >> $(boot_script_sd) && \
	   echo "bmp scale"                                        >> $(boot_script_sd) && \
	   echo "fatload mmc 0:1 0x01080000 uImage"                >> $(boot_script_sd) && \
	   echo "fatload mmc 0:1 0x01000000 $(device_dtb)"         >> $(boot_script_sd) && \
	   echo "setenv bootargs 'console=ttyS0,115200n8 console=tty0 ro root=/dev/mmcblk0p2 rootfstype=ext4 no_console_suspend $(extra)'" >> $(boot_script_sd) && \
	   echo "bootm 0x01080000 - 0x01000000"                    >> $(boot_script_sd) \
	 )

$(boot_scr_sd): $(boot_script_sd)
	$(SRC_DIR)/build/tools/mkimage -A $(ARCH) -T script -C none -n "Boot Script" -d $< $@

$(build_uboot_pkg): $(boot_scr_sd)
	@mkdir -p $(TARGET_DEST_DIR)/bootfs
	@mkdir -p $(UBOOT_BIN_PKG)/boot
	# ======= Copy U-Boot images =======
	@cp -a $(uImage) $(uImage_gz) $(uImage_lzo) \
	                        $(TARGET_DEST_DIR)/bootfs
	@cp -a $(boot_scr_sd)   $(TARGET_DEST_DIR)/bootfs
	@cp -a $(boot_scr_sd)   $(TARGET_DEST_DIR)/bootfs/boot.scr
	@for logo in $(u_boot_logos) ; do \
	   cp -a $(logos_path)/$$logo $(TARGET_DEST_DIR)/bootfs ; \
	 done
	@cp -a $(uImage) $(uImage_gz) $(uImage_lzo) \
	                        $(UBOOT_BIN_PKG)/boot
	@cp -a $(boot_scr_sd)   $(UBOOT_BIN_PKG)/boot
	@cp -a $(boot_scr_sd)   $(UBOOT_BIN_PKG)/boot/boot.scr
	@for logo in $(u_boot_logos) ; do \
	   cp -a $(logos_path)/$$logo $(UBOOT_BIN_PKG)/boot ; \
	 done
	@for binary in $(u_boot_binaries) ; do \
	   chmod a-x $(SRC_DIR)/fip/$$binary ; \
	   cp -a $(SRC_DIR)/fip/$$binary $(TARGET_DEST_DIR)/bootfs ; \
	   cp -a $(SRC_DIR)/fip/$$binary $(UBOOT_BIN_PKG)/boot     ; \
	 done
	@mkdir -p $(UBOOT_BIN_PKG)/usr/doc/u-boot-khadas-$(version)
	@cp -a $(SRC_DIR)/Licenses $(SRC_DIR)/MAINTAINERS $(SRC_DIR)/README \
	       $(UBOOT_BIN_PKG)/usr/doc/u-boot-khadas-$(version)
	@touch $@

$(boot_records): $(build_uboot_pkg)
	@$(DD) if=/dev/zero of=$@ bs=512 count=2048 conv=notrunc
	# ======= Setup u-boot into unallocated space of disk image =======
	@$(DD) if=$(UBOOT_BIN_PKG)/boot/u-boot.bin.sd.bin of=$@ bs=1 count=442       conv=notrunc
	@$(DD) if=$(UBOOT_BIN_PKG)/boot/u-boot.bin.sd.bin of=$@ bs=512 skip=1 seek=1 conv=notrunc
	@touch $@

$(boot_fat32fs): $(build_uboot_pkg)
	@$(DD) if=/dev/zero of=$@ bs=1M count=511
	# ======= Create FAT32 boot partition image =======
	@$(MKDOSFS) -F 32 -n bootfs $@
	@$(MCOPY) -i $@ $(TARGET_DEST_DIR)/bootfs/u-boot.bin ::/
	@$(MCOPY) -i $@ $(TARGET_DEST_DIR)/bootfs/u-boot.bin.sd.bin ::/
	@$(MCOPY) -i $@ $(TARGET_DEST_DIR)/bootfs/boot.scr   ::/
	@for logo in $(u_boot_logos) ; do \
	   $(MCOPY) -i $@ $(logos_path)/$$logo               ::/ ; \
	 done
	@for dtb in $(device_dtb) ; do \
	   $(MCOPY) -i $@ $(TARGET_DEST_DIR)/bootfs/$$dtb    ::/ ; \
	 done
	@for image in $(linux_images) ; do \
	   $(MCOPY) -i $@ $(TARGET_DEST_DIR)/bootfs/$$image  ::/ ; \
	 done
	@for image in $(linux_uimages) ; do \
	   $(MCOPY) -i $@ $(TARGET_DEST_DIR)/bootfs/$$image  ::/ ; \
	 done
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
	@$(PSEUDO) sh -c "cd $(UBOOT_BIN_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
