
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


SOURCE_REQUIRES    = sources/packages/l/cairo

REQUIRES           = libs/lzo/2.09
REQUIRES          += libs/pcre/8.38
REQUIRES          += libs/glib2/2.48.0
REQUIRES          += X11/libs/fontconfig/2.11.1
REQUIRES          += X11/X.org/lib/pixman/0.34.0
REQUIRES          += X11/X.org/lib/libXext/1.3.3
REQUIRES          += X11/X.org/lib/libXrender/0.9.9

REQUIRES          += X11/libs/opengl-collection

# ======= __END_OF_REQUIRES__ =======


version            = 1.14.0
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/l/cairo/cairo-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/cairo-$(version)
src_dir_name       = cairo-$(version)
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
CAIRO_PKG_NAME                = cairo
CAIRO_PKG_VERSION             = 1.14.0
CAIRO_PKG_ARCH                = $(TOOLCHAIN)
CAIRO_PKG_DISTRO_NAME         = $(DISTRO_NAME)
CAIRO_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
CAIRO_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
CAIRO_PKG_SHORT_DESCRIPTION   = graphics library used by GTK+
CAIRO_PKG_URL                 = $(BUG_URL)
CAIRO_PKG_LICENSE             = LGPLv2.1
CAIRO_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(CAIRO_PKG_NAME)-pkg-description
CAIRO_PKG_DESCRIPTION_FILE_IN = $(CAIRO_PKG_NAME)-pkg-description.in
CAIRO_PKG_INSTALL_SCRIPT      = $(CAIRO_PKG_NAME)-pkg-install.sh

CAIRO_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(CAIRO_PKG_NAME)-package

pkg_basename     = $(CAIRO_PKG_NAME)-$(CAIRO_PKG_VERSION)-$(CAIRO_PKG_ARCH)-$(CAIRO_PKG_DISTRO_NAME)-$(CAIRO_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(CAIRO_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --sysconfdir=/etc

extra_configure_switches += --disable-quartz
extra_configure_switches += --disable-win32
extra_configure_switches += --disable-trace
extra_configure_switches += --enable-drm=no
extra_configure_switches += --enable-png=yes
extra_configure_switches += --enable-xlib
extra_configure_switches += --enable-xcb
extra_configure_switches += --enable-xcb-shm
extra_configure_switches += --enable-xlib-xcb
ifneq ($(filter $(HARDWARE),$(HARDWARE_CB1X) $(HARDWARE_CI20)),)
extra_configure_switches += --disable-gl
endif
extra_configure_switches += --enable-egl
extra_configure_switches += --enable-glesv2
extra_configure_switches += --enable-glx=no
extra_configure_switches += --enable-ft=yes
extra_configure_switches += --enable-fc=yes
extra_configure_switches += --enable-ps=no
extra_configure_switches += --enable-pdf=no
extra_configure_switches += --enable-svg=no
extra_configure_switches += --enable-tee
extra_configure_switches += --enable-gobject
extra_configure_switches += --enable-xml
extra_configure_switches += --enable-full-testing=no

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
	@mkdir -p $(CAIRO_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
ifneq ($(filter $(HARDWARE),$(HARDWARE_CI20)),)
	# ======= especially for MIPS Creator CI20 add -lELG, -lGLESv2 flags =======
	# ======= due to mips prolog optimization for PIC (see gcc configure =======
	# ======= option --with-mips-plt)                                    =======
	@( cd $(CAIRO_PKG)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,^\(Libs:.*\),\1 -lEGL,"          cairo-egl.pc    ; \
	   sed -i "s,^\(Libs:.*\),\1 -lGLESv2,"       cairo-glesv2.pc ; \
	   sed -i "s,^\(Libs:.*\),\1 -lEGL -lGLESv2," cairo.pc        ; \
	 )
endif
	# ======= Install Documentation =======
	@if [ -d $(CAIRO_PKG)/usr/share/man ]; then \
	  ( cd $(CAIRO_PKG)/usr/share/man ; \
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
	@mkdir -p $(CAIRO_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING* \
	       $(CAIRO_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(CAIRO_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS BIBLIOGRAPHY BUGS CODING_STYLE \
	         COPYING* HACKING INSTALL KNOWN_ISSUES NEWS \
	         PORTING_GUIDE README* RELEASING \
	         $(CAIRO_PKG)/usr/share/doc/$(src_dir_name) ; \
	   ln -sf ../../gtk-doc/html/cairo $(CAIRO_PKG)/usr/share/doc/$(src_dir_name)/html ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(CAIRO_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(CAIRO_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libcairo.la libcairo-gobject.la  \
	                                    libcairo-script-interpreter.la ; \
	 )
	@( cd $(CAIRO_PKG)/usr/lib$(LIBSUFFIX)/cairo ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" cairo-sphinx.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(CAIRO_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libcairo.la libcairo-gobject.la  \
	                                            libcairo-script-interpreter.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libcairo.la libcairo-gobject.la  \
	                                              libcairo-script-interpreter.la ; \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/cairo ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" cairo-sphinx.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" cairo-sphinx.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" cairo.pc cairo-egl.pc cairo-fc.pc cairo-ft.pc        \
	                                            cairo-glesv2.pc cairo-gobject.pc cairo-png.pc        \
	                                            cairo-script.pc cairo-tee.pc cairo-xcb-shm.pc        \
	                                            cairo-xcb.pc cairo-xlib-xcb.pc cairo-xlib-xrender.pc \
	                                            cairo-xlib.pc cairo-xml.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(CAIRO_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(CAIRO_PKG)/usr/bin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(CAIRO_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(CAIRO_PKG_DESCRIPTION_FILE): $(CAIRO_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(CAIRO_PKG_DESCRIPTION_FILE) $(CAIRO_PKG_INSTALL_SCRIPT)
	@cp $(CAIRO_PKG_DESCRIPTION_FILE) $(CAIRO_PKG)/.DESCRIPTION
	@cp $(CAIRO_PKG_INSTALL_SCRIPT) $(CAIRO_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(CAIRO_PKG)/.REQUIRES
	@echo "pkgname=$(CAIRO_PKG_NAME)"                            >  $(CAIRO_PKG)/.PKGINFO ; \
	 echo "pkgver=$(CAIRO_PKG_VERSION)"                          >> $(CAIRO_PKG)/.PKGINFO ; \
	 echo "arch=$(CAIRO_PKG_ARCH)"                               >> $(CAIRO_PKG)/.PKGINFO ; \
	 echo "distroname=$(CAIRO_PKG_DISTRO_NAME)"                  >> $(CAIRO_PKG)/.PKGINFO ; \
	 echo "distrover=$(CAIRO_PKG_DISTRO_VERSION)"                >> $(CAIRO_PKG)/.PKGINFO ; \
	 echo "group=$(CAIRO_PKG_GROUP)"                             >> $(CAIRO_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(CAIRO_PKG_SHORT_DESCRIPTION)\"" >> $(CAIRO_PKG)/.PKGINFO ; \
	 echo "url=$(CAIRO_PKG_URL)"                                 >> $(CAIRO_PKG)/.PKGINFO ; \
	 echo "license=$(CAIRO_PKG_LICENSE)"                         >> $(CAIRO_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(CAIRO_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
