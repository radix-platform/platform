
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/cups

REQUIRES           = app/cups/2.1.3
REQUIRES          += app/acl/2.2.52-x86_32
REQUIRES          += secure/pam_unix2/2.9.1-x86_32
REQUIRES          += app/dbus/1.11.2-x86_32
REQUIRES          += libs/libtiff/4.0.6-x86_32
REQUIRES          += libs/libpng/libpng14/1.4.19-x86_32
REQUIRES          += net/gnutls/3.4.8-x86_32
REQUIRES          += net/openssl/1.0.2f-x86_32
REQUIRES          += libs/libusb/1.0.20-x86_32
REQUIRES          += net/avahi-daemon/0.6.31-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 2.1.3
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/a/cups/cups-$(version)-source.tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/cups-$(version)
src_dir_name       = cups-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
CUPS_32_PKG_NAME                = cups-x32
CUPS_32_PKG_VERSION             = 2.1.3
CUPS_32_PKG_ARCH                = $(TOOLCHAIN)
CUPS_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
CUPS_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
CUPS_32_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
CUPS_32_PKG_SHORT_DESCRIPTION   = Common UNIX Printing System
CUPS_32_PKG_URL                 = $(BUG_URL)
CUPS_32_PKG_LICENSE             = CUPS
CUPS_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(CUPS_32_PKG_NAME)-pkg-description
CUPS_32_PKG_DESCRIPTION_FILE_IN = $(CUPS_32_PKG_NAME)-pkg-description.in
CUPS_32_PKG_INSTALL_SCRIPT      = $(CUPS_32_PKG_NAME)-pkg-install.sh

CUPS_32_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(CUPS_32_PKG_NAME)-package

pkg_basename     = $(CUPS_32_PKG_NAME)-$(CUPS_32_PKG_VERSION)-$(CUPS_32_PKG_ARCH)-$(CUPS_32_PKG_DISTRO_NAME)-$(CUPS_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = BUILDROOT=$(CUPS_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --with-logdir=/var/log/cups
extra_configure_switches += --with-docdir=/usr/share/doc/$(src_dir_name)/html

extra_configure_switches += --enable-libusb
extra_configure_switches += --enable-acl

extra_configure_switches += --enable-ssl
extra_configure_switches += --enable-gnutls=yes
extra_configure_switches += --enable-cdsassl=no

extra_configure_switches += --without-php

extra_configure_switches += --enable-pam=yes
extra_configure_switches += --enable-raw-printing
extra_configure_switches += --enable-dbus
extra_configure_switches += --with-dbusdir=/etc/dbus-1

extra_configure_switches += --enable-avahi
extra_configure_switches += --enable-dnssd
extra_configure_switches += --disable-libpaper
# GSSAPI library comming with MIT krb5 (Kerberos):
extra_configure_switches += --disable-gssapi
extra_configure_switches += --disable-systemd

extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes

# multilib executables:
extra_configure_switches += --bindir=/usr/bin/32
extra_configure_switches += --sbindir=/usr/sbin/32


LDFLAGS += -Wl,-rpath,/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib/../lib$(MULTILIB_X86_32_SUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@( cd $(SRC_DIR) ; \
	   sed -i.orig -e 's,exec_prefix/lib/cups,libdir/cups,g' configure ; \
	 )
	@touch $@

$(build_target): $(src_done)
	@( cd $(SRC_DIR) ; \
	   PKG_CONFIG_PATH=/usr/lib$(BUILD_MULTILIB_SUFFIX)/pkgconfig \
	   ./configure --prefix=/usr ; \
	   make ; \
	   cp -a man/mantohtml man/mantohtml-build ; \
	   cp -a ppdc/genstrings ppdc/genstrings-build ; \
	   make distclean ; \
	   sed -i.orig "s,\./mantohtml,\./mantohtml-build,g"   man/Makefile  ; \
	   sed -i.orig "s,\./genstrings,\./genstrings-build,g" ppdc/Makefile ; \
	 )
	@cd $(SRC_DIR) && \
	  $(BUILD_ENVIRONMENT) ./configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(CUPS_32_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@( cd $(CUPS_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; chmod 0644 *.a )
	@rm -rf $(CUPS_32_PKG)/etc
	@rm -rf $(CUPS_32_PKG)/usr/include
	@rm -rf $(CUPS_32_PKG)/usr/share
	@rm -rf $(CUPS_32_PKG)/var
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(CUPS_32_PKG))
	# ======= Give write permissions to owner =======
	@( cd $(CUPS_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs chmod u+w 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs chmod u+w 2> /dev/null ; \
	 )
	# ======= Strip Binaries =======
	@( cd $(CUPS_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(CUPS_32_PKG_DESCRIPTION_FILE): $(CUPS_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(CUPS_32_PKG_DESCRIPTION_FILE) $(CUPS_32_PKG_INSTALL_SCRIPT)
	@cp $(CUPS_32_PKG_DESCRIPTION_FILE) $(CUPS_32_PKG)/.DESCRIPTION
	@cp $(CUPS_32_PKG_INSTALL_SCRIPT) $(CUPS_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(CUPS_32_PKG)/.REQUIRES
	@echo "pkgname=$(CUPS_32_PKG_NAME)"                            >  $(CUPS_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(CUPS_32_PKG_VERSION)"                          >> $(CUPS_32_PKG)/.PKGINFO ; \
	 echo "arch=$(CUPS_32_PKG_ARCH)"                               >> $(CUPS_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(CUPS_32_PKG_DISTRO_NAME)"                  >> $(CUPS_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(CUPS_32_PKG_DISTRO_VERSION)"                >> $(CUPS_32_PKG)/.PKGINFO ; \
	 echo "group=$(CUPS_32_PKG_GROUP)"                             >> $(CUPS_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(CUPS_32_PKG_SHORT_DESCRIPTION)\"" >> $(CUPS_32_PKG)/.PKGINFO ; \
	 echo "url=$(CUPS_32_PKG_URL)"                                 >> $(CUPS_32_PKG)/.PKGINFO ; \
	 echo "license=$(CUPS_32_PKG_LICENSE)"                         >> $(CUPS_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(CUPS_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
