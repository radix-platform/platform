
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/icu4c

REQUIRES           = libs/icu4c/55.1

# ======= __END_OF_REQUIRES__ =======


version            = 55.1
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/l/icu4c/icu4c-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/icu4c-$(version)
src_dir_name       = icu4c-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_host_dir     = $(TARGET_BUILD_DIR)/build_host
build_target_dir   = $(TARGET_BUILD_DIR)/build_target

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
ICU4C_32_PKG_NAME                = icu4c-x32
ICU4C_32_PKG_VERSION             = 55.1
ICU4C_32_PKG_ARCH                = $(TOOLCHAIN)
ICU4C_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
ICU4C_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
ICU4C_32_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
ICU4C_32_PKG_SHORT_DESCRIPTION   = International Components for Unicode
ICU4C_32_PKG_URL                 = $(BUG_URL)
ICU4C_32_PKG_LICENSE             = ICU
ICU4C_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(ICU4C_32_PKG_NAME)-pkg-description
ICU4C_32_PKG_DESCRIPTION_FILE_IN = $(ICU4C_32_PKG_NAME)-pkg-description.in
ICU4C_32_PKG_INSTALL_SCRIPT      = $(ICU4C_32_PKG_NAME)-pkg-install.sh

ICU4C_32_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(ICU4C_32_PKG_NAME)-package

pkg_basename     = $(ICU4C_32_PKG_NAME)-$(ICU4C_32_PKG_VERSION)-$(ICU4C_32_PKG_ARCH)-$(ICU4C_32_PKG_DISTRO_NAME)-$(ICU4C_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_certificate  = $(call cert-name,$(pkg_archive))
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(ICU4C_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --disable-samples
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes

extra_configure_switches += --with-cross-build=$(CURDIR)/$(build_host_dir)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@( cd $(SRC_DIR)/source/config ; \
	   sed -i "s,^LDFLAGSICUDT,#LDFLAGSICUDT," mh-linux ; \
	 )
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_host_dir)
	@mkdir -p $(build_target_dir)
	@cd $(build_host_dir) && $(CURDIR)/$(SRC_DIR)/source/runConfigureICU Linux
	@cd $(build_host_dir) && $(MAKE)
	@cd $(build_target_dir) && \
	  $(BUILD_ENVIRONMENT) $(CURDIR)/$(SRC_DIR)/source/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(build_target_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(ICU4C_32_PKG)
	@cd $(build_target_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@mkdir -p $(ICU4C_32_PKG)/usr/bin/32
	@( cd $(ICU4C_32_PKG)/usr/bin ; \
	   find . -type f | xargs mv -t 32 ; \
	 )
	@mkdir -p $(ICU4C_32_PKG)/usr/sbin/32
	@( cd $(ICU4C_32_PKG)/usr/sbin ; \
	   find . -type f | xargs mv -t 32 ; \
	 )
	@rm -rf $(ICU4C_32_PKG)/usr/include
	@rm -rf $(ICU4C_32_PKG)/usr/share
	# ======= change permissions of *.a files =======
	@( cd $(ICU4C_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   chmod 0644 *.a ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(ICU4C_32_PKG))
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" icu-i18n.pc icu-io.pc icu-le.pc icu-lx.pc icu-uc.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(ICU4C_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(ICU4C_32_PKG_DESCRIPTION_FILE): $(ICU4C_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(ICU4C_32_PKG_DESCRIPTION_FILE) $(ICU4C_32_PKG_INSTALL_SCRIPT)
	@cp $(ICU4C_32_PKG_DESCRIPTION_FILE) $(ICU4C_32_PKG)/.DESCRIPTION
	@cp $(ICU4C_32_PKG_INSTALL_SCRIPT) $(ICU4C_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(ICU4C_32_PKG)/.REQUIRES
	@echo "pkgname=$(ICU4C_32_PKG_NAME)"                            >  $(ICU4C_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(ICU4C_32_PKG_VERSION)"                          >> $(ICU4C_32_PKG)/.PKGINFO ; \
	 echo "arch=$(ICU4C_32_PKG_ARCH)"                               >> $(ICU4C_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(ICU4C_32_PKG_DISTRO_NAME)"                  >> $(ICU4C_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(ICU4C_32_PKG_DISTRO_VERSION)"                >> $(ICU4C_32_PKG)/.PKGINFO ; \
	 echo "group=$(ICU4C_32_PKG_GROUP)"                             >> $(ICU4C_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(ICU4C_32_PKG_SHORT_DESCRIPTION)\"" >> $(ICU4C_32_PKG)/.PKGINFO ; \
	 echo "url=$(ICU4C_32_PKG_URL)"                                 >> $(ICU4C_32_PKG)/.PKGINFO ; \
	 echo "license=$(ICU4C_32_PKG_LICENSE)"                         >> $(ICU4C_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(ICU4C_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
