
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/dbus

REQUIRES           = X11/app/dbus-x11-launch/1.8.10
REQUIRES          += app/dbus/1.8.10-x86_32
REQUIRES          += X11/X.org/lib/libX11/1.6.2-x86_32
REQUIRES          += X11/X.org/lib/libSM/1.2.2-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 1.8.10
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/a/dbus/dbus-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/dbus-$(version)
src_dir_name       = dbus-$(version)
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
DBUS_32_PKG_NAME                = dbus-x11-launch-x32
DBUS_32_PKG_VERSION             = 1.8.10
DBUS_32_PKG_ARCH                = $(TOOLCHAIN)
DBUS_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
DBUS_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
DBUS_32_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
DBUS_32_PKG_SHORT_DESCRIPTION   = D-Bus X11 launcher
DBUS_32_PKG_URL                 = $(BUG_URL)
DBUS_32_PKG_LICENSE             = AFLv2.1
DBUS_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(DBUS_32_PKG_NAME)-pkg-description
DBUS_32_PKG_DESCRIPTION_FILE_IN = $(DBUS_32_PKG_NAME)-pkg-description.in
DBUS_32_PKG_INSTALL_SCRIPT      = $(DBUS_32_PKG_NAME)-pkg-install.sh

DBUS_32_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(DBUS_32_PKG_NAME)-package

pkg_basename     = $(DBUS_32_PKG_NAME)-$(DBUS_32_PKG_VERSION)-$(DBUS_32_PKG_ARCH)-$(DBUS_32_PKG_DISTRO_NAME)-$(DBUS_32_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(DBUS_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
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

#
# We don't need documentation for x86_32 compat libraries
#
extra_configure_switches += --disable-doxygen-docs


TARGET_BIN_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(build_dir)/tools && $(BUILD_ENVIRONMENT) $(MAKE) dbus-launch
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(DBUS_32_PKG)/usr/bin/32
	@cp -a $(build_dir)/tools/dbus-launch $(DBUS_32_PKG)/usr/bin/32/dbus-x11-launch
	# ======= make symbolic link dbus-launch =======
	@( cd $(DBUS_32_PKG)/usr/bin/32 ; \
	   ln -sf dbus-x11-launch dbus-launch ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(DBUS_32_PKG))
	# ======= Strip binaries =======
	@( cd $(DBUS_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(DBUS_32_PKG)/usr/bin/32 ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(DBUS_32_PKG_DESCRIPTION_FILE): $(DBUS_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(DBUS_32_PKG_DESCRIPTION_FILE) $(DBUS_32_PKG_INSTALL_SCRIPT)
	@cp $(DBUS_32_PKG_DESCRIPTION_FILE) $(DBUS_32_PKG)/.DESCRIPTION
	@cp $(DBUS_32_PKG_INSTALL_SCRIPT) $(DBUS_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(DBUS_32_PKG)/.REQUIRES
	@echo "pkgname=$(DBUS_32_PKG_NAME)"                            >  $(DBUS_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(DBUS_32_PKG_VERSION)"                          >> $(DBUS_32_PKG)/.PKGINFO ; \
	 echo "arch=$(DBUS_32_PKG_ARCH)"                               >> $(DBUS_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(DBUS_32_PKG_DISTRO_NAME)"                  >> $(DBUS_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(DBUS_32_PKG_DISTRO_VERSION)"                >> $(DBUS_32_PKG)/.PKGINFO ; \
	 echo "group=$(DBUS_32_PKG_GROUP)"                             >> $(DBUS_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(DBUS_32_PKG_SHORT_DESCRIPTION)\"" >> $(DBUS_32_PKG)/.PKGINFO ; \
	 echo "url=$(DBUS_32_PKG_URL)"                                 >> $(DBUS_32_PKG)/.PKGINFO ; \
	 echo "license=$(DBUS_32_PKG_LICENSE)"                         >> $(DBUS_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(DBUS_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
