
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/x/libdrm

REQUIRES           = X11/libs/libdrm/2.4.68
REQUIRES          += X11/X.org/lib/libpciaccess/0.13.4-x86_32
REQUIRES          += X11/X.org/xcb/libpthread-stubs/0.3-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 2.4.68
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/x/libdrm/libdrm-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libdrm-$(version)
src_dir_name       = libdrm-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = xlibs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LIBDRM_32_PKG_NAME                = libdrm-x32
LIBDRM_32_PKG_VERSION             = 2.4.68
LIBDRM_32_PKG_ARCH                = $(TOOLCHAIN)
LIBDRM_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBDRM_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBDRM_32_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
LIBDRM_32_PKG_SHORT_DESCRIPTION   = Direct Rendering library
LIBDRM_32_PKG_URL                 = $(BUG_URL)
LIBDRM_32_PKG_LICENSE             = custom
LIBDRM_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBDRM_32_PKG_NAME)-pkg-description
LIBDRM_32_PKG_DESCRIPTION_FILE_IN = $(LIBDRM_32_PKG_NAME)-pkg-description.in
LIBDRM_32_PKG_INSTALL_SCRIPT      = $(LIBDRM_32_PKG_NAME)-pkg-install.sh

LIBDRM_32_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBDRM_32_PKG_NAME)-package

pkg_basename     = $(LIBDRM_32_PKG_NAME)-$(LIBDRM_32_PKG_VERSION)-$(LIBDRM_32_PKG_ARCH)-$(LIBDRM_32_PKG_DISTRO_NAME)-$(LIBDRM_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../build-system/core.mk


env_sysroot  = DESTDIR=$(LIBDRM_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --enable-udev
extra_configure_switches += --enable-omap-experimental-api
extra_configure_switches += --enable-exynos-experimental-api
extra_configure_switches += --enable-cairo-tests=no

extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LIBDRM_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(LIBDRM_32_PKG)/usr/bin
	@rm -rf $(LIBDRM_32_PKG)/usr/include
	@rm -rf $(LIBDRM_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBDRM_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libdrm.la          \
	                                    libdrm_exynos.la   \
	                                    libdrm_intel.la    \
	                                    libdrm_nouveau.la  \
	                                    libdrm_omap.la     \
	                                    libdrm_radeon.la   \
	                                    libkms.la        ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBDRM_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libdrm.la          \
	                                            libdrm_exynos.la   \
	                                            libdrm_intel.la    \
	                                            libdrm_nouveau.la  \
	                                            libdrm_omap.la     \
	                                            libdrm_radeon.la   \
	                                            libkms.la        ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libdrm.la          \
	                                              libdrm_exynos.la   \
	                                              libdrm_intel.la    \
	                                              libdrm_nouveau.la  \
	                                              libdrm_omap.la     \
	                                              libdrm_radeon.la   \
	                                              libkms.la        ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libdrm.pc          \
	                                            libdrm_exynos.pc   \
	                                            libdrm_intel.pc    \
	                                            libdrm_nouveau.pc  \
	                                            libdrm_omap.pc     \
	                                            libdrm_radeon.pc   \
	                                            libkms.pc        ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBDRM_32_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBDRM_32_PKG_DESCRIPTION_FILE): $(LIBDRM_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBDRM_32_PKG_DESCRIPTION_FILE) $(LIBDRM_32_PKG_INSTALL_SCRIPT)
	@cp $(LIBDRM_32_PKG_DESCRIPTION_FILE) $(LIBDRM_32_PKG)/.DESCRIPTION
	@cp $(LIBDRM_32_PKG_INSTALL_SCRIPT) $(LIBDRM_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBDRM_32_PKG)/.REQUIRES
	@echo "pkgname=$(LIBDRM_32_PKG_NAME)"                            >  $(LIBDRM_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBDRM_32_PKG_VERSION)"                          >> $(LIBDRM_32_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBDRM_32_PKG_ARCH)"                               >> $(LIBDRM_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBDRM_32_PKG_DISTRO_NAME)"                  >> $(LIBDRM_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBDRM_32_PKG_DISTRO_VERSION)"                >> $(LIBDRM_32_PKG)/.PKGINFO ; \
	 echo "group=$(LIBDRM_32_PKG_GROUP)"                             >> $(LIBDRM_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBDRM_32_PKG_SHORT_DESCRIPTION)\"" >> $(LIBDRM_32_PKG)/.PKGINFO ; \
	 echo "url=$(LIBDRM_32_PKG_URL)"                                 >> $(LIBDRM_32_PKG)/.PKGINFO ; \
	 echo "license=$(LIBDRM_32_PKG_LICENSE)"                         >> $(LIBDRM_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LIBDRM_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
