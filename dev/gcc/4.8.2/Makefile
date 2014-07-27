
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_VIP1830)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)

#
# The rest targets links staticaly with newlib or uclibc and not requires binutils on host
#
# COMPONENT_TARGETS += $(HARDWARE_CB1N)
# COMPONENT_TARGETS += $(HARDWARE_AT91S)
# COMPONENT_TARGETS += $(HARDWARE_VIP1830N)
# COMPONENT_TARGETS += $(HARDWARE_L17UC)
#

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/GNU/gcc/gcc-4.8.2
SOURCE_REQUIRES   += sources/GNU/gmp
SOURCE_REQUIRES   += sources/GNU/mpfr
SOURCE_REQUIRES   += sources/GNU/mpc

REQUIRES           = libs/eglibc/2.19.1
REQUIRES          += dev/binutils/2.24


version               = 4.8.2
gmp_version           = 5.1.3
mpfr_version          = 3.1.2
mpc_version           = 1.0.2
tar_bz2_archive       = $(SRC_PACKAGE_PATH)/GNU/gcc/gcc-$(version)/gcc-$(version).tar.bz2
tar_bz2_archive_gmp   = $(SRC_PACKAGE_PATH)/GNU/gmp/gmp-$(gmp_version).tar.bz2
tar_bz2_archive_mpfr  = $(SRC_PACKAGE_PATH)/GNU/mpfr/mpfr-$(mpfr_version).tar.bz2
tar_gz_archive_mpc    = $(SRC_PACKAGE_PATH)/GNU/mpc/mpc-$(mpc_version).tar.gz
SRC_ARCHIVE           = $(tar_bz2_archive)
SRC_DIR               = $(TARGET_BUILD_DIR)/gcc-$(version)
src_dir_name          = gcc-$(version)
src_done              = $(TARGET_BUILD_DIR)/.source-done
gmp_src_done          = $(TARGET_BUILD_DIR)/.gmp-source-done
mpfr_src_done         = $(TARGET_BUILD_DIR)/.mpfr-source-done
mpc_src_done          = $(TARGET_BUILD_DIR)/.mpc-source-done


ifeq ($(TOOLCHAIN),$(TOOLCHAIN_X86_64_EGLIBC))
PATCHES = PATCHES.x86_64
else
PATCHES = PATCHES
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
GCC_DEV_PKG_VERSION             = 4.8.2
GCC_DEV_PKG_ARCH                = $(TOOLCHAIN)
GCC_DEV_PKG_DISTRO_NAME         = kxLab
GCC_DEV_PKG_DISTRO_VERSION      = 1.0
GCC_DEV_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
GCC_DEV_PKG_SHORT_DESCRIPTION   = GNU GCC $(version)
GCC_DEV_PKG_URL                 = $(BUG_URL)
GCC_DEV_PKG_LICENSE             = GPLv2
GCC_DEV_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GCC_DEV_PKG_NAME)-pkg-description
GCC_DEV_PKG_DESCRIPTION_FILE_IN = $(GCC_DEV_PKG_NAME)-pkg-description.in
GCC_DEV_PKG_INSTALL_SCRIPT      = $(GCC_DEV_PKG_NAME)-pkg-install.sh

GCC_DEV_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GCC_DEV_PKG_NAME)-package

pkg_basename     = $(GCC_DEV_PKG_NAME)-$(GCC_DEV_PKG_VERSION)-$(GCC_DEV_PKG_ARCH)-$(GCC_DEV_PKG_DISTRO_NAME)-$(GCC_DEV_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


# NOTE: BUILD_MULTILIB_SUFFIX related to bulld machine
#       (slacware64 - lib; ununtu64 - lib32) see $(BUILDSYSTEM)/targets.mk
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
extra_configure_switches += --disable-libunwind-exceptions
extra_configure_switches += --enable-lto
extra_configure_switches += --enable-c99
extra_configure_switches += --enable-long-long

extra_configure_switches += --with-gnu-ld
extra_configure_switches += --with-gnu-as


ifeq ($(TOOLCHAIN),$(TOOLCHAIN_A1X_EGLIBC))
extra_configure_switches += --with-cpu=cortex-a8
extra_configure_switches += --with-arch=armv7-a
extra_configure_switches += --with-fpu=neon
extra_configure_switches += --with-float=hard
extra_configure_switches += --with-abi=aapcs-linux
endif

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_OMAP35X_EGLIBC))
extra_configure_switches += --with-cpu=cortex-a8
extra_configure_switches += --with-arch=armv7-a
extra_configure_switches += --with-fpu=neon
extra_configure_switches += --with-float=hard
extra_configure_switches += --with-abi=aapcs-linux
endif

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_OMAP543X_EGLIBC))
extra_configure_switches += --with-arch=armv7-a
extra_configure_switches += --with-tune=cortex-a15
extra_configure_switches += --with-fpu=neon-vfpv4
extra_configure_switches += --with-float=hard
extra_configure_switches += --with-abi=aapcs-linux
endif

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_DM644X_EGLIBC))
extra_configure_switches += --with-float=soft
extra_configure_switches += --with-arch=armv5te
extra_configure_switches += --with-tune=arm926ej-s
extra_configure_switches += --with-dwarf2
endif

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_BCM74X_EGLIBC))
extra_configure_switches += --with-arch=mips32
extra_configure_switches += --with-float=hard
extra_configure_switches += --enable-target-optspace
endif

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_I686_EGLIBC))
extra_configure_switches += '--with-pkgversion=Radix $(SYSTEM_VERSION)'
extra_configure_switches += '--with-bugurl=http://www.radix.pro'
extra_configure_switches += --with-arch=i486
extra_configure_switches += --with-tune=i686
endif

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_X86_64_EGLIBC))
extra_configure_switches += '--with-pkgversion=Radix $(SYSTEM_VERSION)'
extra_configure_switches += '--with-bugurl=http://www.radix.pro'
extra_configure_switches += --with-multilib-list=m64,m32
endif


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(gmp_src_done): $(src_done)
	@echo "Expanding $(tar_bz2_archive_gmp)"
	@tar xjf $(tar_bz2_archive_gmp) -C $(TARGET_BUILD_DIR)
	@cd $(SRC_DIR); ln -sf ../gmp-$(gmp_version) gmp
	@touch $@

