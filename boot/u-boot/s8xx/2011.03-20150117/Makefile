
COMPONENT_TARGETS  = $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXV)

NEED_ABS_PATH     = true

COMPONENT_IS_3PP  = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES   = sources/U-Boot/Amlogic/M201

ifneq ($(filter $(HARDWARE),$(HARDWARE_M201)),)
REQUIRES          = boot/kernel/s8xx/3.10.33-20150117
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_MXV)),)
REQUIRES          = boot/kernel/s8xx/3.10.103-20160830
endif

# ======= __END_OF_REQUIRES__ =======


DEFAULT_NFS_ROOT_IP_ADDR = 172.16.0.3
ifneq ($(filter $(HARDWARE),$(HARDWARE_M201)),)
DEFAULT_NFS_ROOT_PATH    = "nfsroot-m201"
DEFAULT_HW_ADDR          = 2a:ab:c0:c4:41:4a
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_MXV)),)
DEFAULT_NFS_ROOT_PATH    = "nfsroot-mxq"
DEFAULT_HW_ADDR          = 2a:ab:c0:58:b1:8d
endif


version         = 2011.03-20150117
tar_xz_archive  = $(SRC_PACKAGE_PATH)/U-Boot/Amlogic/M201/u-boot-aml-$(version).tar.xz
SRC_ARCHIVE     = $(tar_xz_archive)
SRC_DIR         = $(TARGET_BUILD_DIR)/u-boot-aml-$(version)
src_done        = $(TARGET_BUILD_DIR)/.source_done

u_boot          = $(TARGET_BUILD_DIR)/.u_boot_done

ifneq ($(filter $(HARDWARE),$(HARDWARE_M201)),)
u_boot_config   = m8b_m201_512M_config
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_MXV)),)
u_boot_config   = m8b_m201_1G_config
endif

boot_script_sd  = $(TARGET_BUILD_DIR)/boot.script.sd
boot_scr_sd     = $(TARGET_BUILD_DIR)/boot.scr.sd

boot_records         = $(TARGET_BUILD_DIR)/$(HARDWARE).boot-records
boot_fat32fs         = $(TARGET_BUILD_DIR)/$(HARDWARE).fat32fs
install_boot_records = $(TARGET_BUILD_DIR)/.boot_records_done


PATCHES = PATCHES


ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_S8XX_GLIBC)),)
ARCH = arm
endif

USE_TARGET_DEST_DIR_SYSROOT = no


####### Targets

PKG_GROUP = boot


UBOOT_BIN_PKG_NAME                = u-boot
UBOOT_BIN_PKG_VERSION             = 2011.03
UBOOT_BIN_PKG_ARCH                = $(TOOLCHAIN)
UBOOT_BIN_PKG_DISTRO_NAME         = $(DISTRO_NAME)
UBOOT_BIN_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
UBOOT_BIN_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
UBOOT_BIN_PKG_SHORT_DESCRIPTION   = Amlogic S805 meson8b M201 U-Boot
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
BUILD_TARGETS     += $(boot_script_sd)
BUILD_TARGETS     += $(boot_scr_sd)
BUILD_TARGETS     += $(build_uboot_pkg)
BUILD_TARGETS     += $(install_boot_records)

PRODUCT_TARGETS    = $(products)

ROOTFS_TARGETS     = $(pkg_archive)


include ../../../../build-system/core.mk


AMLOGIC_EM4_TOOLCHAIN_PATH  = /opt/toolchain/3pp/Amlogic-S805/arc-EM4
AMLOGIC_S805_TOOLCHAIN_PATH = /opt/toolchain/3pp/Amlogic-S805/arm-S805-lite
AMLOGIC_CROSS_PREFIX        = $(AMLOGIC_S805_TOOLCHAIN_PATH)/bin/arm-none-eabi-

AML_COMLILERS  = ARCCC=$(AMLOGIC_EM4_TOOLCHAIN_PATH)/bin/arc-elf32-em4-gcc
AML_COMLILERS += ARCASM=$(AMLOGIC_EM4_TOOLCHAIN_PATH)/bin/arc-elf32-em4-as
AML_COMLILERS += ARCLD=$(AMLOGIC_EM4_TOOLCHAIN_PATH)/bin/arc-elf32-em4-ld
AML_COMLILERS += ARCOBJCOPY=$(AMLOGIC_EM4_TOOLCHAIN_PATH)/bin/arc-elf32-em4-objcopy
AML_COMLILERS += ARCDUMPELF=$(AMLOGIC_EM4_TOOLCHAIN_PATH)/bin/arc-elf32-em4-elfdump
AML_COMLILERS += ARCOBJDUMP=$(AMLOGIC_EM4_TOOLCHAIN_PATH)/bin/arc-elf32-em4-objdump
AML_COMLILERS += ARCCPP=$(AMLOGIC_EM4_TOOLCHAIN_PATH)/bin/arc-elf32-em4-cpp
AML_COMLILERS += FW_TOOLCHAIN_PATH=$(AMLOGIC_S805_TOOLCHAIN_PATH)


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

#
# Extra kernel boot arguments:
#
extra  = logo=osd1,loaded,0x7900000,$(hdmi_output_mode),full
extra += vdaccfg=0xa001
extra += cvbsmode=576cvbs
extra += hdmimode=$(hdmi_output_mode)
extra += hdmitx=cec0xf
extra += vout=$(video_output_mode)
extra += m_bpp=32
extra += mac=$(DEFAULT_HW_ADDR)


