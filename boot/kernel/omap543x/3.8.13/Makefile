
COMPONENT_TARGETS = $(TARGET_OMAP5EVM)

NEEDS_ABS_PATHS = true

COMPONENT_IS_3PP = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES  += $(SRC_PACKAGE_DIR)/Linux/omap5

REQUIRES          = base/pkgtool


version           = 3.8-6AJ.1.2-RC3
subversion        = 
modules_version   = 3.8.13
full_version      = $(version)
tar_bz2_archive   = $(SRC_PACKAGE_PATH)/Linux/omap5/linux-$(full_version).tar.bz2
SRC_ARCHIVE       = $(tar_bz2_archive)
SRC_DIR           = linux-$(full_version)
src_done          = $(SRC_DIR)/.source_done

config            = $(HARDWARE).config
build_dir         = $(CURDIR)/$(TARGET_BUILD_DIR)/build
modules_dir       = $(CURDIR)/$(TARGET_BUILD_DIR)/modules

build_config      = $(build_dir)/.config
oldconfig_done    = $(build_dir)/.oldconfig_done
modules_done      = $(modules_dir)/.modules_done

devel_sources     = $(TARGET_DEST_DIR)/linux

build_kernel_pkg  = $(TARGET_BUILD_DIR)/.kernel_pkg_done

PATCHES = PATCHES


ifneq ($(filter $(TOOLCHAIN),$(OMAP543X_EGLIBC_TOOLCHAIN_NAME)),)
ARCH = arm
endif


####### Targets

SETUP_TARGETS    += $(src_done)

linux_kernel      = $(TARGET_BUILD_DIR)/vmlinux-$(full_version)-$(TOOLCHAIN)_$(HARDWARE)
linux_zImage      = $(TARGET_BUILD_DIR)/zImage-$(full_version)-$(TOOLCHAIN)_$(HARDWARE)
linux_config      = $(TARGET_BUILD_DIR)/config-$(full_version)-$(TOOLCHAIN)_$(HARDWARE)
linux_systemmap   = $(TARGET_BUILD_DIR)/System.map-$(full_version)-$(TOOLCHAIN)_$(HARDWARE)

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


KERNEL_BIN_PKG_NAME                = kernel
KERNEL_BIN_PKG_VERSION             = 3.8.13
ifeq ($(HARDWARE),$(TARGET_HOST))
KERNEL_BIN_PKG_ARCH                = $(shell uname -m)
else
KERNEL_BIN_PKG_ARCH                = $(TOOLCHAIN)
endif
KERNEL_BIN_PKG_DISTRO_NAME         = kxLab
KERNEL_BIN_PKG_DISTRO_VERSION      = 1.0
KERNEL_BIN_PKG_GROUP               = boot
###                                 |---handy-ruler-------------------------------|
KERNEL_BIN_PKG_SHORT_DESCRIPTION   = Linux $(version) Kernel
KERNEL_BIN_PKG_URL                 = http://www.kxLab.com
KERNEL_BIN_PKG_LICENSE             = GPLv2
KERNEL_BIN_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(KERNEL_BIN_PKG_NAME)-pkg-description
KERNEL_BIN_PKG_DESCRIPTION_FILE_IN = $(KERNEL_BIN_PKG_NAME)-pkg-description.in
KERNEL_BIN_PKG_INSTALL_SCRIPT      = $(KERNEL_BIN_PKG_NAME)-pkg-install.sh

KERNEL_BIN_PKG   = $(CURDIR)/$(TARGET_BUILD_DIR)/$(KERNEL_BIN_PKG_NAME)-package

