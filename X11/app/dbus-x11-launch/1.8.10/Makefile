
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


include ../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/dbus

REQUIRES           = app/dbus/1.8.10
REQUIRES          += X11/X.org/lib/libX11/1.6.2
REQUIRES          += X11/X.org/lib/libSM/1.2.2

# ======= __END_OF_REQUIRES__ =======


version            = 1.8.10
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/a/dbus/dbus-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/dbus-$(version)
src_dir_name       = dbus-$(version)
doc_dir_name       = dbus-x11-launch-$(version)
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
DBUS_PKG_NAME                = dbus-x11-launch
DBUS_PKG_VERSION             = 1.8.10
DBUS_PKG_ARCH                = $(TOOLCHAIN)
DBUS_PKG_DISTRO_NAME         = $(DISTRO_NAME)
DBUS_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
DBUS_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
DBUS_PKG_SHORT_DESCRIPTION   = D-Bus X11 launcher
DBUS_PKG_URL                 = $(BUG_URL)
DBUS_PKG_LICENSE             = AFLv2.1
DBUS_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(DBUS_PKG_NAME)-pkg-description
DBUS_PKG_DESCRIPTION_FILE_IN = $(DBUS_PKG_NAME)-pkg-description.in
DBUS_PKG_INSTALL_SCRIPT      = $(DBUS_PKG_NAME)-pkg-install.sh

DBUS_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(DBUS_PKG_NAME)-package

pkg_basename     = $(DBUS_PKG_NAME)-$(DBUS_PKG_VERSION)-$(DBUS_PKG_ARCH)-$(DBUS_PKG_DISTRO_NAME)-$(DBUS_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(DBUS_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --enable-inotify
extra_configure_switches += --with-system-pid-file=/var/run/dbus/dbus.pid
extra_configure_switches += --with-system-socket=/var/run/dbus/system_bus_socket
extra_configure_switches += --with-init-scripts=slackware
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes

#
# We don't use X11 here but we stil need to define includies because of configure errors in dbus
#
extra_configure_switches += --with-x=yes
extra_configure_switches += --enable-x11-autolaunch=yes

#
# Tests requires dbus-glib and also enabled only when naive build is running
#
extra_configure_switches += --enable-tests=no
extra_configure_switches += --enable-installed-tests=no


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)


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
	@cd $(build_dir)/tools && $(BUILD_ENVIRONMENT) $(MAKE) dbus-launch
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(DBUS_PKG)/usr/bin
	@cp -a $(build_dir)/tools/dbus-launch $(DBUS_PKG)/usr/bin/dbus-x11-launch
	# ======= make symbolic link dbus-launch =======
	@( cd $(DBUS_PKG)/usr/bin ; \
	   ln -sf dbus-x11-launch dbus-launch ; \
	 )
	# ======= Install Documentation =======
	@mkdir -p $(DBUS_PKG)/usr/doc/$(doc_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(DBUS_PKG)/usr/doc/$(doc_dir_name)
	@mkdir -p $(DBUS_PKG)/usr/share/doc/$(doc_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING README.launchd \
	         $(DBUS_PKG)/usr/share/doc/$(doc_dir_name) ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(DBUS_PKG))
	# ======= Strip binaries =======
	@( cd $(DBUS_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(DBUS_PKG)/usr/bin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(DBUS_PKG_DESCRIPTION_FILE): $(DBUS_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(DBUS_PKG_DESCRIPTION_FILE) $(DBUS_PKG_INSTALL_SCRIPT)
	@cp $(DBUS_PKG_DESCRIPTION_FILE) $(DBUS_PKG)/.DESCRIPTION
	@cp $(DBUS_PKG_INSTALL_SCRIPT) $(DBUS_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(DBUS_PKG)/.REQUIRES
	@echo "pkgname=$(DBUS_PKG_NAME)"                            >  $(DBUS_PKG)/.PKGINFO ; \
	 echo "pkgver=$(DBUS_PKG_VERSION)"                          >> $(DBUS_PKG)/.PKGINFO ; \
	 echo "arch=$(DBUS_PKG_ARCH)"                               >> $(DBUS_PKG)/.PKGINFO ; \
	 echo "distroname=$(DBUS_PKG_DISTRO_NAME)"                  >> $(DBUS_PKG)/.PKGINFO ; \
	 echo "distrover=$(DBUS_PKG_DISTRO_VERSION)"                >> $(DBUS_PKG)/.PKGINFO ; \
	 echo "group=$(DBUS_PKG_GROUP)"                             >> $(DBUS_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(DBUS_PKG_SHORT_DESCRIPTION)\"" >> $(DBUS_PKG)/.PKGINFO ; \
	 echo "url=$(DBUS_PKG_URL)"                                 >> $(DBUS_PKG)/.PKGINFO ; \
	 echo "license=$(DBUS_PKG_LICENSE)"                         >> $(DBUS_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(DBUS_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
