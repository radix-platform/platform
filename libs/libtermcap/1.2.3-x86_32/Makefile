
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/termcap-compat

REQUIRES           = libs/libtermcap/1.2.3
REQUIRES          += libs/ncurses/6.0-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 1.2.3
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/termcap-compat/termcap-compat_$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/termcap-compat-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
TERMCAP_32_PKG_NAME                = libtermcap-x32
TERMCAP_32_PKG_VERSION             = 1.2.3
TERMCAP_32_PKG_ARCH                = $(TOOLCHAIN)
TERMCAP_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
TERMCAP_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
TERMCAP_32_PKG_GROUP               = $(PKG_GROUP)
###                                 |---handy-ruler-------------------------------|
TERMCAP_32_PKG_SHORT_DESCRIPTION   = GNU termcap library
TERMCAP_32_PKG_URL                 = $(BUG_URL)
TERMCAP_32_PKG_LICENSE             = GPLv2
TERMCAP_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(TERMCAP_32_PKG_NAME)-pkg-description
TERMCAP_32_PKG_DESCRIPTION_FILE_IN = $(TERMCAP_32_PKG_NAME)-pkg-description.in
TERMCAP_32_PKG_INSTALL_SCRIPT      = $(TERMCAP_32_PKG_NAME)-pkg-install.sh

TERMCAP_32_PKG   = $(CURDIR)/$(TARGET_BUILD_DIR)/$(TERMCAP_32_PKG_NAME)-package

pkg_basename     = $(TERMCAP_32_PKG_NAME)-$(TERMCAP_32_PKG_VERSION)-$(TERMCAP_32_PKG_ARCH)-$(TERMCAP_32_PKG_DISTRO_NAME)-$(TERMCAP_32_PKG_DISTRO_VERSION)

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


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(TERMCAP_32_PKG)/lib$(MULTILIB_X86_32_SUFFIX)
	@mkdir -p $(TERMCAP_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)
	@( cd $(SRC_DIR) ; \
	   install -m755 libtermcap.so.* $(TERMCAP_32_PKG)/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   install -m644 libtermcap.a $(TERMCAP_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) \
	 )
	@( cd $(TERMCAP_32_PKG)/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   ln -sf libtermcap.so.?.?.? libtermcap.so.2 \
	 )
	@( cd $(TERMCAP_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   ln -sf ../../lib$(MULTILIB_X86_32_SUFFIX)/libtermcap.so.?.?.? . ; \
	   ln -sf libtermcap.so.?.?.? libtermcap.so ; \
	   ln -sf libtermcap.so.?.?.? libtermcap.so.2 \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(TERMCAP_32_PKG))
	# ======= Strip binaries =======
	@( cd $(TERMCAP_32_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(TERMCAP_32_PKG_DESCRIPTION_FILE): $(TERMCAP_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(TERMCAP_32_PKG_DESCRIPTION_FILE) $(TERMCAP_32_PKG_INSTALL_SCRIPT)
	@cp $(TERMCAP_32_PKG_DESCRIPTION_FILE) $(TERMCAP_32_PKG)/.DESCRIPTION
	@cp $(TERMCAP_32_PKG_INSTALL_SCRIPT) $(TERMCAP_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(TERMCAP_32_PKG)/.REQUIRES
	@echo "pkgname=$(TERMCAP_32_PKG_NAME)"                            >  $(TERMCAP_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(TERMCAP_32_PKG_VERSION)"                          >> $(TERMCAP_32_PKG)/.PKGINFO ; \
	 echo "arch=$(TERMCAP_32_PKG_ARCH)"                               >> $(TERMCAP_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(TERMCAP_32_PKG_DISTRO_NAME)"                  >> $(TERMCAP_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(TERMCAP_32_PKG_DISTRO_VERSION)"                >> $(TERMCAP_32_PKG)/.PKGINFO ; \
	 echo "group=$(TERMCAP_32_PKG_GROUP)"                             >> $(TERMCAP_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(TERMCAP_32_PKG_SHORT_DESCRIPTION)\"" >> $(TERMCAP_32_PKG)/.PKGINFO ; \
	 echo "url=$(TERMCAP_32_PKG_URL)"                                 >> $(TERMCAP_32_PKG)/.PKGINFO ; \
	 echo "license=$(TERMCAP_32_PKG_LICENSE)"                         >> $(TERMCAP_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(TERMCAP_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
