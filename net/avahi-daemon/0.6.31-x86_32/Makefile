
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/n/avahi

REQUIRES           = net/avahi-daemon/0.6.31
REQUIRES          += dev/python2/2.7.11-x86_32
REQUIRES          += app/dbus/1.11.2-x86_32
REQUIRES          += libs/glib2/2.40.0-x86_32
REQUIRES          += libs/dbus-python/1.2.0-x86_32
REQUIRES          += libs/gdbm/1.11-x86_32
REQUIRES          += secure/libcap/2.25-x86_32
REQUIRES          += libs/libdaemon/0.14-x86_32

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

PKG_GROUP = net
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
AVAHID_32_PKG_NAME                = avahi-daemon-x32
AVAHID_32_PKG_VERSION             = 0.6.31
AVAHID_32_PKG_ARCH                = $(TOOLCHAIN)
AVAHID_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
AVAHID_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
AVAHID_32_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
AVAHID_32_PKG_SHORT_DESCRIPTION   = zeroconf networking
AVAHID_32_PKG_URL                 = $(BUG_URL)
AVAHID_32_PKG_LICENSE             = LGPLv2.1
AVAHID_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(AVAHID_32_PKG_NAME)-pkg-description
AVAHID_32_PKG_DESCRIPTION_FILE_IN = $(AVAHID_32_PKG_NAME)-pkg-description.in
AVAHID_32_PKG_INSTALL_SCRIPT      = $(AVAHID_32_PKG_NAME)-pkg-install.sh

AVAHID_32_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(AVAHID_32_PKG_NAME)-package

pkg_basename     = $(AVAHID_32_PKG_NAME)-$(AVAHID_32_PKG_VERSION)-$(AVAHID_32_PKG_ARCH)-$(AVAHID_32_PKG_DISTRO_NAME)-$(AVAHID_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(AVAHID_32_PKG)

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
	@mkdir -p $(AVAHID_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(AVAHID_32_PKG)/etc
	@rm -rf $(AVAHID_32_PKG)/usr/bin
	@rm -rf $(AVAHID_32_PKG)/usr/include
	@rm -rf $(AVAHID_32_PKG)/usr/sbin
	@rm -rf $(AVAHID_32_PKG)/usr/share
	@rm -rf $(AVAHID_32_PKG)/var
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(AVAHID_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libavahi-client.la libavahi-common.la  \
	                                    libavahi-core.la libavahi-glib.la      \
	                                    libavahi-gobject.la                  ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(AVAHID_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libavahi-client.la libavahi-common.la  \
	                                            libavahi-core.la libavahi-glib.la      \
	                                            libavahi-gobject.la                  ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libavahi-client.la libavahi-common.la  \
	                                              libavahi-core.la libavahi-glib.la      \
	                                              libavahi-gobject.la                  ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" avahi-client.pc avahi-core.pc    \
	                                            avahi-glib.pc avahi-gobject.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(AVAHID_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(AVAHID_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(AVAHID_32_PKG_DESCRIPTION_FILE): $(AVAHID_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(AVAHID_32_PKG_DESCRIPTION_FILE) $(AVAHID_32_PKG_INSTALL_SCRIPT)
	@cp $(AVAHID_32_PKG_DESCRIPTION_FILE) $(AVAHID_32_PKG)/.DESCRIPTION
	@cp $(AVAHID_32_PKG_INSTALL_SCRIPT) $(AVAHID_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(AVAHID_32_PKG)/.REQUIRES
	@echo "pkgname=$(AVAHID_32_PKG_NAME)"                            >  $(AVAHID_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(AVAHID_32_PKG_VERSION)"                          >> $(AVAHID_32_PKG)/.PKGINFO ; \
	 echo "arch=$(AVAHID_32_PKG_ARCH)"                               >> $(AVAHID_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(AVAHID_32_PKG_DISTRO_NAME)"                  >> $(AVAHID_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(AVAHID_32_PKG_DISTRO_VERSION)"                >> $(AVAHID_32_PKG)/.PKGINFO ; \
	 echo "group=$(AVAHID_32_PKG_GROUP)"                             >> $(AVAHID_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(AVAHID_32_PKG_SHORT_DESCRIPTION)\"" >> $(AVAHID_32_PKG)/.PKGINFO ; \
	 echo "url=$(AVAHID_32_PKG_URL)"                                 >> $(AVAHID_32_PKG)/.PKGINFO ; \
	 echo "license=$(AVAHID_32_PKG_LICENSE)"                         >> $(AVAHID_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(AVAHID_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
