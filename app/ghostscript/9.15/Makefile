
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXV)
COMPONENT_TARGETS += $(HARDWARE_P201)
COMPONENT_TARGETS += $(HARDWARE_NEXBOX_A95X)
COMPONENT_TARGETS += $(HARDWARE_P212)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_VIM)
COMPONENT_TARGETS += $(HARDWARE_Q201)
COMPONENT_TARGETS += $(HARDWARE_ENYBOX_X2)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/ghostscript

REQUIRES           = app/cups/2.1.3
REQUIRES          += libs/lcms2/2.7
REQUIRES          += X11/libs/fontconfig/2.11.95
REQUIRES          += X11/X.org/lib/libXext/1.3.3
REQUIRES          += X11/X.org/lib/libXt/1.1.5

# ======= __END_OF_REQUIRES__ =======


version            = 9.15
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/a/ghostscript/ghostscript-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/ghostscript-$(version)
src_dir_name       = ghostscript-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

cidfmap_new        = $(CURDIR)/cidfmap/cidfmap.new

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
GS_PKG_NAME                = ghostscript
GS_PKG_VERSION             = 9.15
GS_PKG_ARCH                = $(TOOLCHAIN)
GS_PKG_DISTRO_NAME         = $(DISTRO_NAME)
GS_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
GS_PKG_GROUP               = $(PKG_GROUP)
###                         |---handy-ruler-------------------------------|
GS_PKG_SHORT_DESCRIPTION   = Postscript and PDF interpreter
GS_PKG_URL                 = $(BUG_URL)
GS_PKG_LICENSE             = AGPLv3
GS_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GS_PKG_NAME)-pkg-description
GS_PKG_DESCRIPTION_FILE_IN = $(GS_PKG_NAME)-pkg-description.in
GS_PKG_INSTALL_SCRIPT      = $(TARGET_BUILD_DIR)/$(GS_PKG_NAME)-pkg-install.sh
GS_PKG_INSTALL_SCRIPT_IN   = $(GS_PKG_NAME)-pkg-install.sh.in

GS_PKG           = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GS_PKG_NAME)-package

pkg_basename     = $(GS_PKG_NAME)-$(GS_PKG_VERSION)-$(GS_PKG_ARCH)-$(GS_PKG_DISTRO_NAME)-$(GS_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(GS_PKG)
env_sysroot += cups_serverroot=$(GS_PKG)/etc/cups
env_sysroot += cups_serverbin=$(GS_PKG)/usr/lib$(LIBSUFFIX)/cups


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man

extra_configure_switches += --sysconfdir=/etc

extra_configure_switches += --with-fontpath=/usr/share/fonts/Type1:/usr/share/fonts/TTF:/usr/share/fonts

extra_configure_switches += --enable-dynamic
extra_configure_switches += --with-ijs
extra_configure_switches += --enable-cups
extra_configure_switches += --with-cups-serverbin=/usr/lib$(LIBSUFFIX)/cups
extra_configure_switches += --with-cups-serverroot=/etc/cups
extra_configure_switches += --with-cups-datadir=/usr/share/cups

extra_configure_switches += --enable-freetype
extra_configure_switches += --enable-fontconfig
extra_configure_switches += --enable-openjpeg
extra_configure_switches += --with-jbig2dec
extra_configure_switches += --without-luratech
extra_configure_switches += --without-omni

extra_configure_switches += --with-x
extra_configure_switches += --with-drivers=ALL
extra_configure_switches += --with-system-libtiff

extra_configure_switches += --disable-gtk

extra_configure_switches += --disable-compile-inits
extra_configure_switches += --program-prefix=
extra_configure_switches += --program-suffix=

#
# We assume that all our targets are LITTLE Endian
#
extra_configure_switches += --enable-little-endian


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@( cd $(SRC_DIR) ; \
	   rm -rf jpeg libpng tiff zlib expat freetype cups/libs ; \
	   autoconf --force ; \
	 )
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC64)),)
	@( cd $(build_dir) ; \
	   PKG_CONFIG_PATH=/usr/lib$(BUILD_MULTILIB_SUFFIX)/pkgconfig \
	   CC="$(CCACHE)gcc" ../$(src_dir_name)/configure --prefix=/usr $(extra_configure_switches) ; \
	   make clean ; \
	   make obj/arch.h obj/aux/genarch obj/aux/genconf obj/aux/echogs ; \
	   make CC="$(CCACHE)gcc" CCLD="$(CCACHE)gcc" ; \
	   make CC="$(CCACHE)gcc" CCLD="$(CCACHE)gcc" so ; \
	 )
