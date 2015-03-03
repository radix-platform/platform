
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/s/pam_unix2

REQUIRES           = secure/pam_unix2/2.9.1
REQUIRES          += libs/eglibc/2.19.1-x86_32
REQUIRES          += secure/pam/1.1.8-x86_32


version            = 2.9.1
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/s/pam_unix2/pam_unix2-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/pam_unix2-$(version)
src_dir_name       = pam_unix2-$(version)
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
PAM_U2_32_PKG_NAME                = pam_unix2-x32
PAM_U2_32_PKG_VERSION             = 2.9.1
PAM_U2_32_PKG_ARCH                = $(TOOLCHAIN)
PAM_U2_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
PAM_U2_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
PAM_U2_32_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
PAM_U2_32_PKG_SHORT_DESCRIPTION   = Standard PAM password authentication module
PAM_U2_32_PKG_URL                 = $(BUG_URL)
PAM_U2_32_PKG_LICENSE             = GPLv2
PAM_U2_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(PAM_U2_32_PKG_NAME)-pkg-description
PAM_U2_32_PKG_DESCRIPTION_FILE_IN = $(PAM_U2_32_PKG_NAME)-pkg-description.in
PAM_U2_32_PKG_INSTALL_SCRIPT      = $(PAM_U2_32_PKG_NAME)-pkg-install.sh

PAM_U2_32_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(PAM_U2_32_PKG_NAME)-package

pkg_basename     = $(PAM_U2_32_PKG_NAME)-$(PAM_U2_32_PKG_VERSION)-$(PAM_U2_32_PKG_ARCH)-$(PAM_U2_32_PKG_DISTRO_NAME)-$(PAM_U2_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(PAM_U2_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --includedir=/usr/include/security
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var/lib
extra_configure_switches += --without-libiconv-prefix
extra_configure_switches += --disable-selinux
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
	@mkdir -p $(PAM_U2_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@rm -rf $(PAM_U2_32_PKG)/etc
	@rm -rf $(PAM_U2_32_PKG)/usr/share
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(PAM_U2_32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= Strip binaries =======
	@( cd $(PAM_U2_32_PKG); \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(PAM_U2_32_PKG_DESCRIPTION_FILE): $(PAM_U2_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(PAM_U2_32_PKG_DESCRIPTION_FILE) $(PAM_U2_32_PKG_INSTALL_SCRIPT)
	@cp $(PAM_U2_32_PKG_DESCRIPTION_FILE) $(PAM_U2_32_PKG)/.DESCRIPTION
	@cp $(PAM_U2_32_PKG_INSTALL_SCRIPT) $(PAM_U2_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(PAM_U2_32_PKG)/.REQUIRES
	@echo "pkgname=$(PAM_U2_32_PKG_NAME)"                            >  $(PAM_U2_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(PAM_U2_32_PKG_VERSION)"                          >> $(PAM_U2_32_PKG)/.PKGINFO ; \
	 echo "arch=$(PAM_U2_32_PKG_ARCH)"                               >> $(PAM_U2_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(PAM_U2_32_PKG_DISTRO_NAME)"                  >> $(PAM_U2_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(PAM_U2_32_PKG_DISTRO_VERSION)"                >> $(PAM_U2_32_PKG)/.PKGINFO ; \
	 echo "group=$(PAM_U2_32_PKG_GROUP)"                             >> $(PAM_U2_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(PAM_U2_32_PKG_SHORT_DESCRIPTION)\"" >> $(PAM_U2_32_PKG)/.PKGINFO ; \
	 echo "url=$(PAM_U2_32_PKG_URL)"                                 >> $(PAM_U2_32_PKG)/.PKGINFO ; \
	 echo "license=$(PAM_U2_32_PKG_LICENSE)"                         >> $(PAM_U2_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(PAM_U2_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
