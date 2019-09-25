
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


SOURCE_REQUIRES    = sources/GNU/binutils

REQUIRES           = libs/zlib/1.2.8
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_POWER8_GLIBC) $(TOOLCHAIN_POWER9_GLIBC)),)
REQUIRES          += libs/zlib/1.2.8-ppc32
endif
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_R1000_GLIBC)),)
REQUIRES          += libs/zlib/1.2.8-sparc32
endif
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC)),)
REQUIRES          += libs/zlib/1.2.8-x86_32
endif

# ======= __END_OF_REQUIRES__ =======


version            = 2.31.1
tar_xz_archive     = $(SRC_PACKAGE_PATH)/GNU/binutils/binutils-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/binutils-$(version)
src_dir_name       = binutils-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = dev

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
BINUTILS_DEV_PKG_NAME                = binutils
BINUTILS_DEV_PKG_VERSION             = 2.31.1
BINUTILS_DEV_PKG_ARCH                = $(TOOLCHAIN)
BINUTILS_DEV_PKG_DISTRO_NAME         = $(DISTRO_NAME)
BINUTILS_DEV_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
BINUTILS_DEV_PKG_GROUP               = $(PKG_GROUP)
###                                   |---handy-ruler-------------------------------|
BINUTILS_DEV_PKG_SHORT_DESCRIPTION   = GNU binary development tools
BINUTILS_DEV_PKG_URL                 = $(BUG_URL)
BINUTILS_DEV_PKG_LICENSE             = GPLv2
BINUTILS_DEV_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(BINUTILS_DEV_PKG_NAME)-pkg-description
BINUTILS_DEV_PKG_DESCRIPTION_FILE_IN = $(BINUTILS_DEV_PKG_NAME)-pkg-description.in
BINUTILS_DEV_PKG_INSTALL_SCRIPT      = $(BINUTILS_DEV_PKG_NAME)-pkg-install.sh

BINUTILS_DEV_PKG = $(CURDIR)/$(TARGET_BUILD_DIR)/$(BINUTILS_DEV_PKG_NAME)-package

