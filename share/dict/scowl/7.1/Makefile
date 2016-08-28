
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES     = sources/dict/scowl

REQUIRES            = base/pkgtool

# ======= __END_OF_REQUIRES__ =======


version             = 7.1
tar_gz_archive      = $(SRC_PACKAGE_PATH)/dict/scowl/scowl-$(version).tar.gz
SRC_ARCHIVE         = $(tar_gz_archive)
SRC_DIR             = $(TARGET_BUILD_DIR)/scowl-$(version)
src_dir_name        = scowl-$(version)
src_done            = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target        = $(TARGET_BUILD_DIR)/.build_done
install_target      = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = dict

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
SCOWL_PKG_NAME                = scowl
SCOWL_PKG_VERSION             = 7.1
SCOWL_PKG_ARCH                = $(TOOLCHAIN)
SCOWL_PKG_DISTRO_NAME         = $(DISTRO_NAME)
SCOWL_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
SCOWL_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
SCOWL_PKG_SHORT_DESCRIPTION   = Spell Checker Oriented Word Lists
SCOWL_PKG_URL                 = $(BUG_URL)
SCOWL_PKG_LICENSE             = public
SCOWL_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(SCOWL_PKG_NAME)-pkg-description
SCOWL_PKG_DESCRIPTION_FILE_IN = $(SCOWL_PKG_NAME)-pkg-description.in
SCOWL_PKG_INSTALL_SCRIPT      = $(SCOWL_PKG_NAME)-pkg-install.sh

SCOWL_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(SCOWL_PKG_NAME)-package

pkg_basename     = $(SCOWL_PKG_NAME)-$(SCOWL_PKG_VERSION)-$(SCOWL_PKG_ARCH)-$(SCOWL_PKG_DISTRO_NAME)-$(SCOWL_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../build-system/core.mk


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(SCOWL_PKG)/usr/share/dict/scowl
	# ======= install wordlists =======
	@( cd $(SRC_DIR) ; \
	   cp final/*.[0-9][0-9] $(SCOWL_PKG)/usr/share/dict/scowl ; \
	   chmod 0644 $(SCOWL_PKG)/usr/share/dict/scowl/* \
	 )
	# ======= documentation =======
	@mkdir -p $(SCOWL_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/Copyright $(SCOWL_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(SCOWL_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a Copyright README \
	         $(SCOWL_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(SCOWL_PKG))
	@touch $@

$(SCOWL_PKG_DESCRIPTION_FILE): $(SCOWL_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(SCOWL_PKG_DESCRIPTION_FILE) $(SCOWL_PKG_INSTALL_SCRIPT)
	@cp $(SCOWL_PKG_DESCRIPTION_FILE) $(SCOWL_PKG)/.DESCRIPTION
	@cp $(SCOWL_PKG_INSTALL_SCRIPT) $(SCOWL_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(SCOWL_PKG)/.REQUIRES
	@echo "pkgname=$(SCOWL_PKG_NAME)"                            >  $(SCOWL_PKG)/.PKGINFO ; \
	 echo "pkgver=$(SCOWL_PKG_VERSION)"                          >> $(SCOWL_PKG)/.PKGINFO ; \
	 echo "arch=$(SCOWL_PKG_ARCH)"                               >> $(SCOWL_PKG)/.PKGINFO ; \
	 echo "distroname=$(SCOWL_PKG_DISTRO_NAME)"                  >> $(SCOWL_PKG)/.PKGINFO ; \
	 echo "distrover=$(SCOWL_PKG_DISTRO_VERSION)"                >> $(SCOWL_PKG)/.PKGINFO ; \
	 echo "group=$(SCOWL_PKG_GROUP)"                             >> $(SCOWL_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(SCOWL_PKG_SHORT_DESCRIPTION)\"" >> $(SCOWL_PKG)/.PKGINFO ; \
	 echo "url=$(SCOWL_PKG_URL)"                                 >> $(SCOWL_PKG)/.PKGINFO ; \
	 echo "license=$(SCOWL_PKG_LICENSE)"                         >> $(SCOWL_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(SCOWL_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
