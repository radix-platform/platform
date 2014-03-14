
#
# GCC has cross compilation error when host==target,
# now we can build only two targets:
#

COMPONENT_TARGETS  = $(TARGET_HOST)
#COMPONENT_TARGETS += $(TARGET_PC32)
COMPONENT_TARGETS += $(TARGET_PC64)
#COMPONENT_TARGETS += $(TARGET_CB1X)
#COMPONENT_TARGETS += $(TARGET_VIP1830)
#COMPONENT_TARGETS += $(TARGET_BEAGLE)
#COMPONENT_TARGETS += $(TARGET_OMAP5UEVM)
#COMPONENT_TARGETS += $(TARGET_B74)

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

version            = 4.8.2


SOURCE_REQUIRES    = $(SRC_PACKAGE_DIR)/GNU/gcc/gcc-$(version)


REQUIRES           = dev/binutils/2.24
REQUIRES          += libs/zlib/1.2.8
REQUIRES          += libs/gmp/5.1.3
REQUIRES          += libs/mpfr/3.1.2
REQUIRES          += libs/mpc/1.0.2
REQUIRES          += app/cloog/0.18.2
REQUIRES          += app/gettext/0.18.3.2


tar_bz2_archive    = $(SRC_PACKAGE_PATH)/GNU/gcc/gcc-$(version)/gcc-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/gcc-$(version)
src_dir_name       = gcc-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

ifeq ($(TOOLCHAIN),$(X86_64_EGLIBC_TOOLCHAIN_NAME))
PATCHES = PATCHES.x86_64
else
PATCHES = PATCHES
endif

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done
build_gcc_pkg      = $(TARGET_BUILD_DIR)/.gcc_pkg_done


####### Targets

PKG_GROUP = dev

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
GCC_DEV_PKG_NAME                = gcc
GCC_DEV_PKG_VERSION             = 4.8.2
ifeq ($(HARDWARE),$(TARGET_HOST))
GCC_DEV_PKG_ARCH                = $(shell uname -m)
else
GCC_DEV_PKG_ARCH                = $(TOOLCHAIN)
endif
GCC_DEV_PKG_DISTRO_NAME         = kxLab
GCC_DEV_PKG_DISTRO_VERSION      = 1.0
GCC_DEV_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
GCC_DEV_PKG_SHORT_DESCRIPTION   = GNU GCC $(version)
GCC_DEV_PKG_URL                 = http://www.kxLab.com
GCC_DEV_PKG_LICENSE             = GPLv2
GCC_DEV_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GCC_DEV_PKG_NAME)-pkg-description
GCC_DEV_PKG_DESCRIPTION_FILE_IN = $(GCC_DEV_PKG_NAME)-pkg-description.in
GCC_DEV_PKG_INSTALL_SCRIPT      = $(GCC_DEV_PKG_NAME)-pkg-install.sh

GCC_DEV_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GCC_DEV_PKG_NAME)-package

