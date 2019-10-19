
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/dbus-glib

REQUIRES           = libs/dbus-glib/0.106
REQUIRES          += app/dbus/1.13.12-x86_32
REQUIRES          += libs/glib2/2.48.0-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 0.106
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
DBUS_GLIB_32_PKG_NAME                = dbus-glib-x32
DBUS_GLIB_32_PKG_VERSION             = 0.106
DBUS_GLIB_32_PKG_ARCH                = $(TOOLCHAIN)
DBUS_GLIB_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
DBUS_GLIB_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
DBUS_GLIB_32_PKG_GROUP               = $(PKG_GROUP)
###                                   |---handy-ruler-------------------------------|
DBUS_GLIB_32_PKG_SHORT_DESCRIPTION   = Glib bindings for dbus
DBUS_GLIB_32_PKG_URL                 = $(BUG_URL)
DBUS_GLIB_32_PKG_LICENSE             = AFLv2.1
DBUS_GLIB_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(DBUS_GLIB_32_PKG_NAME)-pkg-description
DBUS_GLIB_32_PKG_DESCRIPTION_FILE_IN = $(DBUS_GLIB_32_PKG_NAME)-pkg-description.in
DBUS_GLIB_32_PKG_INSTALL_SCRIPT      = $(DBUS_GLIB_32_PKG_NAME)-pkg-install.sh

DBUS_GLIB_32_PKG = $(CURDIR)/$(TARGET_BUILD_DIR)/$(DBUS_GLIB_32_PKG_NAME)-package

pkg_basename     = $(DBUS_GLIB_32_PKG_NAME)-$(DBUS_GLIB_32_PKG_VERSION)-$(DBUS_GLIB_32_PKG_ARCH)-$(DBUS_GLIB_32_PKG_DISTRO_NAME)-$(DBUS_GLIB_32_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(DBUS_GLIB_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man

extra_configure_switches += --bindir=/usr/bin/32

extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes

#
# Cross building requirements:
#
extra_configure_switches += --enable-tests=no
extra_configure_switches += --with-dbus-binding-tool=/usr/bin/dbus-binding-tool


TARGET_BIN_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX)
TARGET_LIB_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib/../lib$(MULTILIB_X86_32_SUFFIX)


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
	@( cd $(build_dir)/dbus ; \
	   sed -i "s,^\(SUBDIRS =\).*,\1 \.," Makefile ; \
	 )
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(DBUS_GLIB_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(DBUS_GLIB_32_PKG)/etc
	@rm -rf $(DBUS_GLIB_32_PKG)/usr/include
	@rm -rf $(DBUS_GLIB_32_PKG)/usr/libexec
	@rm -rf $(DBUS_GLIB_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(DBUS_GLIB_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libdbus-glib-1.la  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(DBUS_GLIB_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libdbus-glib-1.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libdbus-glib-1.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" dbus-glib-1.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(DBUS_GLIB_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(DBUS_GLIB_32_PKG)/usr/bin/32 ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(DBUS_GLIB_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(DBUS_GLIB_32_PKG_DESCRIPTION_FILE): $(DBUS_GLIB_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(DBUS_GLIB_32_PKG_DESCRIPTION_FILE) $(DBUS_GLIB_32_PKG_INSTALL_SCRIPT)
	@cp $(DBUS_GLIB_32_PKG_DESCRIPTION_FILE) $(DBUS_GLIB_32_PKG)/.DESCRIPTION
	@cp $(DBUS_GLIB_32_PKG_INSTALL_SCRIPT) $(DBUS_GLIB_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(DBUS_GLIB_32_PKG)/.REQUIRES
	@echo "pkgname=$(DBUS_GLIB_32_PKG_NAME)"                            >  $(DBUS_GLIB_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(DBUS_GLIB_32_PKG_VERSION)"                          >> $(DBUS_GLIB_32_PKG)/.PKGINFO ; \
	 echo "arch=$(DBUS_GLIB_32_PKG_ARCH)"                               >> $(DBUS_GLIB_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(DBUS_GLIB_32_PKG_DISTRO_NAME)"                  >> $(DBUS_GLIB_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(DBUS_GLIB_32_PKG_DISTRO_VERSION)"                >> $(DBUS_GLIB_32_PKG)/.PKGINFO ; \
	 echo "group=$(DBUS_GLIB_32_PKG_GROUP)"                             >> $(DBUS_GLIB_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(DBUS_GLIB_32_PKG_SHORT_DESCRIPTION)\"" >> $(DBUS_GLIB_32_PKG)/.PKGINFO ; \
	 echo "url=$(DBUS_GLIB_32_PKG_URL)"                                 >> $(DBUS_GLIB_32_PKG)/.PKGINFO ; \
	 echo "license=$(DBUS_GLIB_32_PKG_LICENSE)"                         >> $(DBUS_GLIB_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(DBUS_GLIB_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
