
COMPONENT_TARGETS  += $(TARGET_PC32)
COMPONENT_TARGETS  += $(TARGET_PC64)
COMPONENT_TARGETS  += $(TARGET_CB1X)
COMPONENT_TARGETS  += $(TARGET_VIP1830)
COMPONENT_TARGETS  += $(TARGET_BEAGLE)
COMPONENT_TARGETS  += $(TARGET_OMAP5UEVM)
COMPONENT_TARGETS  += $(TARGET_B74)

#
# The rest targets links staticaly with newlib or uclibc and not requires xz libraties
#
# COMPONENT_TARGETS  += $(TARGET_CB1N)
# COMPONENT_TARGETS  += $(TARGET_GUARD)
# COMPONENT_TARGETS  += $(TARGET_VIP1830N)
# COMPONENT_TARGETS  += $(TARGET_L17UC)
#


NEED_ABS_PATH       = true

COMPONENT_IS_3PP    = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES     = $(SRC_PACKAGE_DIR)/packages/a/usbutils


REQUIRES            = libs/libusb/1.0.9


version             = 007
tar_xz_archive      = $(SRC_PACKAGE_PATH)/packages/a/usbutils/usbutils-$(version).tar.xz
SRC_ARCHIVE         = $(tar_xz_archive)
SRC_DIR             = $(TARGET_BUILD_DIR)/usbutils-$(version)
src_dir_name        = usbutils-$(version)
src_done            = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir           = $(TARGET_BUILD_DIR)/build
build_target        = $(TARGET_BUILD_DIR)/.build_done
install_target      = $(TARGET_BUILD_DIR)/.install_done
build_usbutils_pkg  = $(TARGET_BUILD_DIR)/.usbutils_pkg_done



####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
USBUTILS_PKG_NAME                = usbutils
USBUTILS_PKG_VERSION             = 007
USBUTILS_PKG_ARCH                = $(TOOLCHAIN)
USBUTILS_PKG_DISTRO_NAME         = kxLab
USBUTILS_PKG_DISTRO_VERSION      = 1.0
USBUTILS_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
USBUTILS_PKG_SHORT_DESCRIPTION   = usbutils $(version)
USBUTILS_PKG_URL                 = http://www.kxLab.com
USBUTILS_PKG_LICENSE             = GPLv2
USBUTILS_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(USBUTILS_PKG_NAME)-pkg-description
USBUTILS_PKG_DESCRIPTION_FILE_IN = $(USBUTILS_PKG_NAME)-pkg-description.in
USBUTILS_PKG_INSTALL_SCRIPT      = $(USBUTILS_PKG_NAME)-pkg-install.sh

USBUTILS_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(USBUTILS_PKG_NAME)-package

pkg_basename     = $(USBUTILS_PKG_NAME)-$(USBUTILS_PKG_VERSION)-$(USBUTILS_PKG_ARCH)-$(USBUTILS_PKG_DISTRO_NAME)-$(USBUTILS_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(USBUTILS_PKG_GROUP)/$(pkg_basename).tgz


BUILD_TARGETS    = $(build_usbutils_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(USBUTILS_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sbindir=/sbin
extra_configure_switches += --datadir=/usr/share/hwdata


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@( cd $(SRC_DIR) ; \
	   rm -f usb.ids* ; \
	   wget `grep 'SRC=' update-usbids.sh.in | cut -d= -f2- | tr -d \"` ; \
	 )
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
	@mkdir -p $(USBUTILS_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(environment) $(MAKE) install $(env_sysroot)
	@rm -f $(USBUTILS_PKG)/usr/share/hwdata/usb.ids.gz
	@mkdir -p $(USBUTILS_PKG)/usr/sbin
	mv $(USBUTILS_PKG)/sbin/update-usbids.sh $(USBUTILS_PKG)/usr/sbin/update-usbids.sh
	@( cd $(USBUTILS_PKG)/usr/sbin ; ln -sf update-usbids.sh update-usbids )
	@( cd $(USBUTILS_PKG)/sbin ; ln -sf ../usr/sbin/update-usbids.sh . )
	@mkdir -p $(USBUTILS_PKG)/usr/lib$(LIBSUFFIX)/pkgconfig
	@mv $(USBUTILS_PKG)/usr/share/pkgconfig/usbutils.pc $(USBUTILS_PKG)/usr/lib$(LIBSUFFIX)/pkgconfig
	@rm -rf $(USBUTILS_PKG)/usr/share/pkgconfig
	@ln -sf ../lib$(LIBSUFFIX)/pkgconfig $(USBUTILS_PKG)/usr/share/pkgconfig
	@if [ -d $(USBUTILS_PKG)/usr/share/man ]; then \
	  ( cd $(USBUTILS_PKG)/usr/share/man ; \
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
	@mkdir -p $(USBUTILS_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(USBUTILS_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(USBUTILS_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING INSTALL NEWS README \
	         $(USBUTILS_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(USBUTILS_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(USBUTILS_PKG) && cp -arf * $(TARGET_DEST_DIR)
	# tune pkg-config *.pc search path to the target destination of USB device database
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" usbutils.pc \
	 )
	@(cd $(USBUTILS_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(USBUTILS_PKG_DESCRIPTION_FILE): $(USBUTILS_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(build_usbutils_pkg): $(install_target) $(USBUTILS_PKG_DESCRIPTION_FILE)
	@cp $(USBUTILS_PKG_DESCRIPTION_FILE) $(USBUTILS_PKG)/.DESCRIPTION
	@cp $(USBUTILS_PKG_INSTALL_SCRIPT) $(USBUTILS_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(USBUTILS_PKG)/.REQUIRES
	@echo "pkgname=$(USBUTILS_PKG_NAME)"                            >  $(USBUTILS_PKG)/.PKGINFO ; \
	 echo "pkgver=$(USBUTILS_PKG_VERSION)"                          >> $(USBUTILS_PKG)/.PKGINFO ; \
	 echo "arch=$(USBUTILS_PKG_ARCH)"                               >> $(USBUTILS_PKG)/.PKGINFO ; \
	 echo "distroname=$(USBUTILS_PKG_DISTRO_NAME)"                  >> $(USBUTILS_PKG)/.PKGINFO ; \
	 echo "distrover=$(USBUTILS_PKG_DISTRO_VERSION)"                >> $(USBUTILS_PKG)/.PKGINFO ; \
	 echo "group=$(USBUTILS_PKG_GROUP)"                             >> $(USBUTILS_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(USBUTILS_PKG_SHORT_DESCRIPTION)\"" >> $(USBUTILS_PKG)/.PKGINFO ; \
	 echo "url=$(USBUTILS_PKG_URL)"                                 >> $(USBUTILS_PKG)/.PKGINFO ; \
	 echo "license=$(USBUTILS_PKG_LICENSE)"                         >> $(USBUTILS_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(USBUTILS_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@
