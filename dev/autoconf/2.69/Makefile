
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/GNU/autoconf

REQUIRES           = app/bash/4.3
REQUIRES          += app/gawk/4.1.1
REQUIRES          += app/diffutils/3.3
REQUIRES          += dev/m4/1.4.17
REQUIRES          += dev/perl/5.22.1

# ======= __END_OF_REQUIRES__ =======


version            = 2.69
tar_xz_archive     = $(SRC_PACKAGE_PATH)/GNU/autoconf/autoconf-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/autoconf-$(version)
src_dir_name       = autoconf-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = dev

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
AUTOCONF_PKG_NAME                = autoconf
AUTOCONF_PKG_VERSION             = 2.69
AUTOCONF_PKG_ARCH                = $(TOOLCHAIN)
AUTOCONF_PKG_DISTRO_NAME         = $(DISTRO_NAME)
AUTOCONF_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
AUTOCONF_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
AUTOCONF_PKG_SHORT_DESCRIPTION   = generate configuration scripts
AUTOCONF_PKG_URL                 = $(BUG_URL)
AUTOCONF_PKG_LICENSE             = GPLv3
AUTOCONF_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(AUTOCONF_PKG_NAME)-pkg-description
AUTOCONF_PKG_DESCRIPTION_FILE_IN = $(AUTOCONF_PKG_NAME)-pkg-description.in
AUTOCONF_PKG_INSTALL_SCRIPT      = $(AUTOCONF_PKG_NAME)-pkg-install.sh

AUTOCONF_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(AUTOCONF_PKG_NAME)-package

pkg_basename     = $(AUTOCONF_PKG_NAME)-$(AUTOCONF_PKG_VERSION)-$(AUTOCONF_PKG_ARCH)-$(AUTOCONF_PKG_DISTRO_NAME)-$(AUTOCONF_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(AUTOCONF_PKG)


extra_configure_switches  = --libdir=/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(AUTOCONF_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@rm -f $(AUTOCONF_PKG)/usr/share/info/dir
	@gzip -9 $(AUTOCONF_PKG)/usr/share/info/*
	@if [ -d $(AUTOCONF_PKG)/usr/share/man ]; then \
	  ( cd $(AUTOCONF_PKG)/usr/share/man ; \
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
	@mkdir -p $(AUTOCONF_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING* \
	       $(AUTOCONF_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(AUTOCONF_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS BUGS COPYING* INSTALL NEWS README THANKS TODO \
	         $(AUTOCONF_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(AUTOCONF_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(AUTOCONF_PKG))
	@touch $@

$(AUTOCONF_PKG_DESCRIPTION_FILE): $(AUTOCONF_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(AUTOCONF_PKG_DESCRIPTION_FILE) $(AUTOCONF_PKG_INSTALL_SCRIPT)
	@cp $(AUTOCONF_PKG_DESCRIPTION_FILE) $(AUTOCONF_PKG)/.DESCRIPTION
	@cp $(AUTOCONF_PKG_INSTALL_SCRIPT) $(AUTOCONF_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(AUTOCONF_PKG)/.REQUIRES
	@echo "pkgname=$(AUTOCONF_PKG_NAME)"                            >  $(AUTOCONF_PKG)/.PKGINFO ; \
	 echo "pkgver=$(AUTOCONF_PKG_VERSION)"                          >> $(AUTOCONF_PKG)/.PKGINFO ; \
	 echo "arch=$(AUTOCONF_PKG_ARCH)"                               >> $(AUTOCONF_PKG)/.PKGINFO ; \
	 echo "distroname=$(AUTOCONF_PKG_DISTRO_NAME)"                  >> $(AUTOCONF_PKG)/.PKGINFO ; \
	 echo "distrover=$(AUTOCONF_PKG_DISTRO_VERSION)"                >> $(AUTOCONF_PKG)/.PKGINFO ; \
	 echo "group=$(AUTOCONF_PKG_GROUP)"                             >> $(AUTOCONF_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(AUTOCONF_PKG_SHORT_DESCRIPTION)\"" >> $(AUTOCONF_PKG)/.PKGINFO ; \
	 echo "url=$(AUTOCONF_PKG_URL)"                                 >> $(AUTOCONF_PKG)/.PKGINFO ; \
	 echo "license=$(AUTOCONF_PKG_LICENSE)"                         >> $(AUTOCONF_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(AUTOCONF_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
