
COMPONENT_TARGETS = $(HARDWARE_OMAP5UEVM)

NEED_ABS_PATH     = true

COMPONENT_IS_3PP  = true


include ../../../../build-system/constants.mk

version          = 3.8.y-20140222

REQUIRES         = boot/kernel/omap543x/$(version)

# ======= __END_OF_REQUIRES__ =======


kernel_version   = $(version)
modules_version  = 3.8.13


PKG_GROUP = dev


KS_DEV_PKG_NAME                = kernel-sources
KS_DEV_PKG_VERSION             = 3.8.13
KS_DEV_PKG_ARCH                = $(TOOLCHAIN)
KS_DEV_PKG_DISTRO_NAME         = $(DISTRO_NAME)
KS_DEV_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
KS_DEV_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
KS_DEV_PKG_SHORT_DESCRIPTION   = OMAP543X Linux kernel configured sources
KS_DEV_PKG_URL                 = $(BUG_URL)
KS_DEV_PKG_LICENSE             = GPLv2
KS_DEV_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(KS_DEV_PKG_NAME)-pkg-description
KS_DEV_PKG_DESCRIPTION_FILE_IN = $(KS_DEV_PKG_NAME)-pkg-description.in
KS_DEV_PKG_INSTALL_SCRIPT      = $(KS_DEV_PKG_NAME)-pkg-install.sh


KS_DEV_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(KS_DEV_PKG_NAME)-package

build_ks_pkg     = $(TARGET_BUILD_DIR)/.kernel_sources_pkg_done

pkg_basename     = $(KS_DEV_PKG_NAME)-$(KS_DEV_PKG_VERSION)-$(KS_DEV_PKG_ARCH)-$(KS_DEV_PKG_DISTRO_NAME)-$(KS_DEV_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_ks_pkg)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../build-system/core.mk


$(build_ks_pkg):
	@mkdir -p $(KS_DEV_PKG)/usr/src
	@cd $(TARGET_DEST_DIR)/usr/src && \
	 cp -rf linux-glsdk-$(kernel_version) $(KS_DEV_PKG)/usr/src
	@cp -a $(TARGET_DEST_DIR)/usr/src/.CONTENT \
	       $(KS_DEV_PKG)/usr/src/
	@cd $(KS_DEV_PKG)/usr/src && \
	 $(LN_S)f linux-glsdk-$(kernel_version) linux
	@mkdir -p $(KS_DEV_PKG)/lib/modules/$(modules_version)
	@cd $(KS_DEV_PKG)/lib/modules/$(modules_version) && \
	 $(LN_S)f ../../../usr/src/linux build && \
	 $(LN_S)f ../../../usr/src/linux source
	@touch $@

$(KS_DEV_PKG_DESCRIPTION_FILE): $(KS_DEV_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@KERNEL_VERSION@/$(kernel_version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(build_ks_pkg) $(KS_DEV_PKG_DESCRIPTION_FILE) $(KS_DEV_PKG_INSTALL_SCRIPT)
	@cp $(KS_DEV_PKG_DESCRIPTION_FILE) $(KS_DEV_PKG)/.DESCRIPTION
	@cp $(KS_DEV_PKG_INSTALL_SCRIPT) $(KS_DEV_PKG)/.INSTALL
	@$(BUILD_BIN_PKG_REQUIRES) $(KS_DEV_PKG)/.REQUIRES
	@echo "pkgname=$(KS_DEV_PKG_NAME)"                            >  $(KS_DEV_PKG)/.PKGINFO ; \
	 echo "pkgver=$(KS_DEV_PKG_VERSION)"                          >> $(KS_DEV_PKG)/.PKGINFO ; \
	 echo "arch=$(KS_DEV_PKG_ARCH)"                               >> $(KS_DEV_PKG)/.PKGINFO ; \
	 echo "distroname=$(KS_DEV_PKG_DISTRO_NAME)"                  >> $(KS_DEV_PKG)/.PKGINFO ; \
	 echo "distrover=$(KS_DEV_PKG_DISTRO_VERSION)"                >> $(KS_DEV_PKG)/.PKGINFO ; \
	 echo "group=$(KS_DEV_PKG_GROUP)"                             >> $(KS_DEV_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(KS_DEV_PKG_SHORT_DESCRIPTION)\"" >> $(KS_DEV_PKG)/.PKGINFO ; \
	 echo "url=$(KS_DEV_PKG_URL)"                                 >> $(KS_DEV_PKG)/.PKGINFO ; \
	 echo "license=$(KS_DEV_PKG_LICENSE)"                         >> $(KS_DEV_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(KS_DEV_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
