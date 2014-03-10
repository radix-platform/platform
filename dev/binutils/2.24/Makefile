
COMPONENT_TARGETS  = $(TARGET_HOST)
COMPONENT_TARGETS += $(TARGET_PC32)
COMPONENT_TARGETS += $(TARGET_PC64)
COMPONENT_TARGETS += $(TARGET_CB1X)
COMPONENT_TARGETS += $(TARGET_VIP1830)
COMPONENT_TARGETS += $(TARGET_BEAGLE)
COMPONENT_TARGETS += $(TARGET_OMAP5UEVM)
COMPONENT_TARGETS += $(TARGET_B74)

#
# The rest targets links staticaly with newlib or uclibc and not requires binutils on host
#
# COMPONENT_TARGETS += $(TARGET_CB1N)
# COMPONENT_TARGETS += $(TARGET_GUARD)
# COMPONENT_TARGETS += $(TARGET_VIP1830N)
# COMPONENT_TARGETS += $(TARGET_L17UC)
#

NEED_ABS_PATH      = true

COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = $(SRC_PACKAGE_DIR)/GNU/binutils


ifneq ($(filter $(HARDWARE),$(TARGET_HOST) $(TARGET_PC32) $(TARGET_PC64)),)
REQUIRES           = dev/kernel/x86/3.10.17-headers
endif

ifeq ($(HARDWARE),$(TARGET_CB1X))
REQUIRES           = dev/kernel/a1x/3.0.52-r2-headers
endif

ifeq ($(HARDWARE),$(TARGET_VIP1830))
REQUIRES           = dev/kernel/dm644x/2.6.36-headers
endif

ifeq ($(HARDWARE),$(TARGET_BEAGLE))
REQUIRES           = dev/kernel/omap35x/2.6.36-headers
endif

ifeq ($(HARDWARE),$(TARGET_OMAP5UEVM))
REQUIRES           = dev/kernel/omap543x/3.8.y-20140222-headers
endif

ifeq ($(HARDWARE),$(TARGET_B74))
REQUIRES           = dev/kernel/bcm74x/2.6.36-headers
endif


version            = 2.24
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/GNU/binutils/binutils-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/binutils-$(version)
src_dir_name       = binutils-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done
build_binutils_pkg = $(TARGET_BUILD_DIR)/.binutils_pkg_done


####### Targets

PKG_GROUP = dev

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
BINUTILS_DEV_PKG_NAME                = binutils
BINUTILS_DEV_PKG_VERSION             = 2.24
ifeq ($(HARDWARE),$(TARGET_HOST))
BINUTILS_DEV_PKG_ARCH                = $(shell uname -m)
else
BINUTILS_DEV_PKG_ARCH                = $(TOOLCHAIN)
endif
BINUTILS_DEV_PKG_DISTRO_NAME         = kxLab
BINUTILS_DEV_PKG_DISTRO_VERSION      = 1.0
BINUTILS_DEV_PKG_GROUP               = $(PKG_GROUP)
###                                   |---handy-ruler-------------------------------|
BINUTILS_DEV_PKG_SHORT_DESCRIPTION   = GNU Binutils $(version)
BINUTILS_DEV_PKG_URL                 = http://www.kxLab.com
BINUTILS_DEV_PKG_LICENSE             = GPLv2
BINUTILS_DEV_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(BINUTILS_DEV_PKG_NAME)-pkg-description
BINUTILS_DEV_PKG_DESCRIPTION_FILE_IN = $(BINUTILS_DEV_PKG_NAME)-pkg-description.in
BINUTILS_DEV_PKG_INSTALL_SCRIPT      = $(BINUTILS_DEV_PKG_NAME)-pkg-install.sh

BINUTILS_DEV_PKG = $(CURDIR)/$(TARGET_BUILD_DIR)/$(BINUTILS_DEV_PKG_NAME)-package