$(mpfr_src_done): $(src_done)
	@echo "Expanding $(tar_bz2_archive_mpfr)"
	@tar xjf $(tar_bz2_archive_mpfr) -C $(TARGET_BUILD_DIR)
	@cd $(SRC_DIR); ln -sf ../mpfr-$(mpfr_version) mpfr
	@touch $@

$(mpc_src_done): $(src_done)
	@echo "Expanding $(tar_gz_archive_mpc)"
	@tar xzf $(tar_gz_archive_mpc) -C $(TARGET_BUILD_DIR)
	@cd $(SRC_DIR); ln -sf ../mpc-$(mpc_version) mpc
	@touch $@

$(build_target): $(gmp_src_done) $(mpfr_src_done) $(mpc_src_done)
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
	$(BUILD_ENVIRONMENT) $(MAKE) -C $(build_dir) install $(env_sysroot)
	$(BUILD_ENVIRONMENT) $(MAKE) -C $(build_dir) install-info $(env_sysroot)
	@chmod 755 $(GCC_DEV_PKG)/usr/lib$(LIBSUFFIX)/libgcc_s.so.1
ifeq ($(TOOLCHAIN),$(TOOLCHAIN_X86_64_EGLIBC))
	@chmod 755 $(GCC_DEV_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/libgcc_s.so.1
endif
	@rm -f $(GCC_DEV_PKG)/usr/lib$(LIBSUFFIX)/*gdb.py
ifeq ($(TOOLCHAIN),$(TOOLCHAIN_X86_64_EGLIBC))
	@rm -f $(GCC_DEV_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/*gdb.py
endif
	@mkdir -p $(GCC_DEV_PKG)/lib
	# *not* LIBSUFFIX
	@( cd $(GCC_DEV_PKG) ; \
	   mkdir -p lib ; \
	   cd lib ; \
	   ln -sf ../usr/bin/cpp . \
	 )
	@mkdir -p $(GCC_DEV_PKG)/usr/include
	@cp -a $(SRC_DIR)/include/libiberty.h $(GCC_DEV_PKG)/usr/include
	@cp -a $(build_dir)/libiberty/libiberty.info $(GCC_DEV_PKG)/usr/share/info
	@cp -a $(build_dir)/gcc/specs $(GCC_DEV_PKG)/usr/lib$(LIBSUFFIX)/gcc/$(TARGET)/$(version)
	@rm -f $(GCC_DEV_PKG)/usr/share/info/dir
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
	@( cd $(GCC_DEV_PKG)/usr/lib$(LIBSUFFIX) ; \
	   if [ -f libasan.la ] ; then \
	     sed -i "s,'$(TOOLCHAIN_PATH)/.*la,,g" libasan.la ; \
	   fi ; \
	   if [ -f libtsan.la ] ; then \
	     sed -i "s,'$(TOOLCHAIN_PATH)/.*la,,g" libtsan.la ; \
	   fi \
	 )
ifeq ($(TOOLCHAIN),$(TOOLCHAIN_X86_64_EGLIBC))
	@( cd $(GCC_DEV_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	  sed -i "s,'$(TOOLCHAIN_PATH)/.*la,,g" libasan.la \
	 )
endif
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@if [ -d $(TARGET_DEST_DIR)/usr/libexec/gcc ] ; then \
	   rm -rf $(TARGET_DEST_DIR)/usr/libexec/gcc ; \
	 fi
	@if [ -d $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/gcc ] ; then \
	   rm -rf $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/gcc ; \
	 fi
	@cd $(GCC_DEV_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# tune libtool *.la search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   if [ -f libasan.la ] ; then \
	     sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libasan.la ; \
	   fi ; \
	   if [ -f libtsan.la ] ; then \
	     sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libtsan.la ; \
	   fi ; \
	   if [ -f libquadmath.la ] ; then \
	     sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libquadmath.la ; \
	   fi ; \
	   if [ -f libitm.la ] ; then \
	     sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libitm.la ; \
	   fi ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libatomic.la libgomp.la \
	                                            libmudflap.la libmudflapth.la libssp.la \
	                                            libssp_nonshared.la libstdc++.la libsupc++.la ; \
	 )
ifeq ($(TOOLCHAIN),$(TOOLCHAIN_X86_64_EGLIBC))
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
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

$(GCC_DEV_PKG_DESCRIPTION_FILE): $(GCC_DEV_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

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
	@$(FAKEROOT) sh -c "cd $(GCC_DEV_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
