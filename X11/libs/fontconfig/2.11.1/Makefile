
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


include ../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/x/fontconfig

REQUIRES           = libs/expat/2.1.1
REQUIRES          += env/freetype/2.5.3

# ======= __END_OF_REQUIRES__ =======


version            = 2.11.1
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/x/fontconfig/fontconfig-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/fontconfig-$(version)
src_dir_name       = fontconfig-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = xlibs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
FONTCFG_PKG_NAME                = fontconfig
FONTCFG_PKG_VERSION             = 2.11.1
FONTCFG_PKG_ARCH                = $(TOOLCHAIN)
FONTCFG_PKG_DISTRO_NAME         = $(DISTRO_NAME)
FONTCFG_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
FONTCFG_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
FONTCFG_PKG_SHORT_DESCRIPTION   = Font library and tools
FONTCFG_PKG_URL                 = $(BUG_URL)
FONTCFG_PKG_LICENSE             = custom
FONTCFG_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(FONTCFG_PKG_NAME)-pkg-description
FONTCFG_PKG_DESCRIPTION_FILE_IN = $(FONTCFG_PKG_NAME)-pkg-description.in
FONTCFG_PKG_INSTALL_SCRIPT      = $(FONTCFG_PKG_NAME)-pkg-install.sh

FONTCFG_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(FONTCFG_PKG_NAME)-package

pkg_basename     = $(FONTCFG_PKG_NAME)-$(FONTCFG_PKG_VERSION)-$(FONTCFG_PKG_ARCH)-$(FONTCFG_PKG_DISTRO_NAME)-$(FONTCFG_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(FONTCFG_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --with-templatedir=/etc/fonts/conf.avai
extra_configure_switches += --with-baseconfigdir=/etc/fonts
extra_configure_switches += --with-configdir=/etc/fonts/conf.d
extra_configure_switches += --with-xmldir=/etc/fonts
extra_configure_switches += --localstatedir=/var

extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)
TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	# ======= trick the Makefile.am developers =======
	@( cd $(build_dir)/doc ; \
	   gcc -c -o edit-sgml.o $(CURDIR)/$(SRC_DIR)/doc/edit-sgml.c ; \
	   gcc -o edit-sgml edit-sgml.o ; \
	 )
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(FONTCFG_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Relinking etc/fonts/conf.d/*.conf =======
	@( cd $(FONTCFG_PKG)/etc/fonts/conf.d ; \
	   for file in `find . -type l` ; do \
	     file=`basename $$file` ; rm -f $$file ; ln -sf ../conf.avai/$$file $$file ; \
	   done \
	 )
	# ======= Install Documentation =======
	@if [ -d $(FONTCFG_PKG)/usr/share/man ]; then \
	  ( cd $(FONTCFG_PKG)/usr/share/man ; \
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
	@mkdir -p $(FONTCFG_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING* \
	       $(FONTCFG_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(FONTCFG_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING INSTALL README \
	         $(FONTCFG_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(FONTCFG_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(FONTCFG_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libfontconfig.la  \
	 )
	@( cd $(FONTCFG_PKG)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" fontconfig.pc  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(FONTCFG_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libfontconfig.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libfontconfig.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" fontconfig.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(FONTCFG_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(FONTCFG_PKG)/usr/bin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(FONTCFG_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(FONTCFG_PKG_DESCRIPTION_FILE): $(FONTCFG_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(FONTCFG_PKG_DESCRIPTION_FILE) $(FONTCFG_PKG_INSTALL_SCRIPT)
	@cp $(FONTCFG_PKG_DESCRIPTION_FILE) $(FONTCFG_PKG)/.DESCRIPTION
	@cp $(FONTCFG_PKG_INSTALL_SCRIPT) $(FONTCFG_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(FONTCFG_PKG)/.REQUIRES
	@echo "pkgname=$(FONTCFG_PKG_NAME)"                            >  $(FONTCFG_PKG)/.PKGINFO ; \
	 echo "pkgver=$(FONTCFG_PKG_VERSION)"                          >> $(FONTCFG_PKG)/.PKGINFO ; \
	 echo "arch=$(FONTCFG_PKG_ARCH)"                               >> $(FONTCFG_PKG)/.PKGINFO ; \
	 echo "distroname=$(FONTCFG_PKG_DISTRO_NAME)"                  >> $(FONTCFG_PKG)/.PKGINFO ; \
	 echo "distrover=$(FONTCFG_PKG_DISTRO_VERSION)"                >> $(FONTCFG_PKG)/.PKGINFO ; \
	 echo "group=$(FONTCFG_PKG_GROUP)"                             >> $(FONTCFG_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(FONTCFG_PKG_SHORT_DESCRIPTION)\"" >> $(FONTCFG_PKG)/.PKGINFO ; \
	 echo "url=$(FONTCFG_PKG_URL)"                                 >> $(FONTCFG_PKG)/.PKGINFO ; \
	 echo "license=$(FONTCFG_PKG_LICENSE)"                         >> $(FONTCFG_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(FONTCFG_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
