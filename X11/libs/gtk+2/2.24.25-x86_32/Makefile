
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/GNOME/core/gtk+2

REQUIRES           = X11/libs/gtk+2/2.24.25
REQUIRES          += libs/atk/2.15.1-x86_32
REQUIRES          += libs/poppler/0.29.0-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 2.24.25
tar_xz_archive     = $(SRC_PACKAGE_PATH)/GNOME/core/gtk+2/gtk+-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/gtk+-$(version)
src_dir_name       = gtk+-$(version)
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
GTK2_32_PKG_NAME                = gtk2-x32
GTK2_32_PKG_VERSION             = 2.24.25
GTK2_32_PKG_ARCH                = $(TOOLCHAIN)
GTK2_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
GTK2_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
GTK2_32_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
GTK2_32_PKG_SHORT_DESCRIPTION   = multi-platform GUI toolkit
GTK2_32_PKG_URL                 = $(BUG_URL)
GTK2_32_PKG_LICENSE             = LGPLv2
GTK2_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GTK2_32_PKG_NAME)-pkg-description
GTK2_32_PKG_DESCRIPTION_FILE_IN = $(GTK2_32_PKG_NAME)-pkg-description.in
GTK2_32_PKG_INSTALL_SCRIPT      = $(GTK2_32_PKG_NAME)-pkg-install.sh

GTK2_32_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GTK2_32_PKG_NAME)-package

pkg_basename     = $(GTK2_32_PKG_NAME)-$(GTK2_32_PKG_VERSION)-$(GTK2_32_PKG_ARCH)-$(GTK2_32_PKG_DISTRO_NAME)-$(GTK2_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../build-system/core.mk


env_sysroot  = DESTDIR=$(GTK2_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --sysconfdir=/etc

extra_configure_switches += --with-x
extra_configure_switches += --with-gdktarget=x11
extra_configure_switches += --with-xinput=yes
extra_configure_switches += --enable-xkb

extra_configure_switches += --enable-introspection=no
extra_configure_switches += --enable-gtk-doc=no
extra_configure_switches += --enable-gtk-doc-html=no

extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes

environment  = CUPS_CONFIG=$(TARGET_DEST_DIR)/usr/bin/32/cups-config


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
	  $(BUILD_ENVIRONMENT) $(environment) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(GTK2_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(GTK2_32_PKG)/etc
	@rm -rf $(GTK2_32_PKG)/usr/include
	@rm -rf $(GTK2_32_PKG)/usr/share
	@mkdir -p $(GTK2_32_PKG)/usr/bin/32
	@( cd $(GTK2_32_PKG)/usr/bin ; \
	   mv gtk-query-immodules-2.0{,-32} ; \
	   mv gtk-builder-convert gtk-demo gtk-update-icon-cache 32 ; \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(GTK2_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libgailutil.la libgdk-x11-2.0.la libgtk-x11-2.0.la ; \
	 )
	@( cd $(GTK2_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/gtk-?.?/?.??.?/engines ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libpixmap.la ; \
	 )
	@( cd $(GTK2_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/gtk-?.?/?.??.?/immodules ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" im-am-et.la im-cedilla.la im-cyrillic-translit.la      \
	                                    im-inuktitut.la im-ipa.la im-multipress.la im-thai.la  \
	                                    im-ti-er.la im-ti-et.la im-viqr.la im-xim.la         ; \
	 )
	@( cd $(GTK2_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/gtk-?.?/?.??.?/printbackends ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libprintbackend-cups.la  \
	                                    libprintbackend-file.la  \
	                                    libprintbackend-lpr.la ; \
	 )
	@( cd $(GTK2_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/gtk-?.?/modules ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libferret.la libgail.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(GTK2_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libgailutil.la libgdk-x11-2.0.la libgtk-x11-2.0.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libgailutil.la libgdk-x11-2.0.la libgtk-x11-2.0.la ; \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/gtk-?.?/?.??.?/engines ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libpixmap.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libpixmap.la ; \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/gtk-?.?/?.??.?/immodules ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" im-am-et.la im-cedilla.la im-cyrillic-translit.la      \
	                                            im-inuktitut.la im-ipa.la im-multipress.la im-thai.la  \
	                                            im-ti-er.la im-ti-et.la im-viqr.la im-xim.la         ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" im-am-et.la im-cedilla.la im-cyrillic-translit.la      \
	                                              im-inuktitut.la im-ipa.la im-multipress.la im-thai.la  \
	                                              im-ti-er.la im-ti-et.la im-viqr.la im-xim.la         ; \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/gtk-?.?/?.??.?/printbackends ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libprintbackend-cups.la  \
	                                            libprintbackend-file.la  \
	                                            libprintbackend-lpr.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libprintbackend-cups.la  \
	                                              libprintbackend-file.la  \
	                                              libprintbackend-lpr.la ; \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/gtk-?.?/modules ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libferret.la libgail.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libferret.la libgail.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" gail.pc gdk-2.0.pc gdk-x11-2.0.pc   \
	                                            gtk+-2.0.pc gtk+-unix-print-2.0.pc  \
	                                            gtk+-x11-2.0.pc                   ; \
	 )
	# ======= Strip binaries =======
	@( cd $(GTK2_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(GTK2_32_PKG)/usr/bin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(GTK2_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(GTK2_32_PKG_DESCRIPTION_FILE): $(GTK2_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(GTK2_32_PKG_DESCRIPTION_FILE) $(GTK2_32_PKG_INSTALL_SCRIPT)
	@cp $(GTK2_32_PKG_DESCRIPTION_FILE) $(GTK2_32_PKG)/.DESCRIPTION
	@cp $(GTK2_32_PKG_INSTALL_SCRIPT) $(GTK2_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GTK2_32_PKG)/.REQUIRES
	@echo "pkgname=$(GTK2_32_PKG_NAME)"                            >  $(GTK2_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GTK2_32_PKG_VERSION)"                          >> $(GTK2_32_PKG)/.PKGINFO ; \
	 echo "arch=$(GTK2_32_PKG_ARCH)"                               >> $(GTK2_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(GTK2_32_PKG_DISTRO_NAME)"                  >> $(GTK2_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(GTK2_32_PKG_DISTRO_VERSION)"                >> $(GTK2_32_PKG)/.PKGINFO ; \
	 echo "group=$(GTK2_32_PKG_GROUP)"                             >> $(GTK2_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GTK2_32_PKG_SHORT_DESCRIPTION)\"" >> $(GTK2_32_PKG)/.PKGINFO ; \
	 echo "url=$(GTK2_32_PKG_URL)"                                 >> $(GTK2_32_PKG)/.PKGINFO ; \
	 echo "license=$(GTK2_32_PKG_LICENSE)"                         >> $(GTK2_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(GTK2_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
