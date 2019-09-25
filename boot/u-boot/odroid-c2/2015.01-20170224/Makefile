
COMPONENT_TARGETS  = $(HARDWARE_ODROID_C2)

NEED_ABS_PATH      = true

COMPONENT_IS_3PP   = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/U-Boot/Hardkernel/S905

REQUIRES           = boot/kernel/odroid-c2/3.14.79-20170131

# ======= __END_OF_REQUIRES__ =======


DEFAULT_NFS_ROOT_IP_ADDR = 172.16.0.3
DEFAULT_NFS_ROOT_PATH    = "nfsroot-c2"
DEFAULT_HW_ADDR          = 2a:ab:c0:c5:c3:b2


version            = 2015.01-20170224
tar_xz_archive     = $(SRC_PACKAGE_PATH)/U-Boot/Hardkernel/S905/u-boot-aml-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/u-boot-aml-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

u_boot             = $(TARGET_BUILD_DIR)/.u_boot_done

u_boot_config      = odroidc2_defconfig

#
# zImage from Linux kernel package:
#
kernel_version     = 3.14.79
linux_zImage       = $(TARGET_DEST_DIR)/bootfs/zImage

#
# Image for U-Boot:
#
load_address       = 0x01080000
entry_point        = $(load_address)
uImage             = $(TARGET_BUILD_DIR)/uImage

#
# Boot Script:
#
boot_ini_script = $(CURDIR)/scripts/boot.ini

boot_records         = $(TARGET_BUILD_DIR)/$(HARDWARE).boot-records
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
UBOOT_BIN_PKG_SHORT_DESCRIPTION   = Hardkernel S905 U-Boot
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
BUILD_TARGETS     += $(build_uboot_pkg)
BUILD_TARGETS     += $(install_boot_records)

PRODUCT_TARGETS    = $(products)

ROOTFS_TARGETS     = $(pkg_archive)


include ../../../../build-system/core.mk

#
# armv8 elf toolchain
#
ARMV8_TOOLCHAIN_PATH = /opt/toolchain/3pp/aarch64-NONE-elf-newlib/1.1.1
AML_CROSS_COMPILE    = $(ARMV8_TOOLCHAIN_PATH)/bin/aarch64-none-elf-


logos_path    = $(CURDIR)/logo
logo_fname    = radix-2CPU-224x96-32bpp.bmp

u_boot_logos  = radix-2CPU-224x96.bmp
u_boot_logos += radix-2CPU-224x96-16bpp.bmp
u_boot_logos += radix-2CPU-224x96-24bpp.bmp
u_boot_logos += radix-2CPU-224x96-32bpp.bmp

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

UMAKE := CONFIG_NOSOFTFLOAT=1 $(MAKE) -C $(SRC_DIR) CROSS_COMPILE="$(AML_CROSS_COMPILE)"

$(u_boot): $(src_done)
	$(UMAKE)  $(u_boot_config)
	$(UMAKE)
	@touch $@

$(uImage): $(u_boot)
	$(SRC_DIR)/build/tools/mkimage \
	   -A $(ARCH) -O linux -T kernel -C gzip -a $(load_address) -e $(entry_point) \
	   -n $(kernel_version) -d $(linux_zImage) $@

$(build_uboot_pkg): $(uImage)
	@mkdir -p $(TARGET_DEST_DIR)/bootfs
	@mkdir -p $(UBOOT_BIN_PKG)/boot
	# ======= install U-Boot images =======
	@cp -a $(uImage) $(UBOOT_BIN_PKG)/boot
	@for logo in $(u_boot_logos) ; do \
	   cp -a $(logos_path)/$$logo $(UBOOT_BIN_PKG)/boot ; \
	 done
	# ======= install eMMC/SD U-Boot =======
	@cp -a $(SRC_DIR)/sd_fuse/bl1.bin.hardkernel $(UBOOT_BIN_PKG)/boot/bl1.bin
	@cp -a $(SRC_DIR)/sd_fuse/u-boot.bin         $(UBOOT_BIN_PKG)/boot/u-boot.bin
	@chmod 644 $(UBOOT_BIN_PKG)/boot/bl1.bin
	@chmod 644 $(UBOOT_BIN_PKG)/boot/u-boot.bin
	# ======= copy U-Boot images and binaries into devenv =======
	@cp -a $(uImage) $(TARGET_DEST_DIR)/bootfs
	@for logo in $(u_boot_logos) ; do \
	   cp -a $(logos_path)/$$logo $(TARGET_DEST_DIR)/bootfs ; \
	 done
	@for binary in bl1.bin u-boot.bin ; do \
	   cp -a $(UBOOT_BIN_PKG)/boot/$$binary $(TARGET_DEST_DIR)/bootfs ; \
	 done
	# ======= install rootfs-partition script =======
	@cat $(boot_ini_script) > $(UBOOT_BIN_PKG)/boot/boot.ini
	# ======= Install Documentation =======
	@mkdir -p $(UBOOT_BIN_PKG)/usr/doc/u-boot-aml-$(version)
	@cp -a $(SRC_DIR)/Licenses $(SRC_DIR)/MAINTAINERS $(SRC_DIR)/README \
	       $(UBOOT_BIN_PKG)/usr/doc/u-boot-aml-$(version)
	@touch $@

$(boot_records): $(build_uboot_pkg)
	@$(DD) if=/dev/zero of=$@ bs=512 count=2048 conv=notrunc
	# ======= Setup u-boot into unallocated space of disk image =======
	@$(DD) if=$(UBOOT_BIN_PKG)/boot/bl1.bin    of=$@ bs=1   count=442     conv=notrunc
	@$(DD) if=$(UBOOT_BIN_PKG)/boot/bl1.bin    of=$@ bs=512 skip=1 seek=1 conv=notrunc
	@$(DD) if=$(UBOOT_BIN_PKG)/boot/u-boot.bin of=$@ bs=512 seek=97       conv=notrunc
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
