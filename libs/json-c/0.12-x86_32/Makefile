
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/json-c

REQUIRES           = libs/json-c/0.12
REQUIRES          += libs/eglibc/2.19.1-x86_32


version            = 0.12
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/json-c/json-c-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/json-c-$(version)
src_dir_name       = json-c-$(version)
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
JSONC_32_PKG_NAME                = json-c-x32
JSONC_32_PKG_VERSION             = 0.12
JSONC_32_PKG_ARCH                = $(TOOLCHAIN)
JSONC_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
JSONC_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
JSONC_32_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
JSONC_32_PKG_SHORT_DESCRIPTION   = javascript object notation library for C
JSONC_32_PKG_URL                 = $(BUG_URL)
JSONC_32_PKG_LICENSE             = custom
JSONC_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(JSONC_32_PKG_NAME)-pkg-description
JSONC_32_PKG_DESCRIPTION_FILE_IN = $(JSONC_32_PKG_NAME)-pkg-description.in
JSONC_32_PKG_INSTALL_SCRIPT      = $(JSONC_32_PKG_NAME)-pkg-install.sh

JSONC_32_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(JSONC_32_PKG_NAME)-package

pkg_basename     = $(JSONC_32_PKG_NAME)-$(JSONC_32_PKG_VERSION)-$(JSONC_32_PKG_ARCH)-$(JSONC_32_PKG_DISTRO_NAME)-$(JSONC_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(JSONC_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


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
	@mkdir -p $(JSONC_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@rm -rf $(JSONC_32_PKG)/usr/include
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(JSONC_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libjson-c.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(JSONC_32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libjson-c.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libjson-c.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" json-c.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(JSONC_32_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(JSONC_32_PKG_DESCRIPTION_FILE): $(JSONC_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(JSONC_32_PKG_DESCRIPTION_FILE) $(JSONC_32_PKG_INSTALL_SCRIPT)
	@cp $(JSONC_32_PKG_DESCRIPTION_FILE) $(JSONC_32_PKG)/.DESCRIPTION
	@cp $(JSONC_32_PKG_INSTALL_SCRIPT) $(JSONC_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(JSONC_32_PKG)/.REQUIRES
	@echo "pkgname=$(JSONC_32_PKG_NAME)"                            >  $(JSONC_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(JSONC_32_PKG_VERSION)"                          >> $(JSONC_32_PKG)/.PKGINFO ; \
	 echo "arch=$(JSONC_32_PKG_ARCH)"                               >> $(JSONC_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(JSONC_32_PKG_DISTRO_NAME)"                  >> $(JSONC_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(JSONC_32_PKG_DISTRO_VERSION)"                >> $(JSONC_32_PKG)/.PKGINFO ; \
	 echo "group=$(JSONC_32_PKG_GROUP)"                             >> $(JSONC_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(JSONC_32_PKG_SHORT_DESCRIPTION)\"" >> $(JSONC_32_PKG)/.PKGINFO ; \
	 echo "url=$(JSONC_32_PKG_URL)"                                 >> $(JSONC_32_PKG)/.PKGINFO ; \
	 echo "license=$(JSONC_32_PKG_LICENSE)"                         >> $(JSONC_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(JSONC_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
