
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/libsoxr

REQUIRES           = libs/libsoxr/0.1.2
REQUIRES          += libs/glibc/2.24-x86_32

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
LIBSOXR_32_PKG_NAME                = libsoxr-x32
LIBSOXR_32_PKG_VERSION             = 0.1.2
LIBSOXR_32_PKG_ARCH                = $(TOOLCHAIN)
LIBSOXR_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBSOXR_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBSOXR_32_PKG_GROUP               = $(PKG_GROUP)
###                                 |---handy-ruler-------------------------------|
LIBSOXR_32_PKG_SHORT_DESCRIPTION   = The SoX Resampler library
LIBSOXR_32_PKG_URL                 = $(BUG_URL)
LIBSOXR_32_PKG_LICENSE             = LGPLv2.1
LIBSOXR_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBSOXR_32_PKG_NAME)-pkg-description
LIBSOXR_32_PKG_DESCRIPTION_FILE_IN = $(LIBSOXR_32_PKG_NAME)-pkg-description.in
LIBSOXR_32_PKG_INSTALL_SCRIPT      = $(LIBSOXR_32_PKG_NAME)-pkg-install.sh

LIBSOXR_32_PKG   = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBSOXR_32_PKG_NAME)-package

pkg_basename     = $(LIBSOXR_32_PKG_NAME)-$(LIBSOXR_32_PKG_VERSION)-$(LIBSOXR_32_PKG_ARCH)-$(LIBSOXR_32_PKG_DISTRO_NAME)-$(LIBSOXR_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))


BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(LIBSOXR_32_PKG)

TARGET_BIN_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX)
TARGET_LIB_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib/../lib$(MULTILIB_X86_32_SUFFIX)

configure_switches  = -DCMAKE_BUILD_TYPE='Release'

configure_switches += -DCMAKE_C_COMPILER='$(CROSS_PREFIX)gcc'
configure_switches += -DCMAKE_LINKER='$(CROSS_PREFIX)ld'
configure_switches += -DCMAKE_AR='$(CROSS_PREFIX)ar'
configure_switches += -DCMAKE_NM='$(CROSS_PREFIX)nm'
configure_switches += -DCMAKE_RANLIB='$(CROSS_PREFIX)ranlib'
configure_switches += -DCMAKE_OBJCOPY='$(CROSS_PREFIX)objcopy'
configure_switches += -DCMAKE_OBJDUMP='$(CROSS_PREFIX)objdump'
configure_switches += -DCMAKE_STRIP='$(CROSS_PREFIX)strip'

configure_switches += -DCMAKE_C_FLAGS:STRING='--sysroot=$(TARGET_DEST_DIR) -m32 $(CFLAGS) $(ARCH_FLAGS) $(ARCH_DEFS) $(HW_FLAGS) -Wno-unknown-pragmas'

configure_switches += -DCMAKE_EXE_LINKER_FLAGS='--sysroot=$(TARGET_DEST_DIR) -m32 -Wl,-rpath,$(TARGET_BIN_RPATH) -L$(TARGET_DEST_DIR)/lib$(MULTILIB_X86_32_SUFFIX) -L$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)'
configure_switches += -DCMAKE_MODULE_LINKER_FLAGS='--sysroot=$(TARGET_DEST_DIR) -m32 -Wl,-rpath,$(TARGET_LIB_RPATH) -L$(TARGET_DEST_DIR)/lib$(MULTILIB_X86_32_SUFFIX) -L$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)'
configure_switches += -DCMAKE_SHARED_LINKER_FLAGS='--sysroot=$(TARGET_DEST_DIR) -m32 -Wl,-rpath,$(TARGET_LIB_RPATH) -L$(TARGET_DEST_DIR)/lib$(MULTILIB_X86_32_SUFFIX) -L$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)'

configure_switches += -DCMAKE_INSTALL_PREFIX=/usr

configure_switches += -DDOC_INSTALL_DIR='share/doc/$(doc_dir_name)'
configure_switches += -DLIB_INSTALL_DIR='lib$(MULTILIB_X86_32_SUFFIX)'

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
	@mkdir -p $(LIBSOXR_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(LIBSOXR_32_PKG)/usr/include
	@rm -rf $(LIBSOXR_32_PKG)/usr/share
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBSOXR_32_PKG))
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" soxr-lsr.pc soxr.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBSOXR_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(LIBSOXR_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(LIBSOXR_32_PKG_DESCRIPTION_FILE): $(LIBSOXR_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBSOXR_32_PKG_DESCRIPTION_FILE) $(LIBSOXR_32_PKG_INSTALL_SCRIPT)
	@cp $(LIBSOXR_32_PKG_DESCRIPTION_FILE) $(LIBSOXR_32_PKG)/.DESCRIPTION
	@cp $(LIBSOXR_32_PKG_INSTALL_SCRIPT) $(LIBSOXR_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBSOXR_32_PKG)/.REQUIRES
	@echo "pkgname=$(LIBSOXR_32_PKG_NAME)"                            >  $(LIBSOXR_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBSOXR_32_PKG_VERSION)"                          >> $(LIBSOXR_32_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBSOXR_32_PKG_ARCH)"                               >> $(LIBSOXR_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBSOXR_32_PKG_DISTRO_NAME)"                  >> $(LIBSOXR_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBSOXR_32_PKG_DISTRO_VERSION)"                >> $(LIBSOXR_32_PKG)/.PKGINFO ; \
	 echo "group=$(LIBSOXR_32_PKG_GROUP)"                             >> $(LIBSOXR_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBSOXR_32_PKG_SHORT_DESCRIPTION)\"" >> $(LIBSOXR_32_PKG)/.PKGINFO ; \
	 echo "url=$(LIBSOXR_32_PKG_URL)"                                 >> $(LIBSOXR_32_PKG)/.PKGINFO ; \
	 echo "license=$(LIBSOXR_32_PKG_LICENSE)"                         >> $(LIBSOXR_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBSOXR_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
