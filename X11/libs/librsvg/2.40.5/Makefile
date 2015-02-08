
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_VIP1830)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/GNOME/core/librsvg

REQUIRES           = X11/libs/gdk-pixbuf2/2.31.1
REQUIRES          += libs/libcroco/0.6.8
REQUIRES          += libs/pango/1.36.8


version            = 2.40.5
tar_xz_archive     = $(SRC_PACKAGE_PATH)/GNOME/core/librsvg/librsvg-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/librsvg-$(version)
src_dir_name       = librsvg-$(version)
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
LIBRSVG_PKG_NAME                = librsvg
LIBRSVG_PKG_VERSION             = 2.40.5
LIBRSVG_PKG_ARCH                = $(TOOLCHAIN)
LIBRSVG_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBRSVG_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBRSVG_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
LIBRSVG_PKG_SHORT_DESCRIPTION   = SVG library
LIBRSVG_PKG_URL                 = $(BUG_URL)
LIBRSVG_PKG_LICENSE             = GPLv2
LIBRSVG_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBRSVG_PKG_NAME)-pkg-description
LIBRSVG_PKG_DESCRIPTION_FILE_IN = $(LIBRSVG_PKG_NAME)-pkg-description.in
LIBRSVG_PKG_INSTALL_SCRIPT      = $(LIBRSVG_PKG_NAME)-pkg-install.sh

LIBRSVG_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBRSVG_PKG_NAME)-package

pkg_basename     = $(LIBRSVG_PKG_NAME)-$(LIBRSVG_PKG_VERSION)-$(LIBRSVG_PKG_ARCH)-$(LIBRSVG_PKG_DISTRO_NAME)-$(LIBRSVG_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../build-system/core.mk


env_sysroot = DESTDIR=$(LIBRSVG_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man

extra_configure_switches += --enable-introspection=no
extra_configure_switches += --enable-gtk-doc=no
extra_configure_switches += --enable-vala=no

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
	# ======= Disable rsvg-view-3 (required GTK+ v3) =======
	@( cd $(build_dir) ; \
	   sed -i "s,^am__append_1,#am_append_1,g" Makefile ; \
	   sed -i "s,^am__EXEEXT_1,#am_EXEEXT_1,g" Makefile ; \
	 )
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LIBRSVG_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(LIBRSVG_PKG)/usr/share/man ]; then \
	  ( cd $(LIBRSVG_PKG)/usr/share/man ; \
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
	@mkdir -p $(LIBRSVG_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING* \
	       $(LIBRSVG_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(LIBRSVG_PKG)/usr/share/gtk-doc/html/$(src_dir_name)
	@( cd $(SRC_DIR)/doc/html ; \
	   cp -a *.html *.css *.png \
	         $(LIBRSVG_PKG)/usr/share/gtk-doc/html/$(src_dir_name) ; \
	 )
	@mkdir -p $(LIBRSVG_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING* INSTALL NEWS README \
	         $(LIBRSVG_PKG)/usr/share/doc/$(src_dir_name) ; \
	   ln -sf ../../gtk-doc/html/$(src_dir_name) $(LIBRSVG_PKG)/usr/share/doc/$(src_dir_name)/html ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(LIBRSVG_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBRSVG_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" librsvg-?.la ; \
	 )
	@( cd $(LIBRSVG_PKG)/usr/lib$(LIBSUFFIX)/gdk-pixbuf-?.?/?.??.?/loaders ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libpixbufloader-svg.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(LIBRSVG_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" librsvg-?.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" librsvg-?.la ; \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/gdk-pixbuf-?.?/?.??.?/loaders ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libpixbufloader-svg.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libpixbufloader-svg.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" librsvg-?.?.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBRSVG_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBRSVG_PKG_DESCRIPTION_FILE): $(LIBRSVG_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBRSVG_PKG_DESCRIPTION_FILE) $(LIBRSVG_PKG_INSTALL_SCRIPT)
	@cp $(LIBRSVG_PKG_DESCRIPTION_FILE) $(LIBRSVG_PKG)/.DESCRIPTION
	@cp $(LIBRSVG_PKG_INSTALL_SCRIPT) $(LIBRSVG_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBRSVG_PKG)/.REQUIRES
	@echo "pkgname=$(LIBRSVG_PKG_NAME)"                            >  $(LIBRSVG_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBRSVG_PKG_VERSION)"                          >> $(LIBRSVG_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBRSVG_PKG_ARCH)"                               >> $(LIBRSVG_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBRSVG_PKG_DISTRO_NAME)"                  >> $(LIBRSVG_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBRSVG_PKG_DISTRO_VERSION)"                >> $(LIBRSVG_PKG)/.PKGINFO ; \
	 echo "group=$(LIBRSVG_PKG_GROUP)"                             >> $(LIBRSVG_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBRSVG_PKG_SHORT_DESCRIPTION)\"" >> $(LIBRSVG_PKG)/.PKGINFO ; \
	 echo "url=$(LIBRSVG_PKG_URL)"                                 >> $(LIBRSVG_PKG)/.PKGINFO ; \
	 echo "license=$(LIBRSVG_PKG_LICENSE)"                         >> $(LIBRSVG_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBRSVG_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."