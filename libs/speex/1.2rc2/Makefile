
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


SOURCE_REQUIRES    = sources/packages/m/xiph/speex

REQUIRES           = libs/libogg/1.3.2
REQUIRES          += libs/speexdsp/1.2rc3

# ======= __END_OF_REQUIRES__ =======


version            = 1.2rc2
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/m/xiph/speex/speex-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/speex-$(version)
src_dir_name       = speex-$(version)
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
SPEEX_PKG_NAME                = speex
SPEEX_PKG_VERSION             = 1.2rc2
SPEEX_PKG_ARCH                = $(TOOLCHAIN)
SPEEX_PKG_DISTRO_NAME         = $(DISTRO_NAME)
SPEEX_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
SPEEX_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
SPEEX_PKG_SHORT_DESCRIPTION   = opensource speech codec
SPEEX_PKG_URL                 = $(BUG_URL)
SPEEX_PKG_LICENSE             = BSD
SPEEX_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(SPEEX_PKG_NAME)-pkg-description
SPEEX_PKG_DESCRIPTION_FILE_IN = $(SPEEX_PKG_NAME)-pkg-description.in
SPEEX_PKG_INSTALL_SCRIPT      = $(SPEEX_PKG_NAME)-pkg-install.sh

SPEEX_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(SPEEX_PKG_NAME)-package

pkg_basename     = $(SPEEX_PKG_NAME)-$(SPEEX_PKG_VERSION)-$(SPEEX_PKG_ARCH)-$(SPEEX_PKG_DISTRO_NAME)-$(SPEEX_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(SPEEX_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --sysconfdir=/etc

extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)


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
	@mkdir -p $(SPEEX_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(SPEEX_PKG)/usr/share/man ]; then \
	  ( cd $(SPEEX_PKG)/usr/share/man ; \
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
	@mkdir -p $(SPEEX_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(SPEEX_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(SPEEX_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING INSTALL NEWS README* TODO \
	         $(SPEEX_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(SPEEX_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(SPEEX_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libspeex.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(SPEEX_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libspeex.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libspeex.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" speex.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(SPEEX_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(SPEEX_PKG)/usr/bin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(SPEEX_PKG_DESCRIPTION_FILE): $(SPEEX_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(SPEEX_PKG_DESCRIPTION_FILE) $(SPEEX_PKG_INSTALL_SCRIPT)
	@cp $(SPEEX_PKG_DESCRIPTION_FILE) $(SPEEX_PKG)/.DESCRIPTION
	@cp $(SPEEX_PKG_INSTALL_SCRIPT) $(SPEEX_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(SPEEX_PKG)/.REQUIRES
	@echo "pkgname=$(SPEEX_PKG_NAME)"                            >  $(SPEEX_PKG)/.PKGINFO ; \
	 echo "pkgver=$(SPEEX_PKG_VERSION)"                          >> $(SPEEX_PKG)/.PKGINFO ; \
	 echo "arch=$(SPEEX_PKG_ARCH)"                               >> $(SPEEX_PKG)/.PKGINFO ; \
	 echo "distroname=$(SPEEX_PKG_DISTRO_NAME)"                  >> $(SPEEX_PKG)/.PKGINFO ; \
	 echo "distrover=$(SPEEX_PKG_DISTRO_VERSION)"                >> $(SPEEX_PKG)/.PKGINFO ; \
	 echo "group=$(SPEEX_PKG_GROUP)"                             >> $(SPEEX_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(SPEEX_PKG_SHORT_DESCRIPTION)\"" >> $(SPEEX_PKG)/.PKGINFO ; \
	 echo "url=$(SPEEX_PKG_URL)"                                 >> $(SPEEX_PKG)/.PKGINFO ; \
	 echo "license=$(SPEEX_PKG_LICENSE)"                         >> $(SPEEX_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(SPEEX_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
