
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXV)
COMPONENT_TARGETS += $(HARDWARE_P201)
COMPONENT_TARGETS += $(HARDWARE_NEXBOX_A95X)
COMPONENT_TARGETS += $(HARDWARE_ODROID_C2)
COMPONENT_TARGETS += $(HARDWARE_P212)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_VIM)
COMPONENT_TARGETS += $(HARDWARE_Q201)
COMPONENT_TARGETS += $(HARDWARE_ENYBOX_X2)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/GNU/gcc/gcc-5.3.0
SOURCE_REQUIRES   += sources/packages/j/antlr-runtime
SOURCE_REQUIRES   += sources/packages/j/ecj


REQUIRES           = dev/gcc/5.3.0
REQUIRES          += libs/libart-lgpl/2.3.21
REQUIRES          += app/fastjar/0.98
REQUIRES          += libs/alsa-lib/1.1.1
REQUIRES          += X11/X.org/lib/libXtst/1.2.2
REQUIRES          += X11/libs/gtk+2/2.24.25

# ======= __END_OF_REQUIRES__ =======


version               = 5.3.0

antlr_version         = 3.5.2
ecj_version           = 4.9
jversion              = 16

tar_bz2_archive       = $(SRC_PACKAGE_PATH)/GNU/gcc/gcc-$(version)/gcc-$(version).tar.bz2
jar_archive_antlr     = $(SRC_PACKAGE_PATH)/packages/j/antlr-runtime/antlr-runtime-$(antlr_version).jar
jar_archive_ecj       = $(SRC_PACKAGE_PATH)/packages/j/ecj/ecj-$(ecj_version).jar
SRC_ARCHIVE           = $(tar_bz2_archive)
SRC_DIR               = $(TARGET_BUILD_DIR)/gcc-$(version)
src_dir_name          = gcc-$(version)
doc_dir_name          = gcc-java-$(version)
src_done              = $(TARGET_BUILD_DIR)/.source-done
antlr_src_done        = $(TARGET_BUILD_DIR)/.antlr-source-done
ecj_src_done          = $(TARGET_BUILD_DIR)/.ecj-source-done

ANTLR_RUNTIME_JAR     = $(CURDIR)/$(SRC_DIR)/antlr-runtime-$(antlr_version).jar
ECJ_JAR               = $(CURDIR)/$(SRC_DIR)/ecj-$(ecj_version).jar


ifeq ($(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC))
PATCHES     = PATCHES.x86_64
else
ifeq ($(TOOLCHAIN),$(TOOLCHAIN_S9XX_GLIBC))
PATCHES     = PATCHES.aarch64
else
PATCHES     = PATCHES
endif
endif

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = dev

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
GCJ_DEV_PKG_NAME                = gcc-java
GCJ_DEV_PKG_VERSION             = 5.3.0
GCJ_DEV_PKG_ARCH                = $(TOOLCHAIN)
GCJ_DEV_PKG_DISTRO_NAME         = $(DISTRO_NAME)
GCJ_DEV_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
GCJ_DEV_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
GCJ_DEV_PKG_SHORT_DESCRIPTION   = GNU Compiler Collection
GCJ_DEV_PKG_URL                 = $(BUG_URL)
GCJ_DEV_PKG_LICENSE             = GPLv2
GCJ_DEV_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GCJ_DEV_PKG_NAME)-pkg-description
GCJ_DEV_PKG_DESCRIPTION_FILE_IN = $(GCJ_DEV_PKG_NAME)-pkg-description.in
GCJ_DEV_PKG_INSTALL_SCRIPT      = $(GCJ_DEV_PKG_NAME)-pkg-install.sh

GCJ_DEV_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GCJ_DEV_PKG_NAME)-package

