
COMPONENT_TARGETS  = $(HARDWARE_CI20)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/hal/firmware/ci20/brcm4330

REQUIRES           = base/radix-system

# ======= __END_OF_REQUIRES__ =======


version            = 0.0.0
tar_xz_archive     = $(SRC_PACKAGE_PATH)/hal/firmware/ci20/brcm4330/ci20-brcm4330-fw-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/ci20-brcm4330-fw-$(version)
src_dir_name       = ci20-brcm4330-fw-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = boot

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
WIFIFW_PKG_NAME                = ci20-brcm4330-fw
WIFIFW_PKG_VERSION             = 0.0.0
WIFIFW_PKG_ARCH                = $(TOOLCHAIN)
WIFIFW_PKG_DISTRO_NAME         = $(DISTRO_NAME)
WIFIFW_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
WIFIFW_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
WIFIFW_PKG_SHORT_DESCRIPTION   = BRCM44330 firmware for CI20
WIFIFW_PKG_URL                 = $(BUG_URL)
WIFIFW_PKG_LICENSE             = GPLv2
WIFIFW_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(WIFIFW_PKG_NAME)-pkg-description
WIFIFW_PKG_DESCRIPTION_FILE_IN = $(WIFIFW_PKG_NAME)-pkg-description.in
WIFIFW_PKG_INSTALL_SCRIPT      = $(WIFIFW_PKG_NAME)-pkg-install.sh

WIFIFW_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(WIFIFW_PKG_NAME)-package

pkg_basename     = $(WIFIFW_PKG_NAME)-$(WIFIFW_PKG_VERSION)-$(WIFIFW_PKG_ARCH)-$(WIFIFW_PKG_DISTRO_NAME)-$(WIFIFW_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_certificate  = $(call cert-name,$(pkg_archive))
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../../build-system/core.mk


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(install_target): $(src_done)
	@mkdir -p $(WIFIFW_PKG)/lib/firmware/{brcm,iw8103}
	@( cd $(SRC_DIR) ; \
	   cp -a lib/firmware/brcm/brcmfmac4330-sdio.bin \
	         lib/firmware/brcm/brcmfmac4330-sdio.txt \
	         $(WIFIFW_PKG)/lib/firmware/brcm ; \
	 )
	@( cd $(WIFIFW_PKG)/lib/firmware/iw8103 ; \
	   ln -sf ../brcm/brcmfmac4330-sdio.bin fw_bcm4330b2.bin ; \
	   ln -sf ../brcm/brcmfmac4330-sdio.txt nv_4330b2.txt ; \
	 )
	# ======= Install Documentation =======
	@mkdir -p $(WIFIFW_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a README \
	         $(WIFIFW_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(WIFIFW_PKG))
	@touch $@

$(WIFIFW_PKG_DESCRIPTION_FILE): $(WIFIFW_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(WIFIFW_PKG_DESCRIPTION_FILE) $(WIFIFW_PKG_INSTALL_SCRIPT)
	@cp $(WIFIFW_PKG_DESCRIPTION_FILE) $(WIFIFW_PKG)/.DESCRIPTION
	@cp $(WIFIFW_PKG_INSTALL_SCRIPT) $(WIFIFW_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(WIFIFW_PKG)/.REQUIRES
	@echo "pkgname=$(WIFIFW_PKG_NAME)"                            >  $(WIFIFW_PKG)/.PKGINFO ; \
	 echo "pkgver=$(WIFIFW_PKG_VERSION)"                          >> $(WIFIFW_PKG)/.PKGINFO ; \
	 echo "arch=$(WIFIFW_PKG_ARCH)"                               >> $(WIFIFW_PKG)/.PKGINFO ; \
	 echo "distroname=$(WIFIFW_PKG_DISTRO_NAME)"                  >> $(WIFIFW_PKG)/.PKGINFO ; \
	 echo "distrover=$(WIFIFW_PKG_DISTRO_VERSION)"                >> $(WIFIFW_PKG)/.PKGINFO ; \
	 echo "group=$(WIFIFW_PKG_GROUP)"                             >> $(WIFIFW_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(WIFIFW_PKG_SHORT_DESCRIPTION)\"" >> $(WIFIFW_PKG)/.PKGINFO ; \
	 echo "url=$(WIFIFW_PKG_URL)"                                 >> $(WIFIFW_PKG)/.PKGINFO ; \
	 echo "license=$(WIFIFW_PKG_LICENSE)"                         >> $(WIFIFW_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(WIFIFW_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
