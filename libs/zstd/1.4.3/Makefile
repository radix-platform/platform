
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


SOURCE_REQUIRES    = sources/packages/l/zstd

REQUIRES           = libs/lz4/1.9.2
REQUIRES          += libs/zlib/1.2.8
REQUIRES          += app/xz/5.2.4

# ======= __END_OF_REQUIRES__ =======


version            = 1.4.3
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/l/zstd/zstd-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/zstd-$(version)
src_dir_name       = zstd-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
ZSTD_PKG_NAME                = zstd
ZSTD_PKG_VERSION             = 1.4.3
ZSTD_PKG_ARCH                = $(TOOLCHAIN)
ZSTD_PKG_DISTRO_NAME         = $(DISTRO_NAME)
ZSTD_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
ZSTD_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
ZSTD_PKG_SHORT_DESCRIPTION   = real-time compression algorithm
ZSTD_PKG_URL                 = $(BUG_URL)
ZSTD_PKG_LICENSE             = GPLv2
ZSTD_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(ZSTD_PKG_NAME)-pkg-description
ZSTD_PKG_DESCRIPTION_FILE_IN = $(ZSTD_PKG_NAME)-pkg-description.in
ZSTD_PKG_INSTALL_SCRIPT      = $(ZSTD_PKG_NAME)-pkg-install.sh

ZSTD_PKG          = $(CURDIR)/$(TARGET_BUILD_DIR)/$(ZSTD_PKG_NAME)-package

pkg_basename     = $(ZSTD_PKG_NAME)-$(ZSTD_PKG_VERSION)-$(ZSTD_PKG_ARCH)-$(ZSTD_PKG_DISTRO_NAME)-$(ZSTD_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(ZSTD_PKG)


configure_switches  = prefix=/usr
configure_switches += libdir=/usr/lib$(LIBSUFFIX)
configure_switches += mandir=/usr/share/man


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -C contrib/pzstd
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(ZSTD_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) $(configure_switches) -j1 install $(env_sysroot)
	@cd $(SRC_DIR) && install -Dm755 contrib/pzstd/pzstd $(ZSTD_PKG)/usr/bin/pzstd
ifneq ($(__ENABLE_STATIC__),yes)
	@rm -f $(ZSTD_PKG)/usr/lib$(LIBSUFFIX)/*.a
endif
	# ======= Install Documentation =======
	@if [ -d $(ZSTD_PKG)/usr/share/man ]; then \
	  ( cd $(ZSTD_PKG)/usr/share/man ; \
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
	@mkdir -p $(ZSTD_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING $(SRC_DIR)/LICENSE \
	       $(ZSTD_PKG)/usr/doc/$(src_dir_name)
	@rm -rf $(ZSTD_PKG)/usr/share/doc/$(src_dir_name)
	@mkdir -p $(ZSTD_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING LICENSE *.md doc \
	         $(ZSTD_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(ZSTD_PKG)/usr/share/doc/$(src_dir_name) ; \
	   mv doc html ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r CHANGELOG ]; then \
	     DOCSDIR=`echo $(ZSTD_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat CHANGELOG | head -n 1000 > $$DOCSDIR/CHANGELOG ; \
	     touch -r CHANGELOG $$DOCSDIR/CHANGELOG ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(ZSTD_PKG))
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libzstd.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(ZSTD_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifeq ($(__ENABLE_STATIC__),yes)
	@( cd $(ZSTD_PKG) ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null ; \
	 )
endif
	@touch $@

$(ZSTD_PKG_DESCRIPTION_FILE): $(ZSTD_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(ZSTD_PKG_DESCRIPTION_FILE) $(ZSTD_PKG_INSTALL_SCRIPT)
	@cp $(ZSTD_PKG_DESCRIPTION_FILE) $(ZSTD_PKG)/.DESCRIPTION
	@cp $(ZSTD_PKG_INSTALL_SCRIPT) $(ZSTD_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(ZSTD_PKG)/.REQUIRES
	@echo "pkgname=$(ZSTD_PKG_NAME)"                            >  $(ZSTD_PKG)/.PKGINFO ; \
	 echo "pkgver=$(ZSTD_PKG_VERSION)"                          >> $(ZSTD_PKG)/.PKGINFO ; \
	 echo "arch=$(ZSTD_PKG_ARCH)"                               >> $(ZSTD_PKG)/.PKGINFO ; \
	 echo "distroname=$(ZSTD_PKG_DISTRO_NAME)"                  >> $(ZSTD_PKG)/.PKGINFO ; \
	 echo "distrover=$(ZSTD_PKG_DISTRO_VERSION)"                >> $(ZSTD_PKG)/.PKGINFO ; \
	 echo "group=$(ZSTD_PKG_GROUP)"                             >> $(ZSTD_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(ZSTD_PKG_SHORT_DESCRIPTION)\"" >> $(ZSTD_PKG)/.PKGINFO ; \
	 echo "url=$(ZSTD_PKG_URL)"                                 >> $(ZSTD_PKG)/.PKGINFO ; \
	 echo "license=$(ZSTD_PKG_LICENSE)"                         >> $(ZSTD_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(ZSTD_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
