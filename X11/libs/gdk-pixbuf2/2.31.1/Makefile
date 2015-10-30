
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


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/GNOME/core/gdk-pixbuf

REQUIRES           = libs/glib2/2.40.0
REQUIRES          += libs/libpng/libpng14/1.4.13
REQUIRES          += libs/libtiff/4.0.3
REQUIRES          += X11/X.org/lib/libX11/1.6.2

# ======= __END_OF_REQUIRES__ =======


version            = 2.31.1
tar_xz_archive     = $(SRC_PACKAGE_PATH)/GNOME/core/gdk-pixbuf/gdk-pixbuf-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/gdk-pixbuf-$(version)
src_dir_name       = gdk-pixbuf-$(version)
doc_dir_name       = gdk-pixbuf2-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

update_script_in   = $(CURDIR)/update-loaders/update-gdk-pixbuf-loaders.in

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = xlibs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
PIXBUF2_PKG_NAME                = gdk-pixbuf2
PIXBUF2_PKG_VERSION             = 2.31.1
PIXBUF2_PKG_ARCH                = $(TOOLCHAIN)
PIXBUF2_PKG_DISTRO_NAME         = $(DISTRO_NAME)
PIXBUF2_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
PIXBUF2_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
PIXBUF2_PKG_SHORT_DESCRIPTION   = image library used by GTK+ v2
PIXBUF2_PKG_URL                 = $(BUG_URL)
PIXBUF2_PKG_LICENSE             = GPLv2
PIXBUF2_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(PIXBUF2_PKG_NAME)-pkg-description
PIXBUF2_PKG_DESCRIPTION_FILE_IN = $(PIXBUF2_PKG_NAME)-pkg-description.in
PIXBUF2_PKG_INSTALL_SCRIPT      = $(PIXBUF2_PKG_NAME)-pkg-install.sh

PIXBUF2_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(PIXBUF2_PKG_NAME)-package

