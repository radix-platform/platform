
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


SOURCE_REQUIRES    = sources/GNU/gcc/gcc-6.5.0

REQUIRES           = dev/binutils/2.31.1
REQUIRES          += libs/isl/0.18
REQUIRES          += libs/mpc/1.1.0
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_POWER8_GLIBC) $(TOOLCHAIN_POWER9_GLIBC)),)
REQUIRES          += libs/isl/0.18-ppc32
REQUIRES          += libs/mpc/1.1.0-ppc32
endif
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_R1000_GLIBC)),)
REQUIRES          += libs/isl/0.18-sparc32
REQUIRES          += libs/mpc/1.1.0-sparc32
endif
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC)),)
REQUIRES          += libs/isl/0.18-x86_32
REQUIRES          += libs/mpc/1.1.0-x86_32
endif

# ======= __END_OF_REQUIRES__ =======


version               = 6.5.0

tar_xz_archive        = $(SRC_PACKAGE_PATH)/GNU/gcc/gcc-$(version)/gcc-$(version).tar.xz
SRC_ARCHIVE           = $(tar_xz_archive)
SRC_DIR               = $(TARGET_BUILD_DIR)/gcc-$(version)
src_dir_name          = gcc-$(version)
src_done              = $(TARGET_BUILD_DIR)/.source-done

PATCHES     = PATCHES

ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_H5_GLIBC)     \
                             $(TOOLCHAIN_RK33XX_GLIBC) \
                             $(TOOLCHAIN_RK339X_GLIBC) \
                             $(TOOLCHAIN_S9XX_GLIBC)),)
OPT_PATCHES = PATCHES.aarch64
endif
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_R1000_GLIBC)),)
OPT_PATCHES = PATCHES.sparc
endif
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_POWER8_GLIBC) $(TOOLCHAIN_POWER8LE_GLIBC) \
                             $(TOOLCHAIN_POWER9_GLIBC) $(TOOLCHAIN_POWER9LE_GLIBC)),)
OPT_PATCHES = PATCHES.powerpc
endif
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC)),)
OPT_PATCHES = PATCHES.x86_64
endif

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = dev

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
GCC_DEV_PKG_NAME                = gcc
GCC_DEV_PKG_VERSION             = 6.5.0
GCC_DEV_PKG_ARCH                = $(TOOLCHAIN)
GCC_DEV_PKG_DISTRO_NAME         = $(DISTRO_NAME)
GCC_DEV_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
GCC_DEV_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
GCC_DEV_PKG_SHORT_DESCRIPTION   = GNU Compiler Collection
GCC_DEV_PKG_URL                 = $(BUG_URL)
GCC_DEV_PKG_LICENSE             = GPLv2
GCC_DEV_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GCC_DEV_PKG_NAME)-pkg-description
GCC_DEV_PKG_DESCRIPTION_FILE_IN = $(GCC_DEV_PKG_NAME)-pkg-description.in
GCC_DEV_PKG_INSTALL_SCRIPT      = $(GCC_DEV_PKG_NAME)-pkg-install.sh

GCC_DEV_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GCC_DEV_PKG_NAME)-package

pkg_basename     = $(GCC_DEV_PKG_NAME)-$(GCC_DEV_PKG_VERSION)-$(GCC_DEV_PKG_ARCH)-$(GCC_DEV_PKG_DISTRO_NAME)-$(GCC_DEV_PKG_DISTRO_VERSION)

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

#
# NOTE: BUILD_MULTILIB_SUFFIX related to bulld machine
#       (slacware64 - lib; ununtu64 - lib32) see $(BUILDSYSTEM)/targets.mk
#
export CC_FOR_BUILD       = gcc
export CXX_FOR_BUILD      = g++
export LD_FOR_BUILD       = ld
export AR_FOR_BUILD       = ar
export AS_FOR_BUILD       = as
export NM_FOR_BUILD       = nm
export CFLAGS_FOR_BUILD   = -I/usr/include
export CXXFLAGS_FOR_BUILD = -I/usr/include
export CPPFLAGS_FOR_BUILD = -I/usr/include
export LDFLAGS_FOR_BUILD  = -L/usr/lib$(BUILD_MULTILIB_SUFFIX)

