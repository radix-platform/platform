
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/fftw

REQUIRES           = libs/fftw/3.3.5

# ======= __END_OF_REQUIRES__ =======


version            = 3.3.5
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/fftw/fftw-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/fftw-$(version)
src_dir_name       = fftw-$(version)
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
FFTW_32_PKG_NAME                = fftw-x32
FFTW_32_PKG_VERSION             = 3.3.5
FFTW_32_PKG_ARCH                = $(TOOLCHAIN)
FFTW_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
FFTW_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
FFTW_32_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
FFTW_32_PKG_SHORT_DESCRIPTION   = Discrete Fourier Transform routines
FFTW_32_PKG_URL                 = $(BUG_URL)
FFTW_32_PKG_LICENSE             = GPLv2
FFTW_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(FFTW_32_PKG_NAME)-pkg-description
FFTW_32_PKG_DESCRIPTION_FILE_IN = $(FFTW_32_PKG_NAME)-pkg-description.in
FFTW_32_PKG_INSTALL_SCRIPT      = $(FFTW_32_PKG_NAME)-pkg-install.sh

FFTW_32_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(FFTW_32_PKG_NAME)-package

pkg_basename      = $(FFTW_32_PKG_NAME)-$(FFTW_32_PKG_VERSION)-$(FFTW_32_PKG_ARCH)-$(FFTW_32_PKG_DISTRO_NAME)-$(FFTW_32_PKG_DISTRO_VERSION)

pkg_archive       = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature     = $(call sign-name,$(pkg_archive))
pkg_description   = $(call desc-name,$(pkg_archive))
products          = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS     = $(build_target)
BUILD_TARGETS    += $(install_target)

PRODUCT_TARGETS   = $(products)

ROOTFS_TARGETS    = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(FFTW_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --bindir=/usr/bin/32

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var


float_configure_switches  = --enable-sse --enable-avx
double_configure_switches = --enable-sse2 --enable-avx


extra_configure_switches += --enable-openmp
extra_configure_switches += --enable-threads

extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


CFLAGS += -fstrict-aliasing -ffast-math


TARGET_BIN_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX)
TARGET_LIB_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib/../lib$(MULTILIB_X86_32_SUFFIX)

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
	  --host=$(TARGET32)          \
	  $(extra_configure_switches) \
	  $(double_configure_switches)
	@cd $(SRC_DIR)-long-double && \
	  $(BUILD_ENVIRONMENT) ./configure F77=gfortran \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches) \
	  --enable-long-double
	@cd $(SRC_DIR)-float && \
	  $(BUILD_ENVIRONMENT) ./configure F77=gfortran \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches) \
	  --enable-float              \
	  $(float_configure_switches)
	@cd $(SRC_DIR)             && $(BUILD_ENVIRONMENT) $(MAKE)
	@cd $(SRC_DIR)-long-double && $(BUILD_ENVIRONMENT) $(MAKE)
	@cd $(SRC_DIR)-float       && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(FFTW_32_PKG)
	@cd $(SRC_DIR)             && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@cd $(SRC_DIR)-long-double && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@cd $(SRC_DIR)-float       && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(FFTW_32_PKG)/usr/include
	@rm -rf $(FFTW_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(FFTW_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libfftw3.la  libfftw3_omp.la  libfftw3_threads.la    \
	                                    libfftw3f.la libfftw3f_omp.la libfftw3f_threads.la   \
	                                    libfftw3l.la libfftw3l_omp.la libfftw3l_threads.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(FFTW_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libfftw3.la  libfftw3_omp.la  libfftw3_threads.la    \
	                                            libfftw3f.la libfftw3f_omp.la libfftw3f_threads.la   \
	                                            libfftw3l.la libfftw3l_omp.la libfftw3l_threads.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libfftw3.la  libfftw3_omp.la  libfftw3_threads.la    \
	                                              libfftw3f.la libfftw3f_omp.la libfftw3f_threads.la   \
	                                              libfftw3l.la libfftw3l_omp.la libfftw3l_threads.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" fftw3.pc fftw3f.pc fftw3l.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(FFTW_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(FFTW_32_PKG)/usr/bin/32 ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(FFTW_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(FFTW_32_PKG_DESCRIPTION_FILE): $(FFTW_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(FFTW_32_PKG_DESCRIPTION_FILE) $(FFTW_32_PKG_INSTALL_SCRIPT)
	@cp $(FFTW_32_PKG_DESCRIPTION_FILE) $(FFTW_32_PKG)/.DESCRIPTION
	@cp $(FFTW_32_PKG_INSTALL_SCRIPT) $(FFTW_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(FFTW_32_PKG)/.REQUIRES
	@echo "pkgname=$(FFTW_32_PKG_NAME)"                            >  $(FFTW_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(FFTW_32_PKG_VERSION)"                          >> $(FFTW_32_PKG)/.PKGINFO ; \
	 echo "arch=$(FFTW_32_PKG_ARCH)"                               >> $(FFTW_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(FFTW_32_PKG_DISTRO_NAME)"                  >> $(FFTW_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(FFTW_32_PKG_DISTRO_VERSION)"                >> $(FFTW_32_PKG)/.PKGINFO ; \
	 echo "group=$(FFTW_32_PKG_GROUP)"                             >> $(FFTW_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(FFTW_32_PKG_SHORT_DESCRIPTION)\"" >> $(FFTW_32_PKG)/.PKGINFO ; \
	 echo "url=$(FFTW_32_PKG_URL)"                                 >> $(FFTW_32_PKG)/.PKGINFO ; \
	 echo "license=$(FFTW_32_PKG_LICENSE)"                         >> $(FFTW_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(FFTW_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
