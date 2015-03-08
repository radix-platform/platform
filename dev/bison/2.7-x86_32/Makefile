
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/GNU/bison

REQUIRES           = dev/bison/2.7
REQUIRES          += libs/eglibc/2.19.1-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 2.7
tar_xz_archive     = $(SRC_PACKAGE_PATH)/GNU/bison/bison-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/bison-$(version)
src_dir_name       = bison-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = dev
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
BISON_32_PKG_NAME                = bison-x32
BISON_32_PKG_VERSION             = 2.7
BISON_32_PKG_ARCH                = $(TOOLCHAIN)
BISON_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
BISON_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
BISON_32_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
BISON_32_PKG_SHORT_DESCRIPTION   = parser generator similar to yacc
BISON_32_PKG_URL                 = $(BUG_URL)
BISON_32_PKG_LICENSE             = GPLv2
BISON_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(BISON_32_PKG_NAME)-pkg-description
BISON_32_PKG_DESCRIPTION_FILE_IN = $(BISON_32_PKG_NAME)-pkg-description.in
BISON_32_PKG_INSTALL_SCRIPT      = $(BISON_32_PKG_NAME)-pkg-install.sh

BISON_32_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(BISON_32_PKG_NAME)-package

pkg_basename     = $(BISON_32_PKG_NAME)-$(BISON_32_PKG_VERSION)-$(BISON_32_PKG_ARCH)-$(BISON_32_PKG_DISTRO_NAME)-$(BISON_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(BISON_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man


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
	@mkdir -p $(BISON_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@mkdir -p $(BISON_32_PKG)/usr/bin/32
	@( cd $(BISON_32_PKG)/usr/bin ; \
	   find . -type f | xargs mv -t 32 ; \
	 )
	@rm -rf $(BISON_32_PKG)/usr/share
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(BISON_32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= Strip binaries =======
	@( cd $(BISON_32_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(BISON_32_PKG_DESCRIPTION_FILE): $(BISON_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(BISON_32_PKG_DESCRIPTION_FILE) $(BISON_32_PKG_INSTALL_SCRIPT)
	@cp $(BISON_32_PKG_DESCRIPTION_FILE) $(BISON_32_PKG)/.DESCRIPTION
	@cp $(BISON_32_PKG_INSTALL_SCRIPT) $(BISON_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(BISON_32_PKG)/.REQUIRES
	@echo "pkgname=$(BISON_32_PKG_NAME)"                            >  $(BISON_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(BISON_32_PKG_VERSION)"                          >> $(BISON_32_PKG)/.PKGINFO ; \
	 echo "arch=$(BISON_32_PKG_ARCH)"                               >> $(BISON_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(BISON_32_PKG_DISTRO_NAME)"                  >> $(BISON_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(BISON_32_PKG_DISTRO_VERSION)"                >> $(BISON_32_PKG)/.PKGINFO ; \
	 echo "group=$(BISON_32_PKG_GROUP)"                             >> $(BISON_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(BISON_32_PKG_SHORT_DESCRIPTION)\"" >> $(BISON_32_PKG)/.PKGINFO ; \
	 echo "url=$(BISON_32_PKG_URL)"                                 >> $(BISON_32_PKG)/.PKGINFO ; \
	 echo "license=$(BISON_32_PKG_LICENSE)"                         >> $(BISON_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(BISON_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
