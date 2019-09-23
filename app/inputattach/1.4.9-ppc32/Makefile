
COMPONENT_TARGETS  = $(HARDWARE_S824L)
COMPONENT_TARGETS += $(HARDWARE_VESNIN)
COMPONENT_TARGETS += $(HARDWARE_TL2WK2)
COMPONENT_TARGETS += $(HARDWARE_TL2SV2)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_PPC32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/linuxconsole

REQUIRES           = app/inputattach/1.4.9
REQUIRES          += libs/glibc/2.28-ppc32

# ======= __END_OF_REQUIRES__ =======


version            = 1.4.9
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/a/linuxconsole/linuxconsoletools-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/linuxconsoletools-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
INPUTATTACH32_PKG_NAME                = inputattach-x32
INPUTATTACH32_PKG_VERSION             = 1.4.9
INPUTATTACH32_PKG_ARCH                = $(TOOLCHAIN)
INPUTATTACH32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
INPUTATTACH32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
INPUTATTACH32_PKG_GROUP               = $(PKG_GROUP)
###                                    |---handy-ruler-------------------------------|
INPUTATTACH32_PKG_SHORT_DESCRIPTION   = utility for legacy serial devices
INPUTATTACH32_PKG_URL                 = $(BUG_URL)
INPUTATTACH32_PKG_LICENSE             = GPLv2
INPUTATTACH32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(INPUTATTACH32_PKG_NAME)-pkg-description
INPUTATTACH32_PKG_DESCRIPTION_FILE_IN = $(INPUTATTACH32_PKG_NAME)-pkg-description.in
INPUTATTACH32_PKG_INSTALL_SCRIPT      = $(INPUTATTACH32_PKG_NAME)-pkg-install.sh

INPUTATTACH32_PKG = $(CURDIR)/$(TARGET_BUILD_DIR)/$(INPUTATTACH32_PKG_NAME)-package

pkg_basename      = $(INPUTATTACH32_PKG_NAME)-$(INPUTATTACH32_PKG_VERSION)-$(INPUTATTACH32_PKG_ARCH)-$(INPUTATTACH32_PKG_DISTRO_NAME)-$(INPUTATTACH32_PKG_DISTRO_VERSION)

pkg_archive       = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_certificate  = $(call cert-name,$(pkg_archive))
pkg_signature     = $(call sign-name,$(pkg_archive))
pkg_description   = $(call desc-name,$(pkg_archive))
products          = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS     = $(build_target)
BUILD_TARGETS    += $(install_target)

PRODUCT_TARGETS   = $(products)

ROOTFS_TARGETS    = $(pkg_archive)


include ../../../build-system/core.mk


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR)/utils && $(BUILD_ENVIRONMENT) $(CC) inputattach.c -o inputattach
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(INPUTATTACH32_PKG)/usr/bin/32
	@cd $(SRC_DIR)/utils && cp -a inputattach $(INPUTATTACH32_PKG)/usr/bin/32
	@chmod 755 $(INPUTATTACH32_PKG)/usr/bin/32/*
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(INPUTATTACH32_PKG))
	# ======= Strip binaries =======
	@( cd $(INPUTATTACH32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null \
	 )
	@touch $@

$(INPUTATTACH32_PKG_DESCRIPTION_FILE): $(INPUTATTACH32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(INPUTATTACH32_PKG_DESCRIPTION_FILE) $(INPUTATTACH32_PKG_INSTALL_SCRIPT)
	@cp $(INPUTATTACH32_PKG_DESCRIPTION_FILE) $(INPUTATTACH32_PKG)/.DESCRIPTION
	@cp $(INPUTATTACH32_PKG_INSTALL_SCRIPT) $(INPUTATTACH32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(INPUTATTACH32_PKG)/.REQUIRES
	@echo "pkgname=$(INPUTATTACH32_PKG_NAME)"                            >  $(INPUTATTACH32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(INPUTATTACH32_PKG_VERSION)"                          >> $(INPUTATTACH32_PKG)/.PKGINFO ; \
	 echo "arch=$(INPUTATTACH32_PKG_ARCH)"                               >> $(INPUTATTACH32_PKG)/.PKGINFO ; \
	 echo "distroname=$(INPUTATTACH32_PKG_DISTRO_NAME)"                  >> $(INPUTATTACH32_PKG)/.PKGINFO ; \
	 echo "distrover=$(INPUTATTACH32_PKG_DISTRO_VERSION)"                >> $(INPUTATTACH32_PKG)/.PKGINFO ; \
	 echo "group=$(INPUTATTACH32_PKG_GROUP)"                             >> $(INPUTATTACH32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(INPUTATTACH32_PKG_SHORT_DESCRIPTION)\"" >> $(INPUTATTACH32_PKG)/.PKGINFO ; \
	 echo "url=$(INPUTATTACH32_PKG_URL)"                                 >> $(INPUTATTACH32_PKG)/.PKGINFO ; \
	 echo "license=$(INPUTATTACH32_PKG_LICENSE)"                         >> $(INPUTATTACH32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(INPUTATTACH32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
