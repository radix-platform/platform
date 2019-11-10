
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/lm-sensors

REQUIRES           = app/lm-sensors/3.6.0

# ======= __END_OF_REQUIRES__ =======


version            = 3.6.0
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/a/lm-sensors/lm-sensors-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/lm-sensors-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LMSENS_32_PKG_NAME                = lm-sensors-x32
LMSENS_32_PKG_VERSION             = 3.6.0
LMSENS_32_PKG_ARCH                = $(TOOLCHAIN)
LMSENS_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LMSENS_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LMSENS_32_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
LMSENS_32_PKG_SHORT_DESCRIPTION   = hardware monitoring package
LMSENS_32_PKG_URL                 = $(BUG_URL)
LMSENS_32_PKG_LICENSE             = LGPLv2.1
LMSENS_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LMSENS_32_PKG_NAME)-pkg-description
LMSENS_32_PKG_DESCRIPTION_FILE_IN = $(LMSENS_32_PKG_NAME)-pkg-description.in
LMSENS_32_PKG_INSTALL_SCRIPT      = $(LMSENS_32_PKG_NAME)-pkg-install.sh

LMSENS_32_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LMSENS_32_PKG_NAME)-package

pkg_basename     = $(LMSENS_32_PKG_NAME)-$(LMSENS_32_PKG_VERSION)-$(LMSENS_32_PKG_ARCH)-$(LMSENS_32_PKG_DISTRO_NAME)-$(LMSENS_32_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(LMSENS_32_PKG)

lmsens_environment     = CC="$(CC) --sysroot=$(TARGET_DEST_DIR)"
lmsens_environment    += RANLIB="$(RANLIB)"

lmsens_environment    += CFLAGS="$(ARCH_FLAGS)"
lmsens_environment    += CPPFLAGS="$(ARCH_DEFS)  $(HW_FLAGS)"

lmsens_environment    += LIBDIR=/usr/lib$(MULTILIB_X86_32_SUFFIX)
lmsens_environment    += EXLDFLAGS="-Wl,-rpath,/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX)"
lmsens_environment    += LDFLAGS="-Wl,-rpath,/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib/../lib$(MULTILIB_X86_32_SUFFIX)"

lmsens_environment    += PREFIX=/usr
lmsens_environment    += ETCDIR=/etc
lmsens_environment    += BINDIR=/usr/bin
lmsens_environment    += SBINDIR=/usr/sbin
lmsens_environment    += MANDIR=/usr/share/man


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	# ======= build lm_sensors =======
	@( cd $(SRC_DIR) ; \
	   $(MAKE) user $(lmsens_environment) ; \
	 )
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LMSENS_32_PKG)
	# ======= install lm_sensors =======
	@( cd $(SRC_DIR) ; \
	   $(MAKE) user_install $(lmsens_environment) $(env_sysroot) ; \
	 )
ifneq ($(__ENABLE_STATIC__),yes)
	@rm -f $(LMSENS_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/*.a
endif
	@rm -rf $(LMSENS_32_PKG)/etc
	@rm -rf $(LMSENS_32_PKG)/usr/bin
	@rm -rf $(LMSENS_32_PKG)/usr/include
	@rm -rf $(LMSENS_32_PKG)/usr/sbin
	@rm -rf $(LMSENS_32_PKG)/usr/share
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LMSENS_32_PKG))
	# ======= Strip binaries =======
	@( cd $(LMSENS_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifeq ($(__ENABLE_STATIC__),yes)
	@( cd $(LMSENS_32_PKG) ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null ; \
	 )
endif
	@touch $@

$(LMSENS_32_PKG_DESCRIPTION_FILE): $(LMSENS_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LMSENS_32_PKG_DESCRIPTION_FILE) $(LMSENS_32_PKG_INSTALL_SCRIPT)
	@cp $(LMSENS_32_PKG_DESCRIPTION_FILE) $(LMSENS_32_PKG)/.DESCRIPTION
	@cp $(LMSENS_32_PKG_INSTALL_SCRIPT) $(LMSENS_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LMSENS_32_PKG)/.REQUIRES
	@echo "pkgname=$(LMSENS_32_PKG_NAME)"                            >  $(LMSENS_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LMSENS_32_PKG_VERSION)"                          >> $(LMSENS_32_PKG)/.PKGINFO ; \
	 echo "arch=$(LMSENS_32_PKG_ARCH)"                               >> $(LMSENS_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LMSENS_32_PKG_DISTRO_NAME)"                  >> $(LMSENS_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LMSENS_32_PKG_DISTRO_VERSION)"                >> $(LMSENS_32_PKG)/.PKGINFO ; \
	 echo "group=$(LMSENS_32_PKG_GROUP)"                             >> $(LMSENS_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LMSENS_32_PKG_SHORT_DESCRIPTION)\"" >> $(LMSENS_32_PKG)/.PKGINFO ; \
	 echo "url=$(LMSENS_32_PKG_URL)"                                 >> $(LMSENS_32_PKG)/.PKGINFO ; \
	 echo "license=$(LMSENS_32_PKG_LICENSE)"                         >> $(LMSENS_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LMSENS_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
