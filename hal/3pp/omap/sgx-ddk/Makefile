
COMPONENT_TARGETS = $(TARGET_OMAP5EVM)

NEEDS_ABS_PATHS = true

COMPONENT_IS_3PP = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES  += $(SRC_PACKAGE_DIR)/hal/omap/sgx-ddk

REQUIRES          = boot/kernel/omap543x/3.8.13


version           = 1.9.0.11
kernel_version    = 3.8-6AJ.1.2-RC3
modules_version   = 3.8.13
tar_bz2_archive   = $(SRC_PACKAGE_PATH)/hal/omap/sgx-ddk/ti_imgddk_$(version).tar.bz2
SRC_ARCHIVE       = $(tar_bz2_archive)
SRC_DIR           = ti_imgddk_$(version)
src_done          = $(SRC_DIR)/.source_done

build_dir         = $(CURDIR)/$(TARGET_BUILD_DIR)/build

kernel_sources    = $(TARGET_DEST_DIR)/usr/src/linux-$(kernel_version)

build_sgxddk_pkg  = $(TARGET_BUILD_DIR)/.sgxddk_pkg_done

modules_done      = $(build_dir)/.modules_done


PATCHES = PATCHES


ifneq ($(filter $(TOOLCHAIN),$(OMAP543X_EGLIBC_TOOLCHAIN_NAME)),)
ARCH = arm
endif

extra_build_environment  = KERNELDIR=$(kernel_sources)
extra_build_environment += DISCIMAGE=$(TARGET_DEST_DIR)
extra_build_environment += INSTALL_MOD_PATH=$(TARGET_DEST_DIR)

ifneq ($(filter $(TOOLCHAIN),$(OMAP543X_EGLIBC_TOOLCHAIN_NAME)),)
SGX_KERNEL_MODULE_PATH  = $(CURDIR)/$(SRC_DIR)/eurasia_km/eurasiacon/build/linux2/omap5430_linux
endif


####### Targets


SGXDDK_BIN_PKG_NAME                = sgxddk
SGXDDK_BIN_PKG_VERSION             = $(version)
ifeq ($(HARDWARE),$(TARGET_HOST))
SGXDDK_BIN_PKG_ARCH                = $(shell uname -m)
else
SGXDDK_BIN_PKG_ARCH                = $(TOOLCHAIN)
endif
SGXDDK_BIN_PKG_DISTRO_NAME         = kxLab
SGXDDK_BIN_PKG_DISTRO_VERSION      = 1.0
SGXDDK_BIN_PKG_GROUP               = boot
###                                 |---handy-ruler-------------------------------|
SGXDDK_BIN_PKG_SHORT_DESCRIPTION   = SGX DDK $(version) for Linux kernel
SGXDDK_BIN_PKG_URL                 = http://www.kxLab.com
SGXDDK_BIN_PKG_LICENSE             = GPLv2
SGXDDK_BIN_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(SGXDDK_BIN_PKG_NAME)-pkg-description
SGXDDK_BIN_PKG_DESCRIPTION_FILE_IN = $(SGXDDK_BIN_PKG_NAME)-pkg-description.in
SGXDDK_BIN_PKG_INSTALL_SCRIPT      = $(TARGET_BUILD_DIR)/$(SGXDDK_BIN_PKG_NAME)-pkg-install.sh
SGXDDK_BIN_PKG_INSTALL_SCRIPT_IN   = $(SGXDDK_BIN_PKG_NAME)-pkg-install.sh.in

SGXDDK_BIN_PKG   = $(CURDIR)/$(TARGET_BUILD_DIR)/$(SGXDDK_BIN_PKG_NAME)-package

