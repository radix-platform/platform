
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
COMPONENT_TARGETS += $(HARDWARE_OKMX6DL_C)
COMPONENT_TARGETS += $(HARDWARE_OKMX6Q_C)
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


SOURCE_REQUIRES    = sources/packages/a/lvm2

REQUIRES           = libs/eudev/3.2.8

# ======= __END_OF_REQUIRES__ =======


version            = 2.02.141
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/a/lvm2/LVM2-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/LVM2-$(version)
src_dir_name       = LVM2-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LVM2_PKG_NAME                = lvm2
LVM2_PKG_VERSION             = 2.02.141
LVM2_PKG_ARCH                = $(TOOLCHAIN)
LVM2_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LVM2_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LVM2_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
LVM2_PKG_SHORT_DESCRIPTION   = Logical Volume Manager
LVM2_PKG_URL                 = $(BUG_URL)
LVM2_PKG_LICENSE             = GPLv2
LVM2_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LVM2_PKG_NAME)-pkg-description
LVM2_PKG_DESCRIPTION_FILE_IN = $(LVM2_PKG_NAME)-pkg-description.in
LVM2_PKG_INSTALL_SCRIPT      = $(LVM2_PKG_NAME)-pkg-install.sh

LVM2_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LVM2_PKG_NAME)-package

pkg_basename     = $(LVM2_PKG_NAME)-$(LVM2_PKG_VERSION)-$(LVM2_PKG_ARCH)-$(LVM2_PKG_DISTRO_NAME)-$(LVM2_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(LVM2_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man

extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --disable-readline
extra_configure_switches += --enable-cmdlib
extra_configure_switches += --enable-dmeventd
extra_configure_switches += --enable-applib
extra_configure_switches += --with-usrlibdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --enable-realtime
extra_configure_switches += --with-lvm1=internal
extra_configure_switches += --enable-pkgconfig
extra_configure_switches += --enable-udev_sync
extra_configure_switches += --enable-udev_rules
extra_configure_switches += --with-udev-prefix=""
extra_configure_switches += --with-device-uid=0
extra_configure_switches += --with-device-gid=6
extra_configure_switches += --with-device-mode=0660
extra_configure_switches += --with-default-locking-dir=/run/lock/lvm
extra_configure_switches += --with-default-run-dir=/run/lvm
extra_configure_switches += --with-clvmd-pidfile=/run/lvm/clvmd.pid
extra_configure_switches += --with-cmirrord-pidfile=/run/lvm/cmirrord.pid
extra_configure_switches += --with-dmeventd-pidfile=/run/lvm/dmeventd.pid


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && \
	  $(BUILD_ENVIRONMENT) ./configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LVM2_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@( cd $(LVM2_PKG) ; \
	   for file in `find . -type f -name "*"` ; do \
	     chmod u+w $$file ; \
	   done ; \
	 )
	@mv $(LVM2_PKG)/etc/lvm/lvm.conf      $(LVM2_PKG)/etc/lvm/lvm.conf.new
	@mv $(LVM2_PKG)/etc/lvm/lvmlocal.conf $(LVM2_PKG)/etc/lvm/lvmlocal.conf.new
	@( cd $(LVM2_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in lib*.so.?.* ; do \
	     mv $$file ../../lib$(LIBSUFFIX) ; \
	     ln -sf ../../lib$(LIBSUFFIX)/$$file . ; \
	   done ; \
	 )
	# ======= Install Documentation =======
	@( cd $(LVM2_PKG)/usr/share/man/man8 ; \
	   for file in *.8 ; do                                \
	     ln=`head -n 1 $$file` ;                           \
	     if [ "`echo $$ln | grep '^\.so '`" != "" ] ; then \
	       origin=`echo $$ln | cut -f 2 -d ' '` ;          \
	       origin=`basename $$origin` ;                    \
	       rm -f $$file ;                                  \
	       ln -sf $$origin $$file ;                        \
	     fi ;                                              \
	   done ;                                              \
	 )
	@if [ -d $(LVM2_PKG)/usr/share/man ]; then \
	  ( cd $(LVM2_PKG)/usr/share/man ; \
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
	@mkdir -p $(LVM2_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING* \
	       $(LVM2_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(LVM2_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING* INSTALL README VERSION* WHATS_NEW* \
	         $(LVM2_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LVM2_PKG))
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" devmapper-event.pc devmapper.pc lvm2app.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(LVM2_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(LVM2_PKG_DESCRIPTION_FILE): $(LVM2_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LVM2_PKG_DESCRIPTION_FILE) $(LVM2_PKG_INSTALL_SCRIPT)
	@cp $(LVM2_PKG_DESCRIPTION_FILE) $(LVM2_PKG)/.DESCRIPTION
	@cp $(LVM2_PKG_INSTALL_SCRIPT) $(LVM2_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LVM2_PKG)/.REQUIRES
	@echo "pkgname=$(LVM2_PKG_NAME)"                            >  $(LVM2_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LVM2_PKG_VERSION)"                          >> $(LVM2_PKG)/.PKGINFO ; \
	 echo "arch=$(LVM2_PKG_ARCH)"                               >> $(LVM2_PKG)/.PKGINFO ; \
	 echo "distroname=$(LVM2_PKG_DISTRO_NAME)"                  >> $(LVM2_PKG)/.PKGINFO ; \
	 echo "distrover=$(LVM2_PKG_DISTRO_VERSION)"                >> $(LVM2_PKG)/.PKGINFO ; \
	 echo "group=$(LVM2_PKG_GROUP)"                             >> $(LVM2_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LVM2_PKG_SHORT_DESCRIPTION)\"" >> $(LVM2_PKG)/.PKGINFO ; \
	 echo "url=$(LVM2_PKG_URL)"                                 >> $(LVM2_PKG)/.PKGINFO ; \
	 echo "license=$(LVM2_PKG_LICENSE)"                         >> $(LVM2_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LVM2_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
