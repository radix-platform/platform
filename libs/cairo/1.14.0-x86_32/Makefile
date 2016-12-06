
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/cairo

REQUIRES           = libs/cairo/1.14.0
REQUIRES          += libs/lzo/2.09-x86_32
REQUIRES          += libs/pcre/8.38-x86_32
REQUIRES          += libs/glib2/2.48.0-x86_32
REQUIRES          += X11/libs/fontconfig/2.11.95-x86_32
REQUIRES          += X11/X.org/lib/pixman/0.34.0-x86_32
REQUIRES          += X11/X.org/lib/libXext/1.3.3-x86_32
REQUIRES          += X11/X.org/lib/libXrender/0.9.9-x86_32

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
CAIRO_32_PKG_NAME                = cairo-x32
CAIRO_32_PKG_VERSION             = 1.14.0
CAIRO_32_PKG_ARCH                = $(TOOLCHAIN)
CAIRO_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
CAIRO_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
CAIRO_32_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
CAIRO_32_PKG_SHORT_DESCRIPTION   = graphics library used by GTK+
CAIRO_32_PKG_URL                 = $(BUG_URL)
CAIRO_32_PKG_LICENSE             = LGPLv2.1
CAIRO_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(CAIRO_32_PKG_NAME)-pkg-description
CAIRO_32_PKG_DESCRIPTION_FILE_IN = $(CAIRO_32_PKG_NAME)-pkg-description.in
CAIRO_32_PKG_INSTALL_SCRIPT      = $(CAIRO_32_PKG_NAME)-pkg-install.sh

CAIRO_32_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(CAIRO_32_PKG_NAME)-package

pkg_basename     = $(CAIRO_32_PKG_NAME)-$(CAIRO_32_PKG_VERSION)-$(CAIRO_32_PKG_ARCH)-$(CAIRO_32_PKG_DISTRO_NAME)-$(CAIRO_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(CAIRO_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --bindir=/usr/bin/32
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


TARGET_BIN_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX)
TARGET_LIB_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib/../lib$(MULTILIB_X86_32_SUFFIX)


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
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(CAIRO_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(CAIRO_32_PKG)/usr/include
	@rm -rf $(CAIRO_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(CAIRO_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libcairo.la libcairo-gobject.la  \
	                                    libcairo-script-interpreter.la ; \
	 )
	@( cd $(CAIRO_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/cairo ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" cairo-sphinx.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(CAIRO_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libcairo.la libcairo-gobject.la  \
	                                            libcairo-script-interpreter.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libcairo.la libcairo-gobject.la  \
	                                              libcairo-script-interpreter.la ; \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/cairo ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" cairo-sphinx.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" cairo-sphinx.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" cairo.pc cairo-egl.pc cairo-fc.pc cairo-ft.pc        \
	                                            cairo-glesv2.pc cairo-gobject.pc cairo-png.pc        \
	                                            cairo-script.pc cairo-tee.pc cairo-xcb-shm.pc        \
	                                            cairo-xcb.pc cairo-xlib-xcb.pc cairo-xlib-xrender.pc \
	                                            cairo-xlib.pc cairo-xml.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(CAIRO_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(CAIRO_32_PKG)/usr/bin/32 ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(CAIRO_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(CAIRO_32_PKG_DESCRIPTION_FILE): $(CAIRO_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(CAIRO_32_PKG_DESCRIPTION_FILE) $(CAIRO_32_PKG_INSTALL_SCRIPT)
	@cp $(CAIRO_32_PKG_DESCRIPTION_FILE) $(CAIRO_32_PKG)/.DESCRIPTION
	@cp $(CAIRO_32_PKG_INSTALL_SCRIPT) $(CAIRO_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(CAIRO_32_PKG)/.REQUIRES
	@echo "pkgname=$(CAIRO_32_PKG_NAME)"                            >  $(CAIRO_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(CAIRO_32_PKG_VERSION)"                          >> $(CAIRO_32_PKG)/.PKGINFO ; \
	 echo "arch=$(CAIRO_32_PKG_ARCH)"                               >> $(CAIRO_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(CAIRO_32_PKG_DISTRO_NAME)"                  >> $(CAIRO_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(CAIRO_32_PKG_DISTRO_VERSION)"                >> $(CAIRO_32_PKG)/.PKGINFO ; \
	 echo "group=$(CAIRO_32_PKG_GROUP)"                             >> $(CAIRO_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(CAIRO_32_PKG_SHORT_DESCRIPTION)\"" >> $(CAIRO_32_PKG)/.PKGINFO ; \
	 echo "url=$(CAIRO_32_PKG_URL)"                                 >> $(CAIRO_32_PKG)/.PKGINFO ; \
	 echo "license=$(CAIRO_32_PKG_LICENSE)"                         >> $(CAIRO_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(CAIRO_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
