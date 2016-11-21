
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


SOURCE_REQUIRES    = sources/packages/l/libusb

REQUIRES           = libs/eudev/3.1.5

# ======= __END_OF_REQUIRES__ =======


version            = 1.0.20
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/l/libusb/libusb-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libusb-$(version)
src_dir_name       = libusb-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LIBUSB_PKG_NAME                = libusb
LIBUSB_PKG_VERSION             = 1.0.20
LIBUSB_PKG_ARCH                = $(TOOLCHAIN)
LIBUSB_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBUSB_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBUSB_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
LIBUSB_PKG_SHORT_DESCRIPTION   = USB library
LIBUSB_PKG_URL                 = $(BUG_URL)
LIBUSB_PKG_LICENSE             = GPLv2
LIBUSB_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBUSB_PKG_NAME)-pkg-description
LIBUSB_PKG_DESCRIPTION_FILE_IN = $(LIBUSB_PKG_NAME)-pkg-description.in
LIBUSB_PKG_INSTALL_SCRIPT      = $(LIBUSB_PKG_NAME)-pkg-install.sh

LIBUSB_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBUSB_PKG_NAME)-package

pkg_basename     = $(LIBUSB_PKG_NAME)-$(LIBUSB_PKG_VERSION)-$(LIBUSB_PKG_ARCH)-$(LIBUSB_PKG_DISTRO_NAME)-$(LIBUSB_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(LIBUSB_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


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
	# ======= Now the libusb doesn't allow parallel building =======
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LIBUSB_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@mkdir -p $(LIBUSB_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(LIBUSB_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(LIBUSB_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING INSTALL NEWS PORTING README TODO \
	         $(LIBUSB_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(LIBUSB_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBUSB_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libusb-?.?.la  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBUSB_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libusb-?.?.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libusb-?.?.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libusb-?.?.pc \
	 )
	# ======= Strip Binaries =======
	@( cd $(LIBUSB_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(LIBUSB_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(LIBUSB_PKG_DESCRIPTION_FILE): $(LIBUSB_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBUSB_PKG_DESCRIPTION_FILE) $(LIBUSB_PKG_INSTALL_SCRIPT)
	@cp $(LIBUSB_PKG_DESCRIPTION_FILE) $(LIBUSB_PKG)/.DESCRIPTION
	@cp $(LIBUSB_PKG_INSTALL_SCRIPT) $(LIBUSB_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBUSB_PKG)/.REQUIRES
	@echo "pkgname=$(LIBUSB_PKG_NAME)"                            >  $(LIBUSB_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBUSB_PKG_VERSION)"                          >> $(LIBUSB_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBUSB_PKG_ARCH)"                               >> $(LIBUSB_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBUSB_PKG_DISTRO_NAME)"                  >> $(LIBUSB_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBUSB_PKG_DISTRO_VERSION)"                >> $(LIBUSB_PKG)/.PKGINFO ; \
	 echo "group=$(LIBUSB_PKG_GROUP)"                             >> $(LIBUSB_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBUSB_PKG_SHORT_DESCRIPTION)\"" >> $(LIBUSB_PKG)/.PKGINFO ; \
	 echo "url=$(LIBUSB_PKG_URL)"                                 >> $(LIBUSB_PKG)/.PKGINFO ; \
	 echo "license=$(LIBUSB_PKG_LICENSE)"                         >> $(LIBUSB_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBUSB_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