pkg_basename     = $(GCJ_DEV_PKG_NAME)-$(GCJ_DEV_PKG_VERSION)-$(GCJ_DEV_PKG_ARCH)-$(GCJ_DEV_PKG_DISTRO_NAME)-$(GCJ_DEV_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
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
export GCJ_FOR_BUILD      = gcj
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

export GCJ = $(TOOLCHAIN_PATH)/bin/$(TARGET)-gcj --sysroot=$(TARGET_DEST_DIR)

env_sysroot  = DESTDIR=$(GCJ_DEV_PKG)


extra_configure_switches += --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --datadir=/usr/share
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --docdir=/usr/share/doc

extra_configure_switches += --enable-languages=c,c++,java,lto
extra_configure_switches += --enable-libstdcxx-dual-abi
extra_configure_switches += --with-default-libstdcxx-abi=gcc4-compatible
extra_configure_switches += --enable-__cxa_atexit
extra_configure_switches += --enable-install-libiberty
extra_configure_switches += --enable-shared
extra_configure_switches += --enable-threads=posix
extra_configure_switches += --enable-lto
extra_configure_switches += --enable-c99
extra_configure_switches += --enable-long-long

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_S9XX_GLIBC))
extra_configure_switches += --with-system-libunwind
else
extra_configure_switches += --disable-libunwind-exceptions
endif

extra_configure_switches += --with-system-zlib
extra_configure_switches += --with-mpc=$(TARGET_DEST_DIR)/usr
extra_configure_switches += --with-mpfr=$(TARGET_DEST_DIR)/usr
extra_configure_switches += --with-gmp=$(TARGET_DEST_DIR)/usr
extra_configure_switches += --with-isl=$(TARGET_DEST_DIR)/usr

PYTHON_VERSION = 2.7

# Python 2.7 (The location to install Python modules. This path should NOT include the prefix):
extra_configure_switches += --with-python-dir=/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/site-packages

#
# for target libgo:
#
extra_configure_switches += --enable-werror=no

extra_configure_switches += --with-gnu-ld
extra_configure_switches += --with-gnu-as


