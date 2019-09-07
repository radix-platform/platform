
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_POIN2)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXV)
COMPONENT_TARGETS += $(HARDWARE_P201)
COMPONENT_TARGETS += $(HARDWARE_NEXBOX_A95X)
COMPONENT_TARGETS += $(HARDWARE_ODROID_C2)
COMPONENT_TARGETS += $(HARDWARE_P212)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_VIM)
COMPONENT_TARGETS += $(HARDWARE_Q201)
COMPONENT_TARGETS += $(HARDWARE_ENYBOX_X2)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_VIM2)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BAIKAL_T1)
COMPONENT_TARGETS += $(HARDWARE_MBC4_PC)
COMPONENT_TARGETS += $(HARDWARE_S824L)
COMPONENT_TARGETS += $(HARDWARE_VESNIN)
COMPONENT_TARGETS += $(HARDWARE_S824L_LSB)
COMPONENT_TARGETS += $(HARDWARE_VESNIN_LSB)
COMPONENT_TARGETS += $(HARDWARE_TL2WK2)
COMPONENT_TARGETS += $(HARDWARE_TL2SV2)
COMPONENT_TARGETS += $(HARDWARE_TL2WK2_LSB)
COMPONENT_TARGETS += $(HARDWARE_TL2SV2_LSB)


NEED_ABS_PATH = true


include ../../build-system/constants.mk


REQUIRES           = base/radix-system
REQUIRES          += base/install-tools

# ======= __END_OF_REQUIRES__ =======


PKG_GROUP = base

PKGTOOL_BIN_PKG_NAME                = pkgtool
PKGTOOL_BIN_PKG_VERSION             = 1.3.0
PKGTOOL_BIN_PKG_ARCH                = $(TOOLCHAIN)
PKGTOOL_BIN_PKG_DISTRO_NAME         = $(DISTRO_NAME)
PKGTOOL_BIN_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
PKGTOOL_BIN_PKG_GROUP               = $(PKG_GROUP)
###                                  |---handy-ruler-------------------------------|
PKGTOOL_BIN_PKG_SHORT_DESCRIPTION   = Package Tools
PKGTOOL_BIN_PKG_URL                 = $(BUG_URL)
PKGTOOL_BIN_PKG_LICENSE             = LGPLv2.1
PKGTOOL_BIN_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(PKGTOOL_BIN_PKG_NAME)-pkg-description
PKGTOOL_BIN_PKG_DESCRIPTION_FILE_IN = $(PKGTOOL_BIN_PKG_NAME)-pkg-description.in
PKGTOOL_BIN_PKG_INSTALL_SCRIPT      = $(PKGTOOL_BIN_PKG_NAME)-pkg-install.sh


PKGTOOL_BIN_PKG = $(TARGET_BUILD_DIR)/$(PKGTOOL_BIN_PKG_NAME)-package

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

dialogrc = $(BUILDSYSTEM)/pkgtool/dialogrc

build = $(TARGET_BUILD_DIR)/.done

pkg_basename     = $(PKGTOOL_BIN_PKG_NAME)-$(PKGTOOL_BIN_PKG_VERSION)-$(PKGTOOL_BIN_PKG_ARCH)-$(PKGTOOL_BIN_PKG_DISTRO_NAME)-$(PKGTOOL_BIN_PKG_DISTRO_VERSION)

# we need to have full path of product files for installation:
pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_certificate  = $(call cert-name,$(pkg_archive))
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../build-system/core.mk


$(build):
	@mkdir -p $(PKGTOOL_BIN_PKG)/sbin/$(PKGTOOL_BIN_PKG_NAME) $(PKGTOOL_BIN_PKG)/root
	@cp $(scripts) $(PKGTOOL_BIN_PKG)/sbin/$(PKGTOOL_BIN_PKG_NAME)
	@cp $(dialogrc) $(PKGTOOL_BIN_PKG)/root/.dialogrc.new
	@touch $@

$(PKGTOOL_BIN_PKG_DESCRIPTION_FILE): $(PKGTOOL_BIN_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(PKGTOOL_BIN_PKG_VERSION)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(build) $(PKGTOOL_BIN_PKG_DESCRIPTION_FILE) $(PKGTOOL_BIN_PKG_INSTALL_SCRIPT)
	@cp $(PKGTOOL_BIN_PKG_DESCRIPTION_FILE) $(PKGTOOL_BIN_PKG)/.DESCRIPTION
	@cp $(PKGTOOL_BIN_PKG_INSTALL_SCRIPT) $(PKGTOOL_BIN_PKG)/.INSTALL
	@$(BUILD_BIN_PKG_REQUIRES) $(PKGTOOL_BIN_PKG)/.REQUIRES
	@echo "pkgname=$(PKGTOOL_BIN_PKG_NAME)"                            >  $(PKGTOOL_BIN_PKG)/.PKGINFO ; \
	 echo "pkgver=$(PKGTOOL_BIN_PKG_VERSION)"                          >> $(PKGTOOL_BIN_PKG)/.PKGINFO ; \
	 echo "arch=$(PKGTOOL_BIN_PKG_ARCH)"                               >> $(PKGTOOL_BIN_PKG)/.PKGINFO ; \
	 echo "distroname=$(PKGTOOL_BIN_PKG_DISTRO_NAME)"                  >> $(PKGTOOL_BIN_PKG)/.PKGINFO ; \
	 echo "distrover=$(PKGTOOL_BIN_PKG_DISTRO_VERSION)"                >> $(PKGTOOL_BIN_PKG)/.PKGINFO ; \
	 echo "group=$(PKGTOOL_BIN_PKG_GROUP)"                             >> $(PKGTOOL_BIN_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(PKGTOOL_BIN_PKG_SHORT_DESCRIPTION)\"" >> $(PKGTOOL_BIN_PKG)/.PKGINFO ; \
	 echo "url=$(PKGTOOL_BIN_PKG_URL)"                                 >> $(PKGTOOL_BIN_PKG)/.PKGINFO ; \
	 echo "license=$(PKGTOOL_BIN_PKG_LICENSE)"                         >> $(PKGTOOL_BIN_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(PKGTOOL_BIN_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
