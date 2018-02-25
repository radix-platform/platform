
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


SOURCE_REQUIRES    = sources/packages/a/cups-filters

ifeq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC)),)
REQUIRES           = app/cups/2.1.3
else
REQUIRES           = app/cups/2.1.3-x86_32
endif
REQUIRES          += app/ghostscript-fonts-std/8.11
REQUIRES          += X11/font/dejavu-fonts-ttf/2.35
REQUIRES          += libs/poppler/0.45.0
REQUIRES          += app/qpdf/6.0.0

# ======= __END_OF_REQUIRES__ =======


version            = 1.0.76
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/a/cups-filters/cups-filters-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/cups-filters-$(version)
src_dir_name       = cups-filters-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done


PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
CUPS_FLTS_PKG_NAME                = cups-filters
CUPS_FLTS_PKG_VERSION             = 1.0.76
CUPS_FLTS_PKG_ARCH                = $(TOOLCHAIN)
CUPS_FLTS_PKG_DISTRO_NAME         = $(DISTRO_NAME)
CUPS_FLTS_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
CUPS_FLTS_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
CUPS_FLTS_PKG_SHORT_DESCRIPTION   = OpenPrinting CUPS Filters
CUPS_FLTS_PKG_URL                 = $(BUG_URL)
CUPS_FLTS_PKG_LICENSE             = CUPS
CUPS_FLTS_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(CUPS_FLTS_PKG_NAME)-pkg-description
CUPS_FLTS_PKG_DESCRIPTION_FILE_IN = $(CUPS_FLTS_PKG_NAME)-pkg-description.in
CUPS_FLTS_PKG_INSTALL_SCRIPT      = $(CUPS_FLTS_PKG_NAME)-pkg-install.sh

CUPS_FLTS_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(CUPS_FLTS_PKG_NAME)-package

pkg_basename     = $(CUPS_FLTS_PKG_NAME)-$(CUPS_FLTS_PKG_VERSION)-$(CUPS_FLTS_PKG_ARCH)-$(CUPS_FLTS_PKG_DISTRO_NAME)-$(CUPS_FLTS_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(CUPS_FLTS_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --with-rcdir=/etc

extra_configure_switches += --enable-avahi
extra_configure_switches += --with-browseremoteprotocols=DNSSD,CUPS
extra_configure_switches += --with-test-font-path=/usr/share/fonts/TTF/DejaVuSans.ttf

cups_environment  = CUPSCONFIG=$(TARGET_DEST_DIR)/usr/bin/cups-config


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)
TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && \
	  $(BUILD_ENVIRONMENT) $(cups_environment) ./configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(CUPS_FLTS_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@( cd $(CUPS_FLTS_PKG)/usr/bin ; \
	   rm -f foomatic-rip ; \
	   ln -sf ../lib$(LIBSUFFIX)/cups/filter/foomatic-rip foomatic-rip ; \
	 )
	@mv $(CUPS_FLTS_PKG)/etc/cups/cups-browsed.conf $(CUPS_FLTS_PKG)/etc/cups/cups-browsed.conf.new
	# ======= Set up fontconfig files =======
	@mkdir -p $(CUPS_FLTS_PKG)/etc/fonts/conf.avai
	@( cd $(CUPS_FLTS_PKG)/etc/fonts/conf.d ; \
	   mv 99pdftoopvp.conf ../conf.avai/99-pdftoopvp.conf ; \
	   ln -sf ../conf.avai/99-pdftoopvp.conf 99-pdftoopvp.conf ; \
	 )
	# ======= Set up system-init script and config files =======
	@mkdir -p $(CUPS_FLTS_PKG)/etc/rc.d
	@mv $(CUPS_FLTS_PKG)/etc/init.d/cups-browsed $(CUPS_FLTS_PKG)/etc/rc.d/rc.cups-browsed.new
	@chmod 0644 $(CUPS_FLTS_PKG)/etc/rc.d/rc.cups-browsed.new
	@rm -rf $(CUPS_FLTS_PKG)/etc/init.d $(CUPS_FLTS_PKG)/etc/rc{0,2,3,5}.d
	# ======= Install Documentation =======
	@if [ -d $(CUPS_FLTS_PKG)/usr/share/man ]; then \
	  ( cd $(CUPS_FLTS_PKG)/usr/share/man ; \
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
	@mkdir -p $(CUPS_FLTS_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(CUPS_FLTS_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(CUPS_FLTS_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING INSTALL NEWS README \
	         $(CUPS_FLTS_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog -a -s ChangeLog ]; then \
	     DOCSDIR=`echo $(CUPS_FLTS_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(CUPS_FLTS_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libcupsfilters.la libfontembed.la ; \
	 )
	# ======= remove toolchain path from target pkg-config *.pc files =======
	@( cd $(CUPS_FLTS_PKG)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libcupsfilters.pc libfontembed.pc ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(CUPS_FLTS_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libcupsfilters.la libfontembed.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libcupsfilters.la libfontembed.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libcupsfilters.pc libfontembed.pc ; \
	 )
	# ======= Strip Binaries =======
	@( cd $(CUPS_FLTS_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(CUPS_FLTS_PKG)/usr ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(CUPS_FLTS_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(CUPS_FLTS_PKG_DESCRIPTION_FILE): $(CUPS_FLTS_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(CUPS_FLTS_PKG_DESCRIPTION_FILE) $(CUPS_FLTS_PKG_INSTALL_SCRIPT)
	@cp $(CUPS_FLTS_PKG_DESCRIPTION_FILE) $(CUPS_FLTS_PKG)/.DESCRIPTION
	@cp $(CUPS_FLTS_PKG_INSTALL_SCRIPT) $(CUPS_FLTS_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(CUPS_FLTS_PKG)/.REQUIRES
	@echo "pkgname=$(CUPS_FLTS_PKG_NAME)"                            >  $(CUPS_FLTS_PKG)/.PKGINFO ; \
	 echo "pkgver=$(CUPS_FLTS_PKG_VERSION)"                          >> $(CUPS_FLTS_PKG)/.PKGINFO ; \
	 echo "arch=$(CUPS_FLTS_PKG_ARCH)"                               >> $(CUPS_FLTS_PKG)/.PKGINFO ; \
	 echo "distroname=$(CUPS_FLTS_PKG_DISTRO_NAME)"                  >> $(CUPS_FLTS_PKG)/.PKGINFO ; \
	 echo "distrover=$(CUPS_FLTS_PKG_DISTRO_VERSION)"                >> $(CUPS_FLTS_PKG)/.PKGINFO ; \
	 echo "group=$(CUPS_FLTS_PKG_GROUP)"                             >> $(CUPS_FLTS_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(CUPS_FLTS_PKG_SHORT_DESCRIPTION)\"" >> $(CUPS_FLTS_PKG)/.PKGINFO ; \
	 echo "url=$(CUPS_FLTS_PKG_URL)"                                 >> $(CUPS_FLTS_PKG)/.PKGINFO ; \
	 echo "license=$(CUPS_FLTS_PKG_LICENSE)"                         >> $(CUPS_FLTS_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(CUPS_FLTS_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
