
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_ORANGE_PP2E)
COMPONENT_TARGETS += $(HARDWARE_NANOPI_NEO)
COMPONENT_TARGETS += $(HARDWARE_ORANGE_PP)
COMPONENT_TARGETS += $(HARDWARE_ORANGE_PL2)
COMPONENT_TARGETS += $(HARDWARE_WECHIP_TX6)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_POIN2)
COMPONENT_TARGETS += $(HARDWARE_RK3328_CC)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_EDGE)
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


SOURCE_REQUIRES    = sources/packages/l/dbus-python

REQUIRES           = app/dbus/1.11.2
REQUIRES          += libs/dbus-glib/0.106
REQUIRES          += dev/python2/2.7.11

# ======= __END_OF_REQUIRES__ =======

PYTHON_VERSION = 2.7


version            = 1.2.0
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/dbus-python/dbus-python-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/dbus-python-$(version)
src_dir_name       = dbus-python-$(version)
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
DBUS_PYTHON_PKG_NAME                = dbus-python
DBUS_PYTHON_PKG_VERSION             = 1.2.0
DBUS_PYTHON_PKG_ARCH                = $(TOOLCHAIN)
DBUS_PYTHON_PKG_DISTRO_NAME         = $(DISTRO_NAME)
DBUS_PYTHON_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
DBUS_PYTHON_PKG_GROUP               = $(PKG_GROUP)
###                                  |---handy-ruler-------------------------------|
DBUS_PYTHON_PKG_SHORT_DESCRIPTION   = Python bindings for dbus
DBUS_PYTHON_PKG_URL                 = $(BUG_URL)
DBUS_PYTHON_PKG_LICENSE             = non-copyleft
DBUS_PYTHON_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(DBUS_PYTHON_PKG_NAME)-pkg-description
DBUS_PYTHON_PKG_DESCRIPTION_FILE_IN = $(DBUS_PYTHON_PKG_NAME)-pkg-description.in
DBUS_PYTHON_PKG_INSTALL_SCRIPT      = $(DBUS_PYTHON_PKG_NAME)-pkg-install.sh

DBUS_PYTHON_PKG  = $(CURDIR)/$(TARGET_BUILD_DIR)/$(DBUS_PYTHON_PKG_NAME)-package

pkg_basename     = $(DBUS_PYTHON_PKG_NAME)-$(DBUS_PYTHON_PKG_VERSION)-$(DBUS_PYTHON_PKG_ARCH)-$(DBUS_PYTHON_PKG_DISTRO_NAME)-$(DBUS_PYTHON_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(DBUS_PYTHON_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes

python_environment  = PLATFORM=linux2
python_environment += PYTHON_VERSION=$(PYTHON_VERSION)
python_environment += PYTHON_SITE_PACKAGES=/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/site-packages
python_environment += PYTHON_INCLUDES=$(TARGET_DEST_DIR)/usr/include/python$(PYTHON_VERSION)
python_environment += PYTHON_LIBS=-L$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/config

#
# The cross-building requirements:
#
python_environment += CPPFLAGS="$(CFLAGS) -I$(TARGET_DEST_DIR)/usr/include/python$(PYTHON_VERSION)"
python_environment += CPP="$(CC) --sysroot=$(TARGET_DEST_DIR) -E"
python_environment += am_cv_python_pythondir=/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/site-packages
python_environment += am_cv_python_pyexecdir=/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/site-packages


TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) $(python_environment) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(python_environment) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(DBUS_PYTHON_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(DBUS_PYTHON_PKG)/usr/share/man ]; then \
	  ( cd $(DBUS_PYTHON_PKG)/usr/share/man ; \
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
	@mkdir -p $(DBUS_PYTHON_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(DBUS_PYTHON_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(DBUS_PYTHON_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING INSTALL \
	         $(DBUS_PYTHON_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(DBUS_PYTHON_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(DBUS_PYTHON_PKG)/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/site-packages ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" _dbus_bindings.la _dbus_glib_bindings.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(DBUS_PYTHON_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/site-packages ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" _dbus_bindings.la _dbus_glib_bindings.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" _dbus_bindings.la _dbus_glib_bindings.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" dbus-python.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(DBUS_PYTHON_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(DBUS_PYTHON_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(DBUS_PYTHON_PKG_DESCRIPTION_FILE): $(DBUS_PYTHON_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(DBUS_PYTHON_PKG_DESCRIPTION_FILE) $(DBUS_PYTHON_PKG_INSTALL_SCRIPT)
	@cp $(DBUS_PYTHON_PKG_DESCRIPTION_FILE) $(DBUS_PYTHON_PKG)/.DESCRIPTION
	@cp $(DBUS_PYTHON_PKG_INSTALL_SCRIPT) $(DBUS_PYTHON_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(DBUS_PYTHON_PKG)/.REQUIRES
	@echo "pkgname=$(DBUS_PYTHON_PKG_NAME)"                            >  $(DBUS_PYTHON_PKG)/.PKGINFO ; \
	 echo "pkgver=$(DBUS_PYTHON_PKG_VERSION)"                          >> $(DBUS_PYTHON_PKG)/.PKGINFO ; \
	 echo "arch=$(DBUS_PYTHON_PKG_ARCH)"                               >> $(DBUS_PYTHON_PKG)/.PKGINFO ; \
	 echo "distroname=$(DBUS_PYTHON_PKG_DISTRO_NAME)"                  >> $(DBUS_PYTHON_PKG)/.PKGINFO ; \
	 echo "distrover=$(DBUS_PYTHON_PKG_DISTRO_VERSION)"                >> $(DBUS_PYTHON_PKG)/.PKGINFO ; \
	 echo "group=$(DBUS_PYTHON_PKG_GROUP)"                             >> $(DBUS_PYTHON_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(DBUS_PYTHON_PKG_SHORT_DESCRIPTION)\"" >> $(DBUS_PYTHON_PKG)/.PKGINFO ; \
	 echo "url=$(DBUS_PYTHON_PKG_URL)"                                 >> $(DBUS_PYTHON_PKG)/.PKGINFO ; \
	 echo "license=$(DBUS_PYTHON_PKG_LICENSE)"                         >> $(DBUS_PYTHON_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(DBUS_PYTHON_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
