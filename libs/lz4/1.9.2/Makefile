
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


SOURCE_REQUIRES    = sources/packages/l/lz4

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/6.5.0
else
REQUIRES           = libs/glibc/2.28
endif

# ======= __END_OF_REQUIRES__ =======


version            = 1.9.2
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/l/lz4/lz4-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/lz4-$(version)
src_dir_name       = lz4-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LZ4_PKG_NAME                = lz4
LZ4_PKG_VERSION             = 1.9.2
LZ4_PKG_ARCH                = $(TOOLCHAIN)
LZ4_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LZ4_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LZ4_PKG_GROUP               = $(PKG_GROUP)
###                          |---handy-ruler-------------------------------|
LZ4_PKG_SHORT_DESCRIPTION   = fast compression algorithm
LZ4_PKG_URL                 = $(BUG_URL)
LZ4_PKG_LICENSE             = BSD
LZ4_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LZ4_PKG_NAME)-pkg-description
LZ4_PKG_DESCRIPTION_FILE_IN = $(LZ4_PKG_NAME)-pkg-description.in
LZ4_PKG_INSTALL_SCRIPT      = $(LZ4_PKG_NAME)-pkg-install.sh

LZ4_PKG          = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LZ4_PKG_NAME)-package

pkg_basename     = $(LZ4_PKG_NAME)-$(LZ4_PKG_VERSION)-$(LZ4_PKG_ARCH)-$(LZ4_PKG_DISTRO_NAME)-$(LZ4_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(LZ4_PKG)


configure_switches  = PREFIX=/usr
configure_switches += LIBDIR=/usr/lib$(LIBSUFFIX)
configure_switches += MANDIR=/usr/share/man


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) $(configure_switches) -C lib
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) $(configure_switches) -C programs lz4 lz4c
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LZ4_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) $(configure_switches) -j1 install $(env_sysroot)
ifneq ($(__ENABLE_STATIC__),yes)
	@rm -f $(LZ4_PKG)/usr/lib$(LIBSUFFIX)/*.a
endif
	# ======= Install Documentation =======
	@if [ -d $(LZ4_PKG)/usr/share/man ]; then \
	  ( cd $(LZ4_PKG)/usr/share/man ; \
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
	@mkdir -p $(LZ4_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/LICENSE \
	       $(LZ4_PKG)/usr/doc/$(src_dir_name)
	@rm -rf $(LZ4_PKG)/usr/share/doc/$(src_dir_name)
	@mkdir -p $(LZ4_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a INSTALL LICENSE *.md doc \
	         $(LZ4_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(LZ4_PKG)/usr/share/doc/$(src_dir_name) ; \
	   mv doc html ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r CHANGELOG ]; then \
	     DOCSDIR=`echo $(LZ4_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat CHANGELOG | head -n 1000 > $$DOCSDIR/CHANGELOG ; \
	     touch -r CHANGELOG $$DOCSDIR/CHANGELOG ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LZ4_PKG))
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" liblz4.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LZ4_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifeq ($(__ENABLE_STATIC__),yes)
	@( cd $(LZ4_PKG) ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null ; \
	 )
endif
	@touch $@

$(LZ4_PKG_DESCRIPTION_FILE): $(LZ4_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LZ4_PKG_DESCRIPTION_FILE) $(LZ4_PKG_INSTALL_SCRIPT)
	@cp $(LZ4_PKG_DESCRIPTION_FILE) $(LZ4_PKG)/.DESCRIPTION
	@cp $(LZ4_PKG_INSTALL_SCRIPT) $(LZ4_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LZ4_PKG)/.REQUIRES
	@echo "pkgname=$(LZ4_PKG_NAME)"                            >  $(LZ4_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LZ4_PKG_VERSION)"                          >> $(LZ4_PKG)/.PKGINFO ; \
	 echo "arch=$(LZ4_PKG_ARCH)"                               >> $(LZ4_PKG)/.PKGINFO ; \
	 echo "distroname=$(LZ4_PKG_DISTRO_NAME)"                  >> $(LZ4_PKG)/.PKGINFO ; \
	 echo "distrover=$(LZ4_PKG_DISTRO_VERSION)"                >> $(LZ4_PKG)/.PKGINFO ; \
	 echo "group=$(LZ4_PKG_GROUP)"                             >> $(LZ4_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LZ4_PKG_SHORT_DESCRIPTION)\"" >> $(LZ4_PKG)/.PKGINFO ; \
	 echo "url=$(LZ4_PKG_URL)"                                 >> $(LZ4_PKG)/.PKGINFO ; \
	 echo "license=$(LZ4_PKG_LICENSE)"                         >> $(LZ4_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LZ4_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
