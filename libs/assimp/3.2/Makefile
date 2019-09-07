
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


SOURCE_REQUIRES    = sources/packages/l/assimp

REQUIRES           = libs/boost/1.61.0

# ======= __END_OF_REQUIRES__ =======


version            = 3.2
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/l/assimp/assimp-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/assimp-$(version)
src_dir_name       = assimp-$(version)
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
ASSIMP_PKG_NAME                = assimp
ASSIMP_PKG_VERSION             = 3.2
ASSIMP_PKG_ARCH                = $(TOOLCHAIN)
ASSIMP_PKG_DISTRO_NAME         = $(DISTRO_NAME)
ASSIMP_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
ASSIMP_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
ASSIMP_PKG_SHORT_DESCRIPTION   = Open Asset Import Library
ASSIMP_PKG_URL                 = $(BUG_URL)
ASSIMP_PKG_LICENSE             = BSD
ASSIMP_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(ASSIMP_PKG_NAME)-pkg-description
ASSIMP_PKG_DESCRIPTION_FILE_IN = $(ASSIMP_PKG_NAME)-pkg-description.in
ASSIMP_PKG_INSTALL_SCRIPT      = $(ASSIMP_PKG_NAME)-pkg-install.sh

ASSIMP_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(ASSIMP_PKG_NAME)-package

pkg_basename     = $(ASSIMP_PKG_NAME)-$(ASSIMP_PKG_VERSION)-$(ASSIMP_PKG_ARCH)-$(ASSIMP_PKG_DISTRO_NAME)-$(ASSIMP_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(ASSIMP_PKG)


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)
TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)

configure_switches  = -DCMAKE_C_COMPILER='$(CROSS_PREFIX)gcc'
configure_switches += -DCMAKE_CXX_COMPILER='$(CROSS_PREFIX)g++'

configure_switches += -DCMAKE_LINKER='$(CROSS_PREFIX)ld'
configure_switches += -DCMAKE_AR='$(CROSS_PREFIX)ar'
configure_switches += -DCMAKE_NM='$(CROSS_PREFIX)nm'
configure_switches += -DCMAKE_RANLIB='$(CROSS_PREFIX)ranlib'
configure_switches += -DCMAKE_OBJCOPY='$(CROSS_PREFIX)objcopy'
configure_switches += -DCMAKE_OBJDUMP='$(CROSS_PREFIX)objdump'
configure_switches += -DCMAKE_STRIP='$(CROSS_PREFIX)strip'

configure_switches += -DCMAKE_C_FLAGS:STRING='--sysroot=$(TARGET_DEST_DIR) $(CFLAGS) $(ARCH_FLAGS) $(ARCH_DEFS) $(HW_FLAGS)'
configure_switches += -DCMAKE_CXX_FLAGS:STRING='--sysroot=$(TARGET_DEST_DIR) $(CFLAGS) $(ARCH_FLAGS) $(ARCH_DEFS) $(HW_FLAGS)'

configure_switches += -DCMAKE_EXE_LINKER_FLAGS='--sysroot=$(TARGET_DEST_DIR) -Wl,-rpath,$(TARGET_BIN_RPATH) -L$(TARGET_DEST_DIR)/lib$(LIBSUFFIX) -L$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)'
configure_switches += -DCMAKE_MODULE_LINKER_FLAGS='--sysroot=$(TARGET_DEST_DIR) -Wl,-rpath,$(TARGET_LIB_RPATH) -L$(TARGET_DEST_DIR)/lib$(LIBSUFFIX) -L$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)'
configure_switches += -DCMAKE_SHARED_LINKER_FLAGS='--sysroot=$(TARGET_DEST_DIR) -Wl,-rpath,$(TARGET_LIB_RPATH) -L$(TARGET_DEST_DIR)/lib$(LIBSUFFIX) -L$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)'

configure_switches += -DCMAKE_SKIP_INSTALL_RPATH=NO
configure_switches += -DCMAKE_SKIP_RPATH=YES

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_JZ47XX_GLIBC))
configure_switches += -DCMAKE_C_FLAGS_RELEASE='-O2 -DNDEBUG'
configure_switches += -DCMAKE_CXX_FLAGS_RELEASE='-O2 -DNDEBUG'
configure_switches += -DCMAKE_ASM_FLAGS_RELEASE='-O2 -DNDEBUG'
endif

