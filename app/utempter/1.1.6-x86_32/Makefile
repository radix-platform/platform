
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/utempter

REQUIRES           = app/utempter/1.1.6
REQUIRES          += libs/glibc/2.28-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 1.1.6
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/a/utempter/libutempter-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libutempter-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
UTEMPTER_32_PKG_NAME                = utempter-x32
UTEMPTER_32_PKG_VERSION             = 1.1.6
UTEMPTER_32_PKG_ARCH                = $(TOOLCHAIN)
UTEMPTER_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
UTEMPTER_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
UTEMPTER_32_PKG_GROUP               = $(PKG_GROUP)
###                                  |---handy-ruler-------------------------------|
UTEMPTER_32_PKG_SHORT_DESCRIPTION   = utmp updating x86_32 library
UTEMPTER_32_PKG_URL                 = $(BUG_URL)
UTEMPTER_32_PKG_LICENSE             = LGPLv2.1
UTEMPTER_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(UTEMPTER_32_PKG_NAME)-pkg-description
UTEMPTER_32_PKG_DESCRIPTION_FILE_IN = $(UTEMPTER_32_PKG_NAME)-pkg-description.in
UTEMPTER_32_PKG_INSTALL_SCRIPT      = $(UTEMPTER_32_PKG_NAME)-pkg-install.sh

UTEMPTER_32_PKG  = $(CURDIR)/$(TARGET_BUILD_DIR)/$(UTEMPTER_32_PKG_NAME)-package

pkg_basename     = $(UTEMPTER_32_PKG_NAME)-$(UTEMPTER_32_PKG_VERSION)-$(UTEMPTER_32_PKG_ARCH)-$(UTEMPTER_32_PKG_DISTRO_NAME)-$(UTEMPTER_32_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(UTEMPTER_32_PKG)

environment  = libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
environment += libexecdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
environment += includedir=/usr/include
environment += mandir=/usr/share/man


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(environment) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(UTEMPTER_32_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(environment) $(MAKE) -j1 install $(env_sysroot)
ifneq ($(__ENABLE_STATIC__),yes)
	@rm -f $(UTEMPTER_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/*.a
endif
	@rm -rf $(UTEMPTER_32_PKG)/usr/include
	@rm -rf $(UTEMPTER_32_PKG)/usr/share
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(UTEMPTER_32_PKG))
	# ======= Strip binaries =======
	@( cd $(UTEMPTER_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifeq ($(__ENABLE_STATIC__),yes)
	@( cd $(UTEMPTER_32_PKG) ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null ; \
	 )
endif
	@touch $@

$(UTEMPTER_32_PKG_DESCRIPTION_FILE): $(UTEMPTER_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(UTEMPTER_32_PKG_DESCRIPTION_FILE) $(UTEMPTER_32_PKG_INSTALL_SCRIPT)
	@cp $(UTEMPTER_32_PKG_DESCRIPTION_FILE) $(UTEMPTER_32_PKG)/.DESCRIPTION
	@cp $(UTEMPTER_32_PKG_INSTALL_SCRIPT) $(UTEMPTER_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(UTEMPTER_32_PKG)/.REQUIRES
	@echo "pkgname=$(UTEMPTER_32_PKG_NAME)"                            >  $(UTEMPTER_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(UTEMPTER_32_PKG_VERSION)"                          >> $(UTEMPTER_32_PKG)/.PKGINFO ; \
	 echo "arch=$(UTEMPTER_32_PKG_ARCH)"                               >> $(UTEMPTER_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(UTEMPTER_32_PKG_DISTRO_NAME)"                  >> $(UTEMPTER_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(UTEMPTER_32_PKG_DISTRO_VERSION)"                >> $(UTEMPTER_32_PKG)/.PKGINFO ; \
	 echo "group=$(UTEMPTER_32_PKG_GROUP)"                             >> $(UTEMPTER_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(UTEMPTER_32_PKG_SHORT_DESCRIPTION)\"" >> $(UTEMPTER_32_PKG)/.PKGINFO ; \
	 echo "url=$(UTEMPTER_32_PKG_URL)"                                 >> $(UTEMPTER_32_PKG)/.PKGINFO ; \
	 echo "license=$(UTEMPTER_32_PKG_LICENSE)"                         >> $(UTEMPTER_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(UTEMPTER_32_PKG) && \
	                  chown -R root:root .  && \
	                  chown    root:22 usr/lib$(MULTILIB_X86_32_SUFFIX)/utempter/utempter && \
	                  $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