pkg_basename     = $(PIXBUF2_PKG_NAME)-$(PIXBUF2_PKG_VERSION)-$(PIXBUF2_PKG_ARCH)-$(PIXBUF2_PKG_DISTRO_NAME)-$(PIXBUF2_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../build-system/core.mk


env_sysroot = DESTDIR=$(PIXBUF2_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(doc_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --enable-introspection=no
extra_configure_switches += --enable-gio-sniffing=no
extra_configure_switches += --with-x11

extra_configure_switches += --with-libjasper=no
extra_configure_switches += --disable-rebuilds
extra_configure_switches += --enable-gtk-doc=no
extra_configure_switches += --with-html-dir=/usr/share/gtk-doc/html/$(doc_dir_name)

extra_configure_switches += --disable-rpath
extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


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
	@mkdir -p $(PIXBUF2_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC64)),)
	@( cd $(PIXBUF2_PKG)/usr/bin ; mv gdk-pixbuf-query-loaders gdk-pixbuf-query-loaders-64 ; ln -sf gdk-pixbuf-query-loaders-64 gdk-pixbuf-query-loaders )
else
	@( cd $(PIXBUF2_PKG)/usr/bin ; mv gdk-pixbuf-query-loaders gdk-pixbuf-query-loaders-32 ; ln -sf gdk-pixbuf-query-loaders-32 gdk-pixbuf-query-loaders )
endif
	@cat $(update_script_in) | sed -e 's/@HOST_TRIPLET@/$(TARGET)/g' > $(PIXBUF2_PKG)/usr/bin/update-gdk-pixbuf-loaders
	@chmod 0755 $(PIXBUF2_PKG)/usr/bin/update-gdk-pixbuf-loaders
	# ======= Install Documentation =======
	@if [ -d $(PIXBUF2_PKG)/usr/share/man ]; then \
	  ( cd $(PIXBUF2_PKG)/usr/share/man ; \
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
	@mkdir -p $(PIXBUF2_PKG)/usr/doc/$(doc_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(PIXBUF2_PKG)/usr/doc/$(doc_dir_name)
	@mkdir -p $(PIXBUF2_PKG)/usr/share/gtk-doc/html/$(doc_dir_name)
	@( cd $(SRC_DIR)/docs/reference/gdk-pixbuf/html ; \
	   cp -a *.html *.css *.png \
	         $(PIXBUF2_PKG)/usr/share/gtk-doc/html/$(doc_dir_name) ; \
	 )
	@mkdir -p $(PIXBUF2_PKG)/usr/share/doc/$(doc_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING INSTALL NEWS \
	         $(PIXBUF2_PKG)/usr/share/doc/$(doc_dir_name) ; \
	   ln -sf ../../gtk-doc/html/$(doc_dir_name) $(PIXBUF2_PKG)/usr/share/doc/$(doc_dir_name)/html ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(PIXBUF2_PKG)/usr/share/doc/$(doc_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(PIXBUF2_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libgdk_pixbuf-?.?.la libgdk_pixbuf_xlib-?.?.la ; \
	 )
	@( cd $(PIXBUF2_PKG)/usr/lib$(LIBSUFFIX)/gdk-pixbuf-?.?/?.??.?/loaders ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libpixbufloader-ani.la  libpixbufloader-bmp.la   \
	                                    libpixbufloader-gif.la  libpixbufloader-icns.la  \
	                                    libpixbufloader-ico.la  libpixbufloader-jpeg.la  \
	                                    libpixbufloader-pcx.la  libpixbufloader-png.la   \
	                                    libpixbufloader-pnm.la  libpixbufloader-qtif.la  \
	                                    libpixbufloader-ras.la  libpixbufloader-tga.la   \
	                                    libpixbufloader-tiff.la libpixbufloader-wbmp.la  \
	                                    libpixbufloader-xbm.la  libpixbufloader-xpm.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(PIXBUF2_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libgdk_pixbuf-?.?.la libgdk_pixbuf_xlib-?.?.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libgdk_pixbuf-?.?.la libgdk_pixbuf_xlib-?.?.la ; \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/gdk-pixbuf-?.?/?.??.?/loaders ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libpixbufloader-ani.la  libpixbufloader-bmp.la   \
	                                            libpixbufloader-gif.la  libpixbufloader-icns.la  \
	                                            libpixbufloader-ico.la  libpixbufloader-jpeg.la  \
	                                            libpixbufloader-pcx.la  libpixbufloader-png.la   \
	                                            libpixbufloader-pnm.la  libpixbufloader-qtif.la  \
	                                            libpixbufloader-ras.la  libpixbufloader-tga.la   \
	                                            libpixbufloader-tiff.la libpixbufloader-wbmp.la  \
	                                            libpixbufloader-xbm.la  libpixbufloader-xpm.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libpixbufloader-ani.la  libpixbufloader-bmp.la   \
	                                              libpixbufloader-gif.la  libpixbufloader-icns.la  \
	                                              libpixbufloader-ico.la  libpixbufloader-jpeg.la  \
	                                              libpixbufloader-pcx.la  libpixbufloader-png.la   \
	                                              libpixbufloader-pnm.la  libpixbufloader-qtif.la  \
	                                              libpixbufloader-ras.la  libpixbufloader-tga.la   \
	                                              libpixbufloader-tiff.la libpixbufloader-wbmp.la  \
	                                              libpixbufloader-xbm.la  libpixbufloader-xpm.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,prefix=/usr,prefix=$(TARGET_DEST_DIR)/usr,g" gdk-pixbuf-?.?.pc gdk-pixbuf-xlib-?.?.pc ; \
	   sed -i "s,libdir=/usr,libdir=$(TARGET_DEST_DIR)/usr,g" gdk-pixbuf-?.?.pc gdk-pixbuf-xlib-?.?.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(PIXBUF2_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(PIXBUF2_PKG)/usr/bin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(PIXBUF2_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(PIXBUF2_PKG_DESCRIPTION_FILE): $(PIXBUF2_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(PIXBUF2_PKG_DESCRIPTION_FILE) $(PIXBUF2_PKG_INSTALL_SCRIPT)
	@cp $(PIXBUF2_PKG_DESCRIPTION_FILE) $(PIXBUF2_PKG)/.DESCRIPTION
	@cp $(PIXBUF2_PKG_INSTALL_SCRIPT) $(PIXBUF2_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(PIXBUF2_PKG)/.REQUIRES
	@echo "pkgname=$(PIXBUF2_PKG_NAME)"                            >  $(PIXBUF2_PKG)/.PKGINFO ; \
	 echo "pkgver=$(PIXBUF2_PKG_VERSION)"                          >> $(PIXBUF2_PKG)/.PKGINFO ; \
	 echo "arch=$(PIXBUF2_PKG_ARCH)"                               >> $(PIXBUF2_PKG)/.PKGINFO ; \
	 echo "distroname=$(PIXBUF2_PKG_DISTRO_NAME)"                  >> $(PIXBUF2_PKG)/.PKGINFO ; \
	 echo "distrover=$(PIXBUF2_PKG_DISTRO_VERSION)"                >> $(PIXBUF2_PKG)/.PKGINFO ; \
	 echo "group=$(PIXBUF2_PKG_GROUP)"                             >> $(PIXBUF2_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(PIXBUF2_PKG_SHORT_DESCRIPTION)\"" >> $(PIXBUF2_PKG)/.PKGINFO ; \
	 echo "url=$(PIXBUF2_PKG_URL)"                                 >> $(PIXBUF2_PKG)/.PKGINFO ; \
	 echo "license=$(PIXBUF2_PKG_LICENSE)"                         >> $(PIXBUF2_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(PIXBUF2_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