configure_switches += -DCMAKE_BUILD_TYPE=Release
configure_switches += -DCMAKE_CROSSCOMPILING=True

configure_switches += -DCMAKE_INSTALL_PREFIX=/usr
configure_switches += -DASSIMP_BIN_INSTALL_DIR=bin
configure_switches += -DASSIMP_INCLUDE_INSTALL_DIR=include
configure_switches += -DASSIMP_LIB_INSTALL_DIR=lib$(LIBSUFFIX)

configure_switches += -DASSIMP_ENABLE_BOOST_WORKAROUND=OFF
configure_switches += -DASSIMP_BUILD_SAMPLES=OFF
configure_switches += -DASSIMP_BUILD_TESTS=OFF


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@( cd $(build_dir) ; \
	   $(BUILD_ENVIRONMENT) cmake $(configure_switches) ../$(src_dir_name) ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) ; \
	 )
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(ASSIMP_PKG)
	@( cd $(build_dir) ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) -j1 $(env_sysroot) install ; \
	 )
	# ======= Convert dos to unix end-of-line symbols =======
	@( cd $(SRC_DIR) ; \
	   for file in CHANGES CREDITS INSTALL LICENSE Readme.md ; do \
	     sed -i $$'s/\r$$//g' $$file ; \
	   done ; \
	 )
	# ======= Install Documentation =======
	@if [ -d $(ASSIMP_PKG)/usr/share/man ]; then \
	  ( cd $(ASSIMP_PKG)/usr/share/man ; \
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
	@mkdir -p $(ASSIMP_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/LICENSE $(SRC_DIR)/CREDITS \
	       $(ASSIMP_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(ASSIMP_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a CREDITS INSTALL LICENSE README Readme.md \
	         $(ASSIMP_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r CHANGES ]; then \
	     DOCSDIR=`echo $(ASSIMP_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat CHANGES | head -n 1000 > $$DOCSDIR/CHANGES ; \
	     touch -r CHANGES $$DOCSDIR/CHANGES ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(ASSIMP_PKG))
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" assimp.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(ASSIMP_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(ASSIMP_PKG_DESCRIPTION_FILE): $(ASSIMP_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(ASSIMP_PKG_DESCRIPTION_FILE) $(ASSIMP_PKG_INSTALL_SCRIPT)
	@cp $(ASSIMP_PKG_DESCRIPTION_FILE) $(ASSIMP_PKG)/.DESCRIPTION
	@cp $(ASSIMP_PKG_INSTALL_SCRIPT) $(ASSIMP_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(ASSIMP_PKG)/.REQUIRES
	@echo "pkgname=$(ASSIMP_PKG_NAME)"                            >  $(ASSIMP_PKG)/.PKGINFO ; \
	 echo "pkgver=$(ASSIMP_PKG_VERSION)"                          >> $(ASSIMP_PKG)/.PKGINFO ; \
	 echo "arch=$(ASSIMP_PKG_ARCH)"                               >> $(ASSIMP_PKG)/.PKGINFO ; \
	 echo "distroname=$(ASSIMP_PKG_DISTRO_NAME)"                  >> $(ASSIMP_PKG)/.PKGINFO ; \
	 echo "distrover=$(ASSIMP_PKG_DISTRO_VERSION)"                >> $(ASSIMP_PKG)/.PKGINFO ; \
	 echo "group=$(ASSIMP_PKG_GROUP)"                             >> $(ASSIMP_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(ASSIMP_PKG_SHORT_DESCRIPTION)\"" >> $(ASSIMP_PKG)/.PKGINFO ; \
	 echo "url=$(ASSIMP_PKG_URL)"                                 >> $(ASSIMP_PKG)/.PKGINFO ; \
	 echo "license=$(ASSIMP_PKG_LICENSE)"                         >> $(ASSIMP_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(ASSIMP_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
