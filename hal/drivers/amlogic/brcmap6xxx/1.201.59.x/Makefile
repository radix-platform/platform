
COMPONENT_TARGETS  = $(HARDWARE_KHADAS_VIM)
COMPONENT_TARGETS += $(HARDWARE_ENYBOX_X2)

NEED_ABS_PATH      = true

COMPONENT_IS_3PP   = true

NO_CCACHE = true

include ../../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/hal/drivers/wireless/Amlogic/brcmap6xxx
SOURCE_REQUIRES   += sources/hal/firmware/wireless/Amlogic

ifneq ($(filter $(HARDWARE),$(HARDWARE_KHADAS_VIM)),)
REQUIRES           = boot/kernel/kvim/3.14.29-20170119
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_ENYBOX_X2)),)
REQUIRES           = boot/kernel/x2/3.14.29-20170119
endif

# ======= __END_OF_REQUIRES__ =======


version            = 1.201.59.x
amlogic_version    = 20160818
kernel_version     = 3.14.29-20170119
modules_version    = 3.14.29
tar_xz_archive     = $(SRC_PACKAGE_PATH)/hal/drivers/wireless/Amlogic/brcmap6xxx/brcmap6xxx-$(amlogic_version).tar.xz
fw_src_archive     = $(SRC_PACKAGE_PATH)/hal/firmware/wireless/Amlogic/wifi-fw-$(amlogic_version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/brcmap6xxx-$(amlogic_version)
FW_SRC_DIR         = $(TARGET_BUILD_DIR)/wifi-fw-$(amlogic_version)
src_done           = $(TARGET_BUILD_DIR)/.source_done
src_fw_done        = $(TARGET_BUILD_DIR)/.source_fw_done

kernel_sources     = $(TARGET_DEST_DIR)/usr/src/linux-aml-$(kernel_version)

build_ap6xxx_pkg   = $(TARGET_BUILD_DIR)/.ap6xxx_pkg_done

modules_done       = $(TARGET_BUILD_DIR)/.modules_done


PATCHES = PATCHES


ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_S9XX_GLIBC)),)
ARCH = arm64
endif


USE_TARGET_DEST_DIR_SYSROOT = no


####### Targets

PKG_GROUP = boot


AP6XXX_PKG_NAME                = brcmap6xxx
AP6XXX_PKG_VERSION             = 1.201.59.x
AP6XXX_PKG_ARCH                = $(TOOLCHAIN)
AP6XXX_PKG_DISTRO_NAME         = $(DISTRO_NAME)
AP6XXX_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
AP6XXX_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
AP6XXX_PKG_SHORT_DESCRIPTION   = Broadcom FullMAC wireless support
AP6XXX_PKG_URL                 = $(BUG_URL)
AP6XXX_PKG_LICENSE             = GPLv2
AP6XXX_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(AP6XXX_PKG_NAME)-pkg-description
AP6XXX_PKG_DESCRIPTION_FILE_IN = $(AP6XXX_PKG_NAME)-pkg-description.in
AP6XXX_PKG_INSTALL_SCRIPT      = $(TARGET_BUILD_DIR)/$(AP6XXX_PKG_NAME)-pkg-install.sh
AP6XXX_PKG_INSTALL_SCRIPT_IN   = $(AP6XXX_PKG_NAME)-pkg-install.sh.in

AP6XXX_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(AP6XXX_PKG_NAME)-package