export GNATBIND           = $(TOOLCHAIN_PATH)/bin/$(TARGET)-gnatbind
export GNATLINK           = $(TOOLCHAIN_PATH)/bin/$(TARGET)-gnatlink
export GNATMAKE           = $(TOOLCHAIN_PATH)/bin/$(TARGET)-gnatmake
#
# Do not use CCACHE for Ada/tools:
#
export GCC_FOR_GNAT       = $(TOOLCHAIN_PATH)/bin/$(TARGET)-gcc --sysroot=$(TARGET_DEST_DIR)
export GCC_LINK_FOR_GNAT  = $(TOOLCHAIN_PATH)/bin/$(TARGET)-g++ --sysroot=$(TARGET_DEST_DIR)


env_sysroot  = DESTDIR=$(GCC_DEV_PKG)


extra_configure_switches += --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --datadir=/usr/share
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --docdir=/usr/share/doc

extra_configure_switches += --enable-languages=c,c++,objc,obj-c++,fortran,go,lto,ada
extra_configure_switches += --enable-libstdcxx-dual-abi
extra_configure_switches += --with-default-libstdcxx-abi=new
extra_configure_switches += --enable-__cxa_atexit
extra_configure_switches += --disable-install-libiberty
extra_configure_switches += --enable-shared
extra_configure_switches += --enable-threads=posix
extra_configure_switches += --enable-lto
extra_configure_switches += --enable-c99
extra_configure_switches += --enable-long-long

extra_configure_switches += --with-system-zlib
extra_configure_switches += --with-mpc=$(TARGET_DEST_DIR)/usr
extra_configure_switches += --with-mpfr=$(TARGET_DEST_DIR)/usr
extra_configure_switches += --with-gmp=$(TARGET_DEST_DIR)/usr
extra_configure_switches += --with-isl=$(TARGET_DEST_DIR)/usr

# Python 2.7 (The location to install Python modules. This path should NOT include the prefix):
extra_configure_switches += --with-python-dir=/lib$(LIBSUFFIX)/python2.7/site-packages

#
# for target libgo:
#
extra_configure_switches += --enable-werror=no

extra_configure_switches += --with-gnu-ld
extra_configure_switches += --with-gnu-as


