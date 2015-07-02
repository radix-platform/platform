
COMPONENT_TARGETS  = $(HARDWARE_CB1N)
COMPONENT_TARGETS += $(HARDWARE_CB2N)
COMPONENT_TARGETS += $(HARDWARE_CB3N)
COMPONENT_TARGETS += $(HARDWARE_AT91S)
COMPONENT_TARGETS += $(HARDWARE_VIP1830N)
COMPONENT_TARGETS += $(HARDWARE_L17UC)

COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_VIP1830)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)
COMPONENT_TARGETS += $(HARDWARE_CI20)

COMPONENT_TARGETS += $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)


NEED_ABS_PATH = true


include ../../build-system/constants.mk


# ======= __END_OF_REQUIRES__ =======


PKG_GROUP = base

BIN_PKG_NAME                = pkgtool
BIN_PKG_VERSION             = 1.0.5
BIN_PKG_ARCH                = $(TOOLCHAIN)
BIN_PKG_DISTRO_NAME         = $(DISTRO_NAME)
BIN_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
BIN_PKG_GROUP               = $(PKG_GROUP)
###                          |---handy-ruler-------------------------------|
BIN_PKG_SHORT_DESCRIPTION   = Package Tools
BIN_PKG_URL                 = $(BUG_URL)
BIN_PKG_LICENSE             = Proprietary
BIN_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/pkg-description
BIN_PKG_DESCRIPTION_FILE_IN = pkg-description.in
BIN_PKG_INSTALL_SCRIPT      = pkg-install.sh


BIN_PKG = $(TARGET_BUILD_DIR)/$(BIN_PKG_NAME)-package

scripts  = $(BUILDSYSTEM)/pkgtool/change-refs
scripts += $(BUILDSYSTEM)/pkgtool/check-db-integrity
scripts += $(BUILDSYSTEM)/pkgtool/check-package
scripts += $(BUILDSYSTEM)/pkgtool/check-requires
scripts += $(BUILDSYSTEM)/pkgtool/install-package
scripts += $(BUILDSYSTEM)/pkgtool/install-pkglist
scripts += $(BUILDSYSTEM)/pkgtool/make-package
scripts += $(BUILDSYSTEM)/pkgtool/make-pkglist
scripts += $(BUILDSYSTEM)/pkgtool/pkginfo
scripts += $(BUILDSYSTEM)/pkgtool/pkglog
scripts += $(BUILDSYSTEM)/pkgtool/remove-package
scripts += $(BUILDSYSTEM)/pkgtool/update-package


build = $(TARGET_BUILD_DIR)/.done

pkg_basename    = $(BIN_PKG_NAME)-$(BIN_PKG_VERSION)-$(BIN_PKG_ARCH)-$(BIN_PKG_DISTRO_NAME)-$(BIN_PKG_DISTRO_VERSION)

# we need to have full path of product files for installation:
pkg_archive     = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature   = $(call sign-name,$(pkg_archive))
pkg_description = $(call desc-name,$(pkg_archive))
products        = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS   = $(build)

PRODUCT_TARGETS = $(products)

ROOTFS_TARGETS  = $(pkg_archive)


include ../../build-system/core.mk


$(build):
	@mkdir -p $(BIN_PKG)/sbin/$(BIN_PKG_NAME)
	@cp $(scripts) $(BIN_PKG)/sbin/$(BIN_PKG_NAME)
	@touch $@

$(BIN_PKG_DESCRIPTION_FILE): $(BIN_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(BIN_PKG_VERSION)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(build) $(BIN_PKG_DESCRIPTION_FILE) $(BIN_PKG_INSTALL_SCRIPT)
	@cp $(BIN_PKG_DESCRIPTION_FILE) $(BIN_PKG)/.DESCRIPTION
	@cp $(BIN_PKG_INSTALL_SCRIPT) $(BIN_PKG)/.INSTALL
	@$(BUILD_BIN_PKG_REQUIRES) $(BIN_PKG)/.REQUIRES
	@echo "pkgname=$(BIN_PKG_NAME)"                            >  $(BIN_PKG)/.PKGINFO ; \
	 echo "pkgver=$(BIN_PKG_VERSION)"                          >> $(BIN_PKG)/.PKGINFO ; \
	 echo "arch=$(BIN_PKG_ARCH)"                               >> $(BIN_PKG)/.PKGINFO ; \
	 echo "distroname=$(BIN_PKG_DISTRO_NAME)"                  >> $(BIN_PKG)/.PKGINFO ; \
	 echo "distrover=$(BIN_PKG_DISTRO_VERSION)"                >> $(BIN_PKG)/.PKGINFO ; \
	 echo "group=$(BIN_PKG_GROUP)"                             >> $(BIN_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(BIN_PKG_SHORT_DESCRIPTION)\"" >> $(BIN_PKG)/.PKGINFO ; \
	 echo "url=$(BIN_PKG_URL)"                                 >> $(BIN_PKG)/.PKGINFO ; \
	 echo "license=$(BIN_PKG_LICENSE)"                         >> $(BIN_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(BIN_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
