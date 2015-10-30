
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/libcap

REQUIRES           = libs/libcap/2.24
REQUIRES          += app/attr/2.4.47-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 2.24
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/l/libcap/libcap-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libcap-$(version)
src_dir_name       = libcap-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LIBCAP_32_PKG_NAME                = libcap-x32
LIBCAP_32_PKG_VERSION             = 2.24
LIBCAP_32_PKG_ARCH                = $(TOOLCHAIN)
LIBCAP_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBCAP_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBCAP_32_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
LIBCAP_32_PKG_SHORT_DESCRIPTION   = get/set POSIX capabilities
LIBCAP_32_PKG_URL                 = $(BUG_URL)
LIBCAP_32_PKG_LICENSE             = GPLv2
LIBCAP_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBCAP_32_PKG_NAME)-pkg-description
LIBCAP_32_PKG_DESCRIPTION_FILE_IN = $(LIBCAP_32_PKG_NAME)-pkg-description.in
LIBCAP_32_PKG_INSTALL_SCRIPT      = $(LIBCAP_32_PKG_NAME)-pkg-install.sh

LIBCAP_32_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBCAP_32_PKG_NAME)-package

pkg_basename     = $(LIBCAP_32_PKG_NAME)-$(LIBCAP_32_PKG_VERSION)-$(LIBCAP_32_PKG_ARCH)-$(LIBCAP_32_PKG_DISTRO_NAME)-$(LIBCAP_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = FAKEROOT=$(LIBCAP_32_PKG)


BUILD_PAM_MODULE    = no

configure_switches  = lib=lib$(MULTILIB_X86_32_SUFFIX)
configure_switches += DYNAMIC=yes
configure_switches += RAISE_SETFCAP=no
configure_switches += BUILD_CC=gcc
configure_switches += PAM_CAP=$(BUILD_PAM_MODULE)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@( cd $(SRC_DIR) ; \
	   sed -i.orig "s/^\(DEBUG =\).*/\1 $(ARCH_FLAGS) $(ARCH_DEFS) $(HW_FLAGS)/" Make.Rules ; \
	 )
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) $(configure_switches)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LIBCAP_32_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(configure_switches) $(env_sysroot)
	@chmod 0755 $(LIBCAP_32_PKG)/lib$(MULTILIB_X86_32_SUFFIX)/libcap.so.?.??
ifeq ($(BUILD_PAM_MODULE),yes)
	@mv $(LIBCAP_32_PKG)/lib$(MULTILIB_X86_32_SUFFIX)/security $(LIBCAP_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)
endif
	@rm -rf $(LIBCAP_32_PKG)/sbin
	@rm -rf $(LIBCAP_32_PKG)/usr/include
	@rm -rf $(LIBCAP_32_PKG)/usr/share
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBCAP_32_PKG))
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libcap.pc ; \
	   sed -i "s,/lib,$(TARGET_DEST_DIR)/lib,g" libcap.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBCAP_32_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBCAP_32_PKG_DESCRIPTION_FILE): $(LIBCAP_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBCAP_32_PKG_DESCRIPTION_FILE) $(LIBCAP_32_PKG_INSTALL_SCRIPT)
	@cp $(LIBCAP_32_PKG_DESCRIPTION_FILE) $(LIBCAP_32_PKG)/.DESCRIPTION
	@cp $(LIBCAP_32_PKG_INSTALL_SCRIPT) $(LIBCAP_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBCAP_32_PKG)/.REQUIRES
	@echo "pkgname=$(LIBCAP_32_PKG_NAME)"                            >  $(LIBCAP_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBCAP_32_PKG_VERSION)"                          >> $(LIBCAP_32_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBCAP_32_PKG_ARCH)"                               >> $(LIBCAP_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBCAP_32_PKG_DISTRO_NAME)"                  >> $(LIBCAP_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBCAP_32_PKG_DISTRO_VERSION)"                >> $(LIBCAP_32_PKG)/.PKGINFO ; \
	 echo "group=$(LIBCAP_32_PKG_GROUP)"                             >> $(LIBCAP_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBCAP_32_PKG_SHORT_DESCRIPTION)\"" >> $(LIBCAP_32_PKG)/.PKGINFO ; \
	 echo "url=$(LIBCAP_32_PKG_URL)"                                 >> $(LIBCAP_32_PKG)/.PKGINFO ; \
	 echo "license=$(LIBCAP_32_PKG_LICENSE)"                         >> $(LIBCAP_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBCAP_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
