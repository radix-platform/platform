
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_DM64X)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/libgd

REQUIRES           = libs/libtiff/4.0.3
REQUIRES          += libs/libvpx/1.4.0
REQUIRES          += libs/libpng/libpng14/1.4.13
REQUIRES          += libs/libjpeg-turbo/1.3.1
REQUIRES          += libs/freetype/2.5.3
REQUIRES          += X11/libs/fontconfig/2.11.1
REQUIRES          += X11/X.org/lib/libXpm/3.5.11

# ======= __END_OF_REQUIRES__ =======


version            = 2.1.1
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/m/libgd/libgd-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libgd-$(version)
src_dir_name       = libgd-$(version)
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
LIBGD_PKG_NAME                = libgd
LIBGD_PKG_VERSION             = 2.1.1
LIBGD_PKG_ARCH                = $(TOOLCHAIN)
LIBGD_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBGD_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBGD_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
LIBGD_PKG_SHORT_DESCRIPTION   = GD graphic library
LIBGD_PKG_URL                 = $(BUG_URL)
LIBGD_PKG_LICENSE             = custom
LIBGD_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBGD_PKG_NAME)-pkg-description
LIBGD_PKG_DESCRIPTION_FILE_IN = $(LIBGD_PKG_NAME)-pkg-description.in
LIBGD_PKG_INSTALL_SCRIPT      = $(LIBGD_PKG_NAME)-pkg-install.sh

LIBGD_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBGD_PKG_NAME)-package

pkg_basename     = $(LIBGD_PKG_NAME)-$(LIBGD_PKG_VERSION)-$(LIBGD_PKG_ARCH)-$(LIBGD_PKG_DISTRO_NAME)-$(LIBGD_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(LIBGD_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --disable-rpath

extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes

major_version = $(shell echo $(version) | cut -f 1 -d '.')
minor_version = $(shell echo $(version) | cut -f 2 -d '.')
extra_version = $(shell echo $(version) | cut -f 3 -d '.')


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)
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
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LIBGD_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@( cd $(LIBGD_PKG)/usr/bin ; \
	   sed -i 's,@GDLIB_MAJOR@,$(major_version),g' gdlib-config ; \
	   sed -i 's,@GDLIB_MINOR@,$(minor_version),g' gdlib-config ; \
	   sed -i 's,@GDLIB_EXTRA@,$(extra_version),g' gdlib-config ; \
	 )
	# ======= Install Documentation =======
	@if [ -d $(LIBGD_PKG)/usr/share/man ]; then \
	  ( cd $(LIBGD_PKG)/usr/share/man ; \
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
	@mkdir -p $(LIBGD_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/CONTRIBUTORS $(SRC_DIR)/COPYING \
	       $(LIBGD_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(LIBGD_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a CONTRIBUTORS COPYING NEWS README \
	         docs/INSTALL* docs/README* docs/naturaldocs/html \
	         $(LIBGD_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(LIBGD_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBGD_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libgd.la \
	 )
	# ======= remove toolchain path from pkg-config *.pc files =======
	@( cd $(LIBGD_PKG)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" gdlib.pc \
	 )
	# ======= remove toolchain path from gdlib-config file =======
	@( cd $(LIBGD_PKG)/usr/bin ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" gdlib-config \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBGD_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libgd.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libgd.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" gdlib.pc \
	 )
	# ======= tune LDFLAGS in gdlib-config file to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/bin ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" gdlib-config ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" gdlib-config \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBGD_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(LIBGD_PKG)/usr/bin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(LIBGD_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(LIBGD_PKG_DESCRIPTION_FILE): $(LIBGD_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBGD_PKG_DESCRIPTION_FILE) $(LIBGD_PKG_INSTALL_SCRIPT)
	@cp $(LIBGD_PKG_DESCRIPTION_FILE) $(LIBGD_PKG)/.DESCRIPTION
	@cp $(LIBGD_PKG_INSTALL_SCRIPT) $(LIBGD_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBGD_PKG)/.REQUIRES
	@echo "pkgname=$(LIBGD_PKG_NAME)"                            >  $(LIBGD_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBGD_PKG_VERSION)"                          >> $(LIBGD_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBGD_PKG_ARCH)"                               >> $(LIBGD_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBGD_PKG_DISTRO_NAME)"                  >> $(LIBGD_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBGD_PKG_DISTRO_VERSION)"                >> $(LIBGD_PKG)/.PKGINFO ; \
	 echo "group=$(LIBGD_PKG_GROUP)"                             >> $(LIBGD_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBGD_PKG_SHORT_DESCRIPTION)\"" >> $(LIBGD_PKG)/.PKGINFO ; \
	 echo "url=$(LIBGD_PKG_URL)"                                 >> $(LIBGD_PKG)/.PKGINFO ; \
	 echo "license=$(LIBGD_PKG_LICENSE)"                         >> $(LIBGD_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBGD_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
