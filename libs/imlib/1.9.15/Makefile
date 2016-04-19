
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/imlib

REQUIRES           = libs/libpng/libpng14/1.4.19
REQUIRES          += libs/libtiff/4.0.3
REQUIRES          += libs/giflib/5.1.0
REQUIRES          += X11/X.org/lib/libXt/1.1.4
REQUIRES          += X11/X.org/lib/libXext/1.3.3

# ======= __END_OF_REQUIRES__ =======


version            = 1.9.15
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/l/imlib/imlib-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/imlib-$(version)
src_dir_name       = imlib-$(version)
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
IMLIB_PKG_NAME                = imlib
IMLIB_PKG_VERSION             = 1.9.15
IMLIB_PKG_ARCH                = $(TOOLCHAIN)
IMLIB_PKG_DISTRO_NAME         = $(DISTRO_NAME)
IMLIB_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
IMLIB_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
IMLIB_PKG_SHORT_DESCRIPTION   = image loading and rendering library
IMLIB_PKG_URL                 = $(BUG_URL)
IMLIB_PKG_LICENSE             = GPLv2
IMLIB_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(IMLIB_PKG_NAME)-pkg-description
IMLIB_PKG_DESCRIPTION_FILE_IN = $(IMLIB_PKG_NAME)-pkg-description.in
IMLIB_PKG_INSTALL_SCRIPT      = $(IMLIB_PKG_NAME)-pkg-install.sh

IMLIB_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(IMLIB_PKG_NAME)-package

pkg_basename     = $(IMLIB_PKG_NAME)-$(IMLIB_PKG_VERSION)-$(IMLIB_PKG_ARCH)-$(IMLIB_PKG_DISTRO_NAME)-$(IMLIB_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(IMLIB_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --sysconfdir=/etc

extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@( cd $(SRC_DIR) ; \
	   autoreconf -i ; \
	 )
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@( cd $(build_dir) ; \
	   sed -i "s,^\(CPPFLAGS =\).*,\1 -I$(TARGET_DEST_DIR)/usr/include," Makefile ; \
	   sed -i "s,^\(CPPFLAGS =\).*,\1 -I$(TARGET_DEST_DIR)/usr/include," Imlib/Makefile ; \
	   sed -i "s,^\(CPPFLAGS =\).*,\1 -I$(TARGET_DEST_DIR)/usr/include," utils/Makefile ; \
	 )
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(IMLIB_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -f $(IMLIB_PKG)/usr/lib$(LIBSUFFIX)/pkgconfig/imlibgdk.pc
	# ======= Install Documentation =======
	@if [ -d $(IMLIB_PKG)/usr/share/man ]; then \
	  ( cd $(IMLIB_PKG)/usr/share/man ; \
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
	@mkdir -p $(IMLIB_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING* \
	       $(IMLIB_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(IMLIB_PKG)/usr/share/doc/$(src_dir_name)/html
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING* INSTALL README \
	         $(IMLIB_PKG)/usr/share/doc/$(src_dir_name) ; \
	   cp -a doc/*.{gif,html} \
	         $(IMLIB_PKG)/usr/share/doc/$(src_dir_name)/html ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(IMLIB_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(IMLIB_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libImlib.la \
	 )
	# ======= remove toolchain path from target imlib *.pc files =======
	@( cd $(IMLIB_PKG)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" imlib.pc \
	 )
	# ======= remove toolchain path from target imlib-config script =======
	@( cd $(IMLIB_PKG)/usr/bin ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" imlib-config \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(IMLIB_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libImlib.la ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libImlib.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,=/usr,=$(TARGET_DEST_DIR)/usr,g"   imlib.pc ; \
	   sed -i "s,-L/usr,-L$(TARGET_DEST_DIR)/usr,g" imlib.pc ; \
	 )
	# ======= tune imlib-config script to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/bin ; \
	   sed -i "s,prefix=/usr,prefix=$(TARGET_DEST_DIR)/usr,g" imlib-config ; \
	   sed -i "s,-L/usr,-L$(TARGET_DEST_DIR)/usr,g"           imlib-config ; \
	 )
	# ======= Strip binaries =======
	@( cd $(IMLIB_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(IMLIB_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(IMLIB_PKG_DESCRIPTION_FILE): $(IMLIB_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(IMLIB_PKG_DESCRIPTION_FILE) $(IMLIB_PKG_INSTALL_SCRIPT)
	@cp $(IMLIB_PKG_DESCRIPTION_FILE) $(IMLIB_PKG)/.DESCRIPTION
	@cp $(IMLIB_PKG_INSTALL_SCRIPT) $(IMLIB_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(IMLIB_PKG)/.REQUIRES
	@echo "pkgname=$(IMLIB_PKG_NAME)"                            >  $(IMLIB_PKG)/.PKGINFO ; \
	 echo "pkgver=$(IMLIB_PKG_VERSION)"                          >> $(IMLIB_PKG)/.PKGINFO ; \
	 echo "arch=$(IMLIB_PKG_ARCH)"                               >> $(IMLIB_PKG)/.PKGINFO ; \
	 echo "distroname=$(IMLIB_PKG_DISTRO_NAME)"                  >> $(IMLIB_PKG)/.PKGINFO ; \
	 echo "distrover=$(IMLIB_PKG_DISTRO_VERSION)"                >> $(IMLIB_PKG)/.PKGINFO ; \
	 echo "group=$(IMLIB_PKG_GROUP)"                             >> $(IMLIB_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(IMLIB_PKG_SHORT_DESCRIPTION)\"" >> $(IMLIB_PKG)/.PKGINFO ; \
	 echo "url=$(IMLIB_PKG_URL)"                                 >> $(IMLIB_PKG)/.PKGINFO ; \
	 echo "license=$(IMLIB_PKG_LICENSE)"                         >> $(IMLIB_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(IMLIB_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
