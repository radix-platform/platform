
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/VideoLAN/x264

REQUIRES           = libs/openh264/1.6.0
REQUIRES          += libs/glibc/2.24-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 1.6.0
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/m/openh264/openh264-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/openh264-$(version)
src_dir_name       = openh264-$(version)
doc_dir_name       = openh264-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
OPENH264_32_PKG_NAME                = openh264-x32
OPENH264_32_PKG_VERSION             = 1.6.0
OPENH264_32_PKG_ARCH                = $(TOOLCHAIN)
OPENH264_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
OPENH264_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
OPENH264_32_PKG_GROUP               = $(PKG_GROUP)
###                                  |---handy-ruler-------------------------------|
OPENH264_32_PKG_SHORT_DESCRIPTION   = Cisco H.264 implementation
OPENH264_32_PKG_URL                 = $(BUG_URL)
OPENH264_32_PKG_LICENSE             = BSD
OPENH264_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(OPENH264_32_PKG_NAME)-pkg-description
OPENH264_32_PKG_DESCRIPTION_FILE_IN = $(OPENH264_32_PKG_NAME)-pkg-description.in
OPENH264_32_PKG_INSTALL_SCRIPT      = $(OPENH264_32_PKG_NAME)-pkg-install.sh

OPENH264_32_PKG   = $(CURDIR)/$(TARGET_BUILD_DIR)/$(OPENH264_32_PKG_NAME)-package

pkg_basename      = $(OPENH264_32_PKG_NAME)-$(OPENH264_32_PKG_VERSION)-$(OPENH264_32_PKG_ARCH)-$(OPENH264_32_PKG_DISTRO_NAME)-$(OPENH264_32_PKG_DISTRO_VERSION)

pkg_archive       = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature     = $(call sign-name,$(pkg_archive))
pkg_description   = $(call desc-name,$(pkg_archive))
products          = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS     = $(build_target)
BUILD_TARGETS    += $(install_target)

PRODUCT_TARGETS   = $(products)

ROOTFS_TARGETS    = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(OPENH264_32_PKG)


ENABLE_X86_NASM = no


TARGET_LIB_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib/../lib$(MULTILIB_X86_32_SUFFIX)


ARCH = i386
ARCH_INCLUDES = x86


h264_environment  = OS=linux
h264_environment += ARCH=$(ARCH)

ifneq ($(filter $(HARDWARE),$(HARDWARE_PC64)),)
ifneq ($(ENABLE_X86_NASM),yes)
h264_environment += USE_ASM=No
endif
endif

h264_environment += PREFIX=/usr
h264_environment += LIBDIR_NAME=lib$(MULTILIB_X86_32_SUFFIX)
h264_environment += SHAREDLIB_DIR=/usr/lib$(MULTILIB_X86_32_SUFFIX)

h264_environment += CC='$(CROSS_PREFIX)gcc'
h264_environment += CXX='$(CROSS_PREFIX)g++'
h264_environment += CCAS='$(CROSS_PREFIX)gcc'
h264_environment += LD='$(CROSS_PREFIX)ld'
h264_environment += AR='$(CROSS_PREFIX)ar'
h264_environment += STRIP='$(CROSS_PREFIX)strip'

h264_environment += SRC_PATH='$(CURDIR)/$(SRC_DIR)/'

h264_environment += CFLAGS_OPT='--sysroot=$(TARGET_DEST_DIR) $(CFLAGS) $(ARCH_FLAGS) $(ARCH_DEFS) $(HW_FLAGS) -m32 -fPIC -Wno-parentheses'
h264_environment += ASMFLAGS='--sysroot=$(TARGET_DEST_DIR) -m32 $(CFLAGS) $(ARCH_FLAGS) -I$(CURDIR)/$(SRC_DIR)/codec/common/$(ARCH_INCLUDES)'
h264_environment += LDFLAGS='--sysroot=$(TARGET_DEST_DIR) -m32 -Wl,-rpath,$(TARGET_LIB_RPATH) -L$(TARGET_DEST_DIR)/lib$(LIBSUFFIX) -L$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) -lpthread -lstdc++'



####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) $(h264_environment)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(OPENH264_32_PKG)/usr/bin/32
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot) $(h264_environment)
	@( cd $(SRC_DIR) ; \
	   cp -a h264{enc,dec} $(OPENH264_32_PKG)/usr/bin/32 ; \
	 )
	@rm -rf $(OPENH264_32_PKG)/usr/include
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(OPENH264_32_PKG))
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" openh264.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(OPENH264_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(OPENH264_32_PKG_DESCRIPTION_FILE): $(OPENH264_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(OPENH264_32_PKG_DESCRIPTION_FILE) $(OPENH264_32_PKG_INSTALL_SCRIPT)
	@cp $(OPENH264_32_PKG_DESCRIPTION_FILE) $(OPENH264_32_PKG)/.DESCRIPTION
	@cp $(OPENH264_32_PKG_INSTALL_SCRIPT) $(OPENH264_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(OPENH264_32_PKG)/.REQUIRES
	@echo "pkgname=$(OPENH264_32_PKG_NAME)"                            >  $(OPENH264_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(OPENH264_32_PKG_VERSION)"                          >> $(OPENH264_32_PKG)/.PKGINFO ; \
	 echo "arch=$(OPENH264_32_PKG_ARCH)"                               >> $(OPENH264_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(OPENH264_32_PKG_DISTRO_NAME)"                  >> $(OPENH264_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(OPENH264_32_PKG_DISTRO_VERSION)"                >> $(OPENH264_32_PKG)/.PKGINFO ; \
	 echo "group=$(OPENH264_32_PKG_GROUP)"                             >> $(OPENH264_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(OPENH264_32_PKG_SHORT_DESCRIPTION)\"" >> $(OPENH264_32_PKG)/.PKGINFO ; \
	 echo "url=$(OPENH264_32_PKG_URL)"                                 >> $(OPENH264_32_PKG)/.PKGINFO ; \
	 echo "license=$(OPENH264_32_PKG_LICENSE)"                         >> $(OPENH264_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(OPENH264_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
