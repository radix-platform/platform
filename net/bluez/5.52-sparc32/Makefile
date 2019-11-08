
COMPONENT_TARGETS  = $(HARDWARE_MBC4_PC)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_SPARC32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/n/bluez

REQUIRES           = net/bluez/5.52
REQUIRES          += app/dbus/1.13.12-sparc32
REQUIRES          += libs/glib2/2.63.0-sparc32
REQUIRES          += libs/libical/3.0.6-sparc32

# ======= __END_OF_REQUIRES__ =======


version            = 5.52
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/n/bluez/bluez-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/bluez-$(version)
src_dir_name       = bluez-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
BLUEZ_32_PKG_NAME                = bluez-x32
BLUEZ_32_PKG_VERSION             = 5.52
BLUEZ_32_PKG_ARCH                = $(TOOLCHAIN)
BLUEZ_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
BLUEZ_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
BLUEZ_32_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
BLUEZ_32_PKG_SHORT_DESCRIPTION   = Bluetooth libraries and utilities
BLUEZ_32_PKG_URL                 = $(BUG_URL)
BLUEZ_32_PKG_LICENSE             = GPLv2
BLUEZ_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(BLUEZ_32_PKG_NAME)-pkg-description
BLUEZ_32_PKG_DESCRIPTION_FILE_IN = $(BLUEZ_32_PKG_NAME)-pkg-description.in
BLUEZ_32_PKG_INSTALL_SCRIPT      = $(BLUEZ_32_PKG_NAME)-pkg-install.sh

BLUEZ_32_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(BLUEZ_32_PKG_NAME)-package

pkg_basename     = $(BLUEZ_32_PKG_NAME)-$(BLUEZ_32_PKG_VERSION)-$(BLUEZ_32_PKG_ARCH)-$(BLUEZ_32_PKG_DISTRO_NAME)-$(BLUEZ_32_PKG_DISTRO_VERSION)

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