ifeq ($(TOOLCHAIN),$(TOOLCHAIN_A1X_GLIBC))
JAVA_LIB_ARCH = armv7a
extra_configure_switches += '--with-pkgversion=$(DISTRO_NAME) $(SYSTEM_VERSION)'
extra_configure_switches += '--with-bugurl=$(BUG_URL)'
extra_configure_switches += --with-arch=armv7-a
extra_configure_switches += --with-tune=cortex-a8
extra_configure_switches += --with-fpu=neon
extra_configure_switches += --with-float=hard
extra_configure_switches += --with-abi=aapcs-linux
endif

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_A2X_GLIBC))
JAVA_LIB_ARCH = armv7ve
extra_configure_switches += '--with-pkgversion=$(DISTRO_NAME) $(SYSTEM_VERSION)'
extra_configure_switches += '--with-bugurl=$(BUG_URL)'
extra_configure_switches += --with-arch=armv7ve
extra_configure_switches += --with-tune=cortex-a7
extra_configure_switches += --with-fpu=neon-vfpv4
extra_configure_switches += --with-float=hard
extra_configure_switches += --with-abi=aapcs-linux
endif

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_RK328X_GLIBC))
JAVA_LIB_ARCH = armv7ve
extra_configure_switches += '--with-pkgversion=$(DISTRO_NAME) $(SYSTEM_VERSION)'
extra_configure_switches += '--with-bugurl=$(BUG_URL)'
extra_configure_switches += --with-arch=armv7ve
extra_configure_switches += --with-tune=cortex-a17
extra_configure_switches += --with-fpu=neon-vfpv4
extra_configure_switches += --with-float=hard
extra_configure_switches += --with-abi=aapcs-linux
endif

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_S8XX_GLIBC))
JAVA_LIB_ARCH = armv7a
extra_configure_switches += '--with-pkgversion=$(DISTRO_NAME) $(SYSTEM_VERSION)'
extra_configure_switches += '--with-bugurl=$(BUG_URL)'
extra_configure_switches += --with-arch=armv7-a
extra_configure_switches += --with-tune=cortex-a5
extra_configure_switches += --with-fpu=neon
extra_configure_switches += --with-float=hard
extra_configure_switches += --with-abi=aapcs-linux
endif

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_S9XX_GLIBC))
extra_configure_switches += '--with-pkgversion=$(DISTRO_NAME) $(SYSTEM_VERSION)'
extra_configure_switches += '--with-bugurl=$(BUG_URL)'
extra_configure_switches += --with-arch=armv8-a
extra_configure_switches += --with-cpu=cortex-a53
extra_configure_switches += --with-abi=lp64
extra_configure_switches += --enable-fix-cortex-a53-835769
extra_configure_switches += --enable-fix-cortex-a53-843419
endif

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_IMX6_GLIBC))
JAVA_LIB_ARCH = armv7a
extra_configure_switches += '--with-pkgversion=$(DISTRO_NAME) $(SYSTEM_VERSION)'
extra_configure_switches += '--with-bugurl=$(BUG_URL)'
extra_configure_switches += --with-arch=armv7-a
extra_configure_switches += --with-tune=cortex-a9
extra_configure_switches += --with-fpu=vfpv3
extra_configure_switches += --with-float=hard
extra_configure_switches += --with-abi=aapcs-linux
endif

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_OMAP543X_GLIBC))
JAVA_LIB_ARCH = armv7a
extra_configure_switches += '--with-pkgversion=$(DISTRO_NAME) $(SYSTEM_VERSION)'
extra_configure_switches += '--with-bugurl=$(BUG_URL)'
extra_configure_switches += --with-arch=armv7-a
extra_configure_switches += --with-tune=cortex-a15
extra_configure_switches += --with-fpu=neon-vfpv4
extra_configure_switches += --with-float=hard
extra_configure_switches += --with-abi=aapcs-linux
endif

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_JZ47XX_GLIBC))
JAVA_LIB_ARCH = mips32r2
extra_configure_switches += '--with-pkgversion=$(DISTRO_NAME) $(SYSTEM_VERSION)'
extra_configure_switches += '--with-bugurl=$(BUG_URL)'
extra_configure_switches += --with-arch-32=mips32r2
extra_configure_switches += --with-arch-64=mips64r2
extra_configure_switches += --with-float=hard
extra_configure_switches += --with-mips-plt
extra_configure_switches += --enable-target-optspace
extra_configure_switches += --enable-symvers=gnu
extra_configure_switches += --enable-__cxa_atexit
endif

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_P5600_GLIBC))
JAVA_LIB_ARCH = mips32r5
extra_configure_switches += '--with-pkgversion=$(DISTRO_NAME) $(SYSTEM_VERSION)'
extra_configure_switches += '--with-bugurl=$(BUG_URL)'
extra_configure_switches += --with-arch=mips32r5
extra_configure_switches += --with-tune=p5600
extra_configure_switches += --with-float=hard
extra_configure_switches += --with-mips-plt
extra_configure_switches += --enable-target-optspace
extra_configure_switches += --enable-symvers=gnu
extra_configure_switches += --enable-__cxa_atexit
endif

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_I686_GLIBC))
JAVA_LIB_ARCH = i386
extra_configure_switches += '--with-pkgversion=$(DISTRO_NAME) $(SYSTEM_VERSION)'
extra_configure_switches += '--with-bugurl=$(BUG_URL)'
extra_configure_switches += --with-arch=i486
extra_configure_switches += --with-tune=i686
endif

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC))
JAVA_LIB_ARCH = amd64
extra_configure_switches += '--with-pkgversion=$(DISTRO_NAME) $(SYSTEM_VERSION)'
extra_configure_switches += '--with-bugurl=$(BUG_URL)'
extra_configure_switches += --enable-multilib=no
endif

#
# java:
#
extra_configure_switches += --enable-java-home
extra_configure_switches += --with-java-home=/usr/lib$(LIBSUFFIX)/jvm/jre
extra_configure_switches += --with-jvm-root-dir=/usr/lib$(LIBSUFFIX)/jvm
extra_configure_switches += --with-jvm-jar-dir=/usr/lib$(LIBSUFFIX)/jvm/jvm-exports
extra_configure_switches += --with-arch-directory=$(JAVA_LIB_ARCH)
extra_configure_switches += --with-antlr-jar=$(ANTLR_RUNTIME_JAR)
extra_configure_switches += --with-ecj-jar=$(ECJ_JAR)
extra_configure_switches += --enable-java-awt=gtk