ifeq ($(TOOLCHAIN),$(TOOLCHAIN_A1X_GLIBC))
extra_configure_switches += '--with-pkgversion=$(DISTRO_NAME) $(SYSTEM_VERSION)'
extra_configure_switches += '--with-bugurl=$(BUG_URL)'
extra_configure_switches += --with-arch=armv7-a
extra_configure_switches += --with-tune=cortex-a8
extra_configure_switches += --with-fpu=neon
extra_configure_switches += --with-float=hard
extra_configure_switches += --with-abi=aapcs-linux
extra_configure_switches += --disable-isl-version-check
endif

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_A2X_GLIBC))
extra_configure_switches += '--with-pkgversion=$(DISTRO_NAME) $(SYSTEM_VERSION)'
extra_configure_switches += '--with-bugurl=$(BUG_URL)'
extra_configure_switches += --with-arch=armv7ve
extra_configure_switches += --with-tune=cortex-a7
extra_configure_switches += --with-fpu=neon-vfpv4
extra_configure_switches += --with-float=hard
extra_configure_switches += --with-abi=aapcs-linux
extra_configure_switches += --disable-isl-version-check
endif

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_H3_GLIBC))
extra_configure_switches += '--with-pkgversion=$(DISTRO_NAME) $(SYSTEM_VERSION)'
extra_configure_switches += '--with-bugurl=$(BUG_URL)'
extra_configure_switches += --with-arch=armv7ve
extra_configure_switches += --with-tune=cortex-a7
extra_configure_switches += --with-fpu=neon-vfpv4
extra_configure_switches += --with-float=hard
extra_configure_switches += --with-abi=aapcs-linux
extra_configure_switches += --disable-isl-version-check
endif

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_H5_GLIBC))
extra_configure_switches += '--with-pkgversion=$(DISTRO_NAME) $(SYSTEM_VERSION)'
extra_configure_switches += '--with-bugurl=$(BUG_URL)'
extra_configure_switches += --with-arch=armv8-a
extra_configure_switches += --with-cpu=cortex-a53
extra_configure_switches += --with-abi=lp64
extra_configure_switches += --enable-fix-cortex-a53-835769
extra_configure_switches += --enable-fix-cortex-a53-843419
extra_configure_switches += --disable-isl-version-check
extra_configure_switches += --disable-libstdcxx-pch
endif

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_RK328X_GLIBC))
extra_configure_switches += '--with-pkgversion=$(DISTRO_NAME) $(SYSTEM_VERSION)'
extra_configure_switches += '--with-bugurl=$(BUG_URL)'
extra_configure_switches += --with-arch=armv7ve
extra_configure_switches += --with-tune=cortex-a17
extra_configure_switches += --with-fpu=neon-vfpv4
extra_configure_switches += --with-float=hard
extra_configure_switches += --with-abi=aapcs-linux
extra_configure_switches += --disable-isl-version-check
endif

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_S8XX_GLIBC))
extra_configure_switches += '--with-pkgversion=$(DISTRO_NAME) $(SYSTEM_VERSION)'
extra_configure_switches += '--with-bugurl=$(BUG_URL)'
extra_configure_switches += --with-arch=armv7-a
extra_configure_switches += --with-tune=cortex-a5
extra_configure_switches += --with-fpu=neon
extra_configure_switches += --with-float=hard
extra_configure_switches += --with-abi=aapcs-linux
extra_configure_switches += --disable-isl-version-check
endif

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_S9XX_GLIBC))
extra_configure_switches += '--with-pkgversion=$(DISTRO_NAME) $(SYSTEM_VERSION)'
extra_configure_switches += '--with-bugurl=$(BUG_URL)'
extra_configure_switches += --with-arch=armv8-a
extra_configure_switches += --with-cpu=cortex-a53
extra_configure_switches += --with-abi=lp64
extra_configure_switches += --enable-fix-cortex-a53-835769
extra_configure_switches += --enable-fix-cortex-a53-843419
extra_configure_switches += --disable-isl-version-check
extra_configure_switches += --disable-libstdcxx-pch
endif

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_RK33XX_GLIBC))
extra_configure_switches += '--with-pkgversion=$(DISTRO_NAME) $(SYSTEM_VERSION)'
extra_configure_switches += '--with-bugurl=$(BUG_URL)'
extra_configure_switches += --with-arch=armv8-a
extra_configure_switches += --with-cpu=cortex-a53
extra_configure_switches += --with-abi=lp64
extra_configure_switches += --enable-fix-cortex-a53-835769
extra_configure_switches += --enable-fix-cortex-a53-843419
extra_configure_switches += --disable-isl-version-check
extra_configure_switches += --disable-libstdcxx-pch
endif

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_RK339X_GLIBC))
extra_configure_switches += '--with-pkgversion=$(DISTRO_NAME) $(SYSTEM_VERSION)'
extra_configure_switches += '--with-bugurl=$(BUG_URL)'
extra_configure_switches += --with-arch=armv8-a
extra_configure_switches += --with-cpu=cortex-a72.cortex-a53
extra_configure_switches += --with-abi=lp64
extra_configure_switches += --enable-fix-cortex-a53-835769
extra_configure_switches += --enable-fix-cortex-a53-843419
extra_configure_switches += --disable-isl-version-check
extra_configure_switches += --disable-libstdcxx-pch
endif

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_IMX6_GLIBC))
extra_configure_switches += '--with-pkgversion=$(DISTRO_NAME) $(SYSTEM_VERSION)'
extra_configure_switches += '--with-bugurl=$(BUG_URL)'
extra_configure_switches += --with-arch=armv7-a
extra_configure_switches += --with-tune=cortex-a9
extra_configure_switches += --with-fpu=vfpv3
extra_configure_switches += --with-float=hard
extra_configure_switches += --with-mode=thumb
extra_configure_switches += --with-abi=aapcs-linux
extra_configure_switches += --disable-isl-version-check
extra_configure_switches += --disable-libstdcxx-pch
extra_configure_switches += --enable-linker-build-id
extra_configure_switches += --enable-gnu-unique-object
endif

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_OMAP543X_GLIBC))
extra_configure_switches += '--with-pkgversion=$(DISTRO_NAME) $(SYSTEM_VERSION)'
extra_configure_switches += '--with-bugurl=$(BUG_URL)'
extra_configure_switches += --with-arch=armv7-a
extra_configure_switches += --with-tune=cortex-a15
extra_configure_switches += --with-fpu=neon-vfpv4
extra_configure_switches += --with-float=hard
extra_configure_switches += --with-mode=thumb
extra_configure_switches += --with-abi=aapcs-linux
extra_configure_switches += --disable-isl-version-check
extra_configure_switches += --disable-libstdcxx-pch
extra_configure_switches += --enable-linker-build-id
extra_configure_switches += --enable-gnu-unique-object
endif

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_JZ47XX_GLIBC))
extra_configure_switches += '--with-pkgversion=$(DISTRO_NAME) $(SYSTEM_VERSION)'
extra_configure_switches += '--with-bugurl=$(BUG_URL)'
extra_configure_switches += --with-arch-32=mips32r2
extra_configure_switches += --with-arch-64=mips64r2
extra_configure_switches += --with-float=hard
extra_configure_switches += --with-mips-plt
extra_configure_switches += --enable-target-optspace
extra_configure_switches += --enable-symvers=gnu
extra_configure_switches += --disable-isl-version-check
extra_configure_switches += --disable-libstdcxx-pch
endif

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_P5600_GLIBC))
extra_configure_switches += '--with-pkgversion=$(DISTRO_NAME) $(SYSTEM_VERSION)'
extra_configure_switches += '--with-bugurl=$(BUG_URL)'
extra_configure_switches += --with-arch=mips32r5
extra_configure_switches += --with-tune=p5600
extra_configure_switches += --with-float=hard
extra_configure_switches += --with-mips-plt
extra_configure_switches += --enable-target-optspace
extra_configure_switches += --enable-symvers=gnu
extra_configure_switches += --disable-isl-version-check
extra_configure_switches += --disable-libstdcxx-pch
endif

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_POWER8_GLIBC))
extra_configure_switches += '--with-pkgversion=$(DISTRO_NAME) $(SYSTEM_VERSION)'
extra_configure_switches += '--with-bugurl=$(BUG_URL)'
extra_configure_switches += --with-cpu-32=power8
extra_configure_switches += --with-tune-32=power8
extra_configure_switches += --with-cpu-64=power8
extra_configure_switches += --with-tune-64=power8
extra_configure_switches += --with-long-double-128
# gnu-indirect-function available for i[3456]86*|x86_64*|ppc*|ppc64*|s390*|arm*|aarch64*|mips* targets:
extra_configure_switches += --enable-gnu-indirect-function
extra_configure_switches += --enable-secureplt
extra_configure_switches += --disable-isl-version-check
extra_configure_switches += --with-multilib-list=m64,m32
endif

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_POWER9_GLIBC))
extra_configure_switches += '--with-pkgversion=$(DISTRO_NAME) $(SYSTEM_VERSION)'
extra_configure_switches += '--with-bugurl=$(BUG_URL)'
extra_configure_switches += --with-cpu-32=power9
extra_configure_switches += --with-tune-32=power9
extra_configure_switches += --with-cpu-64=power9
extra_configure_switches += --with-tune-64=power9
extra_configure_switches += --with-long-double-128
# gnu-indirect-function available for i[3456]86*|x86_64*|ppc*|ppc64*|s390*|arm*|aarch64*|mips* targets:
extra_configure_switches += --enable-gnu-indirect-function
extra_configure_switches += --enable-secureplt
extra_configure_switches += --disable-isl-version-check
extra_configure_switches += --with-multilib-list=m64,m32
endif

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_POWER8LE_GLIBC))
extra_configure_switches += '--with-pkgversion=$(DISTRO_NAME) $(SYSTEM_VERSION)'
extra_configure_switches += '--with-bugurl=$(BUG_URL)'
extra_configure_switches += --with-cpu=power8
extra_configure_switches += --with-tune=power8
extra_configure_switches += --with-long-double-128
# gnu-indirect-function available for i[3456]86*|x86_64*|ppc*|ppc64*|s390*|arm*|aarch64*|mips* targets:
extra_configure_switches += --enable-gnu-indirect-function
extra_configure_switches += --enable-secureplt
extra_configure_switches += --disable-isl-version-check
extra_configure_switches += --disable-multilib
endif

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_POWER9LE_GLIBC))
extra_configure_switches += '--with-pkgversion=$(DISTRO_NAME) $(SYSTEM_VERSION)'
extra_configure_switches += '--with-bugurl=$(BUG_URL)'
extra_configure_switches += --with-cpu=power9
extra_configure_switches += --with-tune=power9
extra_configure_switches += --with-long-double-128
# gnu-indirect-function available for i[3456]86*|x86_64*|ppc*|ppc64*|s390*|arm*|aarch64*|mips* targets:
extra_configure_switches += --enable-gnu-indirect-function
extra_configure_switches += --enable-secureplt
extra_configure_switches += --disable-isl-version-check
extra_configure_switches += --disable-multilib
endif

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_R1000_GLIBC))
extra_configure_switches += '--with-pkgversion=$(DISTRO_NAME) $(SYSTEM_VERSION)'
extra_configure_switches += '--with-bugurl=$(BUG_URL)'
extra_configure_switches += --with-cpu=ultrasparc3
extra_configure_switches += --with-tune=ultrasparc3
extra_configure_switches += --with-long-double-128
extra_configure_switches += --disable-isl-version-check
extra_configure_switches += --disable-libstdcxx-pch
extra_configure_switches += --disable-linux-futex
extra_configure_switches += --enable-multilib
endif

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_I686_GLIBC))
extra_configure_switches += '--with-pkgversion=$(DISTRO_NAME) $(SYSTEM_VERSION)'
extra_configure_switches += '--with-bugurl=$(BUG_URL)'
extra_configure_switches += --with-arch=i686
extra_configure_switches += --with-tune=i686
extra_configure_switches += --disable-isl-version-check
extra_configure_switches += --disable-libstdcxx-pch
extra_configure_switches += --disable-libmpx
endif

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC))
extra_configure_switches += '--with-pkgversion=$(DISTRO_NAME) $(SYSTEM_VERSION)'
extra_configure_switches += '--with-bugurl=$(BUG_URL)'
extra_configure_switches += --disable-isl-version-check
extra_configure_switches += --disable-libstdcxx-pch
extra_configure_switches += --disable-libmpx
extra_configure_switches += --with-multilib-list=m64,m32
endif