pkg_basename     = $(AP6XXX_PKG_NAME)-$(AP6XXX_PKG_VERSION)-$(AP6XXX_PKG_ARCH)-$(AP6XXX_PKG_DISTRO_NAME)-$(AP6XXX_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(modules_done)
BUILD_TARGETS   += $(build_ap6xxx_pkg)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../../build-system/core.mk


MODULE_DIR   = kernel/drivers/net/wireless/bcmdhd
INSTALL_DIR  = lib/modules/$(modules_version)/$(MODULE_DIR)
FIRMWARE_DIR = lib/firmware/broadcom/ap6xxx

BCMDHD_SRC_DIR = $(CURDIR)/$(SRC_DIR)/bcmdhd_1_201_59_x
BCMDHD_USB_SRC_DIR = $(CURDIR)/$(SRC_DIR)/bcmdhd-usb.1.201.88.27.x

FIRMWARE_SRC_DIR = $(CURDIR)/$(FW_SRC_DIR)/bcm_ampak/config

extra_build_environment  = KCPPFLAGS='-DCONFIG_BCMDHD_FW_PATH=\"/$(FIRMWARE_DIR)/fw_bcmdhd.bin\" -DCONFIG_BCMDHD_NVRAM_PATH=\"/$(FIRMWARE_DIR)/nvram.txt\"'


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(src_fw_done): $(src_done)
	@echo "Expanding `basename $(fw_src_archive)`"
	@tar xJf $(fw_src_archive) -C $(TARGET_BUILD_DIR)
	@touch $@

LMAKE := CROSS_COMPILE="$(CROSS_PREFIX)" ARCH=$(ARCH)  $(extra_build_environment) V=$(if $(VERBOSE),1,0) $(MAKE)

$(modules_done): $(src_fw_done)
	$(LMAKE) -C $(kernel_sources) M=$(BCMDHD_SRC_DIR) modules
	$(LMAKE) -C $(kernel_sources) M=$(BCMDHD_USB_SRC_DIR) modules
	@touch $@

$(build_ap6xxx_pkg): $(modules_done)
	@mkdir -p $(AP6XXX_PKG)/$(INSTALL_DIR)
	@mkdir -p $(AP6XXX_PKG)/$(FIRMWARE_DIR)
	# ======= Copy modules and firmware (without links to sources): =======
	@install -m 0666 $(BCMDHD_SRC_DIR)/dhd.ko        $(AP6XXX_PKG)/$(INSTALL_DIR)
	@install -m 0666 $(BCMDHD_USB_SRC_DIR)/bcmdhd.ko $(AP6XXX_PKG)/$(INSTALL_DIR)
	@( cd $(FIRMWARE_SRC_DIR) ; \
	   install -m 0644 6212/BT/bcm43438a0.hcd       $(AP6XXX_PKG)/$(FIRMWARE_DIR)                  ; \
	   install -m 0644 6212/fw_bcm43438a0.bin       $(AP6XXX_PKG)/$(FIRMWARE_DIR)                  ; \
	   install -m 0644 6212/fw_bcm43438a0_apsta.bin $(AP6XXX_PKG)/$(FIRMWARE_DIR)                  ; \
	   install -m 0644 6212/fw_bcm43438a0_p2p.bin   $(AP6XXX_PKG)/$(FIRMWARE_DIR)                  ; \
	   install -m 0644 6212/nvram.txt               $(AP6XXX_PKG)/$(FIRMWARE_DIR)/nvram_ap6212.txt ; \
	   install -m 0644 6255/BT/BCM4345C0.hcd           $(AP6XXX_PKG)/$(FIRMWARE_DIR)                  ; \
	   install -m 0644 6255/fw_bcm43455c0_ag.bin       $(AP6XXX_PKG)/$(FIRMWARE_DIR)                  ; \
	   install -m 0644 6255/fw_bcm43455c0_ag_apsta.bin $(AP6XXX_PKG)/$(FIRMWARE_DIR)                  ; \
	   install -m 0644 6255/fw_bcm43455c0_ag_p2p.bin   $(AP6XXX_PKG)/$(FIRMWARE_DIR)                  ; \
	   install -m 0644 6255/nvram.txt                  $(AP6XXX_PKG)/$(FIRMWARE_DIR)/nvram_ap6255.txt ; \
	 )
ifneq ($(filter $(HARDWARE),$(HARDWARE_KHADAS_VIM)),)
	@( cd $(AP6XXX_PKG)/$(FIRMWARE_DIR) ; \
	   ln -sf nvram_ap6212.txt nvram.txt ; \
	 )
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_ENYBOX_X2)),)
	@( cd $(AP6XXX_PKG)/$(FIRMWARE_DIR) ; \
	   ln -sf nvram_ap6255.txt nvram.txt ; \
	 )
endif
	# ======= Install Documentation =======
	@mkdir -p $(AP6XXX_PKG)/usr/doc/brcmap6xxx-$(version)
	@cp -a $(FIRMWARE_SRC_DIR)/p2p_supplicant_overlay.conf \
	       $(FIRMWARE_SRC_DIR)/wpa_supplicant.conf         \
	       $(AP6XXX_PKG)/usr/doc/brcmap6xxx-$(version)
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(AP6XXX_PKG))
	@touch $@

$(AP6XXX_PKG_DESCRIPTION_FILE): $(AP6XXX_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(AP6XXX_PKG_INSTALL_SCRIPT): $(AP6XXX_PKG_INSTALL_SCRIPT_IN)
	@cat $< | $(SED) -e "s/@MODULES_VERSION@/$(modules_version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(build_ap6xxx_pkg) $(AP6XXX_PKG_DESCRIPTION_FILE) $(AP6XXX_PKG_INSTALL_SCRIPT)
	@cp $(AP6XXX_PKG_DESCRIPTION_FILE) $(AP6XXX_PKG)/.DESCRIPTION
	@cp $(AP6XXX_PKG_INSTALL_SCRIPT) $(AP6XXX_PKG)/.INSTALL
	@chmod a+x $(AP6XXX_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(AP6XXX_PKG)/.REQUIRES
	@echo "pkgname=$(AP6XXX_PKG_NAME)"                            >  $(AP6XXX_PKG)/.PKGINFO ; \
	 echo "pkgver=$(AP6XXX_PKG_VERSION)"                          >> $(AP6XXX_PKG)/.PKGINFO ; \
	 echo "arch=$(AP6XXX_PKG_ARCH)"                               >> $(AP6XXX_PKG)/.PKGINFO ; \
	 echo "distroname=$(AP6XXX_PKG_DISTRO_NAME)"                  >> $(AP6XXX_PKG)/.PKGINFO ; \
	 echo "distrover=$(AP6XXX_PKG_DISTRO_VERSION)"                >> $(AP6XXX_PKG)/.PKGINFO ; \
	 echo "group=$(AP6XXX_PKG_GROUP)"                             >> $(AP6XXX_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(AP6XXX_PKG_SHORT_DESCRIPTION)\"" >> $(AP6XXX_PKG)/.PKGINFO ; \
	 echo "url=$(AP6XXX_PKG_URL)"                                 >> $(AP6XXX_PKG)/.PKGINFO ; \
	 echo "license=$(AP6XXX_PKG_LICENSE)"                         >> $(AP6XXX_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(AP6XXX_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
