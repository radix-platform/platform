
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


SOURCE_REQUIRES    = sources/packages/l/keyutils

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


version            = 1.5.9
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/l/keyutils/keyutils-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/keyutils-$(version)
src_dir_name       = keyutils-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
KEYUTILS_PKG_NAME                = keyutils
KEYUTILS_PKG_VERSION             = 1.5.9
KEYUTILS_PKG_ARCH                = $(TOOLCHAIN)
KEYUTILS_PKG_DISTRO_NAME         = $(DISTRO_NAME)
KEYUTILS_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
KEYUTILS_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
KEYUTILS_PKG_SHORT_DESCRIPTION   = Kernel key management utilities
KEYUTILS_PKG_URL                 = $(BUG_URL)
KEYUTILS_PKG_LICENSE             = LGPLv2
KEYUTILS_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(KEYUTILS_PKG_NAME)-pkg-description
KEYUTILS_PKG_DESCRIPTION_FILE_IN = $(KEYUTILS_PKG_NAME)-pkg-description.in
KEYUTILS_PKG_INSTALL_SCRIPT      = $(KEYUTILS_PKG_NAME)-pkg-install.sh

KEYUTILS_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(KEYUTILS_PKG_NAME)-package

pkg_basename     = $(KEYUTILS_PKG_NAME)-$(KEYUTILS_PKG_VERSION)-$(KEYUTILS_PKG_ARCH)-$(KEYUTILS_PKG_DISTRO_NAME)-$(KEYUTILS_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(KEYUTILS_PKG)
env_build   = SBINDIR='/sbin' BINDIR='/bin'    \
              LIBDIR='/lib$(LIBSUFFIX)'        \
              USRLIBDIR='/usr/lib$(LIBSUFFIX)'


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(env_build) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(KEYUTILS_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_build) $(env_sysroot)
	@( cd $(KEYUTILS_PKG)/usr/lib$(LIBSUFFIX) ; \
	   rm -f lib*.so ; \
	   ln -sf ../../lib$(LIBSUFFIX)/lib*.so.?.? . ; \
	   ln -sf lib*.so.?.? libkeyutils.so.1 ; \
	   ln -sf lib*.so.? libkeyutils.so     ; \
	 )
	# ======= Install Documentation =======
	@if [ -d $(KEYUTILS_PKG)/usr/share/man ]; then \
	  ( cd $(KEYUTILS_PKG)/usr/share/man ; \
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
	@mkdir -p $(KEYUTILS_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/LICENCE.GPL $(SRC_DIR)/LICENCE.LGPL \
	       $(KEYUTILS_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(KEYUTILS_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a LICENCE.GPL LICENCE.LGPL  \
	         README SUBMITTING_PATCHES \
	         $(KEYUTILS_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(KEYUTILS_PKG))
	# ======= Strip binaries =======
	@( cd $(KEYUTILS_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(KEYUTILS_PKG_DESCRIPTION_FILE): $(KEYUTILS_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(KEYUTILS_PKG_DESCRIPTION_FILE) $(KEYUTILS_PKG_INSTALL_SCRIPT)
	@cp $(KEYUTILS_PKG_DESCRIPTION_FILE) $(KEYUTILS_PKG)/.DESCRIPTION
	@cp $(KEYUTILS_PKG_INSTALL_SCRIPT) $(KEYUTILS_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(KEYUTILS_PKG)/.REQUIRES
	@echo "pkgname=$(KEYUTILS_PKG_NAME)"                            >  $(KEYUTILS_PKG)/.PKGINFO ; \
	 echo "pkgver=$(KEYUTILS_PKG_VERSION)"                          >> $(KEYUTILS_PKG)/.PKGINFO ; \
	 echo "arch=$(KEYUTILS_PKG_ARCH)"                               >> $(KEYUTILS_PKG)/.PKGINFO ; \
	 echo "distroname=$(KEYUTILS_PKG_DISTRO_NAME)"                  >> $(KEYUTILS_PKG)/.PKGINFO ; \
	 echo "distrover=$(KEYUTILS_PKG_DISTRO_VERSION)"                >> $(KEYUTILS_PKG)/.PKGINFO ; \
	 echo "group=$(KEYUTILS_PKG_GROUP)"                             >> $(KEYUTILS_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(KEYUTILS_PKG_SHORT_DESCRIPTION)\"" >> $(KEYUTILS_PKG)/.PKGINFO ; \
	 echo "url=$(KEYUTILS_PKG_URL)"                                 >> $(KEYUTILS_PKG)/.PKGINFO ; \
	 echo "license=$(KEYUTILS_PKG_LICENSE)"                         >> $(KEYUTILS_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(KEYUTILS_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
