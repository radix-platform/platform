
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


SOURCE_REQUIRES    = sources/packages/m/vid-stab

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/6.5.0
else
REQUIRES          += libs/glibc/2.28
endif

# ======= __END_OF_REQUIRES__ =======


version            = 1.1
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/m/vid-stab/vid-stab-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/vid-stab-$(version)
src_dir_name       = vid-stab-$(version)
doc_dir_name       = libvidstab-$(version)
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
VIDSTAB_PKG_NAME                = libvidstab
VIDSTAB_PKG_VERSION             = 1.1
VIDSTAB_PKG_ARCH                = $(TOOLCHAIN)
VIDSTAB_PKG_DISTRO_NAME         = $(DISTRO_NAME)
VIDSTAB_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
VIDSTAB_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
VIDSTAB_PKG_SHORT_DESCRIPTION   = video stabilization library
VIDSTAB_PKG_URL                 = $(BUG_URL)
VIDSTAB_PKG_LICENSE             = GPL
VIDSTAB_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(VIDSTAB_PKG_NAME)-pkg-description
VIDSTAB_PKG_DESCRIPTION_FILE_IN = $(VIDSTAB_PKG_NAME)-pkg-description.in
VIDSTAB_PKG_INSTALL_SCRIPT      = $(VIDSTAB_PKG_NAME)-pkg-install.sh

VIDSTAB_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(VIDSTAB_PKG_NAME)-package

pkg_basename     = $(VIDSTAB_PKG_NAME)-$(VIDSTAB_PKG_VERSION)-$(VIDSTAB_PKG_ARCH)-$(VIDSTAB_PKG_DISTRO_NAME)-$(VIDSTAB_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(VIDSTAB_PKG)


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)
TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


configure_switches  = -DCMAKE_BUILD_TYPE='Release'

configure_switches += -DCMAKE_C_COMPILER='$(CROSS_PREFIX)gcc'
configure_switches += -DCMAKE_LINKER='$(CROSS_PREFIX)ld'
configure_switches += -DCMAKE_AR='$(CROSS_PREFIX)ar'
configure_switches += -DCMAKE_NM='$(CROSS_PREFIX)nm'
configure_switches += -DCMAKE_RANLIB='$(CROSS_PREFIX)ranlib'
configure_switches += -DCMAKE_OBJCOPY='$(CROSS_PREFIX)objcopy'
configure_switches += -DCMAKE_OBJDUMP='$(CROSS_PREFIX)objdump'
configure_switches += -DCMAKE_STRIP='$(CROSS_PREFIX)strip'

configure_switches += -DCMAKE_C_FLAGS:STRING='--sysroot=$(TARGET_DEST_DIR) $(CFLAGS) $(ARCH_FLAGS) $(ARCH_DEFS) $(HW_FLAGS) -Wno-unknown-pragmas'

configure_switches += -DCMAKE_EXE_LINKER_FLAGS='--sysroot=$(TARGET_DEST_DIR) -Wl,-rpath,$(TARGET_BIN_RPATH) -L$(TARGET_DEST_DIR)/lib$(LIBSUFFIX) -L$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)'
configure_switches += -DCMAKE_MODULE_LINKER_FLAGS='--sysroot=$(TARGET_DEST_DIR) -Wl,-rpath,$(TARGET_LIB_RPATH) -L$(TARGET_DEST_DIR)/lib$(LIBSUFFIX) -L$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)'
configure_switches += -DCMAKE_SHARED_LINKER_FLAGS='--sysroot=$(TARGET_DEST_DIR) -Wl,-rpath,$(TARGET_LIB_RPATH) -L$(TARGET_DEST_DIR)/lib$(LIBSUFFIX) -L$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)'


ifeq ($(TOOLCHAIN),$(TOOLCHAIN_JZ47XX_GLIBC))
configure_switches += -DCMAKE_C_FLAGS_RELEASE='-O2 -DNDEBUG'
configure_switches += -DCMAKE_CXX_FLAGS_RELEASE='-O2 -DNDEBUG'
configure_switches += -DCMAKE_ASM_FLAGS_RELEASE='-O2 -DNDEBUG'
endif

