
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
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/n/avahi

REQUIRES           = net/avahi-daemon/0.6.31
REQUIRES          += X11/libs/gtk+2/2.24.25
REQUIRES          += X11/libs/qt4/4.8.6
REQUIRES          += X11/app/desktop-file-utils/0.22
REQUIRES          += libs/pygtk/2.24.0

# ======= __END_OF_REQUIRES__ =======

PYTHON_VERSION = 2.7


version            = 0.6.31
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/n/avahi/avahi-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/avahi-$(version)
src_dir_name       = avahi-$(version)
doc_dir_name       = avahi-ui-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = xapp

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
AVAHIUI_PKG_NAME                = avahi-ui
AVAHIUI_PKG_VERSION             = 0.6.31
AVAHIUI_PKG_ARCH                = $(TOOLCHAIN)
AVAHIUI_PKG_DISTRO_NAME         = $(DISTRO_NAME)
AVAHIUI_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
AVAHIUI_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
AVAHIUI_PKG_SHORT_DESCRIPTION   = zeroconf networking GTK+ and QT4 UI
AVAHIUI_PKG_URL                 = $(BUG_URL)
AVAHIUI_PKG_LICENSE             = LGPLv2.1
AVAHIUI_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(AVAHIUI_PKG_NAME)-pkg-description
AVAHIUI_PKG_DESCRIPTION_FILE_IN = $(AVAHIUI_PKG_NAME)-pkg-description.in
AVAHIUI_PKG_INSTALL_SCRIPT      = $(AVAHIUI_PKG_NAME)-pkg-install.sh

AVAHIUI_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(AVAHIUI_PKG_NAME)-package

