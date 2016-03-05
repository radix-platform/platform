
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/ghostscript-fonts-std

ifeq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC)),)
REQUIRES           = app/ghostscript/9.15
else
REQUIRES           = app/ghostscript/9.15-x86_32
endif
REQUIRES          += X11/X.org/app/mkfontdir/1.0.7
REQUIRES          += X11/X.org/app/mkfontscale/1.1.1

# ======= __END_OF_REQUIRES__ =======


version            = 8.11
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/a/ghostscript-fonts-std/ghostscript-fonts-std-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/fonts
doc_dir_name       = ghostscript-fonts-std-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
GSFONTS_PKG_NAME                = ghostscript-fonts-std
GSFONTS_PKG_VERSION             = 8.11
GSFONTS_PKG_ARCH                = $(TOOLCHAIN)
GSFONTS_PKG_DISTRO_NAME         = $(DISTRO_NAME)
GSFONTS_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
GSFONTS_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
GSFONTS_PKG_SHORT_DESCRIPTION   = Ghostscript fonts
GSFONTS_PKG_URL                 = $(BUG_URL)
GSFONTS_PKG_LICENSE             = GPLv2
GSFONTS_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GSFONTS_PKG_NAME)-pkg-description
GSFONTS_PKG_DESCRIPTION_FILE_IN = $(GSFONTS_PKG_NAME)-pkg-description.in
GSFONTS_PKG_INSTALL_SCRIPT      = $(GSFONTS_PKG_NAME)-pkg-install.sh

GSFONTS_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GSFONTS_PKG_NAME)-package

pkg_basename     = $(GSFONTS_PKG_NAME)-$(GSFONTS_PKG_VERSION)-$(GSFONTS_PKG_ARCH)-$(GSFONTS_PKG_DISTRO_NAME)-$(GSFONTS_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(install_target): $(src_done)
	@mkdir -p $(GSFONTS_PKG)/usr/share/{ghostscript,fonts/Type1}
	@( cd $(SRC_DIR) ; \
	   cp -a *.{afm,pfb,pfm} $(GSFONTS_PKG)/usr/share/fonts/Type1 ; \
	 )
	@( cd $(GSFONTS_PKG)/usr/share/ghostscript ; \
	   ln -sf ../fonts/Type1 fonts ; \
	 )
	# ======= Install Documentation =======
	@mkdir -p $(GSFONTS_PKG)/usr/doc/$(doc_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(GSFONTS_PKG)/usr/doc/$(doc_dir_name)
	@mkdir -p $(GSFONTS_PKG)/usr/share/doc/$(doc_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING README* TODO \
	         $(GSFONTS_PKG)/usr/share/doc/$(doc_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(GSFONTS_PKG)/usr/share/doc/$(doc_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(GSFONTS_PKG))
	@touch $@

$(GSFONTS_PKG_DESCRIPTION_FILE): $(GSFONTS_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(GSFONTS_PKG_DESCRIPTION_FILE) $(GSFONTS_PKG_INSTALL_SCRIPT)
	@cp $(GSFONTS_PKG_DESCRIPTION_FILE) $(GSFONTS_PKG)/.DESCRIPTION
	@cp $(GSFONTS_PKG_INSTALL_SCRIPT) $(GSFONTS_PKG)/.INSTALL
	@chmod a+x $(GSFONTS_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GSFONTS_PKG)/.REQUIRES
	@echo "pkgname=$(GSFONTS_PKG_NAME)"                            >  $(GSFONTS_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GSFONTS_PKG_VERSION)"                          >> $(GSFONTS_PKG)/.PKGINFO ; \
	 echo "arch=$(GSFONTS_PKG_ARCH)"                               >> $(GSFONTS_PKG)/.PKGINFO ; \
	 echo "distroname=$(GSFONTS_PKG_DISTRO_NAME)"                  >> $(GSFONTS_PKG)/.PKGINFO ; \
	 echo "distrover=$(GSFONTS_PKG_DISTRO_VERSION)"                >> $(GSFONTS_PKG)/.PKGINFO ; \
	 echo "group=$(GSFONTS_PKG_GROUP)"                             >> $(GSFONTS_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GSFONTS_PKG_SHORT_DESCRIPTION)\"" >> $(GSFONTS_PKG)/.PKGINFO ; \
	 echo "url=$(GSFONTS_PKG_URL)"                                 >> $(GSFONTS_PKG)/.PKGINFO ; \
	 echo "license=$(GSFONTS_PKG_LICENSE)"                         >> $(GSFONTS_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(GSFONTS_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
