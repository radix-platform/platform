
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


SOURCE_REQUIRES    = sources/packages/m/libsoxr

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.4.0
else
REQUIRES          += libs/glibc/2.26
endif

# ======= __END_OF_REQUIRES__ =======


version            = 0.1.2
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/m/libsoxr/soxr-$(version)-Source.tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/soxr-$(version)-Source
src_dir_name       = soxr-$(version)-Source
doc_dir_name       = libsoxr-$(version)
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
LIBSOXR_PKG_NAME                = libsoxr
LIBSOXR_PKG_VERSION             = 0.1.2
LIBSOXR_PKG_ARCH                = $(TOOLCHAIN)
LIBSOXR_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBSOXR_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBSOXR_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
LIBSOXR_PKG_SHORT_DESCRIPTION   = The SoX Resampler library
LIBSOXR_PKG_URL                 = $(BUG_URL)
LIBSOXR_PKG_LICENSE             = LGPLv2.1
LIBSOXR_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBSOXR_PKG_NAME)-pkg-description
LIBSOXR_PKG_DESCRIPTION_FILE_IN = $(LIBSOXR_PKG_NAME)-pkg-description.in
LIBSOXR_PKG_INSTALL_SCRIPT      = $(LIBSOXR_PKG_NAME)-pkg-install.sh

LIBSOXR_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBSOXR_PKG_NAME)-package

pkg_basename     = $(LIBSOXR_PKG_NAME)-$(LIBSOXR_PKG_VERSION)-$(LIBSOXR_PKG_ARCH)-$(LIBSOXR_PKG_DISTRO_NAME)-$(LIBSOXR_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(LIBSOXR_PKG)


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

configure_switches += -DDOC_INSTALL_DIR='share/doc/$(doc_dir_name)'
configure_switches += -DLIB_INSTALL_DIR='lib$(LIBSUFFIX)'

configure_switches += -DCMAKE_CROSSCOMPILING=True

configure_switches += -DBUILD_TESTS=OFF
configure_switches += -DBUILD_EXAMPLES=OFF
configure_switches += -DBUILD_SHARED_LIBS=ON
configure_switches += -DWITH_AVFFT=ON
configure_switches += -DWITH_DOUBLE_PRECISION=ON
configure_switches += -DWITH_LSR_BINDINGS=ON
configure_switches += -DWITH_OPENMP=ON
configure_switches += -DWITH_PFFFT=ON
configure_switches += -DWITH_SIMD=ON


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
	@mkdir -p $(LIBSOXR_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(LIBSOXR_PKG)/usr/share/man ]; then \
	  ( cd $(LIBSOXR_PKG)/usr/share/man ; \
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
	@mkdir -p $(LIBSOXR_PKG)/usr/doc/$(doc_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING.LGPL $(SRC_DIR)/LICENCE \
	       $(LIBSOXR_PKG)/usr/doc/$(doc_dir_name)
	@mkdir -p $(LIBSOXR_PKG)/usr/share/doc/$(doc_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING.LGPL INSTALL TODO \
	         $(LIBSOXR_PKG)/usr/share/doc/$(doc_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog -a -s ChangeLog ]; then \
	     DOCSDIR=`echo $(LIBSOXR_PKG)/usr/share/doc/$(doc_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBSOXR_PKG))
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" soxr-lsr.pc soxr.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBSOXR_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(LIBSOXR_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(LIBSOXR_PKG_DESCRIPTION_FILE): $(LIBSOXR_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBSOXR_PKG_DESCRIPTION_FILE) $(LIBSOXR_PKG_INSTALL_SCRIPT)
	@cp $(LIBSOXR_PKG_DESCRIPTION_FILE) $(LIBSOXR_PKG)/.DESCRIPTION
	@cp $(LIBSOXR_PKG_INSTALL_SCRIPT) $(LIBSOXR_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBSOXR_PKG)/.REQUIRES
	@echo "pkgname=$(LIBSOXR_PKG_NAME)"                            >  $(LIBSOXR_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBSOXR_PKG_VERSION)"                          >> $(LIBSOXR_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBSOXR_PKG_ARCH)"                               >> $(LIBSOXR_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBSOXR_PKG_DISTRO_NAME)"                  >> $(LIBSOXR_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBSOXR_PKG_DISTRO_VERSION)"                >> $(LIBSOXR_PKG)/.PKGINFO ; \
	 echo "group=$(LIBSOXR_PKG_GROUP)"                             >> $(LIBSOXR_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBSOXR_PKG_SHORT_DESCRIPTION)\"" >> $(LIBSOXR_PKG)/.PKGINFO ; \
	 echo "url=$(LIBSOXR_PKG_URL)"                                 >> $(LIBSOXR_PKG)/.PKGINFO ; \
	 echo "license=$(LIBSOXR_PKG_LICENSE)"                         >> $(LIBSOXR_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LIBSOXR_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
