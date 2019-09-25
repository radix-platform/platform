
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


SOURCE_REQUIRES    = sources/packages/n/dhcpcd

REQUIRES           = libs/eudev/1.9

# ======= __END_OF_REQUIRES__ =======


version            = 6.4.2
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/n/dhcpcd/dhcpcd-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/dhcpcd-$(version)
src_dir_name       = dhcpcd-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done

license            = $(CURDIR)/license/COPYRIGHT

####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
DHCPCD_PKG_NAME                = dhcpcd
DHCPCD_PKG_VERSION             = 6.4.2
DHCPCD_PKG_ARCH                = $(TOOLCHAIN)
DHCPCD_PKG_DISTRO_NAME         = $(DISTRO_NAME)
DHCPCD_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
DHCPCD_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
DHCPCD_PKG_SHORT_DESCRIPTION   = DHCP client daemon
DHCPCD_PKG_URL                 = $(BUG_URL)
DHCPCD_PKG_LICENSE             = BSD
DHCPCD_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(DHCPCD_PKG_NAME)-pkg-description
DHCPCD_PKG_DESCRIPTION_FILE_IN = $(DHCPCD_PKG_NAME)-pkg-description.in
DHCPCD_PKG_INSTALL_SCRIPT      = $(DHCPCD_PKG_NAME)-pkg-install.sh

DHCPCD_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(DHCPCD_PKG_NAME)-package

pkg_basename     = $(DHCPCD_PKG_NAME)-$(DHCPCD_PKG_VERSION)-$(DHCPCD_PKG_ARCH)-$(DHCPCD_PKG_DISTRO_NAME)-$(DHCPCD_PKG_DISTRO_VERSION)

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


env_sysroot  = DESTDIR=$(DHCPCD_PKG) HOOKSCRIPTS="50-ntp.conf 50-yp.conf"


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --sbindir=/sbin
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --dbdir=/var/lib/dhcpcd
extra_configure_switches += --libexecdir=/lib/dhcpcd
extra_configure_switches += --mandir=/usr/share/man

CFLAGS += -D_DEFAULT_SOURCE
####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) ./configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	exit 1
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(DHCPCD_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Set permissions for dhcpcd daemon =======
	@chmod 0755 $(DHCPCD_PKG)/sbin/dhcpcd
	@chmod 0755 $(DHCPCD_PKG)/usr/lib$(LIBSUFFIX)/dhcpcd/dev/udev.so
	# ======= Let's not clobber the config file =======
	@mv $(DHCPCD_PKG)/etc/dhcpcd.conf $(DHCPCD_PKG)/etc/dhcpcd.conf.new
	# ======= man pages =======
	@if [ -d $(DHCPCD_PKG)/usr/share/man ]; then \
	  ( cd $(DHCPCD_PKG)/usr/share/man ; \
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
	# ======= Install Documentation =======
	@mkdir -p $(DHCPCD_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(license) \
	       $(DHCPCD_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(DHCPCD_PKG)/usr/share/doc/$(src_dir_name)
	@cp -a $(license) $(SRC_DIR)/README \
	       $(DHCPCD_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(DHCPCD_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(DHCPCD_PKG))
	# ======= Strip binaries =======
	@( cd $(DHCPCD_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(DHCPCD_PKG_DESCRIPTION_FILE): $(DHCPCD_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(DHCPCD_PKG_DESCRIPTION_FILE) $(DHCPCD_PKG_INSTALL_SCRIPT)
	@cp $(DHCPCD_PKG_DESCRIPTION_FILE) $(DHCPCD_PKG)/.DESCRIPTION
	@cp $(DHCPCD_PKG_INSTALL_SCRIPT) $(DHCPCD_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(DHCPCD_PKG)/.REQUIRES
	@echo "pkgname=$(DHCPCD_PKG_NAME)"                            >  $(DHCPCD_PKG)/.PKGINFO ; \
	 echo "pkgver=$(DHCPCD_PKG_VERSION)"                          >> $(DHCPCD_PKG)/.PKGINFO ; \
	 echo "arch=$(DHCPCD_PKG_ARCH)"                               >> $(DHCPCD_PKG)/.PKGINFO ; \
	 echo "distroname=$(DHCPCD_PKG_DISTRO_NAME)"                  >> $(DHCPCD_PKG)/.PKGINFO ; \
	 echo "distrover=$(DHCPCD_PKG_DISTRO_VERSION)"                >> $(DHCPCD_PKG)/.PKGINFO ; \
	 echo "group=$(DHCPCD_PKG_GROUP)"                             >> $(DHCPCD_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(DHCPCD_PKG_SHORT_DESCRIPTION)\"" >> $(DHCPCD_PKG)/.PKGINFO ; \
	 echo "url=$(DHCPCD_PKG_URL)"                                 >> $(DHCPCD_PKG)/.PKGINFO ; \
	 echo "license=$(DHCPCD_PKG_LICENSE)"                         >> $(DHCPCD_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(DHCPCD_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
