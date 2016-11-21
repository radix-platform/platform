
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXV)
COMPONENT_TARGETS += $(HARDWARE_P201)
COMPONENT_TARGETS += $(HARDWARE_NEXBOX_A95X)
COMPONENT_TARGETS += $(HARDWARE_P212)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_VIM)
COMPONENT_TARGETS += $(HARDWARE_Q201)
COMPONENT_TARGETS += $(HARDWARE_ENYBOX_X2)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/linuxdoc-tools/sgml-common

REQUIRES           = app/bash/4.3
REQUIRES          += app/grep/2.18
REQUIRES          += app/sed/4.2.2

# ======= __END_OF_REQUIRES__ =======


version            = 0.6.3
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/a/linuxdoc-tools/sgml-common/sgml-common-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/sgml-common-$(version)
src_dir_name       = sgml-common-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

autoconf_dir       = $(CURDIR)/auto

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = doc

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
SGML_PKG_NAME                = sgml-common
SGML_PKG_VERSION             = 0.6.3
SGML_PKG_ARCH                = $(TOOLCHAIN)
SGML_PKG_DISTRO_NAME         = $(DISTRO_NAME)
SGML_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
SGML_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
SGML_PKG_SHORT_DESCRIPTION   = Centralized SGML or XML catalogs tools
SGML_PKG_URL                 = $(BUG_URL)
SGML_PKG_LICENSE             = GPLv3
SGML_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(SGML_PKG_NAME)-pkg-description
SGML_PKG_DESCRIPTION_FILE_IN = $(SGML_PKG_NAME)-pkg-description.in
SGML_PKG_INSTALL_SCRIPT      = $(SGML_PKG_NAME)-pkg-install.sh

SGML_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(SGML_PKG_NAME)-package

pkg_basename     = $(SGML_PKG_NAME)-$(SGML_PKG_VERSION)-$(SGML_PKG_ARCH)-$(SGML_PKG_DISTRO_NAME)-$(SGML_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(SGML_PKG)


extra_configure_switches  = --libdir=/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc



####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@( cd $(SRC_DIR) ; \
	   rm -f COPYING INSTALL install-sh missing mkinstalldirs ; \
	   cp -a $(autoconf_dir)/COPYING       \
	         $(autoconf_dir)/INSTALL       \
	         $(autoconf_dir)/install-sh    \
	         $(autoconf_dir)/missing       \
	         $(autoconf_dir)/mkinstalldirs \
	         . ; \
	   chmod 0755 install-sh missing mkinstalldirs ; \
	   autoreconf -f -i ; \
	 )
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(SGML_PKG)
	@cd $(SRC_DIR) && \
	  $(BUILD_ENVIRONMENT) ./configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(SGML_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@( cd $(SGML_PKG)/usr ; mv doc share )
	# ======= Install Documentation =======
	@if [ -d $(SGML_PKG)/usr/share/man ]; then \
	  ( cd $(SGML_PKG)/usr/share/man ; \
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
	@mkdir -p $(SGML_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(SGML_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(SGML_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING INSTALL NEWS README \
	         $(SGML_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(SGML_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(SGML_PKG))
	@touch $@

$(SGML_PKG_DESCRIPTION_FILE): $(SGML_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(SGML_PKG_DESCRIPTION_FILE) $(SGML_PKG_INSTALL_SCRIPT)
	@cp $(SGML_PKG_DESCRIPTION_FILE) $(SGML_PKG)/.DESCRIPTION
	@cp $(SGML_PKG_INSTALL_SCRIPT) $(SGML_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(SGML_PKG)/.REQUIRES
	@echo "pkgname=$(SGML_PKG_NAME)"                            >  $(SGML_PKG)/.PKGINFO ; \
	 echo "pkgver=$(SGML_PKG_VERSION)"                          >> $(SGML_PKG)/.PKGINFO ; \
	 echo "arch=$(SGML_PKG_ARCH)"                               >> $(SGML_PKG)/.PKGINFO ; \
	 echo "distroname=$(SGML_PKG_DISTRO_NAME)"                  >> $(SGML_PKG)/.PKGINFO ; \
	 echo "distrover=$(SGML_PKG_DISTRO_VERSION)"                >> $(SGML_PKG)/.PKGINFO ; \
	 echo "group=$(SGML_PKG_GROUP)"                             >> $(SGML_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(SGML_PKG_SHORT_DESCRIPTION)\"" >> $(SGML_PKG)/.PKGINFO ; \
	 echo "url=$(SGML_PKG_URL)"                                 >> $(SGML_PKG)/.PKGINFO ; \
	 echo "license=$(SGML_PKG_LICENSE)"                         >> $(SGML_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(SGML_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
