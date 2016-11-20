
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXV)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/x/libevdev

REQUIRES          += dev/check/0.10.0

# ======= __END_OF_REQUIRES__ =======


version            = 1.5.1
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/x/libevdev/libevdev-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libevdev-$(version)
src_dir_name       = libevdev-$(version)
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
LIBEVDEV_PKG_NAME                = libevdev
LIBEVDEV_PKG_VERSION             = 1.5.1
LIBEVDEV_PKG_ARCH                = $(TOOLCHAIN)
LIBEVDEV_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBEVDEV_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBEVDEV_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
LIBEVDEV_PKG_SHORT_DESCRIPTION   = Wrapper library for evdev devices
LIBEVDEV_PKG_URL                 = $(BUG_URL)
LIBEVDEV_PKG_LICENSE             = custom
LIBEVDEV_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBEVDEV_PKG_NAME)-pkg-description
LIBEVDEV_PKG_DESCRIPTION_FILE_IN = $(LIBEVDEV_PKG_NAME)-pkg-description.in
LIBEVDEV_PKG_INSTALL_SCRIPT      = $(LIBEVDEV_PKG_NAME)-pkg-install.sh

LIBEVDEV_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBEVDEV_PKG_NAME)-package

pkg_basename     = $(LIBEVDEV_PKG_NAME)-$(LIBEVDEV_PKG_VERSION)-$(LIBEVDEV_PKG_ARCH)-$(LIBEVDEV_PKG_DISTRO_NAME)-$(LIBEVDEV_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../build-system/core.mk


env_sysroot = DESTDIR=$(LIBEVDEV_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


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
	@mkdir -p $(LIBEVDEV_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(LIBEVDEV_PKG)/usr/share/man ]; then \
	  ( cd $(LIBEVDEV_PKG)/usr/share/man ; \
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
	@mkdir -p $(LIBEVDEV_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(LIBEVDEV_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(LIBEVDEV_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING \
	         $(LIBEVDEV_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(build_dir) ; \
	   cp -a doc/html \
	         $(LIBEVDEV_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(LIBEVDEV_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBEVDEV_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libevdev.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBEVDEV_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libevdev.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libevdev.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libevdev.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBEVDEV_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBEVDEV_PKG_DESCRIPTION_FILE): $(LIBEVDEV_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBEVDEV_PKG_DESCRIPTION_FILE) $(LIBEVDEV_PKG_INSTALL_SCRIPT)
	@cp $(LIBEVDEV_PKG_DESCRIPTION_FILE) $(LIBEVDEV_PKG)/.DESCRIPTION
	@cp $(LIBEVDEV_PKG_INSTALL_SCRIPT) $(LIBEVDEV_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBEVDEV_PKG)/.REQUIRES
	@echo "pkgname=$(LIBEVDEV_PKG_NAME)"                            >  $(LIBEVDEV_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBEVDEV_PKG_VERSION)"                          >> $(LIBEVDEV_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBEVDEV_PKG_ARCH)"                               >> $(LIBEVDEV_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBEVDEV_PKG_DISTRO_NAME)"                  >> $(LIBEVDEV_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBEVDEV_PKG_DISTRO_VERSION)"                >> $(LIBEVDEV_PKG)/.PKGINFO ; \
	 echo "group=$(LIBEVDEV_PKG_GROUP)"                             >> $(LIBEVDEV_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBEVDEV_PKG_SHORT_DESCRIPTION)\"" >> $(LIBEVDEV_PKG)/.PKGINFO ; \
	 echo "url=$(LIBEVDEV_PKG_URL)"                                 >> $(LIBEVDEV_PKG)/.PKGINFO ; \
	 echo "license=$(LIBEVDEV_PKG_LICENSE)"                         >> $(LIBEVDEV_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBEVDEV_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
