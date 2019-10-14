
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


SOURCE_REQUIRES    = sources/packages/n/libgpg-error

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/6.5.0
else
REQUIRES           = libs/glibc/2.28
endif

# ======= __END_OF_REQUIRES__ =======


version            = 1.36
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/n/libgpg-error/libgpg-error-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libgpg-error-$(version)
src_dir_name       = libgpg-error-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
GPGERROR_PKG_NAME                = libgpg-error
GPGERROR_PKG_VERSION             = 1.36
GPGERROR_PKG_ARCH                = $(TOOLCHAIN)
GPGERROR_PKG_DISTRO_NAME         = $(DISTRO_NAME)
GPGERROR_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
GPGERROR_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
GPGERROR_PKG_SHORT_DESCRIPTION   = GnuPG Error Definitions Library
GPGERROR_PKG_URL                 = $(BUG_URL)
GPGERROR_PKG_LICENSE             = GPLv2
GPGERROR_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GPGERROR_PKG_NAME)-pkg-description
GPGERROR_PKG_DESCRIPTION_FILE_IN = $(GPGERROR_PKG_NAME)-pkg-description.in
GPGERROR_PKG_INSTALL_SCRIPT      = $(GPGERROR_PKG_NAME)-pkg-install.sh

GPGERROR_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GPGERROR_PKG_NAME)-package

pkg_basename     = $(GPGERROR_PKG_NAME)-$(GPGERROR_PKG_VERSION)-$(GPGERROR_PKG_ARCH)-$(GPGERROR_PKG_DISTRO_NAME)-$(GPGERROR_PKG_DISTRO_VERSION)

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


env_sysroot  = DESTDIR=$(GPGERROR_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --with-gnu-ld
ifeq ($(__ENABLE_STATIC__),yes)
extra_configure_switches += --enable-static=yes
else
extra_configure_switches += --enable-static=no
endif
extra_configure_switches += --enable-shared=yes


ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_A1X_GLIBC)  $(TOOLCHAIN_A2X_GLIBC)    \
                             $(TOOLCHAIN_H3_GLIBC)   $(TOOLCHAIN_RK328X_GLIBC) \
                             $(TOOLCHAIN_S8XX_GLIBC) $(TOOLCHAIN_IMX6_GLIBC)   \
                             $(TOOLCHAIN_OMAP543X_GLIBC)),)
gpgrt_lock_t_name = arm-unknown-linux-gnueabihf
endif
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_H5_GLIBC)     $(TOOLCHAIN_RK33XX_GLIBC) \
                             $(TOOLCHAIN_RK339X_GLIBC) $(TOOLCHAIN_S9XX_GLIBC)),)
gpgrt_lock_t_name = aarch64-unknown-linux-gnu
endif
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_JZ47XX_GLIBC) $(TOOLCHAIN_P5600_GLIBC)),)
gpgrt_lock_t_name = mipsel-unknown-linux-gnu
endif
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_R1000_GLIBC)),)
gpgrt_lock_t_name = sparc64-unknown-linux-gnu
endif
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_POWER8_GLIBC) $(TOOLCHAIN_POWER9_GLIBC)),)
gpgrt_lock_t_name = powerpc64-unknown-linux-gnu
endif
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_POWER8LE_GLIBC) $(TOOLCHAIN_POWER9LE_GLIBC)),)
gpgrt_lock_t_name = powerpc64le-unknown-linux-gnu
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC32)),)
gpgrt_lock_t_name = i686-pc-linux-gnu
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC64)),)
gpgrt_lock_t_name = x86_64-pc-linux-gnu
endif


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@( cd $(SRC_DIR)/src/syscfg ; \
	   ln -sf lock-obj-pub.$(gpgrt_lock_t_name).h lock-obj-pub.$(TARGET).h ; \
	 )
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(GPGERROR_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@mkdir -p $(GPGERROR_PKG)/lib$(LIBSUFFIX)
	@( cd $(GPGERROR_PKG)/usr/lib$(LIBSUFFIX) ; \
	   chmod +w lib*.so.?.*.? ; \
	   mv lib*.so.?.*.? ../../lib$(LIBSUFFIX) ; \
	   ln -sf ../../lib$(LIBSUFFIX)/lib*.so.?.*.? . ; \
	   cp -a lib*.so.? ../../lib$(LIBSUFFIX) ; \
	 )
	# ====== Install Documentation =======
	@rm -f $(GPGERROR_PKG)/usr/share/info/dir
	@gzip -9 $(GPGERROR_PKG)/usr/share/info/*
	@if [ -d $(GPGERROR_PKG)/usr/share/man ]; then \
	  ( cd $(GPGERROR_PKG)/usr/share/man ; \
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
	@mkdir -p $(GPGERROR_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING* \
	       $(GPGERROR_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(GPGERROR_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING* NEWS README* THANKS VERSION doc/HACKING \
	         $(GPGERROR_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(GPGERROR_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(GPGERROR_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libgpg-error.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(GPGERROR_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g"   libgpg-error.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libgpg-error.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" gpg-error.pc ; \
	 )
	# ======= tune gpg-error-config script to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/bin ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" gpg-error-config ; \
	 )
	# ======= Strip binaries =======
	@( cd $(GPGERROR_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifeq ($(__ENABLE_STATIC__),yes)
	@( cd $(GPGERROR_PKG) ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null ; \
	 )
endif
	@touch $@

$(GPGERROR_PKG_DESCRIPTION_FILE): $(GPGERROR_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(GPGERROR_PKG_DESCRIPTION_FILE) $(GPGERROR_PKG_INSTALL_SCRIPT)
	@cp $(GPGERROR_PKG_DESCRIPTION_FILE) $(GPGERROR_PKG)/.DESCRIPTION
	@cp $(GPGERROR_PKG_INSTALL_SCRIPT) $(GPGERROR_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GPGERROR_PKG)/.REQUIRES
	@echo "pkgname=$(GPGERROR_PKG_NAME)"                            >  $(GPGERROR_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GPGERROR_PKG_VERSION)"                          >> $(GPGERROR_PKG)/.PKGINFO ; \
	 echo "arch=$(GPGERROR_PKG_ARCH)"                               >> $(GPGERROR_PKG)/.PKGINFO ; \
	 echo "distroname=$(GPGERROR_PKG_DISTRO_NAME)"                  >> $(GPGERROR_PKG)/.PKGINFO ; \
	 echo "distrover=$(GPGERROR_PKG_DISTRO_VERSION)"                >> $(GPGERROR_PKG)/.PKGINFO ; \
	 echo "group=$(GPGERROR_PKG_GROUP)"                             >> $(GPGERROR_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GPGERROR_PKG_SHORT_DESCRIPTION)\"" >> $(GPGERROR_PKG)/.PKGINFO ; \
	 echo "url=$(GPGERROR_PKG_URL)"                                 >> $(GPGERROR_PKG)/.PKGINFO ; \
	 echo "license=$(GPGERROR_PKG_LICENSE)"                         >> $(GPGERROR_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(GPGERROR_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
