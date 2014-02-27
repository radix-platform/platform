
COMPONENT_TARGETS  = $(TARGET_HOST)
COMPONENT_TARGETS += $(TARGET_PC32)
COMPONENT_TARGETS += $(TARGET_PC64)

NEED_ABS_PATH     = true

COMPONENT_IS_3PP  = true


include ../../../../build-system/constants.mk


version          = 3.10.17

SOURCE_REQUIRES  = $(SRC_PACKAGE_DIR)/Linux/v3.x

REQUIRES         = base/pkgtool


modules_version  = 3.10.17
full_version     = $(version)
tar_bz2_archive  = $(SRC_PACKAGE_PATH)/Linux/v3.x/linux-$(version).tar.bz2
SRC_ARCHIVE      = $(tar_bz2_archive)
SRC_DIR          = $(TARGET_BUILD_DIR)/linux-$(full_version)
src_done         = $(TARGET_BUILD_DIR)/.source_done


build_kh_pkg = $(TARGET_BUILD_DIR)/.kernel_headers_pkg_done


PATCHES =

ifneq ($(filter $(TOOLCHAIN),$(X86_64_EGLIBC_TOOLCHAIN_NAME) $(I686_EGLIBC_TOOLCHAIN_NAME) $(BUILD_TOOLCHAIN_NAME)),)
ARCH = x86
endif


####### Targets

PKG_GROUP = dev

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
KH_DEV_PKG_NAME                = kernel-headers
KH_DEV_PKG_VERSION             = 3.10.17
ifeq ($(HARDWARE),$(TARGET_HOST))
KH_DEV_PKG_ARCH                = $(shell uname -m)
else
KH_DEV_PKG_ARCH                = $(TOOLCHAIN)
endif
KH_DEV_PKG_DISTRO_NAME         = kxLab
KH_DEV_PKG_DISTRO_VERSION      = 1.0
KH_DEV_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
KH_DEV_PKG_SHORT_DESCRIPTION   = Linux $(version) header files
KH_DEV_PKG_URL                 = http://www.kxLab.com
KH_DEV_PKG_LICENSE             = GPLv2
KH_DEV_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(KH_DEV_PKG_NAME)-pkg-description
KH_DEV_PKG_DESCRIPTION_FILE_IN = $(KH_DEV_PKG_NAME)-pkg-description.in
KH_DEV_PKG_INSTALL_SCRIPT      = $(KH_DEV_PKG_NAME)-pkg-install.sh


KH_DEV_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(KH_DEV_PKG_NAME)-package

pkg_basename     = $(KH_DEV_PKG_NAME)-$(KH_DEV_PKG_VERSION)-$(KH_DEV_PKG_ARCH)-$(KH_DEV_PKG_DISTRO_NAME)-$(KH_DEV_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(KH_DEV_PKG_GROUP)/$(pkg_basename).tgz

BUILD_TARGETS    = $(build_kh_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../../build-system/core.mk


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(SRC_DIR)/include/generated/uapi/linux/version.h: $(src_done)
	@touch $(SRC_DIR)/.config
	$(MAKE) -C $(SRC_DIR) include/generated/uapi/linux/version.h

$(KH_DEV_PKG)/usr/include/linux/autoconf.h: $(SRC_DIR)/include/generated/uapi/linux/version.h
	@mkdir -p $(KH_DEV_PKG)/usr
	$(MAKE) -C $(SRC_DIR) headers_install \
	           ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_PREFIX) \
	           INSTALL_HDR_PATH=$(KH_DEV_PKG)/usr
	touch $@


$(KH_DEV_PKG_DESCRIPTION_FILE): $(KH_DEV_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@KERNEL_VERSION@/$(version)/g" > $@


$(build_kh_pkg): $(KH_DEV_PKG)/usr/include/linux/autoconf.h $(KH_DEV_PKG_DESCRIPTION_FILE)
	@( cd $(KH_DEV_PKG)/usr/include ; \
	   for file in `find . -name *.install*` ; do \
	     rm -f $$file; \
	   done )
	# Install the same to $(TARGET_DEST_DIR)
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(KH_DEV_PKG) && cp -rf * $(TARGET_DEST_DIR)
	@cp $(KH_DEV_PKG_DESCRIPTION_FILE) $(KH_DEV_PKG)/.DESCRIPTION
	@cp $(KH_DEV_PKG_INSTALL_SCRIPT) $(KH_DEV_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(KH_DEV_PKG)/.REQUIRES
	@echo "pkgname=$(KH_DEV_PKG_NAME)"                            >  $(KH_DEV_PKG)/.PKGINFO ; \
	 echo "pkgver=$(KH_DEV_PKG_VERSION)"                          >> $(KH_DEV_PKG)/.PKGINFO ; \
	 echo "arch=$(KH_DEV_PKG_ARCH)"                               >> $(KH_DEV_PKG)/.PKGINFO ; \
	 echo "distroname=$(KH_DEV_PKG_DISTRO_NAME)"                  >> $(KH_DEV_PKG)/.PKGINFO ; \
	 echo "distrover=$(KH_DEV_PKG_DISTRO_VERSION)"                >> $(KH_DEV_PKG)/.PKGINFO ; \
	 echo "group=$(KH_DEV_PKG_GROUP)"                             >> $(KH_DEV_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(KH_DEV_PKG_SHORT_DESCRIPTION)\"" >> $(KH_DEV_PKG)/.PKGINFO ; \
	 echo "url=$(KH_DEV_PKG_URL)"                                 >> $(KH_DEV_PKG)/.PKGINFO ; \
	 echo "license=$(KH_DEV_PKG_LICENSE)"                         >> $(KH_DEV_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(KH_DEV_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@