####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_H5_GLIBC)     $(TOOLCHAIN_RK33XX_GLIBC)   \
                             $(TOOLCHAIN_RK339X_GLIBC) $(TOOLCHAIN_S9XX_GLIBC)     \
                             $(TOOLCHAIN_R1000_GLIBC)                              \
                             $(TOOLCHAIN_POWER8_GLIBC) $(TOOLCHAIN_POWER8LE_GLIBC) \
                             $(TOOLCHAIN_POWER9_GLIBC) $(TOOLCHAIN_POWER9LE_GLIBC) \
                             $(TOOLCHAIN_X86_64_GLIBC)),)
	$(call apply-opt-patches, $(SRC_DIR))
endif
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr                             \
	  --build=$(BUILD)                          \
	  --host=$(TARGET)                          \
	  --target=$(TARGET)                        \
	  $(extra_configure_switches)
	$(BUILD_ENVIRONMENT) $(MAKE) -C $(build_dir) all
	$(BUILD_ENVIRONMENT) $(MAKE) -C $(build_dir) info
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(GCC_DEV_PKG)
	$(BUILD_ENVIRONMENT) $(MAKE) -C $(build_dir) -j1 install $(env_sysroot)
	$(BUILD_ENVIRONMENT) $(MAKE) -C $(build_dir) -j1 install-info $(env_sysroot)
	@chmod 755 $(GCC_DEV_PKG)/usr/lib$(LIBSUFFIX)/libgcc_s.so.1
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_POWER8_GLIBC) \
                             $(TOOLCHAIN_POWER9_GLIBC)),)
	@chmod 755 $(GCC_DEV_PKG)/usr/lib$(MULTILIB_PPC32_SUFFIX)/libgcc_s.so.1
