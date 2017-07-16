
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/GNOME/core/librsvg

REQUIRES           = X11/libs/librsvg/2.40.5
REQUIRES          += X11/libs/gdk-pixbuf2/2.35.1-x86_32
REQUIRES          += libs/libcroco/0.6.11-x86_32
REQUIRES          += libs/pango/1.40.1-x86_32

# ======= __END_OF_REQUIRES__ =======


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
LIBRSVG_32_PKG_NAME                = librsvg-x32
LIBRSVG_32_PKG_VERSION             = 2.40.5
LIBRSVG_32_PKG_ARCH                = $(TOOLCHAIN)
LIBRSVG_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBRSVG_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBRSVG_32_PKG_GROUP               = $(PKG_GROUP)
###                                 |---handy-ruler-------------------------------|
LIBRSVG_32_PKG_SHORT_DESCRIPTION   = SVG library
LIBRSVG_32_PKG_URL                 = $(BUG_URL)
LIBRSVG_32_PKG_LICENSE             = GPLv2
LIBRSVG_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBRSVG_32_PKG_NAME)-pkg-description
LIBRSVG_32_PKG_DESCRIPTION_FILE_IN = $(LIBRSVG_32_PKG_NAME)-pkg-description.in
LIBRSVG_32_PKG_INSTALL_SCRIPT      = $(LIBRSVG_32_PKG_NAME)-pkg-install.sh

LIBRSVG_32_PKG   = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBRSVG_32_PKG_NAME)-package

pkg_basename     = $(LIBRSVG_32_PKG_NAME)-$(LIBRSVG_32_PKG_VERSION)-$(LIBRSVG_32_PKG_ARCH)-$(LIBRSVG_32_PKG_DISTRO_NAME)-$(LIBRSVG_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../build-system/core.mk


env_sysroot  = DESTDIR=$(LIBRSVG_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --bindir=/usr/bin/32

extra_configure_switches += --enable-introspection=no
extra_configure_switches += --enable-gtk-doc=no
extra_configure_switches += --enable-vala=no

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
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	# ======= Disable rsvg-view-3 (required GTK+ v3) =======
	@( cd $(build_dir) ; \
	   sed -i "s,^am__append_1,#am_append_1,g" Makefile ; \
	   sed -i "s,^am__EXEEXT_1,#am_EXEEXT_1,g" Makefile ; \
	 )
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LIBRSVG_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(LIBRSVG_32_PKG)/usr/include
	@rm -rf $(LIBRSVG_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBRSVG_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" librsvg-?.la ; \
	 )
	@( cd $(LIBRSVG_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/gdk-pixbuf-?.?/?.??.?/loaders ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libpixbufloader-svg.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBRSVG_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" librsvg-?.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" librsvg-?.la ; \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/gdk-pixbuf-?.?/?.??.?/loaders ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libpixbufloader-svg.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libpixbufloader-svg.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" librsvg-?.?.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBRSVG_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(LIBRSVG_32_PKG)/usr/bin/32 ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(LIBRSVG_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(LIBRSVG_32_PKG_DESCRIPTION_FILE): $(LIBRSVG_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBRSVG_32_PKG_DESCRIPTION_FILE) $(LIBRSVG_32_PKG_INSTALL_SCRIPT)
	@cp $(LIBRSVG_32_PKG_DESCRIPTION_FILE) $(LIBRSVG_32_PKG)/.DESCRIPTION
	@cp $(LIBRSVG_32_PKG_INSTALL_SCRIPT) $(LIBRSVG_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBRSVG_32_PKG)/.REQUIRES
	@echo "pkgname=$(LIBRSVG_32_PKG_NAME)"                            >  $(LIBRSVG_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBRSVG_32_PKG_VERSION)"                          >> $(LIBRSVG_32_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBRSVG_32_PKG_ARCH)"                               >> $(LIBRSVG_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBRSVG_32_PKG_DISTRO_NAME)"                  >> $(LIBRSVG_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBRSVG_32_PKG_DISTRO_VERSION)"                >> $(LIBRSVG_32_PKG)/.PKGINFO ; \
	 echo "group=$(LIBRSVG_32_PKG_GROUP)"                             >> $(LIBRSVG_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBRSVG_32_PKG_SHORT_DESCRIPTION)\"" >> $(LIBRSVG_32_PKG)/.PKGINFO ; \
	 echo "url=$(LIBRSVG_32_PKG_URL)"                                 >> $(LIBRSVG_32_PKG)/.PKGINFO ; \
	 echo "license=$(LIBRSVG_32_PKG_LICENSE)"                         >> $(LIBRSVG_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LIBRSVG_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
