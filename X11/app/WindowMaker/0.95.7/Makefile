
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


include ../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/x/WindowMaker

REQUIRES           = app/gettext/0.19.7
REQUIRES          += X11/X.org/lib/libXaw/1.0.13
REQUIRES          += X11/X.org/lib/libXft/2.3.2
REQUIRES          += X11/X.org/lib/libXinerama/1.1.3
REQUIRES          += X11/X.org/lib/libXrandr/1.5.0
REQUIRES          += X11/X.org/lib/libxshmfence/1.2
REQUIRES          += libs/libtiff/4.0.6
REQUIRES          += libs/giflib/5.1.3

# ======= __END_OF_REQUIRES__ =======


version            = 0.95.7
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/x/WindowMaker/WindowMaker-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/WindowMaker-$(version)
src_dir_name       = WindowMaker-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

wmaker_desktop     = $(CURDIR)/desktop/wmaker.desktop
wmaker_xinitrc     = $(CURDIR)/xinit/xinitrc.wmaker

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = xapp

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
WMAKER_PKG_NAME                = WindowMaker
WMAKER_PKG_VERSION             = 0.95.7
WMAKER_PKG_ARCH                = $(TOOLCHAIN)
WMAKER_PKG_DISTRO_NAME         = $(DISTRO_NAME)
WMAKER_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
WMAKER_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
WMAKER_PKG_SHORT_DESCRIPTION   = an X11 window manager
WMAKER_PKG_URL                 = $(BUG_URL)
WMAKER_PKG_LICENSE             = GPLv2
WMAKER_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(WMAKER_PKG_NAME)-pkg-description
WMAKER_PKG_DESCRIPTION_FILE_IN = $(WMAKER_PKG_NAME)-pkg-description.in
WMAKER_PKG_INSTALL_SCRIPT      = $(WMAKER_PKG_NAME)-pkg-install.sh

WMAKER_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(WMAKER_PKG_NAME)-package