pkg_basename     = $(BINUTILS_DEV_PKG_NAME)-$(BINUTILS_DEV_PKG_VERSION)-$(BINUTILS_DEV_PKG_ARCH)-$(BINUTILS_DEV_PKG_DISTRO_NAME)-$(BINUTILS_DEV_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(BINUTILS_DEV_PKG)

DEFAULT_LD  = ld.bfd

#
# Common controls for components:
#
extra_configure_switches  = --disable-dependency-tracking
extra_configure_switches += --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --enable-shared
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --docdir=/usr/share/doc

# NOTE:
#   --enable-threads, --enable-plugins - are GOLD related options
#   --enable-multilib - default 'yes'

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_A1X_GLIBC))
extra_configure_switches += '--with-pkgversion=$(DISTRO_NAME) $(SYSTEM_VERSION)'
extra_configure_switches += '--with-bugurl=$(BUG_URL)'
# experimental gold linker( DEFAULT_LD=ld.bfd ):
extra_configure_switches += --enable-gold=yes
extra_configure_switches += --enable-ld=default
extra_configure_switches += --enable-werror=no
# standard options:
extra_configure_switches += --enable-interwork
extra_configure_switches += --enable-multilib
extra_configure_switches += --with-cpu=cortex-a8
extra_configure_switches += --with-arch=armv7-a
extra_configure_switches += --with-fpu=neon
extra_configure_switches += --with-abi=aapcs-linux
extra_configure_switches += --enable-threads
extra_configure_switches += --enable-plugins
extra_configure_switches += --enable-targets=$(TARGET),arm-radix-linux-gnu
endif

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_A2X_GLIBC))
extra_configure_switches += '--with-pkgversion=$(DISTRO_NAME) $(SYSTEM_VERSION)'
extra_configure_switches += '--with-bugurl=$(BUG_URL)'
# experimental gold linker( DEFAULT_LD=ld.bfd ):
extra_configure_switches += --enable-gold=yes
extra_configure_switches += --enable-ld=default
extra_configure_switches += --enable-werror=no
# standard options:
extra_configure_switches += --enable-interwork
extra_configure_switches += --enable-multilib
extra_configure_switches += --with-cpu=cortex-a7
extra_configure_switches += --with-arch=armv7ve
extra_configure_switches += --with-fpu=neon-vfpv4
extra_configure_switches += --with-abi=aapcs-linux
extra_configure_switches += --enable-threads
extra_configure_switches += --enable-plugins
extra_configure_switches += --enable-targets=$(TARGET),arm-radix-linux-gnu
endif

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_H3_GLIBC))
extra_configure_switches += '--with-pkgversion=$(DISTRO_NAME) $(SYSTEM_VERSION)'
extra_configure_switches += '--with-bugurl=$(BUG_URL)'
# experimental gold linker( DEFAULT_LD=ld.bfd ):
extra_configure_switches += --enable-gold=yes
extra_configure_switches += --enable-ld=default
extra_configure_switches += --enable-werror=no
# standard options:
extra_configure_switches += --enable-interwork
extra_configure_switches += --enable-multilib
extra_configure_switches += --with-arch=armv7ve
extra_configure_switches += --with-tune=cortex-a7
extra_configure_switches += --with-fpu=neon-vfpv4
extra_configure_switches += --with-abi=aapcs-linux
extra_configure_switches += --enable-threads
extra_configure_switches += --enable-plugins
extra_configure_switches += --enable-targets=$(TARGET),arm-radix-linux-gnu
endif

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_H5_GLIBC))
extra_configure_switches += '--with-pkgversion=$(DISTRO_NAME) $(SYSTEM_VERSION)'
extra_configure_switches += '--with-bugurl=$(BUG_URL)'
# experimental gold linker( DEFAULT_LD=ld.bfd ):
extra_configure_switches += --enable-gold=yes
extra_configure_switches += --enable-ld=default
extra_configure_switches += --enable-werror=no
# standard options:
extra_configure_switches += --disable-multilib
extra_configure_switches += --with-cpu=cortex-a53
extra_configure_switches += --with-arch=armv8-a
extra_configure_switches += --with-fpu=neon-fp-armv8
extra_configure_switches += --with-abi=lp64
extra_configure_switches += --enable-threads
extra_configure_switches += --enable-plugins
extra_configure_switches += --enable-targets=$(TARGET),arm-radix-linux-gnu
endif

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_RK328X_GLIBC))
extra_configure_switches += '--with-pkgversion=$(DISTRO_NAME) $(SYSTEM_VERSION)'
extra_configure_switches += '--with-bugurl=$(BUG_URL)'
# experimental gold linker( DEFAULT_LD=ld.bfd ):
extra_configure_switches += --enable-gold=yes
extra_configure_switches += --enable-ld=default
extra_configure_switches += --enable-werror=no
# standard options:
extra_configure_switches += --enable-interwork
extra_configure_switches += --enable-multilib
extra_configure_switches += --with-cpu=cortex-a17
extra_configure_switches += --with-arch=armv7ve
extra_configure_switches += --with-fpu=neon-vfpv4
extra_configure_switches += --with-abi=aapcs-linux
extra_configure_switches += --enable-threads
extra_configure_switches += --enable-plugins
extra_configure_switches += --enable-targets=$(TARGET),arm-radix-linux-gnu
endif

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_RK33XX_GLIBC))
extra_configure_switches += '--with-pkgversion=$(DISTRO_NAME) $(SYSTEM_VERSION)'
extra_configure_switches += '--with-bugurl=$(BUG_URL)'
# experimental gold linker( DEFAULT_LD=ld.bfd ):
extra_configure_switches += --enable-gold=yes
extra_configure_switches += --enable-ld=default
extra_configure_switches += --enable-werror=no
# standard options:
extra_configure_switches += --disable-multilib
extra_configure_switches += --with-cpu=cortex-a53
extra_configure_switches += --with-arch=armv8-a
extra_configure_switches += --with-fpu=neon-fp-armv8
extra_configure_switches += --with-abi=lp64
extra_configure_switches += --enable-threads
extra_configure_switches += --enable-plugins
extra_configure_switches += --enable-targets=$(TARGET),arm-radix-linux-gnu
endif

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_RK339X_GLIBC))
extra_configure_switches += '--with-pkgversion=$(DISTRO_NAME) $(SYSTEM_VERSION)'
extra_configure_switches += '--with-bugurl=$(BUG_URL)'
# experimental gold linker( DEFAULT_LD=ld.bfd ):
extra_configure_switches += --enable-gold=yes
extra_configure_switches += --enable-ld=default
extra_configure_switches += --enable-werror=no
# standard options:
extra_configure_switches += --disable-multilib
extra_configure_switches += --with-cpu=cortex-a53
extra_configure_switches += --with-arch=armv8-a
extra_configure_switches += --with-fpu=neon-fp-armv8
extra_configure_switches += --with-abi=lp64
extra_configure_switches += --enable-threads
extra_configure_switches += --enable-plugins
extra_configure_switches += --enable-targets=$(TARGET),arm-radix-linux-gnu
endif

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_S8XX_GLIBC))
extra_configure_switches += '--with-pkgversion=$(DISTRO_NAME) $(SYSTEM_VERSION)'
extra_configure_switches += '--with-bugurl=$(BUG_URL)'
# experimental gold linker( DEFAULT_LD=ld.bfd ):
extra_configure_switches += --enable-gold=yes
extra_configure_switches += --enable-ld=default
extra_configure_switches += --enable-werror=no
# standard options:
extra_configure_switches += --enable-interwork
extra_configure_switches += --enable-multilib
extra_configure_switches += --with-cpu=cortex-a5
extra_configure_switches += --with-arch=armv7-a
extra_configure_switches += --with-fpu=neon
extra_configure_switches += --with-abi=aapcs-linux
extra_configure_switches += --enable-threads
extra_configure_switches += --enable-plugins
extra_configure_switches += --enable-targets=$(TARGET),arm-radix-linux-gnu
endif

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_S9XX_GLIBC))
extra_configure_switches += '--with-pkgversion=$(DISTRO_NAME) $(SYSTEM_VERSION)'
extra_configure_switches += '--with-bugurl=$(BUG_URL)'
# experimental gold linker( DEFAULT_LD=ld.bfd ):
extra_configure_switches += --enable-gold=yes
extra_configure_switches += --enable-ld=default
extra_configure_switches += --enable-werror=no
# standard options:
extra_configure_switches += --disable-multilib
extra_configure_switches += --with-cpu=cortex-a53
extra_configure_switches += --with-arch=armv8-a
extra_configure_switches += --with-fpu=neon-fp-armv8
extra_configure_switches += --with-abi=lp64
extra_configure_switches += --enable-threads
extra_configure_switches += --enable-plugins
extra_configure_switches += --enable-targets=$(TARGET),aarch64-radix-linux-gnu
endif

ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_IMX6_GLIBC)),)
extra_configure_switches += '--with-pkgversion=$(DISTRO_NAME) $(SYSTEM_VERSION)'
extra_configure_switches += '--with-bugurl=$(BUG_URL)'
# experimental gold linker( DEFAULT_LD=ld.bfd ):
extra_configure_switches += --enable-gold=yes
extra_configure_switches += --enable-ld=default
extra_configure_switches += --enable-werror=no
# standard options:
extra_configure_switches += --enable-interwork
extra_configure_switches += --enable-multilib
extra_configure_switches += --with-arch=armv7-a
extra_configure_switches += --with-tune=cortex-a9
extra_configure_switches += --with-fpu=vfpv3
extra_configure_switches += --with-abi=aapcs-linux
extra_configure_switches += --enable-threads
extra_configure_switches += --enable-plugins
extra_configure_switches += --enable-targets=$(TARGET),arm-radix-linux-gnu
endif

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_OMAP543X_GLIBC))
extra_configure_switches += '--with-pkgversion=$(DISTRO_NAME) $(SYSTEM_VERSION)'
extra_configure_switches += '--with-bugurl=$(BUG_URL)'
# experimental gold linker( DEFAULT_LD=ld.bfd ):
extra_configure_switches += --enable-gold=yes
extra_configure_switches += --enable-ld=default
extra_configure_switches += --enable-werror=no
# standard options:
extra_configure_switches += --enable-interwork
extra_configure_switches += --enable-multilib
extra_configure_switches += --with-arch=armv7-a
extra_configure_switches += --with-tune=cortex-a15
extra_configure_switches += --with-fpu=neon-vfpv4
extra_configure_switches += --with-abi=aapcs-linux
extra_configure_switches += --enable-threads
extra_configure_switches += --enable-plugins
extra_configure_switches += --enable-targets=$(TARGET),arm-radix-linux-gnu
endif

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_JZ47XX_GLIBC))
extra_configure_switches += '--with-pkgversion=$(DISTRO_NAME) $(SYSTEM_VERSION)'
extra_configure_switches += '--with-bugurl=$(BUG_URL)'
extra_configure_switches += --with-arch=mips32r2
extra_configure_switches += --enable-multilib
extra_configure_switches += --enable-werror=no
extra_configure_switches += --enable-plugins
extra_configure_switches += --enable-targets=$(TARGET),mipsel-radix-linux-gnu
endif

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_P5600_GLIBC))
extra_configure_switches += '--with-pkgversion=$(DISTRO_NAME) $(SYSTEM_VERSION)'
extra_configure_switches += '--with-bugurl=$(BUG_URL)'
extra_configure_switches += --with-arch=mips32r5
extra_configure_switches += --with-tune=p5600
extra_configure_switches += --enable-multilib
extra_configure_switches += --enable-werror=no
extra_configure_switches += --enable-plugins
extra_configure_switches += --enable-targets=$(TARGET),mipsel-radix-linux-gnu
endif

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_POWER8_GLIBC))
extra_configure_switches += '--with-pkgversion=$(DISTRO_NAME) $(SYSTEM_VERSION)'
extra_configure_switches += '--with-bugurl=$(BUG_URL)'
# experimental gold linker( DEFAULT_LD=ld.bfd ):
extra_configure_switches += --enable-gold=yes
extra_configure_switches += --enable-ld=default
extra_configure_switches += --enable-werror=no
# standard options:
extra_configure_switches += --enable-multilib
extra_configure_switches += --enable-64-bit-bfd
extra_configure_switches += --enable-threads
extra_configure_switches += --enable-plugins
extra_configure_switches += --enable-targets=$(TARGET),ppc64-$(DISTRO_NAME)-linux,powerpc64-$(DISTRO_NAME)-linux,ppc-$(DISTRO_NAME)-linux,powerpc-$(DISTRO_NAME)-linux,ppc64-linux,powerpc64-linux,ppc-linux,powerpc-linux
endif

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_POWER9_GLIBC))
extra_configure_switches += '--with-pkgversion=$(DISTRO_NAME) $(SYSTEM_VERSION)'
extra_configure_switches += '--with-bugurl=$(BUG_URL)'
# experimental gold linker( DEFAULT_LD=ld.bfd ):
extra_configure_switches += --enable-gold=yes
extra_configure_switches += --enable-ld=default
extra_configure_switches += --enable-werror=no
# standard options:
extra_configure_switches += --enable-multilib
extra_configure_switches += --enable-64-bit-bfd
extra_configure_switches += --enable-threads
extra_configure_switches += --enable-plugins
extra_configure_switches += --enable-targets=$(TARGET),ppc64-$(DISTRO_NAME)-linux,powerpc64-$(DISTRO_NAME)-linux,ppc-$(DISTRO_NAME)-linux,powerpc-$(DISTRO_NAME)-linux,ppc64-linux,powerpc64-linux,ppc-linux,powerpc-linux
endif

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_POWER8LE_GLIBC))
extra_configure_switches += '--with-pkgversion=$(DISTRO_NAME) $(SYSTEM_VERSION)'
extra_configure_switches += '--with-bugurl=$(BUG_URL)'
# experimental gold linker( DEFAULT_LD=ld.bfd ):
extra_configure_switches += --enable-gold=yes
extra_configure_switches += --enable-ld=default
extra_configure_switches += --enable-werror=no
# standard options:
extra_configure_switches += --enable-multilib
extra_configure_switches += --enable-64-bit-bfd
extra_configure_switches += --enable-threads
extra_configure_switches += --enable-plugins
extra_configure_switches += --enable-targets=$(TARGET),ppc64le-$(DISTRO_NAME)-linux,powerpc64le-$(DISTRO_NAME)-linux,ppcle-$(DISTRO_NAME)-linux,powerpcle-$(DISTRO_NAME)-linux,ppc64le-linux,powerpc64le-linux,ppcle-linux,powerpcle-linux
endif

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_POWER9LE_GLIBC))
extra_configure_switches += '--with-pkgversion=$(DISTRO_NAME) $(SYSTEM_VERSION)'
extra_configure_switches += '--with-bugurl=$(BUG_URL)'
# experimental gold linker( DEFAULT_LD=ld.bfd ):
extra_configure_switches += --enable-gold=yes
extra_configure_switches += --enable-ld=default
extra_configure_switches += --enable-werror=no
# standard options:
extra_configure_switches += --enable-multilib
extra_configure_switches += --enable-64-bit-bfd
extra_configure_switches += --enable-threads
extra_configure_switches += --enable-plugins
extra_configure_switches += --enable-targets=$(TARGET),ppc64le-$(DISTRO_NAME)-linux,powerpc64le-$(DISTRO_NAME)-linux,ppcle-$(DISTRO_NAME)-linux,powerpcle-$(DISTRO_NAME)-linux,ppc64le-linux,powerpc64le-linux,ppcle-linux,powerpcle-linux
endif

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_R1000_GLIBC))
extra_configure_switches += '--with-pkgversion=$(DISTRO_NAME) $(SYSTEM_VERSION)'
extra_configure_switches += '--with-bugurl=$(BUG_URL)'
# experimental gold linker( DEFAULT_LD=ld.bfd ):
extra_configure_switches += --enable-gold=yes
extra_configure_switches += --enable-ld=default
extra_configure_switches += --enable-werror=no
# standard options:
extra_configure_switches += --enable-multilib
extra_configure_switches += --enable-64-bit-bfd
extra_configure_switches += --enable-threads
extra_configure_switches += --enable-plugins
extra_configure_switches += --enable-targets=$(TARGET),sparc64-$(DISTRO_NAME)-linux,sparc64-linux,sparc-$(DISTRO_NAME)-linux,sparc-linux
endif

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_I686_GLIBC))
extra_configure_switches += '--with-pkgversion=$(DISTRO_NAME) $(SYSTEM_VERSION)'
extra_configure_switches += '--with-bugurl=$(BUG_URL)'
# experimental gold linker( DEFAULT_LD=ld.bfd ):
extra_configure_switches += --enable-gold=yes
extra_configure_switches += --enable-ld=default
extra_configure_switches += --enable-werror=no
# The --enable-initfini-array option was added in binutils-2.21.51.0.3.
# This option currently causes a world of hurt trying to compile glibc,
# and might break static libraries or cause other ill effects.  There
# is an upstream patch for glibc but it does not avoid all of the known
# problems (and there may be some unknown ones, too), so we will avoid
# introducing this feature for now.
# References:
# http://sourceware.org/bugzilla/show_bug.cgi?id=12343
# http://gcc.gnu.org/bugzilla/show_bug.cgi?id=46770
extra_configure_switches += --disable-initfini-array
# standard options:
extra_configure_switches += --enable-threads
extra_configure_switches += --enable-plugins
extra_configure_switches += --enable-targets=$(TARGET),i686-$(DISTRO_NAME)-linux-gnu
endif

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC))
extra_configure_switches += '--with-pkgversion=$(DISTRO_NAME) $(SYSTEM_VERSION)'
extra_configure_switches += '--with-bugurl=$(BUG_URL)'
# experimental gold linker( DEFAULT_LD=ld.bfd ):
extra_configure_switches += --enable-gold=yes
extra_configure_switches += --enable-ld=default
extra_configure_switches += --enable-werror=no
# The --enable-initfini-array option was added in binutils-2.21.51.0.3.
# This option currently causes a world of hurt trying to compile glibc,
# and might break static libraries or cause other ill effects.  There
# is an upstream patch for glibc but it does not avoid all of the known
# problems (and there may be some unknown ones, too), so we will avoid
# introducing this feature for now.
# References:
# http://sourceware.org/bugzilla/show_bug.cgi?id=12343
# http://gcc.gnu.org/bugzilla/show_bug.cgi?id=46770
extra_configure_switches += --disable-initfini-array
# standard options:
extra_configure_switches += --enable-multilib
extra_configure_switches += --enable-64-bit-bfd
extra_configure_switches += --enable-threads
extra_configure_switches += --enable-plugins
extra_configure_switches += --enable-targets=$(TARGET),x86_64-$(DISTRO_NAME)-linux
extra_configure_switches += --enable-shared
endif


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_POWER8_GLIBC)   \
                             $(TOOLCHAIN_POWER9_GLIBC)   \
                             $(TOOLCHAIN_POWER8LE_GLIBC) \
                             $(TOOLCHAIN_POWER9LE_GLIBC)),)
	# ======= On ppc64 and aarch64, we might use 64KiB pages =======
	@( cd $(SRC_DIR) ; \
	   sed -i -e '/#define.*ELF_COMMONPAGESIZE/s/0x1000$/0x10000/' bfd/elf*ppc.c ; \
	   sed -i -e '/common_pagesize/s/4 /64 /' gold/powerpc.cc ; \
	 )
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
	$(BUILD_ENVIRONMENT) $(MAKE) -C $(build_dir)
	$(BUILD_ENVIRONMENT) $(MAKE) -C $(build_dir) info
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(BINUTILS_DEV_PKG)
	$(BUILD_ENVIRONMENT) $(MAKE) -j1 -C $(build_dir) install $(env_sysroot)
	$(BUILD_ENVIRONMENT) $(MAKE) -j1 -C $(build_dir) install-info $(env_sysroot)
	# ======= Differentiate between BSD strings (util-linux) and GNU strings =======
	@( cd $(BINUTILS_DEV_PKG)/usr/bin ; \
	   mv strings strings-GNU ; \
	 )
	@( cd $(BINUTILS_DEV_PKG)/usr/share/man/man1 ; \
	   mv strings.1 strings-GNU.1 ; \
	 )
	# ======= Remove unneeded man pages =======
	@rm -f $(BINUTILS_DEV_PKG)/usr/share/man/man1/{dlltool,windmc,windres}.1
	# ======= Install Documentation =======
	@rm -f $(BINUTILS_DEV_PKG)/usr/share/info/dir
	@gzip -9 $(BINUTILS_DEV_PKG)/usr/share/info/*
	@if [ -d $(BINUTILS_DEV_PKG)/usr/share/man ]; then \
	  ( cd $(BINUTILS_DEV_PKG)/usr/share/man ; \
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
	@chmod a+x $(BINUTILS_DEV_PKG)/usr/lib$(LIBSUFFIX)/lib*.la
	@mkdir -p $(BINUTILS_DEV_PKG)/usr/doc/binutils-$(version)
	@cp -a $(SRC_DIR)/COPYING* \
	       $(BINUTILS_DEV_PKG)/usr/doc/binutils-$(version)
	@mkdir -p $(BINUTILS_DEV_PKG)/usr/share/doc/binutils-$(version)
	@cp -a $(SRC_DIR)/COPYING* $(SRC_DIR)/MAI* $(SRC_DIR)/README* \
	       $(BINUTILS_DEV_PKG)/usr/share/doc/binutils-$(version)
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(BINUTILS_DEV_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove target destination path from target libtool *.la files =======
	@( cd $(BINUTILS_DEV_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libbfd.la libopcodes.la \
	 )
	# ======= remove (-L/usr/lib$(LIBSUFFIX) already set) libiberty.a search path in libtool *.la files too =======
	@( cd $(BINUTILS_DEV_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,-L$(CURDIR)/$(build_dir)/bfd/../libiberty/pic,,g" libbfd.la ; \
	   sed -i "s,-L$(CURDIR)/$(build_dir)/opcodes/../libiberty/pic,,g" libopcodes.la \
	 )
	@if [ -r $(BINUTILS_DEV_PKG)/usr/bin/$(DEFAULT_LD) ] ; then \
	   ( cd $(BINUTILS_DEV_PKG)/usr/bin ; rm -f ld ; ln -sf $(DEFAULT_LD) ld ) \
	 fi
	@mv $(BINUTILS_DEV_PKG)/usr/$(TARGET)/lib/ldscripts $(BINUTILS_DEV_PKG)/usr/lib$(LIBSUFFIX)
	@( cd $(BINUTILS_DEV_PKG)/usr/$(TARGET) ; \
	   rm -rf lib ; \
	   ln -s ../lib$(LIBSUFFIX) . ; \
	   for FILE in ar as ld ld.bfd ld.gold nm objcopy objdump ranlib readelf strip ; do \
	     if [ -r ../bin/$$FILE ]; then \
	       rm -f bin/$$FILE ; \
	       ln -s ../../bin/$$FILE bin/$$FILE ; \
	     fi ; \
	   done \
	 )
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_POWER8_GLIBC) $(TOOLCHAIN_POWER9_GLIBC)),)
	@mkdir -p $(BINUTILS_DEV_PKG)/usr/lib{$(MULTILIB_PPC32_SUFFIX),$(LIBSUFFIX)}
	@ln -sf ../lib$(LIBSUFFIX) $(BINUTILS_DEV_PKG)/usr/$(TARGET)/lib64
	@ln -sf ../lib$(MULTILIB_PPC32_SUFFIX) $(BINUTILS_DEV_PKG)/usr/$(TARGET)/lib32
endif
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_R1000_GLIBC)),)
	@mkdir -p $(BINUTILS_DEV_PKG)/usr/lib{$(MULTILIB_SPARC32_SUFFIX),$(LIBSUFFIX)}
	@ln -sf ../lib$(LIBSUFFIX) $(BINUTILS_DEV_PKG)/usr/$(TARGET)/lib64
	@ln -sf ../lib$(MULTILIB_SPARC32_SUFFIX) $(BINUTILS_DEV_PKG)/usr/$(TARGET)/lib32
endif
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC)),)
	@mkdir -p $(BINUTILS_DEV_PKG)/usr/lib{$(MULTILIB_X86_32_SUFFIX),$(LIBSUFFIX)}
	@ln -sf ../lib$(LIBSUFFIX) $(BINUTILS_DEV_PKG)/usr/$(TARGET)/lib64
	@ln -sf ../lib$(MULTILIB_X86_32_SUFFIX) $(BINUTILS_DEV_PKG)/usr/$(TARGET)/lib32
endif
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_S9XX_GLIBC)   \
                             $(TOOLCHAIN_RK33XX_GLIBC) \
                             $(TOOLCHAIN_RK339X_GLIBC)),)
	@ln -sf ../lib$(LIBSUFFIX) $(BINUTILS_DEV_PKG)/usr/$(TARGET)/lib64
endif
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(BINUTILS_DEV_PKG))
	# ======= Libiberty will be installed from GCC by --enable-install-libiberty option
	# ======= we don't need LIBIBERTY on $(TARGET_DEST_DIR) until GCC will be built
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libbfd.la libopcodes.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libbfd.la libopcodes.la \
	 )
	# ======= Strip binaries =======
	@( cd $(BINUTILS_DEV_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(BINUTILS_DEV_PKG)/usr/bin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(BINUTILS_DEV_PKG_DESCRIPTION_FILE): $(BINUTILS_DEV_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(BINUTILS_DEV_PKG_DESCRIPTION_FILE) $(BINUTILS_DEV_PKG_INSTALL_SCRIPT)
	@cp $(BINUTILS_DEV_PKG_DESCRIPTION_FILE) $(BINUTILS_DEV_PKG)/.DESCRIPTION
	@cp $(BINUTILS_DEV_PKG_INSTALL_SCRIPT) $(BINUTILS_DEV_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(BINUTILS_DEV_PKG)/.REQUIRES
	@echo "pkgname=$(BINUTILS_DEV_PKG_NAME)"                            >  $(BINUTILS_DEV_PKG)/.PKGINFO ; \
	 echo "pkgver=$(BINUTILS_DEV_PKG_VERSION)"                          >> $(BINUTILS_DEV_PKG)/.PKGINFO ; \
	 echo "arch=$(BINUTILS_DEV_PKG_ARCH)"                               >> $(BINUTILS_DEV_PKG)/.PKGINFO ; \
	 echo "distroname=$(BINUTILS_DEV_PKG_DISTRO_NAME)"                  >> $(BINUTILS_DEV_PKG)/.PKGINFO ; \
	 echo "distrover=$(BINUTILS_DEV_PKG_DISTRO_VERSION)"                >> $(BINUTILS_DEV_PKG)/.PKGINFO ; \
	 echo "group=$(BINUTILS_DEV_PKG_GROUP)"                             >> $(BINUTILS_DEV_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(BINUTILS_DEV_PKG_SHORT_DESCRIPTION)\"" >> $(BINUTILS_DEV_PKG)/.PKGINFO ; \
	 echo "url=$(BINUTILS_DEV_PKG_URL)"                                 >> $(BINUTILS_DEV_PKG)/.PKGINFO ; \
	 echo "license=$(BINUTILS_DEV_PKG_LICENSE)"                         >> $(BINUTILS_DEV_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(BINUTILS_DEV_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