endif
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_R1000_GLIBC)),)
	@chmod 755 $(GCC_DEV_PKG)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/libgcc_s.so.1
endif
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC)),)
	@chmod 755 $(GCC_DEV_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/libgcc_s.so.1
endif
	@rm -f $(GCC_DEV_PKG)/usr/lib$(LIBSUFFIX)/*gdb.py
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_POWER8_GLIBC) \
                             $(TOOLCHAIN_POWER9_GLIBC)),)
	@rm -f $(GCC_DEV_PKG)/usr/lib$(MULTILIB_PPC32_SUFFIX)/*gdb.py
endif
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_R1000_GLIBC)),)
	@rm -f $(GCC_DEV_PKG)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/*gdb.py
endif
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC)),)
	@rm -f $(GCC_DEV_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/*gdb.py
endif
	# ====== Create cpp symbolic link in the '/lib' directory without LIBSUFFIX =======
	@( cd $(GCC_DEV_PKG) ; \
	   mkdir -p lib ; \
	   cd lib ; \
	   ln -sf ../usr/bin/cpp . \
	 )
	# ======= Install Documentation =======
	@cp -a $(build_dir)/gcc/specs $(GCC_DEV_PKG)/usr/lib$(LIBSUFFIX)/gcc/$(TARGET)/$(version)
	@rm -f $(GCC_DEV_PKG)/usr/share/info/dir
	# ======= Remove info for gmp, libffi, mpc, mpfr =======
	@rm -f $(GCC_DEV_PKG)/usr/share/info/{gmp,libffi,mpc,mpfr}.*
	@gzip -9 $(GCC_DEV_PKG)/usr/share/info/*
	@if [ -d $(GCC_DEV_PKG)/usr/share/man ]; then \
	  ( cd $(GCC_DEV_PKG)/usr/share/man ; \
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
	@( cd $(GCC_DEV_PKG)/usr/share/man/man1 ; \
	   ln -sf g++.1.gz c++.1.gz ; \
	   ln -sf gcc.1.gz cc.1.gz \
	 )
	@( cd $(GCC_DEV_PKG)/usr/bin ; \
	   mv g++ g++-$(version) ; \
	   ln -sf g++-$(version) g++ ; \
	   rm -f c++ ; \
	   ln -sf g++ c++ ; \
	   mv gcc gcc-$(version) ; \
	   ln -sf gcc-$(version) gcc ; \
	   ln -sf gcc cc ; \
	   rm -f $(TARGET)-* ; \
	   ln -sf g++-$(version) $(TARGET)-c++ ; \
	   ln -sf g++-$(version) $(TARGET)-g++ ; \
	   ln -sf gcc-$(version) $(TARGET)-gcc ; \
	   ln -sf gcc-$(version) $(TARGET)-gcc-$(version) ; \
	   ln -sf gcc-ar $(TARGET)-gcc-ar ; \
	   ln -sf gcc-nm $(TARGET)-gcc-nm ; \
	   ln -sf gcc-ranlib $(TARGET)-gcc-ranlib ; \
	   ln -sf gccgo $(TARGET)-gccgo ; \
	   mv gfortran gfortran-gcc-$(version) ; \
	   ln -sf gfortran-gcc-$(version) gfortran ; \
	   ln -sf gfortran-gcc-$(version) $(TARGET)-gfortran ; \
	   ln -sf gfortran-gcc-$(version) $(TARGET)-gfortran-$(version) ; \
	   ln -sf gfortran-gcc-$(version) $(TARGET)-g77 ; \
	   ln -sf gfortran-gcc-$(version) $(TARGET)-g95 ; \
	 )
	@chmod a+x $(GCC_DEV_PKG)/usr/lib$(LIBSUFFIX)/lib*.la
	@mkdir -p $(GCC_DEV_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING* \
	       $(GCC_DEV_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(GCC_DEV_PKG)/usr/share/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING* $(SRC_DIR)/MAI* \
	       $(SRC_DIR)/NEWS $(SRC_DIR)/README $(SRC_DIR)/ChangeLog.jit \
	       $(GCC_DEV_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(GCC_DEV_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove target destination path from target libtool *.la files =======
	@( cd $(GCC_DEV_PKG)/usr/libexec/gcc/$(TARGET)/$(version) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" liblto_plugin.la \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(GCC_DEV_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for lib in asan cilkrts lsan tsan ubsan vtv ; do \
	     if [ -f lib$$lib.la ] ; then \
	       sed -i "s,$(TOOLCHAIN_PATH)/$(TARGET),/usr,g" lib$$lib.la ; \
	     fi ; \
	   done \
	 )
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_POWER8_GLIBC) \
                             $(TOOLCHAIN_POWER9_GLIBC)),)
	@( cd $(GCC_DEV_PKG)/usr/lib$(MULTILIB_PPC32_SUFFIX) ; \
	   for lib in asan cilkrts lsan tsan ubsan vtv ; do \
	     if [ -f lib$$lib.la ] ; then \
	       sed -i "s,$(TOOLCHAIN_PATH)/$(TARGET),/usr,g" lib$$lib.la ; \
	     fi ; \
	   done \
	 )
endif
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_R1000_GLIBC)),)
	@( cd $(GCC_DEV_PKG)/usr/lib$(MULTILIB_SPARC32_SUFFIX) ; \
	   for lib in asan cilkrts lsan tsan ubsan vtv ; do \
	     if [ -f lib$$lib.la ] ; then \
	       sed -i "s,$(TOOLCHAIN_PATH)/$(TARGET),/usr,g" lib$$lib.la ; \
	     fi ; \
	   done \
	 )
endif
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC)),)
	@( cd $(GCC_DEV_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for lib in asan cilkrts lsan tsan ubsan vtv ; do \
	     if [ -f lib$$lib.la ] ; then \
	       sed -i "s,$(TOOLCHAIN_PATH)/$(TARGET),/usr,g" lib$$lib.la ; \
	     fi ; \
	   done \
	 )
endif
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@if [ -d $(TARGET_DEST_DIR)/usr/libexec/gcc ] ; then \
	   rm -rf $(TARGET_DEST_DIR)/usr/libexec/gcc ; \
	 fi
	@if [ -d $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/gcc ] ; then \
	   rm -rf $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/gcc ; \
	 fi
	@if [ -d $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/go/$(version) ] ; then \
	   rm -rf $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/go/$(version) ; \
	 fi
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_POWER8_GLIBC) \
                             $(TOOLCHAIN_POWER9_GLIBC)),)
	@if [ -d $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_PPC32_SUFFIX)/go/$(version) ] ; then \
	   rm -rf $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_PPC32_SUFFIX)/go/$(version) ; \
	 fi
endif
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_R1000_GLIBC)),)
	@if [ -d $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/go/$(version) ] ; then \
	   rm -rf $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/go/$(version) ; \
	 fi
endif
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC)),)
	@if [ -d $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/go/$(version) ] ; then \
	   rm -rf $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/go/$(version) ; \
	 fi
endif
	$(call install-into-devenv, $(GCC_DEV_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/libexec/gcc/$(TARGET)/$(version) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" liblto_plugin.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" liblto_plugin.la \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/gcc/$(TARGET)/$(version) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libcaf_single.la ; \
	 )
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_POWER8_GLIBC) \
                             $(TOOLCHAIN_POWER9_GLIBC)),)
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/gcc/$(TARGET)/$(version)/$(MULTILIB_PPC32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libcaf_single.la ; \
	 )
endif
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_R1000_GLIBC)),)
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/gcc/$(TARGET)/$(version)/$(MULTILIB_SPARC32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libcaf_single.la ; \
	 )
endif
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC)),)
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/gcc/$(TARGET)/$(version)/$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libcaf_single.la ; \
	 )
endif
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   for lib in asan atomic cilkrts gfortran go gomp gomp-plugin-host_nonshm itm lsan objc \
	              quadmath mudflap mudflapth ssp ssp_nonshared stdc++ stdc++fs supc++ tsan ubsan vtv ; do \
	     if [ -f lib$$lib.la ] ; then \
	       sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" lib$$lib.la ; \
	     fi ; \
	   done \
	 )
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_POWER8_GLIBC) \
                             $(TOOLCHAIN_POWER9_GLIBC)),)
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_PPC32_SUFFIX) ; \
	   for lib in asan atomic cilkrts gfortran go gomp gomp-plugin-host_nonshm itm lsan objc \
	              quadmath mudflap mudflapth ssp ssp_nonshared stdc++ stdc++fs supc++ tsan ubsan vtv ; do \
	     if [ -f lib$$lib.la ] ; then \
	       sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" lib$$lib.la ; \
	     fi ; \
	   done \
	 )
endif
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_R1000_GLIBC)),)
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_SPARC32_SUFFIX) ; \
	   for lib in asan atomic cilkrts gfortran go gomp gomp-plugin-host_nonshm itm lsan objc \
	              quadmath mudflap mudflapth ssp ssp_nonshared stdc++ stdc++fs supc++ tsan ubsan vtv ; do \
	     if [ -f lib$$lib.la ] ; then \
	       sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" lib$$lib.la ; \
	     fi ; \
	   done \
	 )
endif
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC)),)
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for lib in asan atomic cilkrts gfortran go gomp gomp-plugin-host_nonshm itm lsan objc \
	              quadmath mudflap mudflapth ssp ssp_nonshared stdc++ stdc++fs supc++ tsan ubsan vtv ; do \
	     if [ -f lib$$lib.la ] ; then \
	       sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" lib$$lib.la ; \
	     fi ; \
	   done \
	 )
endif
	# ======= Strip binaries =======
	@( cd $(GCC_DEV_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_R1000_GLIBC)  \
                             $(TOOLCHAIN_POWER8_GLIBC) \
                             $(TOOLCHAIN_POWER9_GLIBC) \
                             $(TOOLCHAIN_X86_64_GLIBC)),)
	@( cd $(GCC_DEV_PKG)/usr/lib$(LIBSUFFIX) ; \
	   target_rpath="/lib/../lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)" ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TOOLCHAIN_PATH)" ; then \
	       $(CHRPATH) -r $${target_rpath} $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
else
	@( cd $(GCC_DEV_PKG)/usr/lib$(LIBSUFFIX) ; \
	   target_rpath="/lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)" ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TOOLCHAIN_PATH)" ; then \
	       $(CHRPATH) -r $${target_rpath} $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_POWER8_GLIBC) \
                             $(TOOLCHAIN_POWER9_GLIBC)),)
	@( cd $(GCC_DEV_PKG)/usr/lib$(MULTILIB_PPC32_SUFFIX) ; \
	   target_rpath="/lib/../lib$(MULTILIB_PPC32_SUFFIX):/usr/lib/../lib$(MULTILIB_PPC32_SUFFIX)" ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TOOLCHAIN_PATH)" ; then \
	       $(CHRPATH) -r $${target_rpath} $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_R1000_GLIBC)),)
	@( cd $(GCC_DEV_PKG)/usr/lib$(MULTILIB_SPARC32_SUFFIX) ; \
	   target_rpath="/lib/../lib$(MULTILIB_SPARC32_SUFFIX):/usr/lib/../lib$(MULTILIB_SPARC32_SUFFIX)" ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TOOLCHAIN_PATH)" ; then \
	       $(CHRPATH) -r $${target_rpath} $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC)),)
	@( cd $(GCC_DEV_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   target_rpath="/lib/../lib$(MULTILIB_X86_32_SUFFIX):/usr/lib/../lib$(MULTILIB_X86_32_SUFFIX)" ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TOOLCHAIN_PATH)" ; then \
	       $(CHRPATH) -r $${target_rpath} $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
endif
	@touch $@

$(GCC_DEV_PKG_DESCRIPTION_FILE): $(GCC_DEV_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(GCC_DEV_PKG_DESCRIPTION_FILE) $(GCC_DEV_PKG_INSTALL_SCRIPT)
	@cp $(GCC_DEV_PKG_DESCRIPTION_FILE) $(GCC_DEV_PKG)/.DESCRIPTION
	@cp $(GCC_DEV_PKG_INSTALL_SCRIPT) $(GCC_DEV_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GCC_DEV_PKG)/.REQUIRES
	@echo "pkgname=$(GCC_DEV_PKG_NAME)"                            >  $(GCC_DEV_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GCC_DEV_PKG_VERSION)"                          >> $(GCC_DEV_PKG)/.PKGINFO ; \
	 echo "arch=$(GCC_DEV_PKG_ARCH)"                               >> $(GCC_DEV_PKG)/.PKGINFO ; \
	 echo "distroname=$(GCC_DEV_PKG_DISTRO_NAME)"                  >> $(GCC_DEV_PKG)/.PKGINFO ; \
	 echo "distrover=$(GCC_DEV_PKG_DISTRO_VERSION)"                >> $(GCC_DEV_PKG)/.PKGINFO ; \
	 echo "group=$(GCC_DEV_PKG_GROUP)"                             >> $(GCC_DEV_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GCC_DEV_PKG_SHORT_DESCRIPTION)\"" >> $(GCC_DEV_PKG)/.PKGINFO ; \
	 echo "url=$(GCC_DEV_PKG_URL)"                                 >> $(GCC_DEV_PKG)/.PKGINFO ; \
	 echo "license=$(GCC_DEV_PKG_LICENSE)"                         >> $(GCC_DEV_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(GCC_DEV_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
