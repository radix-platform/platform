
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
COMPONENT_TARGETS += $(HARDWARE_BT1)
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


SOURCE_REQUIRES    = sources/packages/a/cups

REQUIRES           = app/acl/2.2.52
REQUIRES          += secure/pam_unix2/2.9.1
REQUIRES          += app/dbus/1.11.2
REQUIRES          += libs/libtiff/4.0.6
REQUIRES          += libs/libpng/libpng14/1.4.19
REQUIRES          += net/gnutls/3.4.8
REQUIRES          += net/openssl/1.0.2f
REQUIRES          += libs/libusb/1.0.20
REQUIRES          += net/avahi-daemon/0.6.31

# ======= __END_OF_REQUIRES__ =======


version            = 2.1.3
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/a/cups/cups-$(version)-source.tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/cups-$(version)
src_dir_name       = cups-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

cups_blacklist_dir = $(CURDIR)/blacklist
cups_logrotate     = $(CURDIR)/logrotate/cups.logrotate
cups_pam           = $(CURDIR)/pam.d/cups.pam


PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
CUPS_PKG_NAME                = cups
CUPS_PKG_VERSION             = 2.1.3
CUPS_PKG_ARCH                = $(TOOLCHAIN)
CUPS_PKG_DISTRO_NAME         = $(DISTRO_NAME)
CUPS_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
CUPS_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
CUPS_PKG_SHORT_DESCRIPTION   = Common UNIX Printing System
CUPS_PKG_URL                 = $(BUG_URL)
CUPS_PKG_LICENSE             = CUPS
CUPS_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(CUPS_PKG_NAME)-pkg-description
CUPS_PKG_DESCRIPTION_FILE_IN = $(CUPS_PKG_NAME)-pkg-description.in
CUPS_PKG_INSTALL_SCRIPT      = $(CUPS_PKG_NAME)-pkg-install.sh

CUPS_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(CUPS_PKG_NAME)-package

pkg_basename     = $(CUPS_PKG_NAME)-$(CUPS_PKG_VERSION)-$(CUPS_PKG_ARCH)-$(CUPS_PKG_DISTRO_NAME)-$(CUPS_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = BUILDROOT=$(CUPS_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
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
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(CUPS_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@( cd $(CUPS_PKG)/usr/lib$(LIBSUFFIX) ; chmod 0644 *.a )
	# ======= Install usblp blacklist =======
	@mkdir -p $(CUPS_PKG)/lib/modprobe.d
	@cp -a $(cups_blacklist_dir)/cups-blacklist-usblp.conf \
	       $(CUPS_PKG)/lib/modprobe.d/cups-blacklist-usblp.conf
	@chmod 644 $(CUPS_PKG)/lib/modprobe.d/cups-blacklist-usblp.conf
	# ======= Remove big test files =======
	@rm -f $(CUPS_PKG)/usr/share/cups/ipptool/*.{pdf,ps,jpg}
	# ======= Set up system-init script and config files =======
	@mkdir -p $(CUPS_PKG)/etc/rc.d
	@mv $(CUPS_PKG)/etc/init.d/cups $(CUPS_PKG)/etc/rc.d/rc.cups.new
	@chmod 0644 $(CUPS_PKG)/etc/rc.d/rc.cups.new
	@rm -rf $(CUPS_PKG)/etc/init.d $(CUPS_PKG)/etc/rc{0,2,3,5}.d
	@mv $(CUPS_PKG)/etc/dbus-1/system.d/cups.conf $(CUPS_PKG)/etc/dbus-1/system.d/cups.conf.new
	@( cd $(CUPS_PKG)/etc/cups ; \
	   mv cups-files.conf         cups-files.conf.new         ; \
	   mv cups-files.conf.default cups-files.conf.default.new ; \
	   mv cupsd.conf              cupsd.conf.new              ; \
	   mv cupsd.conf.default      cupsd.conf.default.new      ; \
	   mv snmp.conf               snmp.conf.new               ; \
	   mv snmp.conf.default       snmp.conf.default.new       ; \
	 )
	@mkdir -p $(CUPS_PKG)/etc/pam.d
	@cp -a $(cups_pam) $(CUPS_PKG)/etc/pam.d/cups
	@chmod 0644 $(CUPS_PKG)/etc/pam.d/cups
	@mkdir -p $(CUPS_PKG)/etc/logrotate.d
	@cp -a $(cups_logrotate) $(CUPS_PKG)/etc/logrotate.d/cups
	@chmod 0644 $(CUPS_PKG)/etc/logrotate.d/cups
	# ======= Install Documentation =======
	@mkdir -p $(CUPS_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/CREDITS.txt $(SRC_DIR)/LICENSE.txt \
	       $(CUPS_PKG)/usr/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a CHANGES-IPPTOOL.txt CREDITS.txt INSTALL.txt IPPTOOL.txt LICENSE.txt README.txt \
	         $(CUPS_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r CHANGES.txt ]; then \
	     DOCSDIR=`echo $(CUPS_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat CHANGES.txt | head -n 1000 > $$DOCSDIR/CHANGES.txt ; \
	     touch -r CHANGES.txt $$DOCSDIR/CHANGES.txt ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(CUPS_PKG))
	# ======= Give write permissions to owner =======
	@( cd $(CUPS_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs chmod u+w 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs chmod u+w 2> /dev/null ; \
	 )
	# ======= Strip Binaries =======
	@( cd $(CUPS_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(CUPS_PKG_DESCRIPTION_FILE): $(CUPS_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(CUPS_PKG_DESCRIPTION_FILE) $(CUPS_PKG_INSTALL_SCRIPT)
	@cp $(CUPS_PKG_DESCRIPTION_FILE) $(CUPS_PKG)/.DESCRIPTION
	@cp $(CUPS_PKG_INSTALL_SCRIPT) $(CUPS_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(CUPS_PKG)/.REQUIRES
	@echo "pkgname=$(CUPS_PKG_NAME)"                            >  $(CUPS_PKG)/.PKGINFO ; \
	 echo "pkgver=$(CUPS_PKG_VERSION)"                          >> $(CUPS_PKG)/.PKGINFO ; \
	 echo "arch=$(CUPS_PKG_ARCH)"                               >> $(CUPS_PKG)/.PKGINFO ; \
	 echo "distroname=$(CUPS_PKG_DISTRO_NAME)"                  >> $(CUPS_PKG)/.PKGINFO ; \
	 echo "distrover=$(CUPS_PKG_DISTRO_VERSION)"                >> $(CUPS_PKG)/.PKGINFO ; \
	 echo "group=$(CUPS_PKG_GROUP)"                             >> $(CUPS_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(CUPS_PKG_SHORT_DESCRIPTION)\"" >> $(CUPS_PKG)/.PKGINFO ; \
	 echo "url=$(CUPS_PKG_URL)"                                 >> $(CUPS_PKG)/.PKGINFO ; \
	 echo "license=$(CUPS_PKG_LICENSE)"                         >> $(CUPS_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(CUPS_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
