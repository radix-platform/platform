
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


include ../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/GNOME/core/gtk+2

REQUIRES           = libs/atk/2.15.1
REQUIRES          += libs/poppler/0.29.0

# ======= __END_OF_REQUIRES__ =======


version            = 2.24.25
tar_xz_archive     = $(SRC_PACKAGE_PATH)/GNOME/core/gtk+2/gtk+-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/gtk+-$(version)
src_dir_name       = gtk+-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

profile_dir        = $(CURDIR)/profile.d
update_script_dir  = $(CURDIR)/update-immodules

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = xlibs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
GTK2_PKG_NAME                = gtk2
GTK2_PKG_VERSION             = 2.24.25
GTK2_PKG_ARCH                = $(TOOLCHAIN)
GTK2_PKG_DISTRO_NAME         = $(DISTRO_NAME)
GTK2_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
GTK2_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
GTK2_PKG_SHORT_DESCRIPTION   = multi-platform GUI toolkit
GTK2_PKG_URL                 = $(BUG_URL)
GTK2_PKG_LICENSE             = LGPLv2
GTK2_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GTK2_PKG_NAME)-pkg-description
GTK2_PKG_DESCRIPTION_FILE_IN = $(GTK2_PKG_NAME)-pkg-description.in
GTK2_PKG_INSTALL_SCRIPT      = $(GTK2_PKG_NAME)-pkg-install.sh

GTK2_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GTK2_PKG_NAME)-package

