
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_POIN2)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXV)
COMPONENT_TARGETS += $(HARDWARE_P201)
COMPONENT_TARGETS += $(HARDWARE_NEXBOX_A95X)
COMPONENT_TARGETS += $(HARDWARE_ODROID_C2)
COMPONENT_TARGETS += $(HARDWARE_P212)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_VIM)
COMPONENT_TARGETS += $(HARDWARE_Q201)
COMPONENT_TARGETS += $(HARDWARE_ENYBOX_X2)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_VIM2)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BAIKAL_T1)
COMPONENT_TARGETS += $(HARDWARE_MBC4_PC)
COMPONENT_TARGETS += $(HARDWARE_S824L)
COMPONENT_TARGETS += $(HARDWARE_VESNIN)
COMPONENT_TARGETS += $(HARDWARE_S824L_LSB)
COMPONENT_TARGETS += $(HARDWARE_VESNIN_LSB)
COMPONENT_TARGETS += $(HARDWARE_TL2WK2)
COMPONENT_TARGETS += $(HARDWARE_TL2SV2)
COMPONENT_TARGETS += $(HARDWARE_TL2WK2_LSB)
COMPONENT_TARGETS += $(HARDWARE_TL2SV2_LSB)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/n/avahi

REQUIRES           = dev/python2/2.7.11
REQUIRES          += app/dbus/1.11.2
REQUIRES          += libs/glib2/2.48.0
REQUIRES          += libs/dbus-python/1.2.4
REQUIRES          += libs/gdbm/1.11
REQUIRES          += secure/libcap/2.25
REQUIRES          += libs/libdaemon/0.14

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

rc_avahidaemon     = $(CURDIR)/etc/rc.d/rc.avahidaemon
rc_avahidnsconfd   = $(CURDIR)/etc/rc.d/rc.avahidnsconfd


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
AVAHID_PKG_NAME                = avahi-daemon
AVAHID_PKG_VERSION             = 0.6.31
AVAHID_PKG_ARCH                = $(TOOLCHAIN)
AVAHID_PKG_DISTRO_NAME         = $(DISTRO_NAME)
AVAHID_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
AVAHID_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
AVAHID_PKG_SHORT_DESCRIPTION   = zeroconf networking
AVAHID_PKG_URL                 = $(BUG_URL)
AVAHID_PKG_LICENSE             = LGPLv2.1
AVAHID_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(AVAHID_PKG_NAME)-pkg-description
AVAHID_PKG_DESCRIPTION_FILE_IN = $(AVAHID_PKG_NAME)-pkg-description.in
AVAHID_PKG_INSTALL_SCRIPT      = $(AVAHID_PKG_NAME)-pkg-install.sh

AVAHID_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(AVAHID_PKG_NAME)-package

