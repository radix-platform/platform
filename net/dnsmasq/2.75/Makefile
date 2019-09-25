
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


SOURCE_REQUIRES    = sources/packages/n/dnsmasq

REQUIRES           = app/dbus/1.11.2
REQUIRES          += libs/libidn/1.28
REQUIRES          += net/libnetfilter_conntrack/1.0.5
REQUIRES          += net/nettle/3.2

# ======= __END_OF_REQUIRES__ =======


version            = 2.75
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/n/dnsmasq/dnsmasq-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/dnsmasq-$(version)
src_dir_name       = dnsmasq-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

rc_dnsmasq         = $(CURDIR)/etc/rc.d/rc.dnsmasq

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
DNSMASQ_PKG_NAME                = dnsmasq
DNSMASQ_PKG_VERSION             = 2.75
DNSMASQ_PKG_ARCH                = $(TOOLCHAIN)
DNSMASQ_PKG_DISTRO_NAME         = $(DISTRO_NAME)
DNSMASQ_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
DNSMASQ_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
DNSMASQ_PKG_SHORT_DESCRIPTION   = small DNS and DHCP server
DNSMASQ_PKG_URL                 = $(BUG_URL)
DNSMASQ_PKG_LICENSE             = GPLv3
DNSMASQ_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(DNSMASQ_PKG_NAME)-pkg-description
DNSMASQ_PKG_DESCRIPTION_FILE_IN = $(DNSMASQ_PKG_NAME)-pkg-description.in
DNSMASQ_PKG_INSTALL_SCRIPT      = $(DNSMASQ_PKG_NAME)-pkg-install.sh

DNSMASQ_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(DNSMASQ_PKG_NAME)-package

pkg_basename     = $(DNSMASQ_PKG_NAME)-$(DNSMASQ_PKG_VERSION)-$(DNSMASQ_PKG_ARCH)-$(DNSMASQ_PKG_DISTRO_NAME)-$(DNSMASQ_PKG_DISTRO_VERSION)

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


env_sysroot  = DESTDIR=$(DNSMASQ_PKG)

configure_switches  = PREFIX=/usr
configure_switches += BINDIR=/usr/sbin
configure_switches += MANDIR=/usr/share/man
configure_switches += CFLAGS="-Wall -W $(CFLAGS)"
configure_switches += COPTS="-DHAVE_DNSSEC -DHAVE_DBUS -DHAVE_CONNTRACK -DHAVE_IDN"


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) all-i18n $(configure_switches)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(DNSMASQ_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install-i18n $(configure_switches) $(env_sysroot)
	@mkdir -p $(DNSMASQ_PKG)/etc/dnsmasq.d
	@mkdir -p $(DNSMASQ_PKG)/etc/dbus-1/system.d
	@cat $(SRC_DIR)/dbus/dnsmasq.conf > $(DNSMASQ_PKG)/etc/dbus-1/system.d/dnsmasq.conf
	@chmod 0644 $(DNSMASQ_PKG)/etc/dbus-1/system.d/dnsmasq.conf
	@mkdir -p $(DNSMASQ_PKG)/usr/share/dnsmasq
	@cat $(SRC_DIR)/trust-anchors.conf > $(DNSMASQ_PKG)/usr/share/dnsmasq/trust-anchors.conf
	@chmod 0644 $(DNSMASQ_PKG)/usr/share/dnsmasq/trust-anchors.conf
	@mkdir -p $(DNSMASQ_PKG)/var/state/dnsmasq
	@cat $(SRC_DIR)/dnsmasq.conf.example > $(DNSMASQ_PKG)/etc/dnsmasq.conf.new
	@chmod 0644 $(DNSMASQ_PKG)/etc/dnsmasq.conf.new
	@sed -i 's,%%PREFIX%%,/usr,' $(DNSMASQ_PKG)/etc/dnsmasq.conf.new
	# ======= add newline at end-of-file 'dnsmasq.conf' =======
	@echo "" >> $(DNSMASQ_PKG)/etc/dnsmasq.conf.new
	@mkdir -p $(DNSMASQ_PKG)/etc/rc.d
	@cat $(rc_dnsmasq) > $(DNSMASQ_PKG)/etc/rc.d/rc.dnsmasq.new
	# ======= Install Documentation =======
	@if [ -d $(DNSMASQ_PKG)/usr/share/man ]; then \
	  ( cd $(DNSMASQ_PKG)/usr/share/man ; \
	    for manpagedir in `find . -type d -name "man*"` ; do \
	      ( cd $$manpagedir ; \
	        for eachpage in `find . -type l -maxdepth 1` ; do \
	          ln -s `readlink $$eachpage`.gz $$eachpage.gz ; \
	          rm $$eachpage ; \
	        done ; \
	        gzip -9 *.? ; \
	      ) \
	    done \
	  ) \
	 fi
	@mkdir -p $(DNSMASQ_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING* \
	       $(DNSMASQ_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(DNSMASQ_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING* FAQ doc.html setup.html dbus/DBus-interface \
	         $(DNSMASQ_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r CHANGELOG ]; then \
	     DOCSDIR=`echo $(DNSMASQ_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat CHANGELOG | head -n 1000 > $$DOCSDIR/CHANGELOG ; \
	     touch -r CHANGELOG $$DOCSDIR/CHANGELOG ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(DNSMASQ_PKG))
	# ======= Strip binaries =======
	@( cd $(DNSMASQ_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(DNSMASQ_PKG_DESCRIPTION_FILE): $(DNSMASQ_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(DNSMASQ_PKG_DESCRIPTION_FILE) $(DNSMASQ_PKG_INSTALL_SCRIPT)
	@cp $(DNSMASQ_PKG_DESCRIPTION_FILE) $(DNSMASQ_PKG)/.DESCRIPTION
	@cp $(DNSMASQ_PKG_INSTALL_SCRIPT) $(DNSMASQ_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(DNSMASQ_PKG)/.REQUIRES
	@echo "pkgname=$(DNSMASQ_PKG_NAME)"                            >  $(DNSMASQ_PKG)/.PKGINFO ; \
	 echo "pkgver=$(DNSMASQ_PKG_VERSION)"                          >> $(DNSMASQ_PKG)/.PKGINFO ; \
	 echo "arch=$(DNSMASQ_PKG_ARCH)"                               >> $(DNSMASQ_PKG)/.PKGINFO ; \
	 echo "distroname=$(DNSMASQ_PKG_DISTRO_NAME)"                  >> $(DNSMASQ_PKG)/.PKGINFO ; \
	 echo "distrover=$(DNSMASQ_PKG_DISTRO_VERSION)"                >> $(DNSMASQ_PKG)/.PKGINFO ; \
	 echo "group=$(DNSMASQ_PKG_GROUP)"                             >> $(DNSMASQ_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(DNSMASQ_PKG_SHORT_DESCRIPTION)\"" >> $(DNSMASQ_PKG)/.PKGINFO ; \
	 echo "url=$(DNSMASQ_PKG_URL)"                                 >> $(DNSMASQ_PKG)/.PKGINFO ; \
	 echo "license=$(DNSMASQ_PKG_LICENSE)"                         >> $(DNSMASQ_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(DNSMASQ_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