pkg_basename     = $(GTK2_PKG_NAME)-$(GTK2_PKG_VERSION)-$(GTK2_PKG_ARCH)-$(GTK2_PKG_DISTRO_NAME)-$(GTK2_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../build-system/core.mk


env_sysroot = DESTDIR=$(GTK2_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
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

environment  = CUPS_CONFIG=$(TARGET_DEST_DIR)/usr/bin/cups-config


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
	  $(BUILD_ENVIRONMENT) $(environment) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(GTK2_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install a 'starter' gtkrc =======
	@echo 'gtk-theme-name="GTK+"' > $(GTK2_PKG)/etc/gtk-2.0/gtkrc.new
	# ======= Don't clobber im-multipress.conf =======
	@mv $(GTK2_PKG)/etc/gtk-2.0/im-multipress.conf $(GTK2_PKG)/etc/gtk-2.0/im-multipress.conf.new
	# ======= Add profile scripts to set up GTK+ environment =======
	@mkdir -p $(GTK2_PKG)/etc/profile.d
	@cp -a $(profile_dir)/* $(GTK2_PKG)/etc/profile.d
	@chmod 0755 $(GTK2_PKG)/etc/profile.d/*
	# ======= Install wrappers for the 'gtk-query-immodules' binary =======
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC64)),)
	@( cd $(GTK2_PKG)/usr/bin ; mv gtk-query-immodules-2.0{,-64} ; ln -sf gtk-query-immodules-2.0-64 gtk-query-immodules-2.0 )
else
	@( cd $(GTK2_PKG)/usr/bin ; mv gtk-query-immodules-2.0{,-32} ; ln -sf gtk-query-immodules-2.0-32 gtk-query-immodules-2.0 )
endif
	@cat $(update_script_dir)/update-gtk-immodules > $(GTK2_PKG)/usr/bin/update-gtk-immodules
	@cat $(update_script_dir)/update-gtk-immodules-2.0.in | \
	     sed -e 's/@HOST_TRIPLET@/$(TARGET)/g' > $(GTK2_PKG)/usr/bin/update-gtk-immodules-2.0
	@chmod 0755 $(GTK2_PKG)/usr/bin/update-gtk-immodules
	@chmod 0755 $(GTK2_PKG)/usr/bin/update-gtk-immodules-2.0
	# ======= Install Documentation =======
	@if [ -d $(GTK2_PKG)/usr/share/man ]; then \
	  ( cd $(GTK2_PKG)/usr/share/man ; \
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
	@mkdir -p $(GTK2_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(GTK2_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(GTK2_PKG)/usr/share/gtk-doc/html/{gail-libgail-util,gdk2,gtk2}
	@( cd $(SRC_DIR)/docs/reference/libgail-util/html ; \
	   cp -a *.html *.png *.css \
	         $(GTK2_PKG)/usr/share/gtk-doc/html/gail-libgail-util ; \
	 )
	@( cd $(SRC_DIR)/docs/reference/gdk/html ; \
	   cp -a *.html *.png *.css \
	         $(GTK2_PKG)/usr/share/gtk-doc/html/gdk2 ; \
	 )
	@( cd $(SRC_DIR)/docs/reference/gtk/html ; \
	   cp -a *.html *.png *.css \
	         $(GTK2_PKG)/usr/share/gtk-doc/html/gtk2 ; \
	 )
	@mkdir -p $(GTK2_PKG)/usr/share/doc/$(src_dir_name)/html
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING HACKING INSTALL NEWS* README \
	         $(GTK2_PKG)/usr/share/doc/$(src_dir_name) ; \
	   ln -sf ../../../gtk-doc/html/gail-libgail-util $(GTK2_PKG)/usr/share/doc/$(src_dir_name)/html/gail-libgail-util ; \
	   ln -sf ../../../gtk-doc/html/gdk2              $(GTK2_PKG)/usr/share/doc/$(src_dir_name)/html/gdk2 ; \
	   ln -sf ../../../gtk-doc/html/gtk2              $(GTK2_PKG)/usr/share/doc/$(src_dir_name)/html/gtk2 ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(GTK2_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(GTK2_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libgailutil.la libgdk-x11-2.0.la libgtk-x11-2.0.la ; \
	 )
	@( cd $(GTK2_PKG)/usr/lib$(LIBSUFFIX)/gtk-?.?/?.??.?/engines ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libpixmap.la ; \
	 )
	@( cd $(GTK2_PKG)/usr/lib$(LIBSUFFIX)/gtk-?.?/?.??.?/immodules ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" im-am-et.la im-cedilla.la im-cyrillic-translit.la      \
	                                    im-inuktitut.la im-ipa.la im-multipress.la im-thai.la  \
	                                    im-ti-er.la im-ti-et.la im-viqr.la im-xim.la         ; \
	 )
	@( cd $(GTK2_PKG)/usr/lib$(LIBSUFFIX)/gtk-?.?/?.??.?/printbackends ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libprintbackend-cups.la  \
	                                    libprintbackend-file.la  \
	                                    libprintbackend-lpr.la ; \
	 )
	@( cd $(GTK2_PKG)/usr/lib$(LIBSUFFIX)/gtk-?.?/modules ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libferret.la libgail.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(GTK2_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libgailutil.la libgdk-x11-2.0.la libgtk-x11-2.0.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libgailutil.la libgdk-x11-2.0.la libgtk-x11-2.0.la ; \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/gtk-?.?/?.??.?/engines ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libpixmap.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libpixmap.la ; \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/gtk-?.?/?.??.?/immodules ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" im-am-et.la im-cedilla.la im-cyrillic-translit.la      \
	                                            im-inuktitut.la im-ipa.la im-multipress.la im-thai.la  \
	                                            im-ti-er.la im-ti-et.la im-viqr.la im-xim.la         ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" im-am-et.la im-cedilla.la im-cyrillic-translit.la      \
	                                              im-inuktitut.la im-ipa.la im-multipress.la im-thai.la  \
	                                              im-ti-er.la im-ti-et.la im-viqr.la im-xim.la         ; \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/gtk-?.?/?.??.?/printbackends ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libprintbackend-cups.la  \
	                                            libprintbackend-file.la  \
	                                            libprintbackend-lpr.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libprintbackend-cups.la  \
	                                              libprintbackend-file.la  \
	                                              libprintbackend-lpr.la ; \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/gtk-?.?/modules ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libferret.la libgail.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libferret.la libgail.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" gail.pc gdk-2.0.pc gdk-x11-2.0.pc   \
	                                            gtk+-2.0.pc gtk+-unix-print-2.0.pc  \
	                                            gtk+-x11-2.0.pc                   ; \
	 )
	# ======= Strip binaries =======
	@( cd $(GTK2_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(GTK2_PKG)/usr/bin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(GTK2_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(GTK2_PKG_DESCRIPTION_FILE): $(GTK2_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(GTK2_PKG_DESCRIPTION_FILE) $(GTK2_PKG_INSTALL_SCRIPT)
	@cp $(GTK2_PKG_DESCRIPTION_FILE) $(GTK2_PKG)/.DESCRIPTION
	@cp $(GTK2_PKG_INSTALL_SCRIPT) $(GTK2_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GTK2_PKG)/.REQUIRES
	@echo "pkgname=$(GTK2_PKG_NAME)"                            >  $(GTK2_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GTK2_PKG_VERSION)"                          >> $(GTK2_PKG)/.PKGINFO ; \
	 echo "arch=$(GTK2_PKG_ARCH)"                               >> $(GTK2_PKG)/.PKGINFO ; \
	 echo "distroname=$(GTK2_PKG_DISTRO_NAME)"                  >> $(GTK2_PKG)/.PKGINFO ; \
	 echo "distrover=$(GTK2_PKG_DISTRO_VERSION)"                >> $(GTK2_PKG)/.PKGINFO ; \
	 echo "group=$(GTK2_PKG_GROUP)"                             >> $(GTK2_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GTK2_PKG_SHORT_DESCRIPTION)\"" >> $(GTK2_PKG)/.PKGINFO ; \
	 echo "url=$(GTK2_PKG_URL)"                                 >> $(GTK2_PKG)/.PKGINFO ; \
	 echo "license=$(GTK2_PKG_LICENSE)"                         >> $(GTK2_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(GTK2_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
