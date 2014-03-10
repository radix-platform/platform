
COMPONENT_TARGETS  = $(TARGET_OMAP5UEVM)

NEED_ABS_PATH      = true

COMPONENT_IS_3PP   = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES   += $(SRC_PACKAGE_DIR)/Linux/omap5-glsdk

REQUIRES           = base/pkgtool


version            = 3.8.y-20131223
subversion         = 
modules_version    = 3.8.13
full_version       = $(version)
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/Linux/omap5-glsdk/linux-glsdk-$(full_version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/usr/src/linux-glsdk-$(full_version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

config             = $(HARDWARE).config
build_dir          = $(SRC_DIR)
modules_dir        = $(CURDIR)/$(TARGET_BUILD_DIR)

build_config       = $(SRC_DIR)/.config
oldconfig_done     = $(TARGET_BUILD_DIR)/.oldconfig_done
modules_done       = $(TARGET_BUILD_DIR)/.modules_done
device_dtb_done    = $(TARGET_BUILD_DIR)/.device_dtb_done

devel_sources      = $(TARGET_DEST_DIR)/usr/src/linux-glsdk-$(full_version)
devel_sources_done = $(TARGET_BUILD_DIR)/.devel_sources_done
boot_filesystem    = $(TARGET_DEST_DIR)/bootfs
boot_fs_dir_done   = $(TARGET_BUILD_DIR)/.bootfs_done


PATCHES = PATCHES


ifneq ($(filter $(TOOLCHAIN),$(OMAP543X_EGLIBC_TOOLCHAIN_NAME)),)
ARCH = arm
endif

device_tree_name     = omap5-uevm.dtb
device_src_tree_name = omap5-uevm.dts


####### Targets

linux_kernel      = $(TARGET_BUILD_DIR)/vmlinux-$(full_version)-$(TOOLCHAIN)_$(HARDWARE)
linux_uImage      = $(TARGET_BUILD_DIR)/uImage-$(full_version)-$(TOOLCHAIN)_$(HARDWARE)
linux_zImage      = $(TARGET_BUILD_DIR)/zImage-$(full_version)-$(TOOLCHAIN)_$(HARDWARE)
linux_config      = $(TARGET_BUILD_DIR)/config-$(full_version)-$(TOOLCHAIN)_$(HARDWARE)
linux_systemmap   = $(TARGET_BUILD_DIR)/System.map-$(full_version)-$(TOOLCHAIN)_$(HARDWARE)
board_dtb         = $(TARGET_BUILD_DIR)/$(device_tree_name)-$(full_version)-$(TOOLCHAIN)_$(HARDWARE)
board_dts         = $(TARGET_BUILD_DIR)/$(device_src_tree_name)-$(full_version)-$(TOOLCHAIN)_$(HARDWARE)

#
# gen_init_cpio - is built with kernel for HOST machine (not used here now)
#
# can be installed into ROOTFS_DEST_DIR for HOST target
# i.e. TOOLCHAIN=build HARDWARE=host (see build-system/targets.mk)
#
# in the future we can create package for HOST machine to provide these utils
#
gen_init_cpio_src     = $(SRC_DIR)/usr/gen_init_cpio.c
gen_init_cpio         = $(TARGET_BUILD_DIR)/usr/gen_init_cpio
gen_initramfs_list_sh = $(SRC_DIR)/scripts/gen_initramfs_list.sh


PKG_GROUP = boot


KERNEL_BIN_PKG_NAME                = kernel
KERNEL_BIN_PKG_VERSION             = 3.8.13
ifeq ($(HARDWARE),$(TARGET_HOST))
KERNEL_BIN_PKG_ARCH                = $(shell uname -m)
else
KERNEL_BIN_PKG_ARCH                = $(TOOLCHAIN)
endif
KERNEL_BIN_PKG_DISTRO_NAME         = kxLab
KERNEL_BIN_PKG_DISTRO_VERSION      = 1.0
KERNEL_BIN_PKG_GROUP               = $(PKG_GROUP)
###                                 |---handy-ruler-------------------------------|
KERNEL_BIN_PKG_SHORT_DESCRIPTION   = Linux $(version) Kernel
KERNEL_BIN_PKG_URL                 = http://www.kxLab.com
KERNEL_BIN_PKG_LICENSE             = GPLv2
KERNEL_BIN_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(KERNEL_BIN_PKG_NAME)-pkg-description
KERNEL_BIN_PKG_DESCRIPTION_FILE_IN = $(KERNEL_BIN_PKG_NAME)-pkg-description.in
KERNEL_BIN_PKG_INSTALL_SCRIPT      = $(KERNEL_BIN_PKG_NAME)-pkg-install.sh

KERNEL_BIN_PKG   = $(CURDIR)/$(TARGET_BUILD_DIR)/$(KERNEL_BIN_PKG_NAME)-package

build_kernel_pkg = $(TARGET_BUILD_DIR)/.kernel_pkg_done

pkg_basename     = $(KERNEL_BIN_PKG_NAME)-$(KERNEL_BIN_PKG_VERSION)-$(KERNEL_BIN_PKG_ARCH)-$(KERNEL_BIN_PKG_DISTRO_NAME)-$(KERNEL_BIN_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(KERNEL_BIN_PKG_GROUP)/$(pkg_basename).tgz

BUILD_TARGETS    = $(build_kernel_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../../build-system/core.mk


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

LMAKE := $(BUILD_ENVIRONMENT) $(MAKE) -C $(SRC_DIR) ARCH=$(ARCH) CROSS_COMPILE="$(CROSS_PREFIX)" V=$(if $(VERBOSE),1,0)

# add to LMAKE: CONFIG_DEBUG_SECTION_MISMATCH=y for more detailed log.

$(build_config): $(src_done) $(config)
	@mkdir -p $(build_dir)
	@cp $(config) $@

$(oldconfig_done): $(build_config)
	$(LMAKE) oldconfig
	@touch $@

# When "make" is executed without arguments, zImage will be built:
$(linux_uImage): $(oldconfig_done)
	$(LMAKE) uImage
	cp $(build_dir)/arch/$(ARCH)/boot/uImage $@

$(linux_zImage): $(linux_uImage)
	cp $(build_dir)/arch/$(ARCH)/boot/zImage $@

$(linux_kernel): $(linux_zImage)
	cp $(build_dir)/vmlinux $@

$(linux_systemmap): $(linux_kernel)
	cp $(build_dir)/System.map $@

$(linux_config): $(linux_kernel)
	cp $(build_dir)/.config $@

$(modules_done): $(linux_kernel) $(linux_systemmap) $(linux_config)
	$(LMAKE) modules
	@rm -rf $(TARGET_BUILD_DIR)/lib
	$(LMAKE) modules_install DEPMOD=true INSTALL_MOD_PATH=$(modules_dir)
	@cd $(TARGET_BUILD_DIR) && \
	  CWD=$(CURDIR) $(BUILDSYSTEM)/install_targets --preserve-source-dir=true \
	    $$(find * -path 'lib*' -type f -print)   $(TARGET_DEST_DIR)   $(HARDWARE)
	@touch $@

$(device_dtb_done): $(modules_done)
	$(LMAKE) $(device_tree_name)
	cp $(build_dir)/arch/$(ARCH)/boot/dts/$(device_tree_name)     $(board_dtb)
	cp $(build_dir)/arch/$(ARCH)/boot/dts/$(device_src_tree_name) $(board_dts)
	@touch $@

$(devel_sources_done): $(device_dtb_done)
	@echo "Creating '$(devel_sources)' for building external modules"
	@rm -rf $(devel_sources)
	@mkdir -p $(devel_sources)
	@cd $(TARGET_BUILD_DIR) && \
	  CWD=$(CURDIR) $(BUILDSYSTEM)/install_targets --preserve-source-dir=true \
	    $$(find * -path 'usr*' -type f -print)   $(TARGET_DEST_DIR)   $(HARDWARE)
	@echo "" > $(TARGET_DEST_DIR)/usr/src/.CONTENT
	@echo "Configured '$(HARDWARE)' Linux sources for building external modules." >> $(TARGET_DEST_DIR)/usr/src/.CONTENT
	@echo "" >> $(TARGET_DEST_DIR)/usr/src/.CONTENT
	@cp -rf $(build_dir) $(TARGET_DEST_DIR)/usr/src
	@cd $(TARGET_DEST_DIR)/lib/modules/$(modules_version) && \
	  $$($(LN_S)f ../../../usr/src/linux-glsdk-$(full_version) build && \
	     $(LN_S)f ../../../usr/src/linux-glsdk-$(full_version) source)
	@touch $@


$(boot_fs_dir_done): $(devel_sources_done)
	@echo "Creating '$(boot_filesystem)' directory for collecting boot file system objects"
	@rm -rf $(boot_filesystem)
	@mkdir -p $(boot_filesystem)
	@echo "" > $(boot_filesystem)/.CONTENT
	@echo "Collection '$(HARDWARE)' images for building BOOT filesystem." >> $(boot_filesystem)/.CONTENT
	@echo "" >> $(boot_filesystem)/.CONTENT
	@cp -a $(linux_uImage) $(boot_filesystem)/uImage
	@cp -a $(board_dtb) $(boot_filesystem)/$(device_tree_name)
	@cp -a $(board_dts) $(boot_filesystem)/$(device_src_tree_name)
	@touch $@


$(KERNEL_BIN_PKG_DESCRIPTION_FILE): $(KERNEL_BIN_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@


$(build_kernel_pkg): $(boot_fs_dir_done) $(KERNEL_BIN_PKG_DESCRIPTION_FILE)
	@mkdir -p $(KERNEL_BIN_PKG)/boot
	@mkdir -p $(KERNEL_BIN_PKG)/lib/modules/$(modules_version)
	# Copy modules and firmware (without links to sources):
	@cd $(modules_dir)/lib/modules/$(modules_version) && \
	  cp -rf kernel $(KERNEL_BIN_PKG)/lib/modules/$(modules_version) && \
	  cp -a modules.* $(KERNEL_BIN_PKG)/lib/modules/$(modules_version)
	@if [ -d $(modules_dir)/lib/firmware ] ; then \
	  cd $(modules_dir)/lib && \
	  cp -rf firmware $(KERNEL_BIN_PKG)/lib ; \
	fi
	@cp -a $(linux_kernel)    $(KERNEL_BIN_PKG)/boot/vmlinux-$(full_version)
	@cp -a $(linux_uImage)    $(KERNEL_BIN_PKG)/boot/uImage-$(full_version)
	@cp -a $(linux_zImage)    $(KERNEL_BIN_PKG)/boot/zImage-$(full_version)
	@cp -a $(linux_config)    $(KERNEL_BIN_PKG)/boot/config-$(full_version)
	@cp -a $(linux_systemmap) $(KERNEL_BIN_PKG)/boot/System.map-$(full_version)
	@cp -a $(board_dtb)       $(KERNEL_BIN_PKG)/boot/$(device_tree_name)
	@cd $(KERNEL_BIN_PKG)/boot && $(LN_S)f vmlinux-$(full_version) vmlinux
	@cd $(KERNEL_BIN_PKG)/boot && $(LN_S)f uImage-$(full_version) uImage
	@cd $(KERNEL_BIN_PKG)/boot && $(LN_S)f zImage-$(full_version) zImage
	@cd $(KERNEL_BIN_PKG)/boot && $(LN_S)f config-$(full_version) config
	@cd $(KERNEL_BIN_PKG)/boot && $(LN_S)f System.map-$(full_version) System.map
	@mkdir -p $(KERNEL_BIN_PKG)/usr/doc/kernel-$(full_version)
	@cp -a $(SRC_DIR)/COPYING $(SRC_DIR)/CREDITS $(SRC_DIR)/MAI* \
	       $(SRC_DIR)/README $(SRC_DIR)/REPORTING-BUGS \
	       $(KERNEL_BIN_PKG)/usr/doc/kernel-$(full_version)
	@cp $(KERNEL_BIN_PKG_DESCRIPTION_FILE) $(KERNEL_BIN_PKG)/.DESCRIPTION
	@cp $(KERNEL_BIN_PKG_INSTALL_SCRIPT) $(KERNEL_BIN_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(KERNEL_BIN_PKG)/.REQUIRES
	@echo "pkgname=$(KERNEL_BIN_PKG_NAME)"                            >  $(KERNEL_BIN_PKG)/.PKGINFO ; \
	 echo "pkgver=$(KERNEL_BIN_PKG_VERSION)"                          >> $(KERNEL_BIN_PKG)/.PKGINFO ; \
	 echo "arch=$(KERNEL_BIN_PKG_ARCH)"                               >> $(KERNEL_BIN_PKG)/.PKGINFO ; \
	 echo "distroname=$(KERNEL_BIN_PKG_DISTRO_NAME)"                  >> $(KERNEL_BIN_PKG)/.PKGINFO ; \
	 echo "distrover=$(KERNEL_BIN_PKG_DISTRO_VERSION)"                >> $(KERNEL_BIN_PKG)/.PKGINFO ; \
	 echo "group=$(KERNEL_BIN_PKG_GROUP)"                             >> $(KERNEL_BIN_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(KERNEL_BIN_PKG_SHORT_DESCRIPTION)\"" >> $(KERNEL_BIN_PKG)/.PKGINFO ; \
	 echo "url=$(KERNEL_BIN_PKG_URL)"                                 >> $(KERNEL_BIN_PKG)/.PKGINFO ; \
	 echo "license=$(KERNEL_BIN_PKG_LICENSE)"                         >> $(KERNEL_BIN_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(KERNEL_BIN_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@