pkg_basename     = $(GCC_DEV_PKG_NAME)-$(GCC_DEV_PKG_VERSION)-$(GCC_DEV_PKG_ARCH)-$(GCC_DEV_PKG_DISTRO_NAME)-$(GCC_DEV_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(GCC_DEV_PKG_GROUP)/$(pkg_basename).tgz


BUILD_TARGETS    = $(build_gcc_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../build-system/core.mk


#
# find (SRC_DIR)/include/obstack.h instead of TARGET LIBC /usr/include/obstack.h
#
environment  = CFLAGS="-I../../$(src_dir_name)/include $(CFLAGS)"
environment += CXXFLAGS="-I../../$(src_dir_name)/include $(CXXFLAGS)"

#
# fake-gcc
#
ifeq ($(TOOLCHAIN),$(BUILD_TOOLCHAIN_NAME))
environment += PATH=$(TARGET_DEST_DIR)/bin:$(PATH)
endif

env_sysroot  = DESTDIR=$(GCC_DEV_PKG)


extra_configure_switches += --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --datadir=/usr/share
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --docdir=/usr/share/doc

extra_configure_switches += --enable-languages=c,c++,lto
extra_configure_switches += --enable-__cxa_atexit
extra_configure_switches += --enable-shared
extra_configure_switches += --enable-threads=posix
extra_configure_switches += --with-system-zlib
extra_configure_switches += --disable-libunwind-exceptions
extra_configure_switches += --enable-lto
extra_configure_switches += --enable-c99
extra_configure_switches += --enable-long-long

extra_configure_switches += --with-gnu-ld
extra_configure_switches += --with-gnu-as
extra_configure_switches += --enable-nls

extra_configure_switches += --with-mpc=$(TARGET_DEST_DIR)/usr
extra_configure_switches += --with-mpfr=$(TARGET_DEST_DIR)/usr
extra_configure_switches += --with-gmp=$(TARGET_DEST_DIR)/usr
extra_configure_switches += --with-cloog=$(TARGET_DEST_DIR)/usr
extra_configure_switches += --enable-install-libiberty


ifeq ($(TOOLCHAIN),$(BUILD_TOOLCHAIN_NAME))
extra_configure_switches += '--with-pkgversion=Radix $(SYSTEM_VERSION)'
extra_configure_switches += '--with-bugurl=http://www.radix.pro'
extra_configure_switches += --with-multilib-list=m64,m32
endif


ifeq ($(TOOLCHAIN),$(A1X_EGLIBC_TOOLCHAIN_NAME))
extra_configure_switches += --with-cpu=cortex-a8
extra_configure_switches += --with-arch=armv7-a
extra_configure_switches += --with-fpu=neon
extra_configure_switches += --with-abi=aapcs
extra_configure_switches += --with-dwarf2
endif

ifeq ($(TOOLCHAIN),$(OMAP35X_EGLIBC_TOOLCHAIN_NAME))
extra_configure_switches += --with-cpu=cortex-a8
extra_configure_switches += --with-arch=armv7-a
extra_configure_switches += --with-dwarf2
endif

ifeq ($(TOOLCHAIN),$(OMAP543X_EGLIBC_TOOLCHAIN_NAME))
extra_configure_switches += --with-arch=armv7-a
extra_configure_switches += --with-tune=cortex-a15
extra_configure_switches += --with-fpu=neon-vfpv4
extra_configure_switches += --with-abi=aapcs-linux
endif

ifeq ($(TOOLCHAIN),$(DM644X_EGLIBC_TOOLCHAIN_NAME))
extra_configure_switches += --with-float=soft
extra_configure_switches += --with-arch=armv5te
extra_configure_switches += --with-tune=arm926ej-s
extra_configure_switches += --with-dwarf2
endif

ifeq ($(TOOLCHAIN),$(BCM74X_EGLIBC_TOOLCHAIN_NAME))
extra_configure_switches += --with-arch=mips32
extra_configure_switches += --with-float=hard
extra_configure_switches += --enable-target-optspace
endif

ifeq ($(TOOLCHAIN),$(I686_EGLIBC_TOOLCHAIN_NAME))
extra_configure_switches += '--with-pkgversion=Radix $(SYSTEM_VERSION)'
extra_configure_switches += '--with-bugurl=http://www.radix.pro'
extra_configure_switches += --with-arch=i486
extra_configure_switches += --with-tune=i686
endif

ifeq ($(TOOLCHAIN),$(X86_64_EGLIBC_TOOLCHAIN_NAME))
extra_configure_switches += '--with-pkgversion=Radix $(SYSTEM_VERSION)'
extra_configure_switches += '--with-bugurl=http://www.radix.pro'
extra_configure_switches += --with-multilib-list=m64,m32
endif


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
ifeq ($(TOOLCHAIN),$(BUILD_TOOLCHAIN_NAME))
	@( cd $(TARGET_DEST_DIR)/bin ; \
	   ln -sf /usr/bin/c++        $(TARGET)-c++       ; \
	   ln -sf /usr/bin/g++        $(TARGET)-g++       ; \
	   ln -sf /usr/bin/gcc        $(TARGET)-gcc       ; \
	   ln -sf /usr/bin/gcc-ar     $(TARGET)-gcc-ar    ; \
	   ln -sf /usr/bin/gcc-nm     $(TARGET)-gcc-nm    ; \
	   ln -sf /usr/bin/gcc-ranlib $(TARGET)-gcc-ranlib  \
	 )
endif
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) $(environment) ../$(src_dir_name)/configure \
	  --prefix=/usr                             \
	  --build=$(BUILD)                          \
	  --host=$(TARGET)                          \
	  --target=$(TARGET)                        \
	  $(extra_configure_switches)
	$(BUILD_ENVIRONMENT) $(environment) $(MAKE) -C $(build_dir) all
	$(BUILD_ENVIRONMENT) $(environment) $(MAKE) -C $(build_dir) info
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(GCC_DEV_PKG)
	$(BUILD_ENVIRONMENT) $(environment) $(MAKE) -C $(build_dir) install $(env_sysroot)
	$(BUILD_ENVIRONMENT) $(environment) $(MAKE) -C $(build_dir) install-info $(env_sysroot)
ifeq ($(TOOLCHAIN),$(BUILD_TOOLCHAIN_NAME))
	@( cd $(TARGET_DEST_DIR)/bin ; \
	   rm -f $(TARGET)-c++       ; \
	   rm -f $(TARGET)-g++       ; \
	   rm -f $(TARGET)-gcc       ; \
	   rm -f $(TARGET)-gcc-ar    ; \
	   rm -f $(TARGET)-gcc-nm    ; \
	   rm -f $(TARGET)-gcc-ranlib  \
	 )
endif
	@rm -f $(GCC_DEV_PKG)/usr/share/info/dir
	@gzip -9 $(GCC_DEV_PKG)/usr/share/info/*
	@chmod 755 $(GCC_DEV_PKG)/usr/lib$(LIBSUFFIX)/libgcc_s.so.1
	@cp -a $(build_dir)/gcc/specs $(GCC_DEV_PKG)/usr/lib$(LIBSUFFIX)/gcc/$(TARGET)/$(version)
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
	   mv gcc gcc-$(version) ; \
	   ln -sf gcc-$(version) gcc ; \
	   ln -sf gcc cc ; \
	   rm -f c++ ; \
	   mv g++ g++-$(version) ; \
	   ln -sf g++-$(version) g++ ; \
	   ln -sf g++ c++ ; \
	   rm -f $(TARGET)-* ; \
	   ln -sf gcc-$(version) $(TARGET)-gcc ; \
	   ln -sf gcc-$(version) $(TARGET)-gcc-$(version) ; \
	   ln -sf gcc-ar $(TARGET)-gcc-ar ; \
	   ln -sf gcc-nm $(TARGET)-gcc-nm ; \
	   ln -sf gcc-ranlib $(TARGET)-gcc-ranlib ; \
	   ln -sf g++-$(version) $(TARGET)-c++ ; \
	   ln -sf g++-$(version) $(TARGET)-g++ \
	 )
	@chmod a+x $(GCC_DEV_PKG)/usr/lib$(LIBSUFFIX)/lib*.la
	@mkdir -p $(GCC_DEV_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING* \
	       $(GCC_DEV_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(GCC_DEV_PKG)/usr/share/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING* $(SRC_DIR)/MAI* $(SRC_DIR)/NEWS $(SRC_DIR)/README \
	       $(GCC_DEV_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(GCC_DEV_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# remove target destination path from target libtool *.la files
	@( cd $(GCC_DEV_PKG)/usr/libexec/gcc/$(TARGET)/$(version) ; \
	  sed -i "s,$(TARGET_DEST_DIR),,g" liblto_plugin.la \
	 )
	# remove toolchain path from target libtool *.la files
ifeq ($(TOOLCHAIN),$(BUILD_TOOLCHAIN_NAME))
	@( cd $(GCC_DEV_PKG)/usr/lib$(LIBSUFFIX) ; \
	  sed -i "s,'$(TOOLCHAIN_PATH)/.*la ,,g" libasan.la libtsan.la \
	 )
else
	@( cd $(GCC_DEV_PKG)/usr/lib$(LIBSUFFIX) ; \
	  sed -i "s,'$(TOOLCHAIN_PATH)/.*la,,g" libasan.la libtsan.la \
	 )
endif
ifeq ($(TOOLCHAIN),$(X86_64_EGLIBC_TOOLCHAIN_NAME))
	@( cd $(GCC_DEV_PKG)/usr/lib32 ; \
	  sed -i "s,'$(TOOLCHAIN_PATH)/.*la,,g" libasan.la \
	 )
endif
ifeq ($(TOOLCHAIN),$(BUILD_TOOLCHAIN_NAME))
	@( cd $(GCC_DEV_PKG)/usr/lib ; \
	  sed -i "s,'$(TOOLCHAIN_PATH)/.*la ,,g" libasan.la \
	 )
endif
	# Install the same to $(TARGET_DEST_DIR)
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(GCC_DEV_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# tune libtool *.la search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libasan.la libatomic.la libgomp.la libitm.la \
	                                            libmudflap.la libmudflapth.la libquadmath.la libssp.la \
	                                            libssp_nonshared.la libstdc++.la libsupc++.la libtsan.la ; \
	 )
ifeq ($(TOOLCHAIN),$(X86_64_EGLIBC_TOOLCHAIN_NAME))
	@( cd $(TARGET_DEST_DIR)/usr/lib32 ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libasan.la libatomic.la libgomp.la libitm.la \
	                                            libmudflap.la libmudflapth.la libquadmath.la libssp.la \
	                                            libssp_nonshared.la libstdc++.la libsupc++.la ; \
	 )
endif
ifeq ($(TOOLCHAIN),$(BUILD_TOOLCHAIN_NAME))
	@( cd $(TARGET_DEST_DIR)/usr/lib ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libasan.la libatomic.la libgomp.la libitm.la \
	                                            libmudflap.la libmudflapth.la libquadmath.la libssp.la \
	                                            libssp_nonshared.la libstdc++.la libsupc++.la ; \
	 )
endif
	@( cd $(TARGET_DEST_DIR)/usr/libexec/gcc/$(TARGET)/$(version) ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" liblto_plugin.la ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" liblto_plugin.la \
	 )
	@(cd $(GCC_DEV_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@
	exit 1

$(GCC_DEV_PKG_DESCRIPTION_FILE): $(GCC_DEV_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(build_gcc_pkg): $(install_target) $(GCC_DEV_PKG_DESCRIPTION_FILE)
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
	@$(FAKEROOT) sh -c "cd $(GCC_DEV_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@