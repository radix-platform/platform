
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


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/GNU/libiconv

REQUIRES           = app/gettext/0.19.7

# ======= __END_OF_REQUIRES__ =======


version            = 1.14
tar_gz_archive     = $(SRC_PACKAGE_PATH)/GNU/libiconv/libiconv-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libiconv-$(version)
src_dir_name       = libiconv-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
ICONV_PKG_NAME                = libiconv
ICONV_PKG_VERSION             = 1.14
ICONV_PKG_ARCH                = $(TOOLCHAIN)
ICONV_PKG_DISTRO_NAME         = $(DISTRO_NAME)
ICONV_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
ICONV_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
ICONV_PKG_SHORT_DESCRIPTION   = character set conversion library
ICONV_PKG_URL                 = $(BUG_URL)
ICONV_PKG_LICENSE             = GPLv2
ICONV_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(ICONV_PKG_NAME)-pkg-description
ICONV_PKG_DESCRIPTION_FILE_IN = $(ICONV_PKG_NAME)-pkg-description.in
ICONV_PKG_INSTALL_SCRIPT      = $(ICONV_PKG_NAME)-pkg-install.sh

ICONV_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(ICONV_PKG_NAME)-package

pkg_basename     = $(ICONV_PKG_NAME)-$(ICONV_PKG_VERSION)-$(ICONV_PKG_ARCH)-$(ICONV_PKG_DISTRO_NAME)-$(ICONV_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(ICONV_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --disable-rpath
extra_configure_switches += --enable-nls
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


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
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(ICONV_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@chmod a+x $(ICONV_PKG)/usr/lib$(LIBSUFFIX)/libcharset.la
	@chmod a+x $(ICONV_PKG)/usr/lib$(LIBSUFFIX)/libcharset.so.?.?.?
	@chmod a+x $(ICONV_PKG)/usr/lib$(LIBSUFFIX)/libiconv.la
	@chmod a+x $(ICONV_PKG)/usr/lib$(LIBSUFFIX)/libiconv.so.?.?.?
	@chmod a+x $(ICONV_PKG)/usr/lib$(LIBSUFFIX)/preloadable_libiconv.so
	# ======= Install Documentation =======
	@if [ -d $(ICONV_PKG)/usr/share/man ]; then \
	  ( cd $(ICONV_PKG)/usr/share/man ; \
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
	@mkdir -p $(ICONV_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING* \
	       $(ICONV_PKG)/usr/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a ABOUT-NLS AUTHORS COPYING* DEPENDENCIES INSTALL* \
	         DESIGN HACKING NEWS NOTES PORTS README* THANKS \
	         $(ICONV_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(ICONV_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(ICONV_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libcharset.la libiconv.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(ICONV_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
#	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
#	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libcharset.la libiconv.la ; \
#	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libcharset.la libiconv.la \
#	 )
	# ======= Strip binaries =======
	@( cd $(ICONV_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@
	exit 1

$(ICONV_PKG_DESCRIPTION_FILE): $(ICONV_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(ICONV_PKG_DESCRIPTION_FILE) $(ICONV_PKG_INSTALL_SCRIPT)
	@cp $(ICONV_PKG_DESCRIPTION_FILE) $(ICONV_PKG)/.DESCRIPTION
	@cp $(ICONV_PKG_INSTALL_SCRIPT) $(ICONV_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(ICONV_PKG)/.REQUIRES
	@echo "pkgname=$(ICONV_PKG_NAME)"                            >  $(ICONV_PKG)/.PKGINFO ; \
	 echo "pkgver=$(ICONV_PKG_VERSION)"                          >> $(ICONV_PKG)/.PKGINFO ; \
	 echo "arch=$(ICONV_PKG_ARCH)"                               >> $(ICONV_PKG)/.PKGINFO ; \
	 echo "distroname=$(ICONV_PKG_DISTRO_NAME)"                  >> $(ICONV_PKG)/.PKGINFO ; \
	 echo "distrover=$(ICONV_PKG_DISTRO_VERSION)"                >> $(ICONV_PKG)/.PKGINFO ; \
	 echo "group=$(ICONV_PKG_GROUP)"                             >> $(ICONV_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(ICONV_PKG_SHORT_DESCRIPTION)\"" >> $(ICONV_PKG)/.PKGINFO ; \
	 echo "url=$(ICONV_PKG_URL)"                                 >> $(ICONV_PKG)/.PKGINFO ; \
	 echo "license=$(ICONV_PKG_LICENSE)"                         >> $(ICONV_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(ICONV_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
