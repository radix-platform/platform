
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/slang

REQUIRES           = libs/slang/2.2.4
REQUIRES          += libs/eglibc/2.19.1-x86_32
REQUIRES          += libs/pcre/8.34-x86_32
REQUIRES          += libs/libpng/libpng14/1.4.13-x86_32
REQUIRES          += libs/zlib/1.2.8-x86_32


version            = 2.2.4
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/l/slang/slang-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/slang-$(version)
src_dir_name       = slang-$(version)
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
SLANG_32_PKG_NAME                = slang-x32
SLANG_32_PKG_VERSION             = 2.2.4
SLANG_32_PKG_ARCH                = $(TOOLCHAIN)
SLANG_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
SLANG_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
SLANG_32_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
SLANG_32_PKG_SHORT_DESCRIPTION   = S-Lang interpreter version 2
SLANG_32_PKG_URL                 = $(BUG_URL)
SLANG_32_PKG_LICENSE             = GPLv2
SLANG_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(SLANG_32_PKG_NAME)-pkg-description
SLANG_32_PKG_DESCRIPTION_FILE_IN = $(SLANG_32_PKG_NAME)-pkg-description.in
SLANG_32_PKG_INSTALL_SCRIPT      = $(SLANG_32_PKG_NAME)-pkg-install.sh

SLANG_32_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(SLANG_32_PKG_NAME)-package

pkg_basename     = $(SLANG_32_PKG_NAME)-$(SLANG_32_PKG_VERSION)-$(SLANG_32_PKG_ARCH)-$(SLANG_32_PKG_DISTRO_NAME)-$(SLANG_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(SLANG_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --includedir=/usr/include
extra_configure_switches += --bindir=/usr/bin/32


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) ./configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 elf
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(SLANG_32_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install     $(env_sysroot)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install-elf $(env_sysroot)
	@rm -rf $(SLANG_32_PKG)/etc
	@rm -rf $(SLANG_32_PKG)/usr/include
	@rm -rf $(SLANG_32_PKG)/usr/share
	@( cd $(SLANG_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   chmod 0755 libslang.so.?.?.?  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(SLANG_32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" slang.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(SLANG_32_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(SLANG_32_PKG_DESCRIPTION_FILE): $(SLANG_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(SLANG_32_PKG_DESCRIPTION_FILE) $(SLANG_32_PKG_INSTALL_SCRIPT)
	@cp $(SLANG_32_PKG_DESCRIPTION_FILE) $(SLANG_32_PKG)/.DESCRIPTION
	@cp $(SLANG_32_PKG_INSTALL_SCRIPT) $(SLANG_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(SLANG_32_PKG)/.REQUIRES
	@echo "pkgname=$(SLANG_32_PKG_NAME)"                            >  $(SLANG_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(SLANG_32_PKG_VERSION)"                          >> $(SLANG_32_PKG)/.PKGINFO ; \
	 echo "arch=$(SLANG_32_PKG_ARCH)"                               >> $(SLANG_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(SLANG_32_PKG_DISTRO_NAME)"                  >> $(SLANG_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(SLANG_32_PKG_DISTRO_VERSION)"                >> $(SLANG_32_PKG)/.PKGINFO ; \
	 echo "group=$(SLANG_32_PKG_GROUP)"                             >> $(SLANG_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(SLANG_32_PKG_SHORT_DESCRIPTION)\"" >> $(SLANG_32_PKG)/.PKGINFO ; \
	 echo "url=$(SLANG_32_PKG_URL)"                                 >> $(SLANG_32_PKG)/.PKGINFO ; \
	 echo "license=$(SLANG_32_PKG_LICENSE)"                         >> $(SLANG_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(SLANG_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