extra_configure_switches += --x-includes=$(TARGET_DEST_DIR)/usr/include
extra_configure_switches += --x-libraries=$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)


extra_environment = GCJ='$(TOOLCHAIN_PATH)/bin/$(TARGET)-gcj --sysroot=$(TARGET_DEST_DIR)'


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(antlr_src_done): $(src_done)
	@echo "Copy $(jar_archive_antlr)"
	@cp $(jar_archive_antlr) $(SRC_DIR)
	@touch $@

$(ecj_src_done): $(src_done)
	@echo "Copy $(jar_archive_ecj)"
	@cp $(jar_archive_ecj) $(SRC_DIR)
	@touch $@

$(build_target): $(antlr_src_done) $(ecj_src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) $(extra_environment) ../$(src_dir_name)/configure \
	  --prefix=/usr                             \
	  --build=$(BUILD)                          \
	  --host=$(TARGET)                          \
	  --target=$(TARGET)                        \
	  $(extra_configure_switches)
	# ======= Core Makefile passes DevEnv variables to libjava/configure =======
	# ======= script not correct and we need to configure libjava for    =======
	# ======= target system before building GCJ.                         =======
	@( cd $(build_dir) ; \
	   mkdir -p $(TARGET)/libjava ; \
	   echo "ac_cv_lib_Xtst_XTestQueryExtension=yes" \
	         > $(TARGET)/libjava/config.cache ; \
	 )
	@( cd $(build_dir)/$(TARGET)/libjava; \
	   $(BUILD_ENVIRONMENT) $(extra_environment) ../../../$(src_dir_name)/libjava/configure \
	   --prefix=/usr                             \
	   --build=$(BUILD)                          \
	   --host=$(TARGET)                          \
	   --target=$(TARGET)                        \
	   $(extra_configure_switches) ; \
	 )
	$(BUILD_ENVIRONMENT) $(extra_environment) $(MAKE) -C $(build_dir) all
	$(BUILD_ENVIRONMENT) $(extra_environment) $(MAKE) -C $(build_dir) info
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(GCJ_DEV_PKG)
	$(BUILD_ENVIRONMENT) $(extra_environment) $(MAKE) -C $(build_dir) -j1 install $(env_sysroot)
	$(BUILD_ENVIRONMENT) $(extra_environment) $(MAKE) -C $(build_dir) -j1 install-info $(env_sysroot)
	@cp -a $(SRC_DIR)/ecj-$(ecj_version).jar $(GCJ_DEV_PKG)/usr/share/java/ecj-$(ecj_version).jar
	@( cd $(GCJ_DEV_PKG)/usr/share/java ; \
	   ln -sf ecj-$(ecj_version).jar ecj.jar ; \
	 )
	# ======= remove unneeded stuff =======
	@( cd $(GCJ_DEV_PKG)/usr/bin ; \
	   rm -f cpp *++ *gcc *gcc-* *gcov *gcov-* ; \
	   for file in aot-compile gappletviewer gc-analyze gcj       \
	               gcj-dbtool gcjh gij gjar gjarsigner gjavah     \
	               gjdoc gkeytool gnative2ascii gorbd grmic grmid \
	               grmiregistry gserialver gtnameserv jv-convert  \
	               rebuild-gcj-db                                 ; do \
	     mv $(TARGET)-$$file $$file     ; \
	     ln -sf $$file $(TARGET)-$$file ; \
	   done ; \
	 )
	# ======= in usr/include =======
	@( cd $(GCJ_DEV_PKG)/usr/include ; \
	   rm -rf libiberty ; \
	 )
	@( cd $(GCJ_DEV_PKG)/usr/include/c++/$(version) ; \
	   for dir in backward bits debug decimal experimental \
	              ext parallel profile tr1 tr2 $(TARGET)   ; do \
	     rm -rf $$dir ; \
	   done ; \
	 )
	@( cd $(GCJ_DEV_PKG)/usr/include/c++/$(version) ; \
	   for file in `find . -type f -maxdepth 1` ; do \
	     rm -f $$file ; \
	   done ; \
	 )
	# ======= in usr/libexec =======
	@( cd $(GCJ_DEV_PKG)/usr/libexec/gcc/$(TARGET)/$(version) ; \
	   for dir in install-tools plugin ; do \
	     rm -rf $$dir ; \
	   done ; \
	   for file in c* l* ; do \
	     rm -f $$file ; \
	   done ; \
	 )
	# ======= in usr/lib =======
	@( cd $(GCJ_DEV_PKG)/usr/lib/gcc/$(TARGET)/$(version) ; \
	   for dir in finclude include-fixed install-tools plugin ; do \
	     rm -rf $$dir ; \
	   done ; \
	   for file in *.{a,o} ; do \
	     rm -f $$file ; \
	   done ; \
	 )
	@( cd $(GCJ_DEV_PKG)/usr/lib/gcc/$(TARGET)/$(version)/include ; \
	   for dir in sanitizer ssp ; do \
     rm -rf $$dir ; \
	   done ; \
	   for file in `find . -type f -name "*.h" ! -name "j*.h" -maxdepth 1` ; do \
	     rm -f $$file ; \
	   done ; \
	 )
	@( cd $(GCJ_DEV_PKG)/usr/lib ; \
	   if [ -d ./python$(PYTHON_VERSION)/site-packages/libstdcxx ] ; then \
	     rm -rf ./python$(PYTHON_VERSION)/site-packages/libstdcxx ; \
	   fi ; \
	 )
	@( cd $(GCJ_DEV_PKG)/usr/lib ; \
	   rm -f libasan* libatomic* libcilkrts* libgcc* libgomp* libiberty* libitm* \
	         liblsan* libquadmath* libssp* libstdc* libsupc* libtsan* libubsan* libvtv* ; \
	 )
	# ======= in usr/share =======
	@( cd $(GCJ_DEV_PKG)/usr/share ; \
	   for dir in locale man/man7 ; do \
	     rm -rf $$dir ; \
	   done ; \
	 )
	@( cd $(GCJ_DEV_PKG)/usr/share/info ; \
	   for file in c* l* d* gcc* ; do \
	     rm -f $$file ; \
	   done ; \
	 )
	@( cd $(GCJ_DEV_PKG)/usr/share/man/man1 ; \
	   for file in cpp* gcc* *++* ; do \
	     rm -f $$file ; \
	   done ; \
	   for file in gappletviewer gcjh gjar gjarsigner gjavah gjdoc gkeytool \
	               gnative2ascii gorbd grmid grmiregistry gserialver gtnameserv ; do \
	     mv $(TARGET)-$${file}.1 $${file}.1     ; \
	     ln -sf $${file}.1 $(TARGET)-$${file}.1 ; \
	   done ; \
	 )
	# ======= check jvm invlude files symlinks =======
	@( cd $(GCJ_DEV_PKG)/usr/lib$(LIBSUFFIX)/jvm/include ; \
	   rm -f jawt.h ; ln -sf ../../gcc/$(TARGET)/$(version)/include/jawt.h jawt.h ; \
	   rm -f jni.h  ; ln -sf ../../gcc/$(TARGET)/$(version)/include/jni.h  jni.h  ; \
	 )
	@( cd $(GCJ_DEV_PKG)/usr/lib$(LIBSUFFIX)/jvm/include/linux ; \
	   rm -f jawt_md.h ; ln -sf ../../../gcc/$(TARGET)/$(version)/include/jawt_md.h jawt_md.h ; \
	   rm -f jni_md.h  ; ln -sf ../../../gcc/$(TARGET)/$(version)/include/jni_md.h  jni_md.h  ; \
	 )
	# ======= Install ecj wrapper script =======
	@cat $(CURDIR)/scripts/ecj.sh |  sed -e "s,@JAVADIR@,/usr/share/java," > $(GCJ_DEV_PKG)/usr/bin/ecj
	@chmod 755 $(GCJ_DEV_PKG)/usr/bin/ecj
	# ======= and add the missing javac symlink =======
	@( cd $(GCJ_DEV_PKG)/usr/lib$(LIBSUFFIX)/jvm/bin ; \
	   ln -sf ../../../bin/ecj javac ; \
	 )
	# ======= Install Documentation =======
	@rm -f $(GCJ_DEV_PKG)/usr/share/info/dir
	@gzip -9 $(GCJ_DEV_PKG)/usr/share/info/*
	@if [ -d $(GCJ_DEV_PKG)/usr/share/man ]; then \
	  ( cd $(GCJ_DEV_PKG)/usr/share/man ; \
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
	@mkdir -p $(GCJ_DEV_PKG)/usr/doc/$(doc_dir_name)
	@cp -a $(SRC_DIR)/COPYING* \
	       $(GCJ_DEV_PKG)/usr/doc/$(doc_dir_name)
	@mkdir -p $(GCJ_DEV_PKG)/usr/share/doc/$(doc_dir_name)
	@cp -a $(SRC_DIR)/COPYING* $(SRC_DIR)/MAI* $(SRC_DIR)/NEWS $(SRC_DIR)/README \
	       $(GCJ_DEV_PKG)/usr/share/doc/$(doc_dir_name)
	@mkdir -p $(GCJ_DEV_PKG)/usr/share/doc/$(doc_dir_name)/libjava
	@( cd $(SRC_DIR)/libjava ; \
	   cp -a COPYING ChangeLog LIBGCJ_LICENSE NEWS README \
	         $(GCJ_DEV_PKG)/usr/share/doc/$(doc_dir_name)/libjava ; \
	 )
	@( cd $(SRC_DIR)/gcc/java ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(GCJ_DEV_PKG)/usr/share/doc/$(doc_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
ifeq ($(filter $(HARDWARE),$(HARDWARE_PC32) \
                           $(HARDWARE_PC64) \
                           $(HARDWARE_CI20) \
                           $(HARDWARE_BT1)),)
	@( cd $(GCJ_DEV_PKG)/usr/lib$(LIBSUFFIX)/gcj-$(version)-$(jversion) ; \
	   sed -i "s, '$(TOOLCHAIN_PATH)/$(TARGET)/lib$(LIBSUFFIX)'/libstdc++.la,,g" *.la ; \
	 )
	@( cd $(GCJ_DEV_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s, '$(TOOLCHAIN_PATH)/$(TARGET)/lib$(LIBSUFFIX)'/libstdc++.la,,g" *.la ; \
	 )
endif
	@( cd $(GCJ_DEV_PKG)/usr/lib$(LIBSUFFIX)/gcj-$(version)-$(jversion) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libgjsmalsa.la libgtkpeer.la \
	                                    libjavamath.la libjawt.la    \
	                                    libjvm.la                  ; \
	   sed -i "s,$(TOOLCHAIN_PATH)/$(TARGET),/usr,g" libjvm.la ; \
	   sed -i "s,-L[^[:space:]]*\.libs,-L/usr/lib$(LIBSUFFIX),g" *.la ; \
	   sed -i "s,-L[^[:space:]]*libjava,-L/usr/lib$(LIBSUFFIX)/gcj-$(version)-$(jversion),g" *.la ; \
	 )
	@( cd $(GCJ_DEV_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libgcj-tools.la libgcj.la libgij.la ; \
	   sed -i "s,$(TOOLCHAIN_PATH)/$(TARGET),/usr,g" libgcj-tools.la libgcj.la libgij.la ; \
	   sed -i "s,-L[^[:space:]]*\.libs,-L/usr/lib$(LIBSUFFIX),g" *.la ; \
	   sed -i "s,-L[^[:space:]]*libjava,-L/usr/lib$(LIBSUFFIX)/gcj-$(version)-$(jversion),g" *.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(GCJ_DEV_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/gcj-$(version)-$(jversion) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libgjsmalsa.la libgtkpeer.la \
	                                            libjavamath.la libjawt.la    \
	                                            libjvm.la                  ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libgjsmalsa.la libgtkpeer.la \
	                                              libjavamath.la libjawt.la    \
	                                              libjvm.la                  ; \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libgcj-tools.la libgcj.la libgij.la ; \
	 )
	# ======= tune development pkg-config *.pc files =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libgcj-?.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(GCJ_DEV_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(GCJ_DEV_PKG)/usr/bin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if [ -n "$$rpath" ] ; then \
	       found=`echo "$$rpath" | grep "$(TOOLCHAIN_PATH)/$(TARGET)"` ; \
	       if [ -n "$$found" ] ; then \
	         target_rpath=`echo "$$rpath" | sed "s,\./.*PATH=,," | sed "s,$(TOOLCHAIN_PATH)/$(TARGET),,g"` ; \
	         $(CHRPATH) -r $${target_rpath} $$file 1> /dev/null 2> /dev/null ; \
	       fi ; \
	     fi ; \
	   done ; \
	 )
	@( cd $(GCJ_DEV_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if [ -n "$$rpath" ] ; then \
	       found_toolchain_path=`echo "$$rpath" | grep "$(TOOLCHAIN_PATH)/$(TARGET)"` ; \
	       found_target_dest_dir=`echo "$$rpath" | grep "$(TARGET_DEST_DIR)"` ; \
	       if [ -n "$${found_toolchain_path}" -o -n "$${found_target_dest_dir}" ] ; then \
	         target_rpath=`echo "$$rpath" | sed "s,\./.*PATH=,,"                       \
	                                      | sed "s,$(TOOLCHAIN_PATH)/$(TARGET),/usr,g" \
	                                      | sed "s,$(TARGET_DEST_DIR),,g"`           ; \
	         $(CHRPATH) -r $${target_rpath} $$file 1> /dev/null 2> /dev/null ; \
	       fi ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(GCJ_DEV_PKG_DESCRIPTION_FILE): $(GCJ_DEV_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(GCJ_DEV_PKG_DESCRIPTION_FILE) $(GCJ_DEV_PKG_INSTALL_SCRIPT)
	@cp $(GCJ_DEV_PKG_DESCRIPTION_FILE) $(GCJ_DEV_PKG)/.DESCRIPTION
	@cp $(GCJ_DEV_PKG_INSTALL_SCRIPT) $(GCJ_DEV_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GCJ_DEV_PKG)/.REQUIRES
	@echo "pkgname=$(GCJ_DEV_PKG_NAME)"                            >  $(GCJ_DEV_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GCJ_DEV_PKG_VERSION)"                          >> $(GCJ_DEV_PKG)/.PKGINFO ; \
	 echo "arch=$(GCJ_DEV_PKG_ARCH)"                               >> $(GCJ_DEV_PKG)/.PKGINFO ; \
	 echo "distroname=$(GCJ_DEV_PKG_DISTRO_NAME)"                  >> $(GCJ_DEV_PKG)/.PKGINFO ; \
	 echo "distrover=$(GCJ_DEV_PKG_DISTRO_VERSION)"                >> $(GCJ_DEV_PKG)/.PKGINFO ; \
	 echo "group=$(GCJ_DEV_PKG_GROUP)"                             >> $(GCJ_DEV_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GCJ_DEV_PKG_SHORT_DESCRIPTION)\"" >> $(GCJ_DEV_PKG)/.PKGINFO ; \
	 echo "url=$(GCJ_DEV_PKG_URL)"                                 >> $(GCJ_DEV_PKG)/.PKGINFO ; \
	 echo "license=$(GCJ_DEV_PKG_LICENSE)"                         >> $(GCJ_DEV_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(GCJ_DEV_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