configure_switches += -DCMAKE_INSTALL_PREFIX=/usr

configure_switches += -DLIB_SUFFIX=$(LIBSUFFIX)

configure_switches += -DCMAKE_CROSSCOMPILING=True


ifneq ($(filter $(HARDWARE),$(HARDWARE_PC32) $(HARDWARE_PC64)),)
configure_switches += -DSSE2_FOUND:BOOL=true
configure_switches += -DSSE3_FOUND:BOOL=true
configure_switches += -DSSE4_1_FOUND:BOOL=true
configure_switches += -DSSSE3_FOUND:BOOL=true
else
configure_switches += -DSSE2_FOUND:BOOL=false
configure_switches += -DSSE3_FOUND:BOOL=false
configure_switches += -DSSE4_1_FOUND:BOOL=false
configure_switches += -DSSSE3_FOUND:BOOL=false
endif

configure_switches += -DUSE_OMP:BOOL=ON


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@( cd $(build_dir) ; \
	   $(BUILD_ENVIRONMENT) cmake $(configure_switches) ../$(src_dir_name) ; \
	 )
	@( cd $(build_dir) ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) ; \
	 )
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(VIDSTAB_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(VIDSTAB_PKG)/usr/share/man ]; then \
	  ( cd $(VIDSTAB_PKG)/usr/share/man ; \
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
	@mkdir -p $(VIDSTAB_PKG)/usr/doc/$(doc_dir_name)
	@cp -a $(SRC_DIR)/LICENSE \
	       $(VIDSTAB_PKG)/usr/doc/$(doc_dir_name)
	@mkdir -p $(VIDSTAB_PKG)/usr/share/doc/$(doc_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a LICENSE Install README.md \
	         $(VIDSTAB_PKG)/usr/share/doc/$(doc_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog -a -s ChangeLog ]; then \
	     DOCSDIR=`echo $(VIDSTAB_PKG)/usr/share/doc/$(doc_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(VIDSTAB_PKG))
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" vidstab.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(VIDSTAB_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(VIDSTAB_PKG_DESCRIPTION_FILE): $(VIDSTAB_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(VIDSTAB_PKG_DESCRIPTION_FILE) $(VIDSTAB_PKG_INSTALL_SCRIPT)
	@cp $(VIDSTAB_PKG_DESCRIPTION_FILE) $(VIDSTAB_PKG)/.DESCRIPTION
	@cp $(VIDSTAB_PKG_INSTALL_SCRIPT) $(VIDSTAB_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(VIDSTAB_PKG)/.REQUIRES
	@echo "pkgname=$(VIDSTAB_PKG_NAME)"                            >  $(VIDSTAB_PKG)/.PKGINFO ; \
	 echo "pkgver=$(VIDSTAB_PKG_VERSION)"                          >> $(VIDSTAB_PKG)/.PKGINFO ; \
	 echo "arch=$(VIDSTAB_PKG_ARCH)"                               >> $(VIDSTAB_PKG)/.PKGINFO ; \
	 echo "distroname=$(VIDSTAB_PKG_DISTRO_NAME)"                  >> $(VIDSTAB_PKG)/.PKGINFO ; \
	 echo "distrover=$(VIDSTAB_PKG_DISTRO_VERSION)"                >> $(VIDSTAB_PKG)/.PKGINFO ; \
	 echo "group=$(VIDSTAB_PKG_GROUP)"                             >> $(VIDSTAB_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(VIDSTAB_PKG_SHORT_DESCRIPTION)\"" >> $(VIDSTAB_PKG)/.PKGINFO ; \
	 echo "url=$(VIDSTAB_PKG_URL)"                                 >> $(VIDSTAB_PKG)/.PKGINFO ; \
	 echo "license=$(VIDSTAB_PKG_LICENSE)"                         >> $(VIDSTAB_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(VIDSTAB_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
