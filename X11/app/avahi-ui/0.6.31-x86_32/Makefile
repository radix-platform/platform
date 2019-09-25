
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/n/avahi

REQUIRES           = X11/app/avahi-ui/0.6.31
REQUIRES          += net/avahi-daemon/0.6.31-x86_32
REQUIRES          += X11/libs/gtk+2/2.24.25-x86_32
REQUIRES          += X11/libs/qt4/4.8.7-x86_32
REQUIRES          += libs/pygtk/2.24.0-x86_32

# ======= __END_OF_REQUIRES__ =======

PYTHON_VERSION = 2.7


version            = 0.6.31
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/n/avahi/avahi-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/avahi-$(version)
src_dir_name       = avahi-$(version)
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
AVAHIUI_32_PKG_NAME                = avahi-ui-x32
AVAHIUI_32_PKG_VERSION             = 0.6.31
AVAHIUI_32_PKG_ARCH                = $(TOOLCHAIN)
AVAHIUI_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
AVAHIUI_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
AVAHIUI_32_PKG_GROUP               = $(PKG_GROUP)
###                                 |---handy-ruler-------------------------------|
AVAHIUI_32_PKG_SHORT_DESCRIPTION   = zeroconf networking GTK+ and QT4 UI
AVAHIUI_32_PKG_URL                 = $(BUG_URL)
AVAHIUI_32_PKG_LICENSE             = LGPLv2.1
AVAHIUI_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(AVAHIUI_32_PKG_NAME)-pkg-description
AVAHIUI_32_PKG_DESCRIPTION_FILE_IN = $(AVAHIUI_32_PKG_NAME)-pkg-description.in
AVAHIUI_32_PKG_INSTALL_SCRIPT      = $(AVAHIUI_32_PKG_NAME)-pkg-install.sh

AVAHIUI_32_PKG   = $(CURDIR)/$(TARGET_BUILD_DIR)/$(AVAHIUI_32_PKG_NAME)-package

pkg_basename     = $(AVAHIUI_32_PKG_NAME)-$(AVAHIUI_32_PKG_VERSION)-$(AVAHIUI_32_PKG_ARCH)-$(AVAHIUI_32_PKG_DISTRO_NAME)-$(AVAHIUI_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_certificate  = $(call cert-name,$(pkg_archive))
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../build-system/core.mk


env_sysroot  = DESTDIR=$(AVAHIUI_32_PKG)

#
# Path to Python.h
#
CFLAGS += -I$(TARGET_DEST_DIR)/usr/include/python$(PYTHON_VERSION)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
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
python_environment += am_cv_python_pythondir=/usr/lib$(MULTILIB_X86_32_SUFFIX)/python$(PYTHON_VERSION)/site-packages
python_environment += am_cv_python_pyexecdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)/python$(PYTHON_VERSION)/site-packages


TARGET_LIB_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib/../lib$(MULTILIB_X86_32_SUFFIX)


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
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) $(python_environment)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(AVAHIUI_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(AVAHIUI_32_PKG)/etc
	@rm -rf $(AVAHIUI_32_PKG)/usr/bin
	@rm -rf $(AVAHIUI_32_PKG)/usr/include
	@rm -rf $(AVAHIUI_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/avahi
	@rm -rf $(AVAHIUI_32_PKG)/usr/sbin
	@rm -rf $(AVAHIUI_32_PKG)/usr/share
	@rm -rf $(AVAHIUI_32_PKG)/var
	@( cd $(AVAHIUI_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in client common core glib gobject ; do \
	     rm -f libavahi-$$file.* ; \
	   done ; \
	 )
	@( cd $(AVAHIUI_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/python$(PYTHON_VERSION)/site-packages ; \
	   rm -rf avahi ; \
	 )
	@( cd $(AVAHIUI_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   for file in client core glib gobject ; do \
	     rm -f avahi-$$file.pc ; \
	   done ; \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(AVAHIUI_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libavahi-qt4.la libavahi-ui.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(AVAHIUI_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libavahi-qt4.la libavahi-ui.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libavahi-qt4.la libavahi-ui.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" avahi-qt4.pc avahi-ui.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(AVAHIUI_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(AVAHIUI_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(AVAHIUI_32_PKG_DESCRIPTION_FILE): $(AVAHIUI_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(AVAHIUI_32_PKG_DESCRIPTION_FILE) $(AVAHIUI_32_PKG_INSTALL_SCRIPT)
	@cp $(AVAHIUI_32_PKG_DESCRIPTION_FILE) $(AVAHIUI_32_PKG)/.DESCRIPTION
	@cp $(AVAHIUI_32_PKG_INSTALL_SCRIPT) $(AVAHIUI_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(AVAHIUI_32_PKG)/.REQUIRES
	@echo "pkgname=$(AVAHIUI_32_PKG_NAME)"                            >  $(AVAHIUI_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(AVAHIUI_32_PKG_VERSION)"                          >> $(AVAHIUI_32_PKG)/.PKGINFO ; \
	 echo "arch=$(AVAHIUI_32_PKG_ARCH)"                               >> $(AVAHIUI_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(AVAHIUI_32_PKG_DISTRO_NAME)"                  >> $(AVAHIUI_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(AVAHIUI_32_PKG_DISTRO_VERSION)"                >> $(AVAHIUI_32_PKG)/.PKGINFO ; \
	 echo "group=$(AVAHIUI_32_PKG_GROUP)"                             >> $(AVAHIUI_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(AVAHIUI_32_PKG_SHORT_DESCRIPTION)\"" >> $(AVAHIUI_32_PKG)/.PKGINFO ; \
	 echo "url=$(AVAHIUI_32_PKG_URL)"                                 >> $(AVAHIUI_32_PKG)/.PKGINFO ; \
	 echo "license=$(AVAHIUI_32_PKG_LICENSE)"                         >> $(AVAHIUI_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(AVAHIUI_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