pkg_basename     = $(WMAKER_PKG_NAME)-$(WMAKER_PKG_VERSION)-$(WMAKER_PKG_ARCH)-$(WMAKER_PKG_DISTRO_NAME)-$(WMAKER_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(WMAKER_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc/X11
extra_configure_switches += --localstatedir=/var

extra_configure_switches += --enable-modelock
extra_configure_switches += --enable-usermenu
extra_configure_switches += --enable-xinerama

extra_configure_switches += --disable-webp
extra_configure_switches += --disable-magick

extra_configure_switches += --with-pixmapdir=/usr/share/pixmaps
extra_configure_switches += --with-gnustepdir=/usr/lib/GNUstep
extra_configure_switches += --localedir=/usr/share/locale


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)
TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@( cd $(SRC_DIR) ; \
	   autoreconf -fi ; \
	   for file in WindowMaker/*menu* ; do \
	     if [ -r $$file ] ; then \
	       sed -i -e "s:/usr/local/GNUstep/Applications/WPrefs.app:/usr/lib/GNUstep/Applications/WPrefs.app:g" $$file ; \
	       sed -i -e "s:/usr/local/share/WindowMaker:/usr/share/WindowMaker:g" $$file ; \
	       sed -i -e "s:/opt/share/WindowMaker:/usr/share/WindowMaker:g" $$file ; \
	       sed -i -e "s:/usr/local/Acrobat3:/opt/Adobe/Reader9:g" $$file ; \
	     fi ; \
	   done ; \
	 )
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(WMAKER_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(environment) $(MAKE) -j1 install $(env_sysroot)
	@mkdir -p $(WMAKER_PKG)/usr/share/applications
	@cp -a $(wmaker_desktop) $(WMAKER_PKG)/usr/share/applications
	@( cd $(WMAKER_PKG)/usr/bin ; \
	   ln -sf ../lib$(LIBSUFFIX)/GNUstep/Applications/WPrefs.app/WPrefs . ; \
	 )
	@mkdir -p $(WMAKER_PKG)/etc/X11/xinit
	@cp -a $(wmaker_xinitrc) $(WMAKER_PKG)/etc/X11/xinit/xinitrc.wmaker
	@chmod 0755 $(WMAKER_PKG)/etc/X11/xinit/xinitrc.wmaker
	# ======= Install Documentation =======
	@( cd $(WMAKER_PKG)/usr/share/man/man1 ; \
	   rm -f WindowMaker.1 ; \
	   ln -sf wmaker.1 WindowMaker.1 ; \
	 )
	@if [ -d $(WMAKER_PKG)/usr/share/man ]; then \
	  ( cd $(WMAKER_PKG)/usr/share/man ; \
	    for manpagedir in `find . -type d -name "man*"` ; do \
	      ( cd $$manpagedir ; \
	        for eachpage in `find . -type l -maxdepth 1` ; do \
	          ln -s `readlink $$eachpage`.gz $$eachpage.gz ; \
	          rm $$eachpage ; \
	        done ; \
	        if [ ! -z "`find . -type f -name "*.?"`" ] ; then gzip -9 *.? ; fi ; \
	        if [ ! -z "`find . -type f -name "*.?x"`" ] ; then gzip -9 *.?x ; fi ; \
	      ) \
	    done \
	  ) \
	 fi
	@mkdir -p $(WMAKER_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING* \
	       $(WMAKER_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(WMAKER_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS BUGFORM BUGS COPYING* FAQ* INSTALL* NEWS README* TODO \
	         $(WMAKER_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(WMAKER_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(WMAKER_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libWINGs.la     \
	                                    libWMaker.la    \
	                                    libWUtil.la     \
	                                    libwraster.la ; \
	 )
	@( cd $(WMAKER_PKG)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" WINGs.pc ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(WMAKER_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libWINGs.la     \
	                                            libWMaker.la    \
	                                            libWUtil.la     \
	                                            libwraster.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libWINGs.la     \
	                                              libWMaker.la    \
	                                              libWUtil.la     \
	                                              libwraster.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" WINGs.pc WUtil.pc wrlib.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(WMAKER_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null ; \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(WMAKER_PKG)/usr/bin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	@( cd $(WMAKER_PKG)//usr/lib$(LIBSUFFIX)/GNUstep ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(WMAKER_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(WMAKER_PKG_DESCRIPTION_FILE): $(WMAKER_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(WMAKER_PKG_DESCRIPTION_FILE) $(WMAKER_PKG_INSTALL_SCRIPT)
	@cp $(WMAKER_PKG_DESCRIPTION_FILE) $(WMAKER_PKG)/.DESCRIPTION
	@cp $(WMAKER_PKG_INSTALL_SCRIPT) $(WMAKER_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(WMAKER_PKG)/.REQUIRES
	@echo "pkgname=$(WMAKER_PKG_NAME)"                            >  $(WMAKER_PKG)/.PKGINFO ; \
	 echo "pkgver=$(WMAKER_PKG_VERSION)"                          >> $(WMAKER_PKG)/.PKGINFO ; \
	 echo "arch=$(WMAKER_PKG_ARCH)"                               >> $(WMAKER_PKG)/.PKGINFO ; \
	 echo "distroname=$(WMAKER_PKG_DISTRO_NAME)"                  >> $(WMAKER_PKG)/.PKGINFO ; \
	 echo "distrover=$(WMAKER_PKG_DISTRO_VERSION)"                >> $(WMAKER_PKG)/.PKGINFO ; \
	 echo "group=$(WMAKER_PKG_GROUP)"                             >> $(WMAKER_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(WMAKER_PKG_SHORT_DESCRIPTION)\"" >> $(WMAKER_PKG)/.PKGINFO ; \
	 echo "url=$(WMAKER_PKG_URL)"                                 >> $(WMAKER_PKG)/.PKGINFO ; \
	 echo "license=$(WMAKER_PKG_LICENSE)"                         >> $(WMAKER_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(WMAKER_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
