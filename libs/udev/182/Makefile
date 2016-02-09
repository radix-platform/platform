
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_DM64X)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/udev

REQUIRES           = app/kmod/22
REQUIRES          += libs/pcre/8.38
REQUIRES          += app/util-linux/2.24.1
REQUIRES          += libs/glib2/2.40.0
REQUIRES          += app/pciutils/3.2.1

# ======= __END_OF_REQUIRES__ =======


version            = 182
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/a/udev/udev-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/udev-$(version)
src_dir_name       = udev-$(version)
doc_dir_name       = libudev-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done

config_dir         = $(CURDIR)/config


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
UDEV_PKG_NAME                = libudev
UDEV_PKG_VERSION             = 182
UDEV_PKG_ARCH                = $(TOOLCHAIN)
UDEV_PKG_DISTRO_NAME         = $(DISTRO_NAME)
UDEV_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
UDEV_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
UDEV_PKG_SHORT_DESCRIPTION   = libraries for udev
UDEV_PKG_URL                 = $(BUG_URL)
UDEV_PKG_LICENSE             = GPLv2
UDEV_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(UDEV_PKG_NAME)-pkg-description
UDEV_PKG_DESCRIPTION_FILE_IN = $(UDEV_PKG_NAME)-pkg-description.in
UDEV_PKG_INSTALL_SCRIPT      = $(UDEV_PKG_NAME)-pkg-install.sh

UDEV_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(UDEV_PKG_NAME)-package

pkg_basename     = $(UDEV_PKG_NAME)-$(UDEV_PKG_VERSION)-$(UDEV_PKG_ARCH)-$(UDEV_PKG_DISTRO_NAME)-$(UDEV_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(UDEV_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --with-rootlibdir=/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(doc_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --with-rootprefix=/
extra_configure_switches += --with-firmware-path=/lib/firmware/updates:/lib/firmware
extra_configure_switches += --with-usb-ids-path=/usr/share/hwdata
extra_configure_switches += --with-pci-ids-path=/usr/share/hwdata
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --bindir=/sbin
extra_configure_switches += --sbindir=/sbin
extra_configure_switches += --libexecdir=/lib
extra_configure_switches += --enable-introspection=no
extra_configure_switches += --enable-floppy
extra_configure_switches += --enable-static
extra_configure_switches += --enable-rule_generator
extra_configure_switches += --with-systemdsystemunitdir=no


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
	@mkdir -p $(UDEV_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(UDEV_PKG)/etc
	@rm -rf $(UDEV_PKG)/sbin
	@rm -rf $(UDEV_PKG)/lib$(LIBSUFFIX)/udev
	@rm -rf $(UDEV_PKG)/usr/share/man
	@rm -rf $(UDEV_PKG)/usr/share/pkgconfig
	# ======= Install Documentation =======
	@mkdir -p $(UDEV_PKG)/usr/doc/$(doc_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(UDEV_PKG)/usr/doc/$(doc_dir_name)
	@mkdir -p $(UDEV_PKG)/usr/share/doc/$(doc_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING INSTALL NEWS README TODO \
	         $(UDEV_PKG)/usr/share/doc/$(doc_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(UDEV_PKG)/usr/share/doc/$(doc_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove target destination path from target libtool *.la files =======
	@( cd $(UDEV_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libgudev-?.?.la libudev.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(UDEV_PKG))
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
	@( cd $(UDEV_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(UDEV_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(UDEV_PKG_DESCRIPTION_FILE): $(UDEV_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(UDEV_PKG_DESCRIPTION_FILE) $(UDEV_PKG_INSTALL_SCRIPT)
	@cp $(UDEV_PKG_DESCRIPTION_FILE) $(UDEV_PKG)/.DESCRIPTION
	@cp $(UDEV_PKG_INSTALL_SCRIPT) $(UDEV_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(UDEV_PKG)/.REQUIRES
	@echo "pkgname=$(UDEV_PKG_NAME)"                            >  $(UDEV_PKG)/.PKGINFO ; \
	 echo "pkgver=$(UDEV_PKG_VERSION)"                          >> $(UDEV_PKG)/.PKGINFO ; \
	 echo "arch=$(UDEV_PKG_ARCH)"                               >> $(UDEV_PKG)/.PKGINFO ; \
	 echo "distroname=$(UDEV_PKG_DISTRO_NAME)"                  >> $(UDEV_PKG)/.PKGINFO ; \
	 echo "distrover=$(UDEV_PKG_DISTRO_VERSION)"                >> $(UDEV_PKG)/.PKGINFO ; \
	 echo "group=$(UDEV_PKG_GROUP)"                             >> $(UDEV_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(UDEV_PKG_SHORT_DESCRIPTION)\"" >> $(UDEV_PKG)/.PKGINFO ; \
	 echo "url=$(UDEV_PKG_URL)"                                 >> $(UDEV_PKG)/.PKGINFO ; \
	 echo "license=$(UDEV_PKG_LICENSE)"                         >> $(UDEV_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(UDEV_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
