
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_VIP1830)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)
COMPONENT_TARGETS += $(HARDWARE_CI20)


NEED_ABS_PATH = true


include ../../build-system/constants.mk


REQUIRES           = base/init-devices

# ======= __END_OF_REQUIRES__ =======


dialog_version            = 1.2-20140112

dialog_archive            = ../../build-system/3pp/sources/packages/dialog/dialog-$(dialog_version).tgz
dialog_patch              = ../../build-system/3pp/sources/packages/dialog/patches/dialog-$(dialog_version).patch

dialog_download_script_in = $(CURDIR)/scripts/dialog-download.sh.in
dialog_install_script_in  = $(CURDIR)/scripts/install-dialog.sh.in

readme                    = $(CURDIR)/doc/README


PKG_GROUP = base

SETUP_DEV_PKG_NAME                = install-tools
SETUP_DEV_PKG_VERSION             = 1.1.0
SETUP_DEV_PKG_ARCH                = $(TOOLCHAIN)
SETUP_DEV_PKG_DISTRO_NAME         = $(DISTRO_NAME)
SETUP_DEV_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
SETUP_DEV_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
SETUP_DEV_PKG_SHORT_DESCRIPTION   = Radix Installation Tools
SETUP_DEV_PKG_URL                 = $(BUG_URL)
SETUP_DEV_PKG_LICENSE             = LGPLv2.1
SETUP_DEV_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(SETUP_DEV_PKG_NAME)-pkg-description
SETUP_DEV_PKG_DESCRIPTION_FILE_IN = $(SETUP_DEV_PKG_NAME)-pkg-description.in
SETUP_DEV_PKG_INSTALL_SCRIPT      = $(SETUP_DEV_PKG_NAME)-pkg-install.sh


SETUP_DEV_PKG   = $(TARGET_BUILD_DIR)/$(SETUP_DEV_PKG_NAME)-package

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

pkg_basename    = $(SETUP_DEV_PKG_NAME)-$(SETUP_DEV_PKG_VERSION)-$(SETUP_DEV_PKG_ARCH)-$(SETUP_DEV_PKG_DISTRO_NAME)-$(SETUP_DEV_PKG_DISTRO_VERSION)

pkg_archive     = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature   = $(call sign-name,$(pkg_archive))
pkg_description = $(call desc-name,$(pkg_archive))
products        = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS   = $(build)

PRODUCT_TARGETS = $(products)


include ../../build-system/core.mk


share_dir_name = $(SETUP_DEV_PKG_NAME)/$(SETUP_DEV_PKG_VERSION)


$(build):
	@mkdir -p $(SETUP_DEV_PKG)/usr/share/$(share_dir_name)/{doc,etc,sbin/pkgtool,tools/dialog/patches}
	# ======= Install Package Tool scripts =======
	@cp $(scripts) $(SETUP_DEV_PKG)/usr/share/$(share_dir_name)/sbin/pkgtool
	# ======= Install Dialog Sources =======
	@cp $(dialogrc) $(SETUP_DEV_PKG)/usr/share/$(share_dir_name)/etc/dialogrc
	@cat $(dialog_download_script_in) | \
	     sed 's,@VERSION@,$(dialog_version),' \
	     > $(SETUP_DEV_PKG)/usr/share/$(share_dir_name)/tools/dialog/dialog-download.sh
	@cat $(dialog_install_script_in) | \
	     sed 's,@VERSION@,$(dialog_version),' | \
	     sed 's,@INSTALL_TOOLS_VERSION@,$(SETUP_DEV_PKG_VERSION),' \
	     > $(SETUP_DEV_PKG)/usr/share/$(share_dir_name)/tools/dialog/install-dialog.sh
	@chmod 0644 $(SETUP_DEV_PKG)/usr/share/$(share_dir_name)/tools/dialog/dialog-download.sh
	@cp $(dialog_archive) $(SETUP_DEV_PKG)/usr/share/$(share_dir_name)/tools/dialog
	@cp $(dialog_patch)   $(SETUP_DEV_PKG)/usr/share/$(share_dir_name)/tools/dialog/patches
	# ======= Install Documentation =======
	@cp $(readme) $(SETUP_DEV_PKG)/usr/share/$(share_dir_name)/doc/README
	# ======= Install to the products directory for making releases =======
	@mkdir -p $(PRODUCTS_DEST_DIR)/.install
	@cp -a $(SETUP_DEV_PKG)/usr/share/$(share_dir_name) $(PRODUCTS_DEST_DIR)/.install
	# ======= Products Version Stamp =======
	@echo "$(SETUP_DEV_PKG_VERSION)" > $(PRODUCTS_DEST_DIR)/.install/.version
	@touch $@

$(SETUP_DEV_PKG_DESCRIPTION_FILE): $(SETUP_DEV_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(SETUP_DEV_PKG_VERSION)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(build) $(SETUP_DEV_PKG_DESCRIPTION_FILE) $(SETUP_DEV_PKG_INSTALL_SCRIPT)
	@cp $(SETUP_DEV_PKG_DESCRIPTION_FILE) $(SETUP_DEV_PKG)/.DESCRIPTION
	@cp $(SETUP_DEV_PKG_INSTALL_SCRIPT) $(SETUP_DEV_PKG)/.INSTALL
	@$(BUILD_BIN_PKG_REQUIRES) $(SETUP_DEV_PKG)/.REQUIRES
	@echo "pkgname=$(SETUP_DEV_PKG_NAME)"                            >  $(SETUP_DEV_PKG)/.PKGINFO ; \
	 echo "pkgver=$(SETUP_DEV_PKG_VERSION)"                          >> $(SETUP_DEV_PKG)/.PKGINFO ; \
	 echo "arch=$(SETUP_DEV_PKG_ARCH)"                               >> $(SETUP_DEV_PKG)/.PKGINFO ; \
	 echo "distroname=$(SETUP_DEV_PKG_DISTRO_NAME)"                  >> $(SETUP_DEV_PKG)/.PKGINFO ; \
	 echo "distrover=$(SETUP_DEV_PKG_DISTRO_VERSION)"                >> $(SETUP_DEV_PKG)/.PKGINFO ; \
	 echo "group=$(SETUP_DEV_PKG_GROUP)"                             >> $(SETUP_DEV_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(SETUP_DEV_PKG_SHORT_DESCRIPTION)\"" >> $(SETUP_DEV_PKG)/.PKGINFO ; \
	 echo "url=$(SETUP_DEV_PKG_URL)"                                 >> $(SETUP_DEV_PKG)/.PKGINFO ; \
	 echo "license=$(SETUP_DEV_PKG_LICENSE)"                         >> $(SETUP_DEV_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(SETUP_DEV_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