pkg_basename     = $(BINUTILS_DEV_PKG_NAME)-$(BINUTILS_DEV_PKG_VERSION)-$(BINUTILS_DEV_PKG_ARCH)-$(BINUTILS_DEV_PKG_DISTRO_NAME)-$(BINUTILS_DEV_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(BINUTILS_DEV_PKG_GROUP)/$(pkg_basename).tgz


BUILD_TARGETS    = $(build_binutils_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(BINUTILS_DEV_PKG)

ifeq ($(TOOLCHAIN),$(BUILD_TOOLCHAIN_NAME))
LIBSUFFIX=64
else
LIBSUFFIX=
endif


ifeq ($(TOOLCHAIN),$(BUILD_TOOLCHAIN_NAME))
extra_configure_switches  = '--with-pkgversion=Radix $(TOOLCHAINS_VERSION)'
extra_configure_switches += '--with-bugurl=http://www.radix.pro'
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
extra_configure_switches += --enable-targets=x86_64-kxLab-linux,x86_64-radix-linux,x86_64-kxLab-linux-gnulibc1,x86_64-kxLab-linux-gnuaout
extra_configure_switches += --enable-64-bit-bfd
extra_configure_switches += --enable-shared
extra_configure_switches += --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --docdir=/usr/share/doc
endif

ifeq ($(TOOLCHAIN),$(A1X_NEWLIB_TOOLCHAIN_NAME))
extra_configure_switches  = --enable-interwork
extra_configure_switches += --enable-multilib
extra_configure_switches += --with-cpu=cortex-a8
extra_configure_switches += --with-arch=armv7-a
extra_configure_switches += --with-fpu=neon
extra_configure_switches += --with-abi=aapcs
extra_configure_switches += --libdir=/usr/lib
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --docdir=/usr/share/doc
endif

ifeq ($(TOOLCHAIN),$(DM644X_NEWLIB_TOOLCHAIN_NAME))
extra_configure_switches  = --enable-interwork
extra_configure_switches += --enable-multilib
extra_configure_switches += --with-float=soft
extra_configure_switches += --libdir=/usr/lib
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --docdir=/usr/share/doc
endif

ifeq ($(TOOLCHAIN),$(AT91SAM7S_NEWLIB_TOOLCHAIN_NAME))
extra_configure_switches  = --enable-interwork
extra_configure_switches += --enable-multilib
extra_configure_switches += --with-float=soft
extra_configure_switches += --libdir=/usr/lib
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --docdir=/usr/share/doc
endif

ifeq ($(TOOLCHAIN),$(LPC17XX_UCLIBC_TOOLCHAIN_NAME))
extra_configure_switches  = '--with-pkgversion=Radix $(TOOLCHAINS_VERSION)'
extra_configure_switches += '--with-bugurl=http://www.radix.pro'
extra_configure_switches += --enable-interwork
extra_configure_switches += --enable-multilib
extra_configure_switches += --libdir=/usr/lib
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --docdir=/usr/share/doc
endif

ifeq ($(TOOLCHAIN),$(A1X_EGLIBC_TOOLCHAIN_NAME))
# experimental gold linker( DEFAULT_LD=ld.bfd ):
extra_configure_switches  = --enable-gold=yes
extra_configure_switches += --enable-ld=default
extra_configure_switches += --enable-werror=no
# standard options:
extra_configure_switches += --enable-interwork
extra_configure_switches += --enable-multilib
extra_configure_switches += --with-cpu=cortex-a8
extra_configure_switches += --with-arch=armv7-a
extra_configure_switches += --with-fpu=neon
extra_configure_switches += --with-abi=aapcs
extra_configure_switches += --enable-shared
extra_configure_switches += --libdir=/usr/lib
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --docdir=/usr/share/doc
endif

ifeq ($(TOOLCHAIN),$(OMAP35X_EGLIBC_TOOLCHAIN_NAME))
extra_configure_switches  = --with-cpu=cortex-a8
extra_configure_switches += --with-arch=armv7-a
extra_configure_switches += --enable-shared
extra_configure_switches += --libdir=/usr/lib
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --docdir=/usr/share/doc
endif

ifeq ($(TOOLCHAIN),$(OMAP543X_EGLIBC_TOOLCHAIN_NAME))
# experimental gold linker( DEFAULT_LD=ld.bfd ):
extra_configure_switches  = --enable-gold=yes
extra_configure_switches += --enable-ld=default
extra_configure_switches += --enable-werror=no
# standard options:
extra_configure_switches += --enable-interwork
extra_configure_switches += --enable-multilib
extra_configure_switches += --with-cpu=cortex-a15
extra_configure_switches += --with-arch=armv7-a
extra_configure_switches += --with-fpu=neon-vfpv4
extra_configure_switches += --with-abi=aapcs
extra_configure_switches += --enable-shared
extra_configure_switches += --libdir=/usr/lib
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --docdir=/usr/share/doc
endif


ifeq ($(TOOLCHAIN),$(DM644X_EGLIBC_TOOLCHAIN_NAME))
extra_configure_switches  = --enable-interwork
extra_configure_switches += --enable-multilib
extra_configure_switches += --with-float=soft
extra_configure_switches += --with-cpu=arm926ej-s
extra_configure_switches += --with-arch=armv5tej
extra_configure_switches += --with-tune=arm926ej-s
extra_configure_switches += --enable-shared
extra_configure_switches += --libdir=/usr/lib
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --docdir=/usr/share/doc
endif

ifeq ($(TOOLCHAIN),$(BCM74X_EGLIBC_TOOLCHAIN_NAME))
extra_configure_switches  = --enable-multilib
extra_configure_switches += --with-arch=mips32
extra_configure_switches += --disable-werror
extra_configure_switches += --enable-shared
extra_configure_switches += --libdir=/usr/lib
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --docdir=/usr/share/doc
endif

ifeq ($(TOOLCHAIN),$(I686_EGLIBC_TOOLCHAIN_NAME))
extra_configure_switches  = '--with-pkgversion=Radix $(TOOLCHAINS_VERSION)'
extra_configure_switches += '--with-bugurl=http://www.radix.pro'
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
extra_configure_switches += --enable-targets=i486-kxLab-linux,i486-radix-linux,i486-kxLab-linux-gnulibc1,i486-kxLab-linux-gnuaout
extra_configure_switches += --enable-shared
extra_configure_switches += --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --docdir=/usr/share/doc
endif

ifeq ($(TOOLCHAIN),$(X86_64_EGLIBC_TOOLCHAIN_NAME))
extra_configure_switches  = '--with-pkgversion=Radix $(TOOLCHAINS_VERSION)'
extra_configure_switches += '--with-bugurl=http://www.radix.pro'
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
extra_configure_switches += --enable-targets=x86_64-kxLab-linux,x86_64-radix-linux,x86_64-kxLab-linux-gnulibc1,x86_64-kxLab-linux-gnuaout
extra_configure_switches += --enable-64-bit-bfd
extra_configure_switches += --enable-shared
extra_configure_switches += --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --docdir=/usr/share/doc
endif


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
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
	$(BUILD_ENVIRONMENT) $(MAKE) -C $(build_dir) install $(env_sysroot)
	$(BUILD_ENVIRONMENT) $(MAKE) -C $(build_dir) install-info $(env_sysroot)
	@rm -f $(BINUTILS_DEV_PKG)/usr/share/info/dir
	@gzip -9 $(BINUTILS_DEV_PKG)/usr/share/info/*
	@cat $(BINUTILS_DEV_PKG)/usr/lib$(LIBSUFFIX)/libbfd.la | \
	  $(SED) -e "s|$(build_dir)\/bfd\/\.\.\/libiberty\/pic|\/usr\/lib$(LIBSUFFIX)|g" > \
	  $(BINUTILS_DEV_PKG)/usr/lib$(LIBSUFFIX)/libbfd.la.tmp && \
	  mv $(BINUTILS_DEV_PKG)/usr/lib$(LIBSUFFIX)/libbfd.la.tmp \
	     $(BINUTILS_DEV_PKG)/usr/lib$(LIBSUFFIX)/libbfd.la
	@cat $(BINUTILS_DEV_PKG)/usr/lib$(LIBSUFFIX)/libopcodes.la | \
	  $(SED) -e "s|$(build_dir)\/opcodes\/\.\.\/libiberty\/pic|\/usr\/lib$(LIBSUFFIX)|g" > \
	  $(BINUTILS_DEV_PKG)/usr/lib$(LIBSUFFIX)/libopcodes.la.tmp && \
	  mv $(BINUTILS_DEV_PKG)/usr/lib$(LIBSUFFIX)/libopcodes.la.tmp \
	     $(BINUTILS_DEV_PKG)/usr/lib$(LIBSUFFIX)/libopcodes.la
	@chmod a+x $(BINUTILS_DEV_PKG)/usr/lib$(LIBSUFFIX)/lib*.la
	@mkdir -p $(BINUTILS_DEV_PKG)/usr/doc/binutils-$(version)
	@cp -a $(SRC_DIR)/COPYING* $(SRC_DIR)/ChangeLog $(SRC_DIR)/MAI* $(SRC_DIR)/README* \
	       $(BINUTILS_DEV_PKG)/usr/doc/binutils-$(version)
	@(cd $(BINUTILS_DEV_PKG)/usr/share/man/man1; \
	  for file in *.1 ; do \
	    gzip -9 --force $$file; \
	  done )
	@( cd $(BINUTILS_DEV_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,dependency_libs=' -L.*/usr/lib$(LIBSUFFIX) -liberty',dependency_libs=' -L/usr/lib$(LIBSUFFIX) -liberty',g" libopcodes.la \
	 )
	@( cd $(BINUTILS_DEV_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,dependency_libs=' -L.*/usr/lib$(LIBSUFFIX) -liberty -lz',dependency_libs=' -L/usr/lib$(LIBSUFFIX) -liberty -lz',g" libbfd.la \
	 )
	# Install the same to $(TARGET_DEST_DIR)
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(BINUTILS_DEV_PKG) && cp -rf * $(TARGET_DEST_DIR)
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,libdir='/usr/lib$(LIBSUFFIX)',libdir='$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)',g" libopcodes.la ; \
	   sed -i "s,dependency_libs=' -L/usr/lib$(LIBSUFFIX) -liberty',dependency_libs=' -L$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) -liberty',g" libopcodes.la ; \
	   sed -i "s,libdir='/usr/lib$(LIBSUFFIX)',libdir='$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)',g" libbfd.la ; \
	   sed -i "s,dependency_libs=' -L/usr/lib$(LIBSUFFIX) -liberty -lz',dependency_libs=' -L$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) -liberty -lz',g" libbfd.la \
	 )
	# Libiberty will be installed from GCC by --enable-install-libiberty option but we need it on $(TARGET_DEST_DIR)
	@cp -a $(SRC_DIR)/include/libiberty.h $(TARGET_DEST_DIR)/usr/include/libiberty.h
	@cp -a $(build_dir)/libiberty/pic/libiberty.a $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/libiberty.a
	@(cd $(BINUTILS_DEV_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(BINUTILS_DEV_PKG_DESCRIPTION_FILE): $(BINUTILS_DEV_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(build_binutils_pkg): $(install_target) $(BINUTILS_DEV_PKG_DESCRIPTION_FILE)
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
	@$(FAKEROOT) sh -c "cd $(BINUTILS_DEV_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@
