
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
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/x/xdg-utils

REQUIRES           = X11/X.org/app/xset/1.2.3

# ======= __END_OF_REQUIRES__ =======


version            = 1.1.0
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/x/xdg-utils/xdg-utils-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/xdg-utils-$(version)
src_dir_name       = xdg-utils-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = xapp

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
XDGUTILS_PKG_NAME                = xdg-utils
XDGUTILS_PKG_VERSION             = 1.1.0
XDGUTILS_PKG_ARCH                = $(TOOLCHAIN)
XDGUTILS_PKG_DISTRO_NAME         = $(DISTRO_NAME)
XDGUTILS_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
XDGUTILS_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
XDGUTILS_PKG_SHORT_DESCRIPTION   = command line tools that assist applications
XDGUTILS_PKG_URL                 = $(BUG_URL)
XDGUTILS_PKG_LICENSE             = custom
XDGUTILS_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(XDGUTILS_PKG_NAME)-pkg-description
XDGUTILS_PKG_DESCRIPTION_FILE_IN = $(XDGUTILS_PKG_NAME)-pkg-description.in
XDGUTILS_PKG_INSTALL_SCRIPT      = $(XDGUTILS_PKG_NAME)-pkg-install.sh

XDGUTILS_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(XDGUTILS_PKG_NAME)-package

pkg_basename     = $(XDGUTILS_PKG_NAME)-$(XDGUTILS_PKG_VERSION)-$(XDGUTILS_PKG_ARCH)-$(XDGUTILS_PKG_DISTRO_NAME)-$(XDGUTILS_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../build-system/core.mk


env_sysroot = DESTDIR=$(XDGUTILS_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && \
	  $(BUILD_ENVIRONMENT) ./configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(XDGUTILS_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(XDGUTILS_PKG)/usr/share/man ]; then \
	  ( cd $(XDGUTILS_PKG)/usr/share/man ; \
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
	@mkdir -p $(XDGUTILS_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/LICENSE \
	       $(XDGUTILS_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(XDGUTILS_PKG)/usr/share/doc/$(src_dir_name)/html
	@( cd $(SRC_DIR) ; \
	   cp -a LICENSE README* TODO \
	         $(XDGUTILS_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR)/scripts/html ; \
	   cp -a *.html \
	         $(XDGUTILS_PKG)/usr/share/doc/$(src_dir_name)/html \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(XDGUTILS_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(XDGUTILS_PKG))
	@touch $@

$(XDGUTILS_PKG_DESCRIPTION_FILE): $(XDGUTILS_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(XDGUTILS_PKG_DESCRIPTION_FILE) $(XDGUTILS_PKG_INSTALL_SCRIPT)
	@cp $(XDGUTILS_PKG_DESCRIPTION_FILE) $(XDGUTILS_PKG)/.DESCRIPTION
	@cp $(XDGUTILS_PKG_INSTALL_SCRIPT) $(XDGUTILS_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(XDGUTILS_PKG)/.REQUIRES
	@echo "pkgname=$(XDGUTILS_PKG_NAME)"                            >  $(XDGUTILS_PKG)/.PKGINFO ; \
	 echo "pkgver=$(XDGUTILS_PKG_VERSION)"                          >> $(XDGUTILS_PKG)/.PKGINFO ; \
	 echo "arch=$(XDGUTILS_PKG_ARCH)"                               >> $(XDGUTILS_PKG)/.PKGINFO ; \
	 echo "distroname=$(XDGUTILS_PKG_DISTRO_NAME)"                  >> $(XDGUTILS_PKG)/.PKGINFO ; \
	 echo "distrover=$(XDGUTILS_PKG_DISTRO_VERSION)"                >> $(XDGUTILS_PKG)/.PKGINFO ; \
	 echo "group=$(XDGUTILS_PKG_GROUP)"                             >> $(XDGUTILS_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(XDGUTILS_PKG_SHORT_DESCRIPTION)\"" >> $(XDGUTILS_PKG)/.PKGINFO ; \
	 echo "url=$(XDGUTILS_PKG_URL)"                                 >> $(XDGUTILS_PKG)/.PKGINFO ; \
	 echo "license=$(XDGUTILS_PKG_LICENSE)"                         >> $(XDGUTILS_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(XDGUTILS_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
