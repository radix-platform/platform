
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


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/GNOME/core/glib

REQUIRES           = libs/zlib/1.2.8
REQUIRES          += libs/libffi/3.0.13
REQUIRES          += libs/libelf/0.8.13
REQUIRES          += libs/pcre/8.34
REQUIRES          += app/attr/2.4.47
REQUIRES          += libs/libgamin/0.1.10


version            = 2.40.0
tar_xz_archive     = $(SRC_PACKAGE_PATH)/GNOME/core/glib/glib-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/glib-$(version)
src_dir_name       = glib-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done

hw_cache_in        = $(CURDIR)/cross/hw.cache
hw_cache           = $(CURDIR)/$(build_dir)/hw.cache


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
GLIB2_PKG_NAME                = glib2
GLIB2_PKG_VERSION             = 2.40.0
GLIB2_PKG_ARCH                = $(TOOLCHAIN)
GLIB2_PKG_DISTRO_NAME         = $(DISTRO_NAME)
GLIB2_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
GLIB2_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
GLIB2_PKG_SHORT_DESCRIPTION   = library of C routines
GLIB2_PKG_URL                 = $(BUG_URL)
GLIB2_PKG_LICENSE             = GPLv2
GLIB2_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GLIB2_PKG_NAME)-pkg-description
GLIB2_PKG_DESCRIPTION_FILE_IN = $(GLIB2_PKG_NAME)-pkg-description.in
GLIB2_PKG_INSTALL_SCRIPT      = $(TARGET_BUILD_DIR)/$(GLIB2_PKG_NAME)-pkg-install.sh
GLIB2_PKG_INSTALL_SCRIPT_IN   = $(GLIB2_PKG_NAME)-pkg-install.sh.in

GLIB2_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GLIB2_PKG_NAME)-package

pkg_basename     = $(GLIB2_PKG_NAME)-$(GLIB2_PKG_VERSION)-$(GLIB2_PKG_ARCH)-$(GLIB2_PKG_DISTRO_NAME)-$(GLIB2_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(GLIB2_PKG)


ENABLE_GTK_DOCUMENTATION  = yes

extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --enable-man
extra_configure_switches += --with-gnu-ld
extra_configure_switches += --with-threads=posix
extra_configure_switches += --with-pcre=system
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes

extra_configure_switches += --cache-file=$(hw_cache)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cp -a $(hw_cache_in) $(hw_cache)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(GLIB2_PKG)/etc/profile.d
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@cp -a $(CURDIR)/profile.d/libglib2.{csh,sh} $(GLIB2_PKG)/etc/profile.d
	@chmod 755 $(GLIB2_PKG)/etc/profile.d/*
	mv $(GLIB2_PKG)/etc/profile.d/libglib2.csh $(GLIB2_PKG)/etc/profile.d/libglib2.csh.new
	mv $(GLIB2_PKG)/etc/profile.d/libglib2.sh  $(GLIB2_PKG)/etc/profile.d/libglib2.sh.new
	@if [ -d $(GLIB2_PKG)/usr/share/man ]; then \
	  ( cd $(GLIB2_PKG)/usr/share/man ; \
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
	@mkdir -p $(GLIB2_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(GLIB2_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(GLIB2_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING HACKING INSTALL NEWS* README* \
	         $(GLIB2_PKG)/usr/share/doc/$(src_dir_name) \
	 )
ifeq ($(ENABLE_GTK_DOCUMENTATION),yes)
	@mkdir -p $(GLIB2_PKG)/usr/share/gtk-doc/html/{gio,glib,gobject}
	@cp -a $(SRC_DIR)/docs/reference/gio/html/*     $(GLIB2_PKG)/usr/share/gtk-doc/html/gio
	@cp -a $(SRC_DIR)/docs/reference/glib/html/*    $(GLIB2_PKG)/usr/share/gtk-doc/html/glib
	@cp -a $(SRC_DIR)/docs/reference/gobject/html/* $(GLIB2_PKG)/usr/share/gtk-doc/html/gobject
	@mkdir -p $(GLIB2_PKG)/usr/share/doc/$(src_dir_name)/html
	@ln -sf ../../../gtk-doc/html/gio     $(GLIB2_PKG)/usr/share/doc/$(src_dir_name)/html/gio
	@ln -sf ../../../gtk-doc/html/glib    $(GLIB2_PKG)/usr/share/doc/$(src_dir_name)/html/glib
	@ln -sf ../../../gtk-doc/html/gobject $(GLIB2_PKG)/usr/share/doc/$(src_dir_name)/html/gobject
endif
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(GLIB2_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove target destination path from target libtool *.la files and pkgconfig *.pc files =======
	@( cd $(GLIB2_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" *.la ; \
	 )
	@( cd $(GLIB2_PKG)/usr/lib$(LIBSUFFIX)/gio/modules ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" *.la ; \
	 )
	@( cd $(GLIB2_PKG)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" *.pc ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(GLIB2_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libgio-2.0.la libglib-2.0.la libgmodule-2.0.la \
	                                            libgobject-2.0.la libgthread-2.0.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libgio-2.0.la libglib-2.0.la libgmodule-2.0.la \
	                                              libgobject-2.0.la libgthread-2.0.la \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/gio/modules ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libgiofam.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libgiofam.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" gio-2.0.pc gio-unix-2.0.pc glib-2.0.pc gmodule-2.0.pc \
	                                            gmodule-export-2.0.pc gmodule-no-export-2.0.pc gobject-2.0.pc \
	                                            gthread-2.0.pc \
	 )
	@( cd $(GLIB2_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(GLIB2_PKG_DESCRIPTION_FILE): $(GLIB2_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(GLIB2_PKG_INSTALL_SCRIPT): $(GLIB2_PKG_INSTALL_SCRIPT_IN)
	@cat $< | $(SED) -e "s,@LIBDIR@,/usr/lib$(LIBSUFFIX),g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(GLIB2_PKG_DESCRIPTION_FILE) $(GLIB2_PKG_INSTALL_SCRIPT)
	@cp $(GLIB2_PKG_DESCRIPTION_FILE) $(GLIB2_PKG)/.DESCRIPTION
	@cp $(GLIB2_PKG_INSTALL_SCRIPT) $(GLIB2_PKG)/.INSTALL
	@chmod a+x $(GLIB2_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GLIB2_PKG)/.REQUIRES
	@echo "pkgname=$(GLIB2_PKG_NAME)"                            >  $(GLIB2_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GLIB2_PKG_VERSION)"                          >> $(GLIB2_PKG)/.PKGINFO ; \
	 echo "arch=$(GLIB2_PKG_ARCH)"                               >> $(GLIB2_PKG)/.PKGINFO ; \
	 echo "distroname=$(GLIB2_PKG_DISTRO_NAME)"                  >> $(GLIB2_PKG)/.PKGINFO ; \
	 echo "distrover=$(GLIB2_PKG_DISTRO_VERSION)"                >> $(GLIB2_PKG)/.PKGINFO ; \
	 echo "group=$(GLIB2_PKG_GROUP)"                             >> $(GLIB2_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GLIB2_PKG_SHORT_DESCRIPTION)\"" >> $(GLIB2_PKG)/.PKGINFO ; \
	 echo "url=$(GLIB2_PKG_URL)"                                 >> $(GLIB2_PKG)/.PKGINFO ; \
	 echo "license=$(GLIB2_PKG_LICENSE)"                         >> $(GLIB2_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(GLIB2_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
