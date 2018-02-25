
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/VideoLAN/x264

REQUIRES           = libs/libx264/0.148.20160920
REQUIRES          += libs/glibc/2.26-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 0.148.20160920
short_version      = $(shell echo $(version) | cut -f 1,2 -d '.').x
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/m/VideoLAN/x264/x264-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/x264-$(version)
src_dir_name       = x264-$(version)
doc_dir_name       = libx264-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LIBX264_32_PKG_NAME                = libx264-x32
LIBX264_32_PKG_VERSION             = 0.148.20160920
LIBX264_32_PKG_ARCH                = $(TOOLCHAIN)
LIBX264_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBX264_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBX264_32_PKG_GROUP               = $(PKG_GROUP)
###                                 |---handy-ruler-------------------------------|
LIBX264_32_PKG_SHORT_DESCRIPTION   = H.264/MPEG-4 AVC encoder library
LIBX264_32_PKG_URL                 = $(BUG_URL)
LIBX264_32_PKG_LICENSE             = GPLv2
LIBX264_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBX264_32_PKG_NAME)-pkg-description
LIBX264_32_PKG_DESCRIPTION_FILE_IN = $(LIBX264_32_PKG_NAME)-pkg-description.in
LIBX264_32_PKG_INSTALL_SCRIPT      = $(LIBX264_32_PKG_NAME)-pkg-install.sh

LIBX264_32_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBX264_32_PKG_NAME)-package

pkg_basename      = $(LIBX264_32_PKG_NAME)-$(LIBX264_32_PKG_VERSION)-$(LIBX264_32_PKG_ARCH)-$(LIBX264_32_PKG_DISTRO_NAME)-$(LIBX264_32_PKG_DISTRO_VERSION)

pkg_archive       = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature     = $(call sign-name,$(pkg_archive))
pkg_description   = $(call desc-name,$(pkg_archive))
products          = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS     = $(build_target)
BUILD_TARGETS    += $(install_target)

PRODUCT_TARGETS   = $(products)

ROOTFS_TARGETS    = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(LIBX264_32_PKG)


ENABLE_X86_YASM = yes


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --bindir=/usr/bin/32

extra_configure_switches += --disable-cli
extra_configure_switches += --disable-opencl

extra_configure_switches += --bit-depth='8'
extra_configure_switches += --chroma-format=all

extra_configure_switches += --enable-pic

extra_configure_switches += --disable-avs
extra_configure_switches += --disable-swscale
extra_configure_switches += --disable-lavf
extra_configure_switches += --disable-ffms
extra_configure_switches += --disable-gpac
extra_configure_switches += --disable-lsmash

extra_configure_switches += --enable-shared


ifeq ($(ENABLE_X86_YASM),yes)
extra_x86_environment  = AS=/usr/bin/yasm
else
extra_configure_switches += --disable-asm
endif


TARGET_LIB_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib/../lib$(MULTILIB_X86_32_SUFFIX)

LDFLAGS += -Wl,-rpath,$(TARGET_LIB_RPATH)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && \
	  $(BUILD_ENVIRONMENT) $(extra_x86_environment) ./configure \
	  --prefix=/usr               \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LIBX264_32_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(LIBX264_32_PKG)/usr/include
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBX264_32_PKG))
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" x264.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBX264_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(LIBX264_32_PKG_DESCRIPTION_FILE): $(LIBX264_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(short_version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBX264_32_PKG_DESCRIPTION_FILE) $(LIBX264_32_PKG_INSTALL_SCRIPT)
	@cp $(LIBX264_32_PKG_DESCRIPTION_FILE) $(LIBX264_32_PKG)/.DESCRIPTION
	@cp $(LIBX264_32_PKG_INSTALL_SCRIPT) $(LIBX264_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBX264_32_PKG)/.REQUIRES
	@echo "pkgname=$(LIBX264_32_PKG_NAME)"                            >  $(LIBX264_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBX264_32_PKG_VERSION)"                          >> $(LIBX264_32_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBX264_32_PKG_ARCH)"                               >> $(LIBX264_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBX264_32_PKG_DISTRO_NAME)"                  >> $(LIBX264_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBX264_32_PKG_DISTRO_VERSION)"                >> $(LIBX264_32_PKG)/.PKGINFO ; \
	 echo "group=$(LIBX264_32_PKG_GROUP)"                             >> $(LIBX264_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBX264_32_PKG_SHORT_DESCRIPTION)\"" >> $(LIBX264_32_PKG)/.PKGINFO ; \
	 echo "url=$(LIBX264_32_PKG_URL)"                                 >> $(LIBX264_32_PKG)/.PKGINFO ; \
	 echo "license=$(LIBX264_32_PKG_LICENSE)"                         >> $(LIBX264_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LIBX264_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
