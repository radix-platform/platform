
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/GNOME/core/libgudev

REQUIRES           = libs/glib2/2.48.0
REQUIRES          += libs/eudev/3.1.5

# ======= __END_OF_REQUIRES__ =======


version            = 230
tar_xz_archive     = $(SRC_PACKAGE_PATH)/GNOME/core/libgudev/libgudev-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libgudev-$(version)
src_dir_name       = libgudev-$(version)
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
GUDEV_PKG_NAME                = libgudev
GUDEV_PKG_VERSION             = 230
GUDEV_PKG_ARCH                = $(TOOLCHAIN)
GUDEV_PKG_DISTRO_NAME         = $(DISTRO_NAME)
GUDEV_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
GUDEV_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
GUDEV_PKG_SHORT_DESCRIPTION   = a library of GObject bindings for libudev
GUDEV_PKG_URL                 = $(BUG_URL)
GUDEV_PKG_LICENSE             = LGPLv2.1
GUDEV_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GUDEV_PKG_NAME)-pkg-description
GUDEV_PKG_DESCRIPTION_FILE_IN = $(GUDEV_PKG_NAME)-pkg-description.in
GUDEV_PKG_INSTALL_SCRIPT      = $(GUDEV_PKG_NAME)-pkg-install.sh

GUDEV_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GUDEV_PKG_NAME)-package

pkg_basename     = $(GUDEV_PKG_NAME)-$(GUDEV_PKG_VERSION)-$(GUDEV_PKG_ARCH)-$(GUDEV_PKG_DISTRO_NAME)-$(GUDEV_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(GUDEV_PKG)


ifneq ($(filter $(HARDWARE),$(HARDWARE_PC32) $(HARDWARE_PC64)),)
ENABLE_GTK_DOCUMENTATION  = yes
else
ENABLE_GTK_DOCUMENTATION  = no
endif

extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var

extra_configure_switches += --enable-introspection=no
ifeq ($(ENABLE_GTK_DOCUMENTATION),yes)
extra_configure_switches += --enable-gtk-doc=yes
extra_configure_switches += --enable-gtk-doc-html=yes
extra_configure_switches += --enable-gtk-doc-pdf=no
else
extra_configure_switches += --enable-gtk-doc=no
endif

extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


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
	@mkdir -p $(GUDEV_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(GUDEV_PKG)/usr/share/man ]; then \
	  ( cd $(GUDEV_PKG)/usr/share/man ; \
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
	@mkdir -p $(GUDEV_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING* \
	       $(GUDEV_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(GUDEV_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING NEWS README \
	         $(GUDEV_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
ifneq ($(ENABLE_GTK_DOCUMENTATION),yes)
	@mkdir -p $(GUDEV_PKG)/usr/share/gtk-doc/html/gudev
	@( cd $(SRC_DIR)/docs/html ; \
	   cp -a *.html *.css *.png gudev.devhelp2 \
	         $(GUDEV_PKG)/usr/share/gtk-doc/html/gudev ; \
	 )
endif
	@ln -sf ../../gtk-doc/html/gudev $(GUDEV_PKG)/usr/share/doc/$(src_dir_name)/html
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(GUDEV_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(GUDEV_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libgudev-?.?.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(GUDEV_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libgudev-?.?.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libgudev-?.?.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" gudev-?.?.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(GUDEV_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(GUDEV_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(GUDEV_PKG_DESCRIPTION_FILE): $(GUDEV_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(GUDEV_PKG_DESCRIPTION_FILE) $(GUDEV_PKG_INSTALL_SCRIPT)
	@cp $(GUDEV_PKG_DESCRIPTION_FILE) $(GUDEV_PKG)/.DESCRIPTION
	@cp $(GUDEV_PKG_INSTALL_SCRIPT) $(GUDEV_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GUDEV_PKG)/.REQUIRES
	@echo "pkgname=$(GUDEV_PKG_NAME)"                            >  $(GUDEV_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GUDEV_PKG_VERSION)"                          >> $(GUDEV_PKG)/.PKGINFO ; \
	 echo "arch=$(GUDEV_PKG_ARCH)"                               >> $(GUDEV_PKG)/.PKGINFO ; \
	 echo "distroname=$(GUDEV_PKG_DISTRO_NAME)"                  >> $(GUDEV_PKG)/.PKGINFO ; \
	 echo "distrover=$(GUDEV_PKG_DISTRO_VERSION)"                >> $(GUDEV_PKG)/.PKGINFO ; \
	 echo "group=$(GUDEV_PKG_GROUP)"                             >> $(GUDEV_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GUDEV_PKG_SHORT_DESCRIPTION)\"" >> $(GUDEV_PKG)/.PKGINFO ; \
	 echo "url=$(GUDEV_PKG_URL)"                                 >> $(GUDEV_PKG)/.PKGINFO ; \
	 echo "license=$(GUDEV_PKG_LICENSE)"                         >> $(GUDEV_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(GUDEV_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
