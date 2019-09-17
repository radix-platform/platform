
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_ORANGE_PP2E)
COMPONENT_TARGETS += $(HARDWARE_NANOPI_NEO)
COMPONENT_TARGETS += $(HARDWARE_ORANGE_PP)
COMPONENT_TARGETS += $(HARDWARE_ORANGE_PL2)
COMPONENT_TARGETS += $(HARDWARE_WECHIP_TX6)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_POIN2)
COMPONENT_TARGETS += $(HARDWARE_RK3328_CC)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_EDGE)
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


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/x/hicolor-icon-theme

REQUIRES           = base/radix-system

# ======= __END_OF_REQUIRES__ =======


version            = 0.15
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/x/hicolor-icon-theme/hicolor-icon-theme-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/hicolor-icon-theme-$(version)
src_dir_name       = hicolor-icon-theme-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = xlibs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
DITHEME_PKG_NAME                = hicolor-icon-theme
DITHEME_PKG_VERSION             = 0.15
DITHEME_PKG_ARCH                = $(TOOLCHAIN)
DITHEME_PKG_DISTRO_NAME         = $(DISTRO_NAME)
DITHEME_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
DITHEME_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
DITHEME_PKG_SHORT_DESCRIPTION   = default icon theme
DITHEME_PKG_URL                 = $(BUG_URL)
DITHEME_PKG_LICENSE             = GPLv2
DITHEME_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(DITHEME_PKG_NAME)-pkg-description
DITHEME_PKG_DESCRIPTION_FILE_IN = $(DITHEME_PKG_NAME)-pkg-description.in
DITHEME_PKG_INSTALL_SCRIPT      = $(DITHEME_PKG_NAME)-pkg-install.sh

DITHEME_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(DITHEME_PKG_NAME)-package

pkg_basename     = $(DITHEME_PKG_NAME)-$(DITHEME_PKG_VERSION)-$(DITHEME_PKG_ARCH)-$(DITHEME_PKG_DISTRO_NAME)-$(DITHEME_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_certificate  = $(call cert-name,$(pkg_archive))
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../build-system/core.mk


env_sysroot = DESTDIR=$(DITHEME_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@( cd $(SRC_DIR) ; ./autogen.sh ; make distclean ; chmod 0644 COPYING )
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) $(environment) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(environment) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(DITHEME_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(environment) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(DITHEME_PKG)/usr/share/man ]; then \
	  ( cd $(DITHEME_PKG)/usr/share/man ; \
	    for manpagedir in `find . -type d -name "man*"` ; do \
	      ( cd $$manpagedir ; \
	        for eachpage in `find . -type l -maxdepth 1` ; do \
	          ln -s `readlink $$eachpage`.gz $$eachpage.gz ; \
	          rm $$eachpage ; \
	        done ; \
	        gzip -9 *.?  ; \
	      ) \
	    done \
	  ) \
	 fi
	@mkdir -p $(DITHEME_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(DITHEME_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(DITHEME_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING NEWS README spec \
	         $(DITHEME_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(DITHEME_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(DITHEME_PKG))
	@touch $@

$(DITHEME_PKG_DESCRIPTION_FILE): $(DITHEME_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(DITHEME_PKG_DESCRIPTION_FILE) $(DITHEME_PKG_INSTALL_SCRIPT)
	@cp $(DITHEME_PKG_DESCRIPTION_FILE) $(DITHEME_PKG)/.DESCRIPTION
	@cp $(DITHEME_PKG_INSTALL_SCRIPT) $(DITHEME_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(DITHEME_PKG)/.REQUIRES
	@echo "pkgname=$(DITHEME_PKG_NAME)"                            >  $(DITHEME_PKG)/.PKGINFO ; \
	 echo "pkgver=$(DITHEME_PKG_VERSION)"                          >> $(DITHEME_PKG)/.PKGINFO ; \
	 echo "arch=$(DITHEME_PKG_ARCH)"                               >> $(DITHEME_PKG)/.PKGINFO ; \
	 echo "distroname=$(DITHEME_PKG_DISTRO_NAME)"                  >> $(DITHEME_PKG)/.PKGINFO ; \
	 echo "distrover=$(DITHEME_PKG_DISTRO_VERSION)"                >> $(DITHEME_PKG)/.PKGINFO ; \
	 echo "group=$(DITHEME_PKG_GROUP)"                             >> $(DITHEME_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(DITHEME_PKG_SHORT_DESCRIPTION)\"" >> $(DITHEME_PKG)/.PKGINFO ; \
	 echo "url=$(DITHEME_PKG_URL)"                                 >> $(DITHEME_PKG)/.PKGINFO ; \
	 echo "license=$(DITHEME_PKG_LICENSE)"                         >> $(DITHEME_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(DITHEME_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
