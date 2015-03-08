
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/d/check

REQUIRES           = dev/check/0.9.13
REQUIRES          += libs/eglibc/2.19.1-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 0.9.13
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/d/check/check-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/check-$(version)
src_dir_name       = check-$(version)
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
CHECK_32_PKG_NAME                = check-x32
CHECK_32_PKG_VERSION             = 0.9.13
CHECK_32_PKG_ARCH                = $(TOOLCHAIN)
CHECK_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
CHECK_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
CHECK_32_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
CHECK_32_PKG_SHORT_DESCRIPTION   = The unit testing framework for C
CHECK_32_PKG_URL                 = $(BUG_URL)
CHECK_32_PKG_LICENSE             = LGPLv2
CHECK_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(CHECK_32_PKG_NAME)-pkg-description
CHECK_32_PKG_DESCRIPTION_FILE_IN = $(CHECK_32_PKG_NAME)-pkg-description.in
CHECK_32_PKG_INSTALL_SCRIPT      = $(CHECK_32_PKG_NAME)-pkg-install.sh

CHECK_32_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(CHECK_32_PKG_NAME)-package

pkg_basename     = $(CHECK_32_PKG_NAME)-$(CHECK_32_PKG_VERSION)-$(CHECK_32_PKG_ARCH)-$(CHECK_32_PKG_DISTRO_NAME)-$(CHECK_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(CHECK_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
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
	@mkdir -p $(CHECK_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@mkdir -p $(CHECK_32_PKG)/usr/bin/32
	@( cd $(CHECK_32_PKG)/usr/bin ; \
	   find . -type f | xargs mv -t 32 ; \
	 )
	@rm -rf $(CHECK_32_PKG)/usr/include
	@rm -rf $(CHECK_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(CHECK_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libcheck.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(CHECK_32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libcheck.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libcheck.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" check.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(CHECK_32_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(CHECK_32_PKG_DESCRIPTION_FILE): $(CHECK_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(CHECK_32_PKG_DESCRIPTION_FILE) $(CHECK_32_PKG_INSTALL_SCRIPT)
	@cp $(CHECK_32_PKG_DESCRIPTION_FILE) $(CHECK_32_PKG)/.DESCRIPTION
	@cp $(CHECK_32_PKG_INSTALL_SCRIPT) $(CHECK_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(CHECK_32_PKG)/.REQUIRES
	@echo "pkgname=$(CHECK_32_PKG_NAME)"                            >  $(CHECK_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(CHECK_32_PKG_VERSION)"                          >> $(CHECK_32_PKG)/.PKGINFO ; \
	 echo "arch=$(CHECK_32_PKG_ARCH)"                               >> $(CHECK_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(CHECK_32_PKG_DISTRO_NAME)"                  >> $(CHECK_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(CHECK_32_PKG_DISTRO_VERSION)"                >> $(CHECK_32_PKG)/.PKGINFO ; \
	 echo "group=$(CHECK_32_PKG_GROUP)"                             >> $(CHECK_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(CHECK_32_PKG_SHORT_DESCRIPTION)\"" >> $(CHECK_32_PKG)/.PKGINFO ; \
	 echo "url=$(CHECK_32_PKG_URL)"                                 >> $(CHECK_32_PKG)/.PKGINFO ; \
	 echo "license=$(CHECK_32_PKG_LICENSE)"                         >> $(CHECK_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(CHECK_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