else
	@( cd $(build_dir) ; \
	   PKG_CONFIG_PATH=/usr/lib$(BUILD_MULTILIB_SUFFIX)/pkgconfig \
	   CC="$(CCACHE)gcc -m32" ../$(src_dir_name)/configure --prefix=/usr $(extra_configure_switches) ; \
	   make clean ; \
	   CC="gcc -m32" make obj/arch.h obj/aux/genarch obj/aux/genconf obj/aux/echogs ; \
	   make CC="$(CCACHE)gcc -m32" CCLD="$(CCACHE)gcc -m32" ; \
	   make CC="$(CCACHE)gcc -m32" CCLD="$(CCACHE)gcc -m32" so ; \
	 )
endif
	@( cd $(SRC_DIR) ; \
	   rm -rf lcms lcms2 ; \
	 )
	@cd $(SRC_DIR) && \
	  $(BUILD_ENVIRONMENT) CUPSCONFIG=$(TARGET_DEST_DIR)/usr/bin/cups-config ./configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cp -a $(build_dir)/obj $(SRC_DIR)
	@( cd $(SRC_DIR)/obj ; \
	   rm -f *.o *.so *.dev ldt.tr ; \
	 )
	@cp -a $(build_dir)/soobj $(SRC_DIR)
	@( cd $(SRC_DIR)/soobj ; \
	   rm -f *.o *.so *.dev ldt.tr ; \
	 )
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) so
	@( cd $(SRC_DIR)/ijs ; \
	   sed -i "s:AM_PROG_CC_STDC:AC_PROG_CC:g" configure.ac ; \
	   ./autogen.sh ; \
	   $(BUILD_ENVIRONMENT) ./configure \
	     --prefix=/usr    \
	     --build=$(BUILD) \
	     --host=$(TARGET) \
	     --libdir=/usr/lib$(LIBSUFFIX)       \
	     --program-prefix= --program-suffix= \
	     --enable-shared --enable-static   ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot) ; \
	 )
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(GS_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install install-so $(env_sysroot)
	@( cd $(GS_PKG)/usr/share/ghostscript/$(version)/Resource/Init ; \
	   if [ -r cidfmap ] ; then \
	     mv cidfmap cidfmap.default.ghostscript-$(version) ; \
	     cat $(cidfmap_new) > cidfmap.new ; \
	   fi ; \
	 )
	# ======= Install Documentation =======
	@if [ -d $(GS_PKG)/usr/share/man ]; then \
	  ( cd $(GS_PKG)/usr/share/man ; \
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
	@mkdir -p $(GS_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/doc/AUTHORS $(SRC_DIR)/doc/COPYING $(SRC_DIR)/LICENSE \
	       $(GS_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(GS_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a doc/AUTHORS doc/COPYING DroidSansFallback.NOTICE LICENSE \
	         $(GS_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(GS_PKG)/usr/share/doc/$(src_dir_name) ; \
	   ln -sf ../../ghostscript/$(version)/doc html ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(GS_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(GS_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libijs.la  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(GS_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libijs.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libijs.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" ijs.pc \
	 )
	# ======= tune ijs-config search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/bin ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" ijs-config \
	 )
	# ======= Strip Binaries =======
	@( cd $(GS_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(GS_PKG_DESCRIPTION_FILE): $(GS_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(GS_PKG_INSTALL_SCRIPT): $(GS_PKG_INSTALL_SCRIPT_IN)
	@cat $< | $(SED) -e "s,@VERSION@,$(version),g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(GS_PKG_DESCRIPTION_FILE) $(GS_PKG_INSTALL_SCRIPT)
	@cp $(GS_PKG_DESCRIPTION_FILE) $(GS_PKG)/.DESCRIPTION
	@cp $(GS_PKG_INSTALL_SCRIPT) $(GS_PKG)/.INSTALL
	@chmod a+x $(GS_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GS_PKG)/.REQUIRES
	@echo "pkgname=$(GS_PKG_NAME)"                            >  $(GS_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GS_PKG_VERSION)"                          >> $(GS_PKG)/.PKGINFO ; \
	 echo "arch=$(GS_PKG_ARCH)"                               >> $(GS_PKG)/.PKGINFO ; \
	 echo "distroname=$(GS_PKG_DISTRO_NAME)"                  >> $(GS_PKG)/.PKGINFO ; \
	 echo "distrover=$(GS_PKG_DISTRO_VERSION)"                >> $(GS_PKG)/.PKGINFO ; \
	 echo "group=$(GS_PKG_GROUP)"                             >> $(GS_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GS_PKG_SHORT_DESCRIPTION)\"" >> $(GS_PKG)/.PKGINFO ; \
	 echo "url=$(GS_PKG_URL)"                                 >> $(GS_PKG)/.PKGINFO ; \
	 echo "license=$(GS_PKG_LICENSE)"                         >> $(GS_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(GS_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
