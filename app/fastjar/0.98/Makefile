
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


SOURCE_REQUIRES    = sources/packages/j/fastjar

REQUIRES           = libs/zlib/1.2.8

# ======= __END_OF_REQUIRES__ =======


version            = 0.98
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/j/fastjar/fastjar-$(version).tar.gz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/fastjar-$(version)
src_dir_name       = fastjar-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
FASTJAR_PKG_NAME                = fastjar
FASTJAR_PKG_VERSION             = 0.98
FASTJAR_PKG_ARCH                = $(TOOLCHAIN)
FASTJAR_PKG_DISTRO_NAME         = $(DISTRO_NAME)
FASTJAR_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
FASTJAR_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
FASTJAR_PKG_SHORT_DESCRIPTION   = fast jar command
FASTJAR_PKG_URL                 = $(BUG_URL)
FASTJAR_PKG_LICENSE             = GPLv2
FASTJAR_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(FASTJAR_PKG_NAME)-pkg-description
FASTJAR_PKG_DESCRIPTION_FILE_IN = $(FASTJAR_PKG_NAME)-pkg-description.in
FASTJAR_PKG_INSTALL_SCRIPT      = $(FASTJAR_PKG_NAME)-pkg-install.sh

FASTJAR_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(FASTJAR_PKG_NAME)-package

pkg_basename     = $(FASTJAR_PKG_NAME)-$(FASTJAR_PKG_VERSION)-$(FASTJAR_PKG_ARCH)-$(FASTJAR_PKG_DISTRO_NAME)-$(FASTJAR_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(FASTJAR_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

ifneq ($(filter $(HARDWARE),$(HARDWARE_PC32) $(HARDWARE_PC64)),)
cross_environment  = ac_cv_func_btowc=yes
cross_environment += gl_cv_func_btowc_eof="guessing yes"
cross_environment += ac_cv_func_mbrtowc=yes
cross_environment += ac_cv_func_mbsinit=yes
cross_environment += gl_cv_func_mbrtowc_incomplete_state="guessing yes"
cross_environment += gl_cv_func_mbrtowc_null_arg="guessing yes"
cross_environment += gl_cv_func_mbrtowc_retval="guessing yes"
cross_environment += gl_cv_func_mbrtowc_nul_retval="guessing yes"
cross_environment += gl_cv_func_wcrtomb_retval="guessing yes"
else
cross_environment  =
endif


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) $(cross_environment) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(FASTJAR_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@rm -f $(FASTJAR_PKG)/usr/share/info/dir
	@gzip -9 $(FASTJAR_PKG)/usr/share/info/*
	@if [ -d $(FASTJAR_PKG)/usr/share/man ]; then \
	  ( cd $(FASTJAR_PKG)/usr/share/man ; \
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
	@mkdir -p $(FASTJAR_PKG)/usr/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING* \
	       $(FASTJAR_PKG)/usr/doc/$(src_dir_name) \
	 )
	@mkdir -p $(FASTJAR_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS CHANGES COPYING INSTALL NEWS README TODO \
	       $(FASTJAR_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(FASTJAR_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(FASTJAR_PKG))
	# ======= Strip binaries =======
	@( cd $(FASTJAR_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(FASTJAR_PKG_DESCRIPTION_FILE): $(FASTJAR_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(FASTJAR_PKG_DESCRIPTION_FILE) $(FASTJAR_PKG_INSTALL_SCRIPT)
	@cp $(FASTJAR_PKG_DESCRIPTION_FILE) $(FASTJAR_PKG)/.DESCRIPTION
	@cp $(FASTJAR_PKG_INSTALL_SCRIPT) $(FASTJAR_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(FASTJAR_PKG)/.REQUIRES
	@echo "pkgname=$(FASTJAR_PKG_NAME)"                            >  $(FASTJAR_PKG)/.PKGINFO ; \
	 echo "pkgver=$(FASTJAR_PKG_VERSION)"                          >> $(FASTJAR_PKG)/.PKGINFO ; \
	 echo "arch=$(FASTJAR_PKG_ARCH)"                               >> $(FASTJAR_PKG)/.PKGINFO ; \
	 echo "distroname=$(FASTJAR_PKG_DISTRO_NAME)"                  >> $(FASTJAR_PKG)/.PKGINFO ; \
	 echo "distrover=$(FASTJAR_PKG_DISTRO_VERSION)"                >> $(FASTJAR_PKG)/.PKGINFO ; \
	 echo "group=$(FASTJAR_PKG_GROUP)"                             >> $(FASTJAR_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(FASTJAR_PKG_SHORT_DESCRIPTION)\"" >> $(FASTJAR_PKG)/.PKGINFO ; \
	 echo "url=$(FASTJAR_PKG_URL)"                                 >> $(FASTJAR_PKG)/.PKGINFO ; \
	 echo "license=$(FASTJAR_PKG_LICENSE)"                         >> $(FASTJAR_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(FASTJAR_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
