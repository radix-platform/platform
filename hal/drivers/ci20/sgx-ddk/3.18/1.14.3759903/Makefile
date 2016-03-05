
COMPONENT_TARGETS  = $(HARDWARE_CI20)

NEED_ABS_PATH      = true

COMPONENT_IS_3PP   = true

NO_CCACHE = true

include ../../../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/hal/drivers/ci20/sgx-ddk/3.18

REQUIRES           = boot/kernel/ci20/3.18-20151015

# ======= __END_OF_REQUIRES__ =======


version            = 1.14.3759903
kernel_version     = 3.18-20151015
modules_version    = 3.18.3
tar_xz_archive     = $(SRC_PACKAGE_PATH)/hal/drivers/ci20/sgx-ddk/3.18/ci20-sgx-km-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/ci20-sgx-km-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

udev_rules         = $(CURDIR)/udev/96-powervr.rules

kernel_sources     = $(TARGET_DEST_DIR)/usr/src/linux-ci20-$(kernel_version)

build_sgxddk_pkg   = $(TARGET_BUILD_DIR)/.sgxddk_pkg_done

modules_done       = $(TARGET_BUILD_DIR)/.modules_done


PATCHES = PATCHES


ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_JZ47XX_GLIBC)),)
ARCH = mips
endif

extra_build_environment  = KERNELDIR=$(kernel_sources)
extra_build_environment += DISCIMAGE=$(TARGET_DEST_DIR)
extra_build_environment += INSTALL_MOD_PATH=$(TARGET_DEST_DIR)

ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_JZ47XX_GLIBC)),)
SGX_KERNEL_MODULE_PATH  = $(CURDIR)/$(SRC_DIR)/eurasia_km/eurasiacon/build/linux2/jz4780_linux
endif

USE_TARGET_DEST_DIR_SYSROOT = no

####### Targets

PKG_GROUP = boot


SGXDDK_BIN_PKG_NAME                = sgxddk
SGXDDK_BIN_PKG_VERSION             = 1.14.3759903
SGXDDK_BIN_PKG_ARCH                = $(TOOLCHAIN)
SGXDDK_BIN_PKG_DISTRO_NAME         = $(DISTRO_NAME)
SGXDDK_BIN_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
SGXDDK_BIN_PKG_GROUP               = $(PKG_GROUP)
###                                 |---handy-ruler-------------------------------|
SGXDDK_BIN_PKG_SHORT_DESCRIPTION   = SGX DDK for Linux kernel
SGXDDK_BIN_PKG_URL                 = $(BUG_URL)
SGXDDK_BIN_PKG_LICENSE             = GPLv2
SGXDDK_BIN_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(SGXDDK_BIN_PKG_NAME)-pkg-description
SGXDDK_BIN_PKG_DESCRIPTION_FILE_IN = $(SGXDDK_BIN_PKG_NAME)-pkg-description.in
SGXDDK_BIN_PKG_INSTALL_SCRIPT      = $(TARGET_BUILD_DIR)/$(SGXDDK_BIN_PKG_NAME)-pkg-install.sh
SGXDDK_BIN_PKG_INSTALL_SCRIPT_IN   = $(SGXDDK_BIN_PKG_NAME)-pkg-install.sh.in

SGXDDK_BIN_PKG   = $(CURDIR)/$(TARGET_BUILD_DIR)/$(SGXDDK_BIN_PKG_NAME)-package

pkg_basename     = $(SGXDDK_BIN_PKG_NAME)-$(SGXDDK_BIN_PKG_VERSION)-$(SGXDDK_BIN_PKG_ARCH)-$(SGXDDK_BIN_PKG_DISTRO_NAME)-$(SGXDDK_BIN_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(modules_done)
BUILD_TARGETS   += $(build_sgxddk_pkg)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../../../build-system/core.mk


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

LMAKE := CROSS_COMPILE="$(CROSS_PREFIX)" ARCH=$(ARCH)  $(extra_build_environment) V=$(if $(VERBOSE),1,0) $(MAKE) -C $(SGX_KERNEL_MODULE_PATH)

$(modules_done): $(src_done)
	$(LMAKE) kbuild
	$(LMAKE) kbuild_install
	@( if [ -x /sbin/depmod ] ; then \
	     /sbin/depmod -b $(TARGET_DEST_DIR) $(modules_version) ; \
	   fi \
	 )
	@touch $@

$(build_sgxddk_pkg): $(modules_done)
	@mkdir -p $(SGXDDK_BIN_PKG)/lib/modules/$(modules_version)
	@mkdir -p $(SGXDDK_BIN_PKG)/lib/udev/rules.d
	# ======= Copy modules and firmware (without links to sources): =======
	@cd $(TARGET_DEST_DIR)/lib/modules/$(modules_version) && \
	  cp -rf extra $(SGXDDK_BIN_PKG)/lib/modules/$(modules_version)
	# ======= Copy udev rules to set right permissions for /dev/bc_example inode: =======
	@cp -a $(udev_rules) $(SGXDDK_BIN_PKG)/lib/udev/rules.d
	# ======= Install Documentation =======
	@mkdir -p $(SGXDDK_BIN_PKG)/usr/doc/sgxddk-$(version)
	@cp -a $(SRC_DIR)/eurasia_km/*-COPYING \
	       $(SRC_DIR)/eurasia_km/INSTALL $(SRC_DIR)/eurasia_km/README \
	       $(SGXDDK_BIN_PKG)/usr/doc/sgxddk-$(version)
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(SGXDDK_BIN_PKG))
	@touch $@

$(SGXDDK_BIN_PKG_DESCRIPTION_FILE): $(SGXDDK_BIN_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(SGXDDK_BIN_PKG_INSTALL_SCRIPT): $(SGXDDK_BIN_PKG_INSTALL_SCRIPT_IN)
	@cat $< | $(SED) -e "s/@MODULES_VERSION@/$(modules_version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(build_sgxddk_pkg) $(SGXDDK_BIN_PKG_DESCRIPTION_FILE) $(SGXDDK_BIN_PKG_INSTALL_SCRIPT)
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