env_sysroot  = DESTDIR=$(BLUEZ_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_SPARC32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var

extra_configure_switches += --bindir=/usr/bin/32

#
# NOTE: we have to overwrite variables from DevEnv dbus-1.pc
#
extra_configure_switches += --with-dbusconfdir=/etc
extra_configure_switches += --with-dbussessionbusdir=/usr/share/dbus-1/services
extra_configure_switches += --with-dbussystembusdir=/usr/share/dbus-1/system-services

extra_configure_switches += --disable-systemd

extra_configure_switches += --enable-sixaxis
extra_configure_switches += --enable-experimental
extra_configure_switches += --enable-library

ifeq ($(__ENABLE_STATIC__),yes)
extra_configure_switches += --enable-static=yes
else
extra_configure_switches += --enable-static=no
endif
extra_configure_switches += --enable-shared=yes


TARGET_BIN_RPATH = /lib$(MULTILIB_SPARC32_SUFFIX):/usr/lib$(MULTILIB_SPARC32_SUFFIX)
TARGET_LIB_RPATH = /lib$(MULTILIB_SPARC32_SUFFIX):/usr/lib$(MULTILIB_SPARC32_SUFFIX):/usr/lib/../lib$(MULTILIB_SPARC32_SUFFIX)

LDFLAGS += -Wl,-rpath,$(TARGET_LIB_RPATH)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@( cd $(SRC_DIR) ; \
	   autoreconf -vif ; \
	   sed -i -e 's|-lreadline|\0 -lncursesw|g' Makefile.{in,tools} ; \
	 )
	@( cd $(SRC_DIR) ; \
	   autoreconf -vif ; \
	   sed -i -e 's|-lreadline|\0 -lncursesw|g' Makefile.{in,tools} ; \
	 )
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && \
	  $(BUILD_ENVIRONMENT) LIBS='-latomic' ./configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@( cd $(SRC_DIR) ; \
	   echo ""                                                                       >> config.h ; \
	   echo "/*********************************************************************" >> config.h ; \
	   echo "  Redefine Legacy __sync Built-in Functions for Atomic Memory Access:"  >> config.h ; \
	   echo " */"                                                                    >> config.h ; \
	   echo "#if ! defined( __sync_fetch_and_add )"                                  >> config.h ; \
	   echo "#define __sync_fetch_and_add( p, v ) \\"                                >> config.h ; \
	   echo "  __atomic_fetch_add( p, v, __ATOMIC_RELAXED )"                         >> config.h ; \
	   echo "#endif"                                                                 >> config.h ; \
	   echo ""                                                                       >> config.h ; \
	   echo "#if ! defined( __sync_fetch_and_sub )"                                  >> config.h ; \
	   echo "#define __sync_fetch_and_sub( p, v ) \\"                                >> config.h ; \
	   echo "  __atomic_fetch_sub( p, v, __ATOMIC_RELAXED )"                         >> config.h ; \
	   echo "#endif"                                                                 >> config.h ; \
	   echo ""                                                                       >> config.h ; \
	   echo "#if ! defined( __sync_add_and_fetch )"                                  >> config.h ; \
	   echo "#define __sync_add_and_fetch( p, v ) \\"                                >> config.h ; \
	   echo "  __atomic_add_fetch( p, v, __ATOMIC_RELAXED )"                         >> config.h ; \
	   echo "#endif"                                                                 >> config.h ; \
	   echo ""                                                                       >> config.h ; \
	   echo "#if ! defined( __sync_sub_and_fetch )"                                  >> config.h ; \
	   echo "#define __sync_sub_and_fetch( p, v ) \\"                                >> config.h ; \
	   echo "  __atomic_sub_fetch( p, v, __ATOMIC_RELAXED )"                         >> config.h ; \
	   echo "#endif"                                                                 >> config.h ; \
	 )
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(BLUEZ_32_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(BLUEZ_32_PKG)/etc
	@rm -rf $(BLUEZ_32_PKG)/lib
	@rm -rf $(BLUEZ_32_PKG)/usr/include
	@rm -rf $(BLUEZ_32_PKG)/usr/libexec
	@rm -rf $(BLUEZ_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(BLUEZ_32_PKG)/usr/lib$(MULTILIB_SPARC32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libbluetooth.la ; \
	 )
	@( cd $(BLUEZ_32_PKG)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/bluetooth/plugins ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" sixaxis.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(BLUEZ_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_SPARC32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g"   libbluetooth.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libbluetooth.la ; \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/bluetooth/plugins ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g"   sixaxis.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" sixaxis.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" bluez.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(BLUEZ_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifeq ($(__ENABLE_STATIC__),yes)
	@( cd $(BLUEZ_32_PKG) ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null ; \
	 )
endif
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(BLUEZ_32_PKG) ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(BLUEZ_32_PKG)/usr/lib$(MULTILIB_SPARC32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(BLUEZ_32_PKG_DESCRIPTION_FILE): $(BLUEZ_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(BLUEZ_32_PKG_DESCRIPTION_FILE) $(BLUEZ_32_PKG_INSTALL_SCRIPT)
	@cp $(BLUEZ_32_PKG_DESCRIPTION_FILE) $(BLUEZ_32_PKG)/.DESCRIPTION
	@cp $(BLUEZ_32_PKG_INSTALL_SCRIPT) $(BLUEZ_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(BLUEZ_32_PKG)/.REQUIRES
	@echo "pkgname=$(BLUEZ_32_PKG_NAME)"                            >  $(BLUEZ_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(BLUEZ_32_PKG_VERSION)"                          >> $(BLUEZ_32_PKG)/.PKGINFO ; \
	 echo "arch=$(BLUEZ_32_PKG_ARCH)"                               >> $(BLUEZ_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(BLUEZ_32_PKG_DISTRO_NAME)"                  >> $(BLUEZ_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(BLUEZ_32_PKG_DISTRO_VERSION)"                >> $(BLUEZ_32_PKG)/.PKGINFO ; \
	 echo "group=$(BLUEZ_32_PKG_GROUP)"                             >> $(BLUEZ_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(BLUEZ_32_PKG_SHORT_DESCRIPTION)\"" >> $(BLUEZ_32_PKG)/.PKGINFO ; \
	 echo "url=$(BLUEZ_32_PKG_URL)"                                 >> $(BLUEZ_32_PKG)/.PKGINFO ; \
	 echo "license=$(BLUEZ_32_PKG_LICENSE)"                         >> $(BLUEZ_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(BLUEZ_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