pkg_basename     = $(KERNEL_BIN_PKG_NAME)-$(KERNEL_BIN_PKG_VERSION)-$(KERNEL_BIN_PKG_ARCH)-$(KERNEL_BIN_PKG_DISTRO_NAME)-$(KERNEL_BIN_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(KERNEL_BIN_PKG_GROUP)/$(pkg_basename).tgz

BUILD_TARGETS    = $(build_kernel_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(KERNEL_BIN_PKG_GROUP)

CLEANUP_FILES   += $(SRC_DIR)


include ../../../../build-system/core.mk


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

LMAKE := $(BUILD_ENVIRONMENT) $(MAKE) -C $(SRC_DIR) ARCH=$(ARCH) CROSS_COMPILE="$(CROSS_PREFIX)" \
         O="$(build_dir)" V=$(if $(VERBOSE),1,0)

# add to LMAKE: CONFIG_DEBUG_SECTION_MISMATCH=y for more detailed log.

$(build_config): $(src_done) $(config)
	@mkdir -p $(build_dir)
	@cp $(config) $@

$(oldconfig_done): $(build_config)
	$(LMAKE) oldconfig
	@touch $@

# When "make" is executed without arguments, zImage will be built:
$(linux_zImage): $(oldconfig_done)
	$(LMAKE) zImage
	cp $(build_dir)/arch/$(ARCH)/boot/zImage $@

$(linux_kernel): $(linux_zImage)
	cp $(build_dir)/vmlinux $@

$(linux_systemmap): $(linux_kernel)
	cp $(build_dir)/System.map $@

$(linux_config): $(linux_kernel)
	cp $(build_dir)/.config $@

$(modules_done): $(linux_kernel) $(linux_systemmap) $(linux_config)
	$(LMAKE) modules
	rm -rf $(modules_dir)
	$(LMAKE) modules_install DEPMOD=true INSTALL_MOD_PATH=$(modules_dir)
	@touch $@


$(TARGET_DEST_DIR)/linux: $(modules_done)
	@echo "Creating $@ for building external modules"
	@rm -rf $@
	@mkdir -p $@
	@echo "" > $@/.CONTENT
	@echo "Configured $(HARDWARE) Linux sources for building external modules." >> $@/.CONTENT
	@echo "" >> $@/.CONTENT
	@cp $(linux_config) $@/.config
# Copy scripts:
	@cd $(build_dir) && \
	  CWD=$(CURDIR) $(BUILDSYSTEM)/install_targets \
	    --preserve-source-dir=true \
	    $$(find * -type f -path 'scripts*' -perm /111 -print)  $@  $(HARDWARE)
# Copy kernel makesystem:
	@cd $(SRC_DIR) && \
	  CWD=$(CURDIR) $(BUILDSYSTEM)/install_targets \
	    --preserve-source-dir=true \
	    $$(find * \( -path Documentation -o -path include -o -path scripts \) -prune \
	              -o -type f \( -name 'Kconfig*' -o -name 'Kbuild' -o -name 'Makefile*' \) -print)  \
	    $@  $(HARDWARE)
# Copy includes:
	@cd $(SRC_DIR)/include && \
	  CWD=$(CURDIR) $(BUILDSYSTEM)/install_targets \
	    --preserve-source-dir=true \
	    $$(find * -maxdepth 1 ! -name 'asm*' -a ! -name . -a ! -type d -o -name asm-generic)  \
	    $@/include  $(HARDWARE)
# Copy src scripts:
	@cd $(SRC_DIR)/scripts && \
	  CWD=$(CURDIR) $(BUILDSYSTEM)/install_targets \
	    --preserve-source-dir=true \
	    $$(find * ! -name '*.gitignore' -a ! -type d ) \
	    $@/scripts  $(HARDWARE)
# Generated stuff
	@$(BUILDSYSTEM)/install_targets $(build_dir)/Module.symvers  $@  $(HARDWARE)
	@$(BUILDSYSTEM)/install_targets $(build_dir)/System.map  $@  $(HARDWARE)
	@cd $(SRC_DIR)/include && \
	  CWD=$(CURDIR) $(BUILDSYSTEM)/install_targets \
	    --preserve-source-dir=true \
	    $$(find * -path 'linux*' -type f \( -name '*.h' -o -name '*.conf' \) -print)  $@/include  $(HARDWARE)
	@cd $(build_dir)/include && \
	  CWD=$(CURDIR) $(BUILDSYSTEM)/install_targets \
	    --preserve-source-dir=true \
	    $$(find * -path 'config*' -type f \( -name '*.h' -o -name '*.conf' \) -print)  $@/include  $(HARDWARE)
	@cd $(build_dir)/include && \
	  CWD=$(CURDIR) $(BUILDSYSTEM)/install_targets \
	    --preserve-source-dir=true \
	    $$(find * -path 'generated*' -type f \( -name '*.h' -o -name '*.conf' \) -print)  $@/include  $(HARDWARE)
	@cd $(build_dir)/arch/$(ARCH)/include && \
	  CWD=$(CURDIR) $(BUILDSYSTEM)/install_targets \
	    --preserve-source-dir=true \
	    $$(find * -path 'generated*' -type f \( -name '*.h' -o -name '*.conf' \) -print) \
	    $@/arch/$(ARCH)/include  $(HARDWARE)
	@touch $@

$(KERNEL_BIN_PKG_DESCRIPTION_FILE): $(KERNEL_BIN_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(build_kernel_pkg): $(devel_sources) $(KERNEL_BIN_PKG_DESCRIPTION_FILE)
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
	@cp $(linux_kernel) $(KERNEL_BIN_PKG)/boot/vmlinux-$(full_version)
	@cp $(linux_zImage) $(KERNEL_BIN_PKG)/boot/vmlinuz-$(full_version)
	@cp $(linux_config) $(KERNEL_BIN_PKG)/boot/config-$(full_version)
	@cp $(linux_systemmap) $(KERNEL_BIN_PKG)/boot/System.map-$(full_version)
	@cd $(KERNEL_BIN_PKG)/boot && $(LN_S)f vmlinux-$(full_version) vmlinux
	@cd $(KERNEL_BIN_PKG)/boot && $(LN_S)f vmlinuz-$(full_version) vmlinuz
	@cd $(KERNEL_BIN_PKG)/boot && $(LN_S)f config-$(full_version) config
	@cd $(KERNEL_BIN_PKG)/boot && $(LN_S)f System.map-$(full_version) System.map
	@mkdir -p $(KERNEL_BIN_PKG)/usr/share/doc/kernel-$(full_version)
	@cp -a $(SRC_DIR)/COPYING $(SRC_DIR)/CREDITS $(SRC_DIR)/MAI* \
	       $(SRC_DIR)/README $(SRC_DIR)/REPORTING-BUGS \
	       $(KERNEL_BIN_PKG)/usr/share/doc/kernel-$(full_version)
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
