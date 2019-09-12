
COMPONENT_TARGETS  = $(HARDWARE_OMAP5UEVM)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/hal/firmware/omap5-uevm

REQUIRES           = base/radix-system

# ======= __END_OF_REQUIRES__ =======


version            = 6.04.00.02
tar_xz_archive     = $(SRC_PACKAGE_PATH)/hal/firmware/omap5-uevm/omap5uevm-fw-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/omap5uevm-fw-$(version)
src_dir_name       = omap5uevm-fw-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = boot

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
OMAPFW_PKG_NAME                = omap5uevm-fw
OMAPFW_PKG_VERSION             = 6.04.00.02
OMAPFW_PKG_ARCH                = $(TOOLCHAIN)
OMAPFW_PKG_DISTRO_NAME         = $(DISTRO_NAME)
OMAPFW_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
OMAPFW_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
OMAPFW_PKG_SHORT_DESCRIPTION   = firmware for OMAP5 UEVM
OMAPFW_PKG_URL                 = $(BUG_URL)
OMAPFW_PKG_LICENSE             = GPLv2
OMAPFW_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(OMAPFW_PKG_NAME)-pkg-description
OMAPFW_PKG_DESCRIPTION_FILE_IN = $(OMAPFW_PKG_NAME)-pkg-description.in
OMAPFW_PKG_INSTALL_SCRIPT      = $(OMAPFW_PKG_NAME)-pkg-install.sh

OMAPFW_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(OMAPFW_PKG_NAME)-package

pkg_basename     = $(OMAPFW_PKG_NAME)-$(OMAPFW_PKG_VERSION)-$(OMAPFW_PKG_ARCH)-$(OMAPFW_PKG_DISTRO_NAME)-$(OMAPFW_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_certificate  = $(call cert-name,$(pkg_archive))
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../build-system/core.mk


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(install_target): $(src_done)
	@mkdir -p $(OMAPFW_PKG)/lib/firmware
	@( cd $(SRC_DIR) ; \
	   cp -a lib/firmware/* \
	         $(OMAPFW_PKG)/lib/firmware ; \
	 )
	# ======= Install Documentation =======
	@mkdir -p $(OMAPFW_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a README \
	         $(OMAPFW_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(OMAPFW_PKG))
	@touch $@

$(OMAPFW_PKG_DESCRIPTION_FILE): $(OMAPFW_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(OMAPFW_PKG_DESCRIPTION_FILE) $(OMAPFW_PKG_INSTALL_SCRIPT)
	@cp $(OMAPFW_PKG_DESCRIPTION_FILE) $(OMAPFW_PKG)/.DESCRIPTION
	@cp $(OMAPFW_PKG_INSTALL_SCRIPT) $(OMAPFW_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(OMAPFW_PKG)/.REQUIRES
	@echo "pkgname=$(OMAPFW_PKG_NAME)"                            >  $(OMAPFW_PKG)/.PKGINFO ; \
	 echo "pkgver=$(OMAPFW_PKG_VERSION)"                          >> $(OMAPFW_PKG)/.PKGINFO ; \
	 echo "arch=$(OMAPFW_PKG_ARCH)"                               >> $(OMAPFW_PKG)/.PKGINFO ; \
	 echo "distroname=$(OMAPFW_PKG_DISTRO_NAME)"                  >> $(OMAPFW_PKG)/.PKGINFO ; \
	 echo "distrover=$(OMAPFW_PKG_DISTRO_VERSION)"                >> $(OMAPFW_PKG)/.PKGINFO ; \
	 echo "group=$(OMAPFW_PKG_GROUP)"                             >> $(OMAPFW_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(OMAPFW_PKG_SHORT_DESCRIPTION)\"" >> $(OMAPFW_PKG)/.PKGINFO ; \
	 echo "url=$(OMAPFW_PKG_URL)"                                 >> $(OMAPFW_PKG)/.PKGINFO ; \
	 echo "license=$(OMAPFW_PKG_LICENSE)"                         >> $(OMAPFW_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(OMAPFW_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