pkg_basename     = $(AVAHIUI_PKG_NAME)-$(AVAHIUI_PKG_VERSION)-$(AVAHIUI_PKG_ARCH)-$(AVAHIUI_PKG_DISTRO_NAME)-$(AVAHIUI_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../build-system/core.mk


env_sysroot = DESTDIR=$(AVAHIUI_PKG)

#
# Path to Python.h
#
CFLAGS += -I$(TARGET_DEST_DIR)/usr/include/python$(PYTHON_VERSION)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --enable-python
extra_configure_switches += --enable-python-dbus
extra_configure_switches += --enable-glib
extra_configure_switches += --enable-dbus

extra_configure_switches += --enable-gtk
extra_configure_switches += --disable-gtk3
extra_configure_switches += --enable-pygtk
extra_configure_switches += --disable-qt3
extra_configure_switches += --enable-qt4

extra_configure_switches += --disable-dbm
extra_configure_switches += --enable-gdbm
extra_configure_switches += --enable-libdaemon
extra_configure_switches += --disable-tests
extra_configure_switches += --disable-mono
extra_configure_switches += --disable-monodoc
extra_configure_switches += --enable-core-docs
extra_configure_switches += --with-avahi-user=avahi
extra_configure_switches += --with-avahi-group=avahi
extra_configure_switches += --with-autoipd-user=avahi-autoipd
extra_configure_switches += --with-autoipd-group=avahi-autoipd
extra_configure_switches += --disable-doxygen-doc

extra_configure_switches += --with-distro=none

extra_configure_switches += --enable-introspection=no
extra_configure_switches += --program-prefix=
extra_configure_switches += --program-suffix=

extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


qt_environment  = MOC_QT4=$(TARGET_DEST_DIR)/usr/bin/$(TARGET)-moc


python_environment  = am_cv_python_version=$(PYTHON_VERSION)
python_environment += am_cv_python_platform=linux2
python_environment += am_cv_python_pythondir=/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/site-packages
python_environment += am_cv_python_pyexecdir=/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/site-packages


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
	  $(BUILD_ENVIRONMENT)  $(qt_environment) $(python_environment) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) $(python_environment)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(AVAHIUI_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(AVAHIUI_PKG)/etc
	@rm -rf $(AVAHIUI_PKG)/var
	@rm -rf $(AVAHIUI_PKG)/usr/lib$(LIBSUFFIX)/avahi
	@rm -rf $(AVAHIUI_PKG)/usr/sbin
	@rm  -f $(AVAHIUI_PKG)/usr/share/avahi/avahi-service.dtd
	@rm  -f $(AVAHIUI_PKG)/usr/share/avahi/service-types
	@rm -rf $(AVAHIUI_PKG)/usr/share/dbus-1
	@rm -rf $(AVAHIUI_PKG)/usr/share/locale
	@rm -rf $(AVAHIUI_PKG)/usr/share/man/man{5,8}
	@( cd $(AVAHIUI_PKG)/usr/share/man/man1 ; \
	   for file in bookmarks browse browse-domains \
	               publish publish-address publish-service \
	               resolve resolve-address resolve-host-name set-host-name ; do \
	     rm -f avahi-$$file.1 ; \
	   done ; \
	 )
	@( cd $(AVAHIUI_PKG)/usr/bin ; \
	   for file in bookmarks browse browse-domains \
	               publish publish-address publish-service \
	               resolve resolve-address resolve-host-name set-host-name ; do \
	     rm -f avahi-$$file ; \
	   done ; \
	 )
	@( cd $(AVAHIUI_PKG)/usr/include ; \
	   for dir in client common core glib gobject ; do \
	     rm -rf avahi-$$dir ; \
	   done ; \
	 )
	@( cd $(AVAHIUI_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in client common core glib gobject ; do \
	     rm -f libavahi-$$file.* ; \
	   done ; \
	 )
	@( cd $(AVAHIUI_PKG)/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/site-packages ; \
	   rm -rf avahi ; \
	 )
	@( cd $(AVAHIUI_PKG)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   for file in client core glib gobject ; do \
	     rm -f avahi-$$file.pc ; \
	   done ; \
	 )
	# ======= Install Documentation =======
	@if [ -d $(AVAHIUI_PKG)/usr/share/man ]; then \
	  ( cd $(AVAHIUI_PKG)/usr/share/man ; \
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
	@mkdir -p $(AVAHIUI_PKG)/usr/doc/$(doc_dir_name)
	@cp -a $(SRC_DIR)/LICENSE \
	       $(AVAHIUI_PKG)/usr/doc/$(doc_dir_name)
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(AVAHIUI_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libavahi-qt4.la libavahi-ui.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(AVAHIUI_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libavahi-qt4.la libavahi-ui.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libavahi-qt4.la libavahi-ui.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" avahi-qt4.pc avahi-ui.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(AVAHIUI_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(AVAHIUI_PKG)/usr ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(AVAHIUI_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(AVAHIUI_PKG_DESCRIPTION_FILE): $(AVAHIUI_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(AVAHIUI_PKG_DESCRIPTION_FILE) $(AVAHIUI_PKG_INSTALL_SCRIPT)
	@cp $(AVAHIUI_PKG_DESCRIPTION_FILE) $(AVAHIUI_PKG)/.DESCRIPTION
	@cp $(AVAHIUI_PKG_INSTALL_SCRIPT) $(AVAHIUI_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(AVAHIUI_PKG)/.REQUIRES
	@echo "pkgname=$(AVAHIUI_PKG_NAME)"                            >  $(AVAHIUI_PKG)/.PKGINFO ; \
	 echo "pkgver=$(AVAHIUI_PKG_VERSION)"                          >> $(AVAHIUI_PKG)/.PKGINFO ; \
	 echo "arch=$(AVAHIUI_PKG_ARCH)"                               >> $(AVAHIUI_PKG)/.PKGINFO ; \
	 echo "distroname=$(AVAHIUI_PKG_DISTRO_NAME)"                  >> $(AVAHIUI_PKG)/.PKGINFO ; \
	 echo "distrover=$(AVAHIUI_PKG_DISTRO_VERSION)"                >> $(AVAHIUI_PKG)/.PKGINFO ; \
	 echo "group=$(AVAHIUI_PKG_GROUP)"                             >> $(AVAHIUI_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(AVAHIUI_PKG_SHORT_DESCRIPTION)\"" >> $(AVAHIUI_PKG)/.PKGINFO ; \
	 echo "url=$(AVAHIUI_PKG_URL)"                                 >> $(AVAHIUI_PKG)/.PKGINFO ; \
	 echo "license=$(AVAHIUI_PKG_LICENSE)"                         >> $(AVAHIUI_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(AVAHIUI_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
