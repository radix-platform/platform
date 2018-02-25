
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


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/x/desktop-file-utils

REQUIRES           = libs/glib2/2.48.0

# ======= __END_OF_REQUIRES__ =======


version            = 0.22
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/x/desktop-file-utils/desktop-file-utils-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/desktop-file-utils-$(version)
src_dir_name       = desktop-file-utils-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = xapp

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
DFUTILS_PKG_NAME                = desktop-file-utils
DFUTILS_PKG_VERSION             = 0.22
DFUTILS_PKG_ARCH                = $(TOOLCHAIN)
DFUTILS_PKG_DISTRO_NAME         = $(DISTRO_NAME)
DFUTILS_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
DFUTILS_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
DFUTILS_PKG_SHORT_DESCRIPTION   = Utilities for manipulating desktop files
DFUTILS_PKG_URL                 = $(BUG_URL)
DFUTILS_PKG_LICENSE             = GPLv2
DFUTILS_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(DFUTILS_PKG_NAME)-pkg-description
DFUTILS_PKG_DESCRIPTION_FILE_IN = $(DFUTILS_PKG_NAME)-pkg-description.in
DFUTILS_PKG_INSTALL_SCRIPT      = $(DFUTILS_PKG_NAME)-pkg-install.sh

DFUTILS_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(DFUTILS_PKG_NAME)-package

pkg_basename     = $(DFUTILS_PKG_NAME)-$(DFUTILS_PKG_VERSION)-$(DFUTILS_PKG_ARCH)-$(DFUTILS_PKG_DISTRO_NAME)-$(DFUTILS_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../build-system/core.mk


env_sysroot = DESTDIR=$(DFUTILS_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
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
	@mkdir -p $(DFUTILS_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(environment) $(MAKE) -j1 install $(env_sysroot)
	@mkdir -p $(DFUTILS_PKG)/usr/share/applications
	# ======= Install Documentation =======
	@if [ -d $(DFUTILS_PKG)/usr/share/man ]; then \
	  ( cd $(DFUTILS_PKG)/usr/share/man ; \
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
	@mkdir -p $(DFUTILS_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(DFUTILS_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(DFUTILS_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING HACKING NEWS README \
	         $(DFUTILS_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(DFUTILS_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(DFUTILS_PKG))
	# ======= Strip binaries =======
	@( cd $(DFUTILS_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null \
	 )
	@touch $@

$(DFUTILS_PKG_DESCRIPTION_FILE): $(DFUTILS_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(DFUTILS_PKG_DESCRIPTION_FILE) $(DFUTILS_PKG_INSTALL_SCRIPT)
	@cp $(DFUTILS_PKG_DESCRIPTION_FILE) $(DFUTILS_PKG)/.DESCRIPTION
	@cp $(DFUTILS_PKG_INSTALL_SCRIPT) $(DFUTILS_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(DFUTILS_PKG)/.REQUIRES
	@echo "pkgname=$(DFUTILS_PKG_NAME)"                            >  $(DFUTILS_PKG)/.PKGINFO ; \
	 echo "pkgver=$(DFUTILS_PKG_VERSION)"                          >> $(DFUTILS_PKG)/.PKGINFO ; \
	 echo "arch=$(DFUTILS_PKG_ARCH)"                               >> $(DFUTILS_PKG)/.PKGINFO ; \
	 echo "distroname=$(DFUTILS_PKG_DISTRO_NAME)"                  >> $(DFUTILS_PKG)/.PKGINFO ; \
	 echo "distrover=$(DFUTILS_PKG_DISTRO_VERSION)"                >> $(DFUTILS_PKG)/.PKGINFO ; \
	 echo "group=$(DFUTILS_PKG_GROUP)"                             >> $(DFUTILS_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(DFUTILS_PKG_SHORT_DESCRIPTION)\"" >> $(DFUTILS_PKG)/.PKGINFO ; \
	 echo "url=$(DFUTILS_PKG_URL)"                                 >> $(DFUTILS_PKG)/.PKGINFO ; \
	 echo "license=$(DFUTILS_PKG_LICENSE)"                         >> $(DFUTILS_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(DFUTILS_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