####### Dependencies

ifneq ($(filter $(HARDWARE),$(HARDWARE_M201)),)
device_dtb  = meson8b_m201_512M.dtb
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_MXV)),)
device_dtb  = meson8b-mxq.dtb
endif

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

UMAKE := CONFIG_NOSOFTFLOAT=1 $(MAKE) -C $(SRC_DIR) CROSS_COMPILE="$(AMLOGIC_CROSS_PREFIX)" $(AML_COMLILERS)

$(u_boot): $(src_done)
	$(UMAKE)  $(u_boot_config)
	$(UMAKE)
	@touch $@

$(boot_script_sd): $(u_boot)
	@( echo "mmcinfo"                                           > $(boot_script_sd) && \
	   echo "fatload mmc 0:1 0x12000000 uImage"                >> $(boot_script_sd) && \
	   echo "fatload mmc 0:1 0x12800000 $(device_dtb)"         >> $(boot_script_sd) && \
	   echo "fatload mmc 0:1 0x13000000 $(logo_fname)"         >> $(boot_script_sd) && \
	   echo "setenv display_width $(hdmi_display_width)"       >> $(boot_script_sd) && \
	   echo "setenv display_height $(hdmi_display_height)"     >> $(boot_script_sd) && \
	   echo "setenv hdmimode $(hdmi_output_mode)"              >> $(boot_script_sd) && \
	   echo "setenv outputmode $(hdmi_output_mode)"            >> $(boot_script_sd) && \
	   echo "video dev open $(hdmi_output_mode)"               >> $(boot_script_sd) && \
	   echo "bmp display 0x13000000"                           >> $(boot_script_sd) && \
	   echo "bmp scale"                                        >> $(boot_script_sd) && \
	   echo "setenv bootargs 'console=ttyS0,115200n8 ro root=/dev/mmcblk0p2 rootfstype=ext4 no_console_suspend $(extra)'" >> $(boot_script_sd) && \
	   echo "bootm 0x12000000 - 0x12800000"                    >> $(boot_script_sd) \
	 )

$(boot_scr_sd): $(boot_script_sd)
	$(SRC_DIR)/build/tools/mkimage -A $(ARCH) -T script -C none -n "Boot Script" -d $< $@

$(build_uboot_pkg): $(boot_scr_sd)
	@mkdir -p $(TARGET_DEST_DIR)/bootfs
	@mkdir -p $(UBOOT_BIN_PKG)/boot
	# ======= Copy U-Boot images =======
	@cp -a $(boot_scr_sd)   $(TARGET_DEST_DIR)/bootfs
	@cp -a $(boot_scr_sd)   $(TARGET_DEST_DIR)/bootfs/boot.scr
	@for logo in $(u_boot_logos) ; do \
	   cp -a $(logos_path)/$$logo $(TARGET_DEST_DIR)/bootfs ; \
	 done
	@cp -a $(boot_scr_sd)   $(UBOOT_BIN_PKG)/boot
	@cp -a $(boot_scr_sd)   $(UBOOT_BIN_PKG)/boot/boot.scr
	@for logo in $(u_boot_logos) ; do \
	   cp -a $(logos_path)/$$logo $(UBOOT_BIN_PKG)/boot ; \
	 done
	@cd $(SRC_DIR) && \
	  cp -a build/u-boot.bin $(TARGET_DEST_DIR)/bootfs && \
	  cp -a build/u-boot.bin  $(UBOOT_BIN_PKG)/boot
	@chmod a-x $(UBOOT_BIN_PKG)/boot/u-boot*.bin
	@mkdir -p $(UBOOT_BIN_PKG)/usr/doc/u-boot-aml-$(version)
	@cp -a $(SRC_DIR)/COPYING $(SRC_DIR)/CREDITS $(SRC_DIR)/README \
	       $(UBOOT_BIN_PKG)/usr/doc/u-boot-aml-$(version)
	@touch $@

$(boot_records): $(build_uboot_pkg)
	@$(DD) if=/dev/zero of=$@ bs=512 count=2048 conv=notrunc
	# ======= Setup u-boot into unallocated space of disk image =======
	@$(DD) if=$(UBOOT_BIN_PKG)/boot/u-boot.bin of=$@ bs=1 count=442       conv=notrunc
	@$(DD) if=$(UBOOT_BIN_PKG)/boot/u-boot.bin of=$@ bs=512 skip=1 seek=1 conv=notrunc
	@touch $@

$(boot_fat32fs): $(build_uboot_pkg)
	@$(DD) if=/dev/zero of=$@ bs=1M count=511
	# ======= Create FAT32 boot partition image =======
	@$(MKDOSFS) -F 32 -n bootfs $@
	@$(MCOPY) -i $@ $(TARGET_DEST_DIR)/bootfs/u-boot.bin ::/
	@$(MCOPY) -i $@ $(TARGET_DEST_DIR)/bootfs/boot.scr   ::/
	@for logo in $(u_boot_logos) ; do \
	   $(MCOPY) -i $@ $(logos_path)/$$logo               ::/ ; \
	 done
	@for dtb in $(device_dtb) ; do \
	   $(MCOPY) -i $@ $(TARGET_DEST_DIR)/bootfs/$$dtb    ::/ ; \
	 done
	@$(MCOPY) -i $@ $(TARGET_DEST_DIR)/bootfs/uImage     ::/
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
