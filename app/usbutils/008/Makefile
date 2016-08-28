
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/usbutils
SOURCE_REQUIRES   += sources/packages/l/usbids

ifeq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC)),)
REQUIRES           = libs/libusb-compat/0.1.5
else
REQUIRES           = libs/libusb-compat/0.1.5-x86_32
endif

# ======= __END_OF_REQUIRES__ =======


version            = 008
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/a/usbutils/usbutils-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/usbutils-$(version)
src_dir_name       = usbutils-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

usb_ids_version    = 20160209
usb_ids_archive    = $(SRC_PACKAGE_PATH)/packages/l/usbids/usbids-$(usb_ids_version).tar.xz


PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
USBUTILS_PKG_NAME                = usbutils
USBUTILS_PKG_VERSION             = 008
USBUTILS_PKG_ARCH                = $(TOOLCHAIN)
USBUTILS_PKG_DISTRO_NAME         = $(DISTRO_NAME)
USBUTILS_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
USBUTILS_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
USBUTILS_PKG_SHORT_DESCRIPTION   = USB utilities
USBUTILS_PKG_URL                 = $(BUG_URL)
USBUTILS_PKG_LICENSE             = GPLv2
USBUTILS_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(USBUTILS_PKG_NAME)-pkg-description
USBUTILS_PKG_DESCRIPTION_FILE_IN = $(USBUTILS_PKG_NAME)-pkg-description.in
USBUTILS_PKG_INSTALL_SCRIPT      = $(USBUTILS_PKG_NAME)-pkg-install.sh

USBUTILS_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(USBUTILS_PKG_NAME)-package

pkg_basename     = $(USBUTILS_PKG_NAME)-$(USBUTILS_PKG_VERSION)-$(USBUTILS_PKG_ARCH)-$(USBUTILS_PKG_DISTRO_NAME)-$(USBUTILS_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(USBUTILS_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sbindir=/sbin
extra_configure_switches += --datadir=/usr/share/hwdata


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	# ======= Expanding $(usb_ids_archive) =======
	@tar xJf $(usb_ids_archive) -C $(SRC_DIR)
	@( cd $(SRC_DIR) ; \
	   chmod +x autogen.sh ; ./autogen.sh ; \
	 )
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
	@mkdir -p $(USBUTILS_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(environment) $(MAKE) -j1 install $(env_sysroot)
	@mkdir -p $(USBUTILS_PKG)/usr/sbin
	mv $(USBUTILS_PKG)/sbin/update-usbids.sh $(USBUTILS_PKG)/usr/sbin/update-usbids.sh
	@( cd $(USBUTILS_PKG)/usr/sbin ; ln -sf update-usbids.sh update-usbids )
	@( cd $(USBUTILS_PKG)/sbin ; ln -sf ../usr/sbin/update-usbids.sh . )
	# ====== Install Documentation =======
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
	$(call install-into-devenv, $(USBUTILS_PKG))
	# ======= tune pkg-config *.pc search path to the target destination of USB device database =======
	@( cd $(TARGET_DEST_DIR)/usr/share/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" usbutils.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(USBUTILS_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(USBUTILS_PKG)/usr/bin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(USBUTILS_PKG_DESCRIPTION_FILE): $(USBUTILS_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(USBUTILS_PKG_DESCRIPTION_FILE) $(USBUTILS_PKG_INSTALL_SCRIPT)
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
