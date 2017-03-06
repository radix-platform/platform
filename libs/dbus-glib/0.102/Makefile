
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXV)
COMPONENT_TARGETS += $(HARDWARE_P201)
COMPONENT_TARGETS += $(HARDWARE_NEXBOX_A95X)
COMPONENT_TARGETS += $(HARDWARE_ODROID_C2)
COMPONENT_TARGETS += $(HARDWARE_P212)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_VIM)
COMPONENT_TARGETS += $(HARDWARE_Q201)
COMPONENT_TARGETS += $(HARDWARE_ENYBOX_X2)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/dbus-glib

REQUIRES           = app/dbus/1.11.2
REQUIRES          += libs/glib2/2.48.0

# ======= __END_OF_REQUIRES__ =======


version            = 0.102
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/dbus-glib/dbus-glib-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/dbus-glib-$(version)
src_dir_name       = dbus-glib-$(version)
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
DBUS_GLIB_PKG_NAME                = dbus-glib
DBUS_GLIB_PKG_VERSION             = 0.102
DBUS_GLIB_PKG_ARCH                = $(TOOLCHAIN)
DBUS_GLIB_PKG_DISTRO_NAME         = $(DISTRO_NAME)
DBUS_GLIB_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
DBUS_GLIB_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
DBUS_GLIB_PKG_SHORT_DESCRIPTION   = Glib bindings for dbus
DBUS_GLIB_PKG_URL                 = $(BUG_URL)
DBUS_GLIB_PKG_LICENSE             = AFLv2.1
DBUS_GLIB_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(DBUS_GLIB_PKG_NAME)-pkg-description
DBUS_GLIB_PKG_DESCRIPTION_FILE_IN = $(DBUS_GLIB_PKG_NAME)-pkg-description.in
DBUS_GLIB_PKG_INSTALL_SCRIPT      = $(DBUS_GLIB_PKG_NAME)-pkg-install.sh

DBUS_GLIB_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(DBUS_GLIB_PKG_NAME)-package

pkg_basename     = $(DBUS_GLIB_PKG_NAME)-$(DBUS_GLIB_PKG_VERSION)-$(DBUS_GLIB_PKG_ARCH)-$(DBUS_GLIB_PKG_DISTRO_NAME)-$(DBUS_GLIB_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(DBUS_GLIB_PKG)


ENABLE_GTK_DOCUMENTATION  = yes

extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes

ifeq ($(ENABLE_GTK_DOCUMENTATION),yes)
extra_configure_switches += --enable-gtk-doc
endif

#
# Cross building requirements:
#
extra_configure_switches += --enable-tests=no
extra_configure_switches += --with-dbus-binding-tool=/usr/bin/dbus-binding-tool


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
	@( cd $(build_dir)/dbus ; \
	   sed -i "s,^\(SUBDIRS =\).*,\1 \.," Makefile ; \
	 )
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(DBUS_GLIB_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(DBUS_GLIB_PKG)/usr/share/man ]; then \
	  ( cd $(DBUS_GLIB_PKG)/usr/share/man ; \
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
	@mkdir -p $(DBUS_GLIB_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(DBUS_GLIB_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(DBUS_GLIB_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING HACKING INSTALL NEWS README \
	         $(DBUS_GLIB_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
ifeq ($(ENABLE_GTK_DOCUMENTATION),yes)
	@ln -sf ../../gtk-doc/html/dbus-glib $(DBUS_GLIB_PKG)/usr/share/doc/$(src_dir_name)/html
endif
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(DBUS_GLIB_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(DBUS_GLIB_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libdbus-glib-1.la  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(DBUS_GLIB_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libdbus-glib-1.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libdbus-glib-1.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" dbus-glib-1.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(DBUS_GLIB_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(DBUS_GLIB_PKG)/usr ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(DBUS_GLIB_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(DBUS_GLIB_PKG_DESCRIPTION_FILE): $(DBUS_GLIB_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(DBUS_GLIB_PKG_DESCRIPTION_FILE) $(DBUS_GLIB_PKG_INSTALL_SCRIPT)
	@cp $(DBUS_GLIB_PKG_DESCRIPTION_FILE) $(DBUS_GLIB_PKG)/.DESCRIPTION
	@cp $(DBUS_GLIB_PKG_INSTALL_SCRIPT) $(DBUS_GLIB_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(DBUS_GLIB_PKG)/.REQUIRES
	@echo "pkgname=$(DBUS_GLIB_PKG_NAME)"                            >  $(DBUS_GLIB_PKG)/.PKGINFO ; \
	 echo "pkgver=$(DBUS_GLIB_PKG_VERSION)"                          >> $(DBUS_GLIB_PKG)/.PKGINFO ; \
	 echo "arch=$(DBUS_GLIB_PKG_ARCH)"                               >> $(DBUS_GLIB_PKG)/.PKGINFO ; \
	 echo "distroname=$(DBUS_GLIB_PKG_DISTRO_NAME)"                  >> $(DBUS_GLIB_PKG)/.PKGINFO ; \
	 echo "distrover=$(DBUS_GLIB_PKG_DISTRO_VERSION)"                >> $(DBUS_GLIB_PKG)/.PKGINFO ; \
	 echo "group=$(DBUS_GLIB_PKG_GROUP)"                             >> $(DBUS_GLIB_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(DBUS_GLIB_PKG_SHORT_DESCRIPTION)\"" >> $(DBUS_GLIB_PKG)/.PKGINFO ; \
	 echo "url=$(DBUS_GLIB_PKG_URL)"                                 >> $(DBUS_GLIB_PKG)/.PKGINFO ; \
	 echo "license=$(DBUS_GLIB_PKG_LICENSE)"                         >> $(DBUS_GLIB_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(DBUS_GLIB_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
