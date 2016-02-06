
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


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/eudev

REQUIRES           = app/util-linux/2.27.1
REQUIRES          += libs/glib2/2.40.0
REQUIRES          += app/pciutils/3.2.1

# ======= __END_OF_REQUIRES__ =======


version            = 1.9
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/a/eudev/eudev-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/eudev-$(version)
src_dir_name       = eudev-$(version)
doc_dir_name       = libeudev-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_BCM74X_GLIBC)),)
PATCHES = PATCHES.mips
else
PATCHES = PATCHES
endif

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done

config_dir         = $(CURDIR)/config


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
EUDEV_PKG_NAME                = libeudev
EUDEV_PKG_VERSION             = 1.9
EUDEV_PKG_ARCH                = $(TOOLCHAIN)
EUDEV_PKG_DISTRO_NAME         = $(DISTRO_NAME)
EUDEV_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
EUDEV_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
EUDEV_PKG_SHORT_DESCRIPTION   = libraries for eudev
EUDEV_PKG_URL                 = $(BUG_URL)
EUDEV_PKG_LICENSE             = GPLv2
EUDEV_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(EUDEV_PKG_NAME)-pkg-description
EUDEV_PKG_DESCRIPTION_FILE_IN = $(EUDEV_PKG_NAME)-pkg-description.in
EUDEV_PKG_INSTALL_SCRIPT      = $(EUDEV_PKG_NAME)-pkg-install.sh

EUDEV_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(EUDEV_PKG_NAME)-package

pkg_basename     = $(EUDEV_PKG_NAME)-$(EUDEV_PKG_VERSION)-$(EUDEV_PKG_ARCH)-$(EUDEV_PKG_DISTRO_NAME)-$(EUDEV_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(EUDEV_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --with-rootlibdir=/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(doc_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --with-rootprefix=/
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --bindir=/sbin
extra_configure_switches += --sbindir=/sbin
extra_configure_switches += --libexecdir=/lib
extra_configure_switches += --with-firmware-path=/lib/firmware/updates:/lib/firmware
extra_configure_switches += --with-usb-ids-path=/usr/share/hwdata
extra_configure_switches += --with-pci-ids-path=/usr/share/hwdata
extra_configure_switches += --enable-gudev
extra_configure_switches += --disable-introspection
extra_configure_switches += --enable-floppy
extra_configure_switches += --enable-static
extra_configure_switches += --enable-rule_generator
extra_configure_switches += --with-systemdsystemunitdir=no
extra_configure_switches += --disable-selinux

extra_configure_switches += --enable-libkmod
# OR extra_configure_switches += --with-modprobe=/sbin/modprobe


TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) LIBS=-lrt ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(EUDEV_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(EUDEV_PKG)/etc
	@rm -rf $(EUDEV_PKG)/sbin
	@rm -rf $(EUDEV_PKG)/lib$(LIBSUFFIX)/udev
	@rm -rf $(EUDEV_PKG)/usr/share/man
	@rm -rf $(EUDEV_PKG)/usr/share/pkgconfig
	# ======= Install Documentation =======
	@mkdir -p $(EUDEV_PKG)/usr/doc/$(doc_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(EUDEV_PKG)/usr/doc/$(doc_dir_name)
	@mkdir -p $(EUDEV_PKG)/usr/share/doc/$(doc_dir_name)/html/{gudev,libudev}
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING README \
	         $(EUDEV_PKG)/usr/share/doc/$(doc_dir_name) \
	 )
	@( cd $(SRC_DIR)/docs/gudev/html ; \
	   cp -a *.html *.png *.css $(EUDEV_PKG)/usr/share/doc/$(doc_dir_name)/html/gudev ; \
	 )
	@( cd $(SRC_DIR)/docs/libudev/html ; \
	   cp -a *.html *.png *.css $(EUDEV_PKG)/usr/share/doc/$(doc_dir_name)/html/libudev ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(EUDEV_PKG)/usr/share/doc/$(doc_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove target destination path from target libtool *.la files =======
	@( cd $(EUDEV_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libgudev-?.?.la libudev.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(EUDEV_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libgudev-?.?.la libudev.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libgudev-?.?.la libudev.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" gudev-?.?.pc libudev.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(EUDEV_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(EUDEV_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(EUDEV_PKG_DESCRIPTION_FILE): $(EUDEV_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(EUDEV_PKG_DESCRIPTION_FILE) $(EUDEV_PKG_INSTALL_SCRIPT)
	@cp $(EUDEV_PKG_DESCRIPTION_FILE) $(EUDEV_PKG)/.DESCRIPTION
	@cp $(EUDEV_PKG_INSTALL_SCRIPT) $(EUDEV_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(EUDEV_PKG)/.REQUIRES
	@echo "pkgname=$(EUDEV_PKG_NAME)"                            >  $(EUDEV_PKG)/.PKGINFO ; \
	 echo "pkgver=$(EUDEV_PKG_VERSION)"                          >> $(EUDEV_PKG)/.PKGINFO ; \
	 echo "arch=$(EUDEV_PKG_ARCH)"                               >> $(EUDEV_PKG)/.PKGINFO ; \
	 echo "distroname=$(EUDEV_PKG_DISTRO_NAME)"                  >> $(EUDEV_PKG)/.PKGINFO ; \
	 echo "distrover=$(EUDEV_PKG_DISTRO_VERSION)"                >> $(EUDEV_PKG)/.PKGINFO ; \
	 echo "group=$(EUDEV_PKG_GROUP)"                             >> $(EUDEV_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(EUDEV_PKG_SHORT_DESCRIPTION)\"" >> $(EUDEV_PKG)/.PKGINFO ; \
	 echo "url=$(EUDEV_PKG_URL)"                                 >> $(EUDEV_PKG)/.PKGINFO ; \
	 echo "license=$(EUDEV_PKG_LICENSE)"                         >> $(EUDEV_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(EUDEV_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
