
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


SOURCE_REQUIRES    = sources/packages/a/procps-ng

REQUIRES           = libs/ncurses/6.1
REQUIRES           = app/procinfo-ng/2.0.304
REQUIRES           = app/psmisc/23.2

# ======= __END_OF_REQUIRES__ =======


version            = 3.3.15
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/a/procps-ng/procps-ng-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/procps-ng-$(version)
src_dir_name       = procps-ng-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
PROCPS_PKG_NAME                = procps-ng
PROCPS_PKG_VERSION             = 3.3.15
PROCPS_PKG_ARCH                = $(TOOLCHAIN)
PROCPS_PKG_DISTRO_NAME         = $(DISTRO_NAME)
PROCPS_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
PROCPS_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
PROCPS_PKG_SHORT_DESCRIPTION   = utilities for displaying process information
PROCPS_PKG_URL                 = $(BUG_URL)
PROCPS_PKG_LICENSE             = GPLv2
PROCPS_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(PROCPS_PKG_NAME)-pkg-description
PROCPS_PKG_DESCRIPTION_FILE_IN = $(PROCPS_PKG_NAME)-pkg-description.in
PROCPS_PKG_INSTALL_SCRIPT      = $(PROCPS_PKG_NAME)-pkg-install.sh

PROCPS_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(PROCPS_PKG_NAME)-package

pkg_basename     = $(PROCPS_PKG_NAME)-$(PROCPS_PKG_VERSION)-$(PROCPS_PKG_ARCH)-$(PROCPS_PKG_DISTRO_NAME)-$(PROCPS_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(PROCPS_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --datarootdir=/usr/share
extra_configure_switches += --bindir=/bin
extra_configure_switches += --sbindir=/sbin

extra_configure_switches += --disable-silent-rules
extra_configure_switches += --disable-rpath
extra_configure_switches += --enable-watch8bit
extra_configure_switches += --enable-skill
extra_configure_switches += --enable-sigwinch
extra_configure_switches += --enable-w-from
extra_configure_switches += --disable-kill
extra_configure_switches += --without-systemd
extra_configure_switches += --disable-modern-top

ifeq ($(__ENABLE_STATIC__),yes)
extra_configure_switches += --enable-static=yes
else
extra_configure_switches += --enable-static=no
endif
extra_configure_switches += --enable-shared=yes


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
	@mkdir -p $(PROCPS_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Move the shared library to /lib$(LIBSUFFIX): =======
	@mkdir -p $(PROCPS_PKG)/lib$(LIBSUFFIX)
	@( cd $(PROCPS_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in lib*.so.?.* ; do \
	     mv $$file ../../lib$(LIBSUFFIX) ; \
	     ln -sf ../../lib$(LIBSUFFIX)/$$file . ; \
	   done ; \
	   cp -a lib*.so.? ../../lib$(LIBSUFFIX) ; \
	 )
	@mkdir -p $(PROCPS_PKG)/{bin,sbin}
	@mkdir -p $(PROCPS_PKG)/usr/bin
	@mv $(PROCPS_PKG)/bin/pidof $(PROCPS_PKG)/sbin
	@for file in pgrep pkill pmap pwdx skill slabtop snice tload top uptime vmstat w watch ; do \
	  mv $(PROCPS_PKG)/bin/$$file $(PROCPS_PKG)/usr/bin ; \
	 done
	@( cd $(PROCPS_PKG)/bin ; \
	   ln -sf ../sbin/pidof . ; \
	 )
	@( cd $(PROCPS_PKG)/usr/bin ; \
	   ln -sf ../../bin/free . ; \
	   ln -sf ../../sbin/pidof . ; \
	   ln -sf ../../bin/ps . ; \
	 )
	@mkdir -p $(PROCPS_PKG)/etc/sysctl.d
	# ======= Install Documentation =======
	@( cd $(PROCPS_PKG)/usr/share/man/man1 ; \
	   for file in *.1 ; do                                \
	     ln=`head -n 1 $$file` ;                           \
	     if [ "`echo $$ln | grep '^\.so '`" != "" ] ; then \
	       origin=`echo $$ln | cut -f 2 -d ' '` ;          \
	       origin=`basename $$origin` ;                    \
	       rm -f $$file ;                                  \
	       ln -sf $$origin $$file ;                        \
	     fi ;                                              \
	   done ;                                              \
	 )
	@if [ -d $(PROCPS_PKG)/usr/share/man ]; then \
	  ( cd $(PROCPS_PKG)/usr/share/man ; \
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
	@mkdir -p $(PROCPS_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING* \
	       $(PROCPS_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(PROCPS_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING* ChangeLog Documentation/TODO \
	         $(PROCPS_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r NEWS ]; then \
	     DOCSDIR=`echo $(PROCPS_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat NEWS | head -n 1000 > $$DOCSDIR/NEWS ; \
	     touch -r NEWS $$DOCSDIR/NEWS ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(PROCPS_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libprocps.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(PROCPS_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g"   libprocps.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libprocps.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libprocps.pc \
	 )
	# ======= Strip Binaries =======
	@( cd $(PROCPS_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifeq ($(__ENABLE_STATIC__),yes)
	@( cd $(PROCPS_PKG) ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null ; \
	 )
endif
	@touch $@

$(PROCPS_PKG_DESCRIPTION_FILE): $(PROCPS_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(PROCPS_PKG_DESCRIPTION_FILE) $(PROCPS_PKG_INSTALL_SCRIPT)
	@cp $(PROCPS_PKG_DESCRIPTION_FILE) $(PROCPS_PKG)/.DESCRIPTION
	@cp $(PROCPS_PKG_INSTALL_SCRIPT) $(PROCPS_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(PROCPS_PKG)/.REQUIRES
	@echo "pkgname=$(PROCPS_PKG_NAME)"                            >  $(PROCPS_PKG)/.PKGINFO ; \
	 echo "pkgver=$(PROCPS_PKG_VERSION)"                          >> $(PROCPS_PKG)/.PKGINFO ; \
	 echo "arch=$(PROCPS_PKG_ARCH)"                               >> $(PROCPS_PKG)/.PKGINFO ; \
	 echo "distroname=$(PROCPS_PKG_DISTRO_NAME)"                  >> $(PROCPS_PKG)/.PKGINFO ; \
	 echo "distrover=$(PROCPS_PKG_DISTRO_VERSION)"                >> $(PROCPS_PKG)/.PKGINFO ; \
	 echo "group=$(PROCPS_PKG_GROUP)"                             >> $(PROCPS_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(PROCPS_PKG_SHORT_DESCRIPTION)\"" >> $(PROCPS_PKG)/.PKGINFO ; \
	 echo "url=$(PROCPS_PKG_URL)"                                 >> $(PROCPS_PKG)/.PKGINFO ; \
	 echo "license=$(PROCPS_PKG_LICENSE)"                         >> $(PROCPS_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(PROCPS_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
