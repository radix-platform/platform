
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


SOURCE_REQUIRES    = sources/packages/l/fftw

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/6.5.0
else
ifneq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES           = libs/glibc/2.28
else
REQUIRES           = libs/glibc/2.28-x86_32
endif
endif

# ======= __END_OF_REQUIRES__ =======


version            = 3.3.5
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/fftw/fftw-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/fftw-$(version)
src_dir_name       = fftw-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
FFTW_PKG_NAME                = fftw
FFTW_PKG_VERSION             = 3.3.5
FFTW_PKG_ARCH                = $(TOOLCHAIN)
FFTW_PKG_DISTRO_NAME         = $(DISTRO_NAME)
FFTW_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
FFTW_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
FFTW_PKG_SHORT_DESCRIPTION   = Discrete Fourier Transform routines
FFTW_PKG_URL                 = $(BUG_URL)
FFTW_PKG_LICENSE             = GPLv2
FFTW_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(FFTW_PKG_NAME)-pkg-description
FFTW_PKG_DESCRIPTION_FILE_IN = $(FFTW_PKG_NAME)-pkg-description.in
FFTW_PKG_INSTALL_SCRIPT      = $(FFTW_PKG_NAME)-pkg-install.sh

FFTW_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(FFTW_PKG_NAME)-package

pkg_basename     = $(FFTW_PKG_NAME)-$(FFTW_PKG_VERSION)-$(FFTW_PKG_ARCH)-$(FFTW_PKG_DISTRO_NAME)-$(FFTW_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(FFTW_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var


ifneq ($(filter $(HARDWARE),$(HARDWARE_CB1X)      \
                            $(HARDWARE_CB2X)      \
                            $(HARDWARE_CB3X)      \
                            $(HARDWARE_FFRK3288)  \
                            $(HARDWARE_M201)      \
                            $(HARDWARE_MXV)       \
                            $(HARDWARE_OMAP5UEVM) \
                            $(HARDWARE_DRA7XXEVM)),)
#
# Fast timer is available if armv7 has 64 bits readable CNTVCT
# also we have to change try_run to try_link in configure script.
#
# If CCNT in not available, then we have to use `--with-slow-timer'
# configure switch.
#
float_configure_switches  = --enable-neon
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_NIT6Q)),)
float_configure_switches  = --enable-generic-simd128
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC32)),)
float_configure_switches  = --enable-sse --enable-avx
double_configure_switches = --enable-sse2 --enable-avx
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC64)),)
float_configure_switches  = --enable-sse --enable-avx
double_configure_switches = --enable-sse2 --enable-avx
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_CI20) $(HARDWARE_BAIKAL_T1)),)
extra_configure_switches += --enable-mips-zbus-timer
endif

extra_configure_switches += --enable-openmp
extra_configure_switches += --enable-threads

extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


CFLAGS += -fstrict-aliasing -ffast-math


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)
TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)

LDFLAGS += -Wl,-rpath,$(TARGET_LIB_RPATH)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@( cd $(TARGET_BUILD_DIR) ; \
	   cp -a $(src_dir_name) $(src_dir_name)-long-double ; \
	   cp -a $(src_dir_name) $(src_dir_name)-float ; \
	 )
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && \
	  $(BUILD_ENVIRONMENT) ./configure F77=gfortran \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches) \
	  $(double_configure_switches)
	@cd $(SRC_DIR)-long-double && \
	  $(BUILD_ENVIRONMENT) ./configure F77=gfortran \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches) \
	  --enable-long-double
	@cd $(SRC_DIR)-float && \
	  $(BUILD_ENVIRONMENT) ./configure F77=gfortran \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches) \
	  --enable-float              \
	  $(float_configure_switches)
	@cd $(SRC_DIR)             && $(BUILD_ENVIRONMENT) $(MAKE)
	@cd $(SRC_DIR)-long-double && $(BUILD_ENVIRONMENT) $(MAKE)
	@cd $(SRC_DIR)-float       && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(FFTW_PKG)
	@cd $(SRC_DIR)             && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@cd $(SRC_DIR)-long-double && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@cd $(SRC_DIR)-float       && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@rm -f $(FFTW_PKG)/usr/share/info/dir
	@gzip -9 $(FFTW_PKG)/usr/share/info/*
	@if [ -d $(FFTW_PKG)/usr/share/man ]; then \
	  ( cd $(FFTW_PKG)/usr/share/man ; \
	    for manpagedir in `find . -type d -name "man*"` ; do \
	      ( cd $$manpagedir ; \
	        for eachpage in `find . -type l -maxdepth 1` ; do \
	          ln -s `readlink $$eachpage`.gz $$eachpage.gz ; \
	          rm $$eachpage ; \
	        done ; \
	        gzip -9 *.? ; \
	      ) \
	    done \
	  ) \
	 fi
	@mkdir -p $(FFTW_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING $(SRC_DIR)/COPYRIGHT \
	       $(FFTW_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(FFTW_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING COPYRIGHT INSTALL NEWS README TODO \
	         $(FFTW_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(FFTW_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(FFTW_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libfftw3.la  libfftw3_omp.la  libfftw3_threads.la    \
	                                    libfftw3f.la libfftw3f_omp.la libfftw3f_threads.la   \
	                                    libfftw3l.la libfftw3l_omp.la libfftw3l_threads.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(FFTW_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libfftw3.la  libfftw3_omp.la  libfftw3_threads.la    \
	                                            libfftw3f.la libfftw3f_omp.la libfftw3f_threads.la   \
	                                            libfftw3l.la libfftw3l_omp.la libfftw3l_threads.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libfftw3.la  libfftw3_omp.la  libfftw3_threads.la    \
	                                              libfftw3f.la libfftw3f_omp.la libfftw3f_threads.la   \
	                                              libfftw3l.la libfftw3l_omp.la libfftw3l_threads.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" fftw3.pc fftw3f.pc fftw3l.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(FFTW_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(FFTW_PKG)/usr/bin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(FFTW_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(FFTW_PKG_DESCRIPTION_FILE): $(FFTW_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(FFTW_PKG_DESCRIPTION_FILE) $(FFTW_PKG_INSTALL_SCRIPT)
	@cp $(FFTW_PKG_DESCRIPTION_FILE) $(FFTW_PKG)/.DESCRIPTION
	@cp $(FFTW_PKG_INSTALL_SCRIPT) $(FFTW_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(FFTW_PKG)/.REQUIRES
	@echo "pkgname=$(FFTW_PKG_NAME)"                            >  $(FFTW_PKG)/.PKGINFO ; \
	 echo "pkgver=$(FFTW_PKG_VERSION)"                          >> $(FFTW_PKG)/.PKGINFO ; \
	 echo "arch=$(FFTW_PKG_ARCH)"                               >> $(FFTW_PKG)/.PKGINFO ; \
	 echo "distroname=$(FFTW_PKG_DISTRO_NAME)"                  >> $(FFTW_PKG)/.PKGINFO ; \
	 echo "distrover=$(FFTW_PKG_DISTRO_VERSION)"                >> $(FFTW_PKG)/.PKGINFO ; \
	 echo "group=$(FFTW_PKG_GROUP)"                             >> $(FFTW_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(FFTW_PKG_SHORT_DESCRIPTION)\"" >> $(FFTW_PKG)/.PKGINFO ; \
	 echo "url=$(FFTW_PKG_URL)"                                 >> $(FFTW_PKG)/.PKGINFO ; \
	 echo "license=$(FFTW_PKG_LICENSE)"                         >> $(FFTW_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(FFTW_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
