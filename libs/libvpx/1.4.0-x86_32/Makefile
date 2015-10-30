
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/libvpx

REQUIRES           = libs/libvpx/1.4.0

# ======= __END_OF_REQUIRES__ =======


version            = 1.4.0
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/m/libvpx/libvpx-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libvpx-$(version)
src_dir_name       = libvpx-$(version)
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
LIBVPX_32_PKG_NAME                = libvpx-x32
LIBVPX_32_PKG_VERSION             = 1.4.0
LIBVPX_32_PKG_ARCH                = $(TOOLCHAIN)
LIBVPX_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBVPX_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBVPX_32_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
LIBVPX_32_PKG_SHORT_DESCRIPTION   = The WebM VP8 Codec SDK
LIBVPX_32_PKG_URL                 = $(BUG_URL)
LIBVPX_32_PKG_LICENSE             = BSD
LIBVPX_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBVPX_32_PKG_NAME)-pkg-description
LIBVPX_32_PKG_DESCRIPTION_FILE_IN = $(LIBVPX_32_PKG_NAME)-pkg-description.in
LIBVPX_32_PKG_INSTALL_SCRIPT      = $(LIBVPX_32_PKG_NAME)-pkg-install.sh

LIBVPX_32_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBVPX_32_PKG_NAME)-package

pkg_basename      = $(LIBVPX_32_PKG_NAME)-$(LIBVPX_32_PKG_VERSION)-$(LIBVPX_32_PKG_ARCH)-$(LIBVPX_32_PKG_DISTRO_NAME)-$(LIBVPX_32_PKG_DISTRO_VERSION)

pkg_archive       = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature     = $(call sign-name,$(pkg_archive))
pkg_description   = $(call desc-name,$(pkg_archive))
products          = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS     = $(build_target)
BUILD_TARGETS    += $(install_target)

PRODUCT_TARGETS   = $(products)

ROOTFS_TARGETS    = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DIST_DIR="$(LIBVPX_32_PKG)/usr"


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)

extra_configure_switches += --as=auto

extra_configure_switches += --enable-vp8
extra_configure_switches += --enable-vp9
extra_configure_switches += --enable-runtime-cpu-detect
extra_configure_switches += --enable-postproc
extra_configure_switches += --enable-pic
extra_configure_switches += --disable-install-docs
extra_configure_switches += --disable-install-srcs
extra_configure_switches += --enable-shared


configure_environment  = LD="$(CC) --sysroot=$(TARGET_DEST_DIR)"
configure_environment += CROSS=$(CROSS_PREFIX)


target_platform = x86-linux-gcc


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) $(configure_environment) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --target=$(target_platform) \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LIBVPX_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@mkdir -p $(LIBVPX_32_PKG)/usr/bin/32
	@( cd $(LIBVPX_32_PKG)/usr/bin ; \
	   find . -type f | xargs mv -t 32 ; \
	 )
	@rm -rf $(LIBVPX_32_PKG)/usr/include
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBVPX_32_PKG))
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" vpx.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBVPX_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBVPX_32_PKG_DESCRIPTION_FILE): $(LIBVPX_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBVPX_32_PKG_DESCRIPTION_FILE) $(LIBVPX_32_PKG_INSTALL_SCRIPT)
	@cp $(LIBVPX_32_PKG_DESCRIPTION_FILE) $(LIBVPX_32_PKG)/.DESCRIPTION
	@cp $(LIBVPX_32_PKG_INSTALL_SCRIPT) $(LIBVPX_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBVPX_32_PKG)/.REQUIRES
	@echo "pkgname=$(LIBVPX_32_PKG_NAME)"                            >  $(LIBVPX_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBVPX_32_PKG_VERSION)"                          >> $(LIBVPX_32_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBVPX_32_PKG_ARCH)"                               >> $(LIBVPX_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBVPX_32_PKG_DISTRO_NAME)"                  >> $(LIBVPX_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBVPX_32_PKG_DISTRO_VERSION)"                >> $(LIBVPX_32_PKG)/.PKGINFO ; \
	 echo "group=$(LIBVPX_32_PKG_GROUP)"                             >> $(LIBVPX_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBVPX_32_PKG_SHORT_DESCRIPTION)\"" >> $(LIBVPX_32_PKG)/.PKGINFO ; \
	 echo "url=$(LIBVPX_32_PKG_URL)"                                 >> $(LIBVPX_32_PKG)/.PKGINFO ; \
	 echo "license=$(LIBVPX_32_PKG_LICENSE)"                         >> $(LIBVPX_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBVPX_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
