
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
COMPONENT_TARGETS += $(HARDWARE_BT1)
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


SOURCE_REQUIRES    = sources/packages/m/amr/vo-aacenc

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.4.0
else
ifneq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES           = libs/glibc/2.25
else
REQUIRES           = libs/glibc/2.25-x86_32
endif
endif

# ======= __END_OF_REQUIRES__ =======


version            = 0.1.3
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/m/amr/vo-aacenc/vo-aacenc-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/vo-aacenc-$(version)
src_dir_name       = vo-aacenc-$(version)
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
VO_AACENC_PKG_NAME                = vo-aacenc
VO_AACENC_PKG_VERSION             = 0.1.3
VO_AACENC_PKG_ARCH                = $(TOOLCHAIN)
VO_AACENC_PKG_DISTRO_NAME         = $(DISTRO_NAME)
VO_AACENC_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
VO_AACENC_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
VO_AACENC_PKG_SHORT_DESCRIPTION   = VisualOn AAC encoder library
VO_AACENC_PKG_URL                 = $(BUG_URL)
VO_AACENC_PKG_LICENSE             = Apache-v2.0
VO_AACENC_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(VO_AACENC_PKG_NAME)-pkg-description
VO_AACENC_PKG_DESCRIPTION_FILE_IN = $(VO_AACENC_PKG_NAME)-pkg-description.in
VO_AACENC_PKG_INSTALL_SCRIPT      = $(VO_AACENC_PKG_NAME)-pkg-install.sh

VO_AACENC_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(VO_AACENC_PKG_NAME)-package

pkg_basename     = $(VO_AACENC_PKG_NAME)-$(VO_AACENC_PKG_VERSION)-$(VO_AACENC_PKG_ARCH)-$(VO_AACENC_PKG_DISTRO_NAME)-$(VO_AACENC_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(VO_AACENC_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --enable-example
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes

#
# NOTE:
# ====
#   Do not use '--enable-armv7neon' for OMAP543X.
#
ifneq ($(filter $(HARDWARE),$(HARDWARE_CB1X) $(HARDWARE_CB2X) $(HARDWARE_CB3X)),)
extra_configure_switches += --enable-armv7neon
endif


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
	@mkdir -p $(VO_AACENC_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(VO_AACENC_PKG)/usr/share/man ]; then \
	  ( cd $(VO_AACENC_PKG)/usr/share/man ; \
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
	@mkdir -p $(VO_AACENC_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING $(SRC_DIR)/NOTICE \
	       $(VO_AACENC_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(VO_AACENC_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING NOTICE README aacenc/doc/voAACEncoderSDK.pdf \
	         $(VO_AACENC_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(VO_AACENC_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(VO_AACENC_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libvo-aacenc.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(VO_AACENC_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libvo-aacenc.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libvo-aacenc.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" vo-aacenc.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(VO_AACENC_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(VO_AACENC_PKG_DESCRIPTION_FILE): $(VO_AACENC_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(VO_AACENC_PKG_DESCRIPTION_FILE) $(VO_AACENC_PKG_INSTALL_SCRIPT)
	@cp $(VO_AACENC_PKG_DESCRIPTION_FILE) $(VO_AACENC_PKG)/.DESCRIPTION
	@cp $(VO_AACENC_PKG_INSTALL_SCRIPT) $(VO_AACENC_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(VO_AACENC_PKG)/.REQUIRES
	@echo "pkgname=$(VO_AACENC_PKG_NAME)"                            >  $(VO_AACENC_PKG)/.PKGINFO ; \
	 echo "pkgver=$(VO_AACENC_PKG_VERSION)"                          >> $(VO_AACENC_PKG)/.PKGINFO ; \
	 echo "arch=$(VO_AACENC_PKG_ARCH)"                               >> $(VO_AACENC_PKG)/.PKGINFO ; \
	 echo "distroname=$(VO_AACENC_PKG_DISTRO_NAME)"                  >> $(VO_AACENC_PKG)/.PKGINFO ; \
	 echo "distrover=$(VO_AACENC_PKG_DISTRO_VERSION)"                >> $(VO_AACENC_PKG)/.PKGINFO ; \
	 echo "group=$(VO_AACENC_PKG_GROUP)"                             >> $(VO_AACENC_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(VO_AACENC_PKG_SHORT_DESCRIPTION)\"" >> $(VO_AACENC_PKG)/.PKGINFO ; \
	 echo "url=$(VO_AACENC_PKG_URL)"                                 >> $(VO_AACENC_PKG)/.PKGINFO ; \
	 echo "license=$(VO_AACENC_PKG_LICENSE)"                         >> $(VO_AACENC_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(VO_AACENC_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