pkg_basename     = $(AVAHID_PKG_NAME)-$(AVAHID_PKG_VERSION)-$(AVAHID_PKG_ARCH)-$(AVAHID_PKG_DISTRO_NAME)-$(AVAHID_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_certificate  = $(call cert-name,$(pkg_archive))
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(AVAHID_PKG)

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

extra_configure_switches += --disable-gtk
extra_configure_switches += --disable-gtk3
extra_configure_switches += --disable-pygtk
extra_configure_switches += --disable-qt3
extra_configure_switches += --disable-qt4

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
	@mkdir -p $(AVAHID_PKG)/etc/rc.d
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(AVAHID_PKG)/usr/share/applications
	@rm -rf $(AVAHID_PKG)/usr/share/avahi/interfaces
	@cp -a $(rc_avahidaemon)   $(AVAHID_PKG)/etc/rc.d
	@cp -a $(rc_avahidnsconfd) $(AVAHID_PKG)/etc/rc.d
	@chmod 644 $(AVAHID_PKG)/etc/rc.d/rc.*
	@( cd $(AVAHID_PKG)/etc/rc.d ; \
	   for i in avahidaemon avahidnsconfd ; do \
	     mv rc.$$i rc.$$i.new ; \
	   done ; \
	 )
	@mv $(AVAHID_PKG)/etc/dbus-1/system.d/avahi-dbus.conf $(AVAHID_PKG)/etc/dbus-1/system.d/avahi-dbus.conf.new
	@mv $(AVAHID_PKG)/etc/avahi/avahi-daemon.conf $(AVAHID_PKG)/etc/avahi/avahi-daemon.conf.new
	# ======= Setup up autoipd dirs =======
	@mkdir -p $(AVAHID_PKG)/var/run/avahi-daemon
	@mkdir -p $(AVAHID_PKG)/var/run/avahi-autoipd
	# ======= Install Documentation =======
	@if [ -d $(AVAHID_PKG)/usr/share/man ]; then \
	  ( cd $(AVAHID_PKG)/usr/share/man ; \
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
	@mkdir -p $(AVAHID_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/LICENSE \
	       $(AVAHID_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(AVAHID_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a LICENSE $(AVAHID_PKG)/usr/share/doc/$(src_dir_name) ; \
	   cp -a README  $(AVAHID_PKG)/usr/share/doc/$(src_dir_name)/README.discovery ; \
	 )
	@( cd $(SRC_DIR)/docs ; \
	   cp -a API-CHANGES* AUTHORS COMPAT-LAYERS \
	         DBUS-API HACKING INSTALL MALLOC NEWS README TODO \
	         $(AVAHID_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(AVAHID_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(AVAHID_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libavahi-client.la libavahi-common.la  \
	                                    libavahi-core.la libavahi-glib.la      \
	                                    libavahi-gobject.la                  ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(AVAHID_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libavahi-client.la libavahi-common.la  \
	                                            libavahi-core.la libavahi-glib.la      \
	                                            libavahi-gobject.la                  ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libavahi-client.la libavahi-common.la  \
	                                              libavahi-core.la libavahi-glib.la      \
	                                              libavahi-gobject.la                  ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" avahi-client.pc avahi-core.pc    \
	                                            avahi-glib.pc avahi-gobject.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(AVAHID_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(AVAHID_PKG)/usr ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(AVAHID_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(AVAHID_PKG_DESCRIPTION_FILE): $(AVAHID_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(AVAHID_PKG_DESCRIPTION_FILE) $(AVAHID_PKG_INSTALL_SCRIPT)
	@cp $(AVAHID_PKG_DESCRIPTION_FILE) $(AVAHID_PKG)/.DESCRIPTION
	@cp $(AVAHID_PKG_INSTALL_SCRIPT) $(AVAHID_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(AVAHID_PKG)/.REQUIRES
	@echo "pkgname=$(AVAHID_PKG_NAME)"                            >  $(AVAHID_PKG)/.PKGINFO ; \
	 echo "pkgver=$(AVAHID_PKG_VERSION)"                          >> $(AVAHID_PKG)/.PKGINFO ; \
	 echo "arch=$(AVAHID_PKG_ARCH)"                               >> $(AVAHID_PKG)/.PKGINFO ; \
	 echo "distroname=$(AVAHID_PKG_DISTRO_NAME)"                  >> $(AVAHID_PKG)/.PKGINFO ; \
	 echo "distrover=$(AVAHID_PKG_DISTRO_VERSION)"                >> $(AVAHID_PKG)/.PKGINFO ; \
	 echo "group=$(AVAHID_PKG_GROUP)"                             >> $(AVAHID_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(AVAHID_PKG_SHORT_DESCRIPTION)\"" >> $(AVAHID_PKG)/.PKGINFO ; \
	 echo "url=$(AVAHID_PKG_URL)"                                 >> $(AVAHID_PKG)/.PKGINFO ; \
	 echo "license=$(AVAHID_PKG_LICENSE)"                         >> $(AVAHID_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(AVAHID_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