pkg_basename     = $(SGXDDK_BIN_PKG_NAME)-$(SGXDDK_BIN_PKG_VERSION)-$(SGXDDK_BIN_PKG_ARCH)-$(SGXDDK_BIN_PKG_DISTRO_NAME)-$(SGXDDK_BIN_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(SGXDDK_BIN_PKG_GROUP)/$(pkg_basename).tgz

BUILD_TARGETS    = $(build_sgxddk_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(SGXDDK_BIN_PKG_GROUP)

CLEANUP_FILES   += $(SRC_DIR)


include ../../../../build-system/core.mk


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

LMAKE := $(BUILD_ENVIRONMENT) $(MAKE) -C $(SGX_KERNEL_MODULE_PATH) ARCH=$(ARCH) CROSS_COMPILE="$(CROSS_PREFIX)" $(extra_build_environment) V=$(if $(VERBOSE),1,0)

# add to LMAKE: CONFIG_DEBUG_SECTION_MISMATCH=y for more detailed log.

$(modules_done): $(src_done)
	@mkdir -p $(build_dir)
	$(LMAKE) kbuild_install
	@touch $@


$(SGXDDK_BIN_PKG_DESCRIPTION_FILE): $(SGXDDK_BIN_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(SGXDDK_BIN_PKG_INSTALL_SCRIPT): $(SGXDDK_BIN_PKG_INSTALL_SCRIPT_IN)
	@cat $< | $(SED) -e "s/@MODULES_VERSION@/$(modules_version)/g" > $@


$(build_sgxddk_pkg): $(modules_done) $(SGXDDK_BIN_PKG_DESCRIPTION_FILE) $(SGXDDK_BIN_PKG_INSTALL_SCRIPT)
	@mkdir -p $(SGXDDK_BIN_PKG)/lib/modules/$(modules_version)
	# Copy modules and firmware (without links to sources):
	@cd $(TARGET_DEST_DIR)/lib/modules/$(modules_version) && \
	  cp -rf extra $(SGXDDK_BIN_PKG)/lib/modules/$(modules_version) && \
	  cp -a modules.builtin modules.order $(SGXDDK_BIN_PKG)/lib/modules/$(modules_version)
	@cd $(SGXDDK_BIN_PKG)/lib/modules/$(modules_version) && mv modules.builtin modules.builtin.new
	@cd $(SGXDDK_BIN_PKG)/lib/modules/$(modules_version) && mv modules.order modules.order.new
	@mkdir -p $(SGXDDK_BIN_PKG)/usr/doc/sgxddk-$(version)
	@cp -a $(SRC_DIR)/eurasia_km/*-COPYING \
	       $(SRC_DIR)/eurasia_km/INSTALL $(SRC_DIR)/eurasia_km/README \
	       $(SGXDDK_BIN_PKG)/usr/doc/sgxddk-$(version)
	@cp $(SGXDDK_BIN_PKG_DESCRIPTION_FILE) $(SGXDDK_BIN_PKG)/.DESCRIPTION
	@cp $(SGXDDK_BIN_PKG_INSTALL_SCRIPT) $(SGXDDK_BIN_PKG)/.INSTALL
	@chmod a+x $(SGXDDK_BIN_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(SGXDDK_BIN_PKG)/.REQUIRES
	@echo "pkgname=$(SGXDDK_BIN_PKG_NAME)"                            >  $(SGXDDK_BIN_PKG)/.PKGINFO ; \
	 echo "pkgver=$(SGXDDK_BIN_PKG_VERSION)"                          >> $(SGXDDK_BIN_PKG)/.PKGINFO ; \
	 echo "arch=$(SGXDDK_BIN_PKG_ARCH)"                               >> $(SGXDDK_BIN_PKG)/.PKGINFO ; \
	 echo "distroname=$(SGXDDK_BIN_PKG_DISTRO_NAME)"                  >> $(SGXDDK_BIN_PKG)/.PKGINFO ; \
	 echo "distrover=$(SGXDDK_BIN_PKG_DISTRO_VERSION)"                >> $(SGXDDK_BIN_PKG)/.PKGINFO ; \
	 echo "group=$(SGXDDK_BIN_PKG_GROUP)"                             >> $(SGXDDK_BIN_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(SGXDDK_BIN_PKG_SHORT_DESCRIPTION)\"" >> $(SGXDDK_BIN_PKG)/.PKGINFO ; \
	 echo "url=$(SGXDDK_BIN_PKG_URL)"                                 >> $(SGXDDK_BIN_PKG)/.PKGINFO ; \
	 echo "license=$(SGXDDK_BIN_PKG_LICENSE)"                         >> $(SGXDDK_BIN_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(SGXDDK_BIN_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@
