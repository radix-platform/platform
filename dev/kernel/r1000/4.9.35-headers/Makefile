
COMPONENT_TARGETS  = $(HARDWARE_MBC4_PC)

NEED_ABS_PATH     = true
COMPONENT_IS_3PP  = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES  = sources/Linux/v4.x

REQUIRES         = base/pkgtool

# ======= __END_OF_REQUIRES__ =======


version          = 4.9.35
modules_version  = 4.9.35
full_version     = $(version)
tar_xz_archive   = $(SRC_PACKAGE_PATH)/Linux/v4.x/linux-$(version).tar.xz
SRC_ARCHIVE      = $(tar_xz_archive)
SRC_DIR          = $(TARGET_BUILD_DIR)/linux-$(full_version)
src_done         = $(TARGET_BUILD_DIR)/.source_done


build_kh_pkg = $(TARGET_BUILD_DIR)/.kernel_headers_pkg_done


PATCHES =

ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_R1000_GLIBC)),)
ARCH = sparc
endif

USE_TARGET_DEST_DIR_SYSROOT = no

####### Targets

PKG_GROUP = dev

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
KH_DEV_PKG_NAME                = kernel-headers
KH_DEV_PKG_VERSION             = 4.9.35
KH_DEV_PKG_ARCH                = $(TOOLCHAIN)
KH_DEV_PKG_DISTRO_NAME         = $(DISTRO_NAME)
KH_DEV_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
KH_DEV_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
KH_DEV_PKG_SHORT_DESCRIPTION   = Linux kernel header files
KH_DEV_PKG_URL                 = $(BUG_URL)
KH_DEV_PKG_LICENSE             = GPLv2
KH_DEV_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(KH_DEV_PKG_NAME)-pkg-description
KH_DEV_PKG_DESCRIPTION_FILE_IN = $(KH_DEV_PKG_NAME)-pkg-description.in
KH_DEV_PKG_INSTALL_SCRIPT      = $(KH_DEV_PKG_NAME)-pkg-install.sh


KH_DEV_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(KH_DEV_PKG_NAME)-package

pkg_basename     = $(KH_DEV_PKG_NAME)-$(KH_DEV_PKG_VERSION)-$(KH_DEV_PKG_ARCH)-$(KH_DEV_PKG_DISTRO_NAME)-$(KH_DEV_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_kh_pkg)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../build-system/core.mk


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(SRC_DIR)/include/generated/uapi/linux/version.h: $(src_done)
	@touch $(SRC_DIR)/.config
	@$(MAKE) -C $(SRC_DIR) \
	            ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_PREFIX) \
	            include/generated/uapi/linux/version.h

$(KH_DEV_PKG)/usr/include/linux/autoconf.h: $(SRC_DIR)/include/generated/uapi/linux/version.h
	@mkdir -p $(KH_DEV_PKG)/usr
	@$(MAKE) -C $(SRC_DIR) headers_install \
	            ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_PREFIX) \
	            INSTALL_HDR_PATH=$(KH_DEV_PKG)/usr
	@touch $@

$(build_kh_pkg): $(KH_DEV_PKG)/usr/include/linux/autoconf.h
	@( cd $(KH_DEV_PKG)/usr/include ; \
	   for file in `find . -name *.install*` ; do \
	     rm -f $$file; \
	   done )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(KH_DEV_PKG))
	@touch $@

$(KH_DEV_PKG_DESCRIPTION_FILE): $(KH_DEV_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@KERNEL_VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(build_kh_pkg) $(KH_DEV_PKG_DESCRIPTION_FILE) $(KH_DEV_PKG_INSTALL_SCRIPT)
	@cp $(KH_DEV_PKG_DESCRIPTION_FILE) $(KH_DEV_PKG)/.DESCRIPTION
	@cp $(KH_DEV_PKG_INSTALL_SCRIPT) $(KH_DEV_PKG)/.INSTALL
	@$(BUILD_BIN_PKG_REQUIRES) $(KH_DEV_PKG)/.REQUIRES
	@echo "pkgname=$(KH_DEV_PKG_NAME)"                            >  $(KH_DEV_PKG)/.PKGINFO ; \
	 echo "pkgver=$(KH_DEV_PKG_VERSION)"                          >> $(KH_DEV_PKG)/.PKGINFO ; \
	 echo "arch=$(KH_DEV_PKG_ARCH)"                               >> $(KH_DEV_PKG)/.PKGINFO ; \
	 echo "distroname=$(KH_DEV_PKG_DISTRO_NAME)"                  >> $(KH_DEV_PKG)/.PKGINFO ; \
	 echo "distrover=$(KH_DEV_PKG_DISTRO_VERSION)"                >> $(KH_DEV_PKG)/.PKGINFO ; \
	 echo "group=$(KH_DEV_PKG_GROUP)"                             >> $(KH_DEV_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(KH_DEV_PKG_SHORT_DESCRIPTION)\"" >> $(KH_DEV_PKG)/.PKGINFO ; \
	 echo "url=$(KH_DEV_PKG_URL)"                                 >> $(KH_DEV_PKG)/.PKGINFO ; \
	 echo "license=$(KH_DEV_PKG_LICENSE)"                         >> $(KH_DEV_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(KH_DEV_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
