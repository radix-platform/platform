
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_VIP1830)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)
COMPONENT_TARGETS += $(HARDWARE_CI20)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/n/netkit-bootparamd

REQUIRES           = libs/glibc/2.21

# ======= __END_OF_REQUIRES__ =======


version            = 0.17
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/n/netkit-bootparamd/netkit-bootparamd-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/netkit-bootparamd-$(version)
src_dir_name       = netkit-bootparamd-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source-done


PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
BOOTPARAMD_PKG_NAME                = netkit-bootparamd
BOOTPARAMD_PKG_VERSION             = 0.17
BOOTPARAMD_PKG_ARCH                = $(TOOLCHAIN)
BOOTPARAMD_PKG_DISTRO_NAME         = $(DISTRO_NAME)
BOOTPARAMD_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
BOOTPARAMD_PKG_GROUP               = $(PKG_GROUP)
###                                 |---handy-ruler-------------------------------|
BOOTPARAMD_PKG_SHORT_DESCRIPTION   = boot parameter server
BOOTPARAMD_PKG_URL                 = $(BUG_URL)
BOOTPARAMD_PKG_LICENSE             = BSD
BOOTPARAMD_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(BOOTPARAMD_PKG_NAME)-pkg-description
BOOTPARAMD_PKG_DESCRIPTION_FILE_IN = $(BOOTPARAMD_PKG_NAME)-pkg-description.in
BOOTPARAMD_PKG_INSTALL_SCRIPT      = $(BOOTPARAMD_PKG_NAME)-pkg-install.sh

BOOTPARAMD_PKG   = $(CURDIR)/$(TARGET_BUILD_DIR)/$(BOOTPARAMD_PKG_NAME)-package

pkg_basename     = $(BOOTPARAMD_PKG_NAME)-$(BOOTPARAMD_PKG_VERSION)-$(BOOTPARAMD_PKG_ARCH)-$(BOOTPARAMD_PKG_DISTRO_NAME)-$(BOOTPARAMD_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


bootparamd_CFLAGS = -isystem $(TARGET_DEST_DIR)/usr/include $(OPTIMIZATION_FLAGS) $(ARCH_FLAGS) $(HW_FLAGS)
bootparamd_environment = CFLAGS="$(bootparamd_CFLAGS)"


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(bootparamd_environment) ./configure --prefix=/usr
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(bootparamd_environment) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(BOOTPARAMD_PKG)/usr/{bin,sbin}
	@mkdir -p $(BOOTPARAMD_PKG)/usr/share/man/man{5,8}
	@mkdir -p $(BOOTPARAMD_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR)/rpc.bootparamd ; \
	   cat bootparamd > $(BOOTPARAMD_PKG)/usr/sbin/rpc.bootparamd ; \
	   chmod 755 $(BOOTPARAMD_PKG)/usr/sbin/* ; \
	   cat bootparamd.8 | gzip -9c > $(BOOTPARAMD_PKG)/usr/share/man/man8/bootparamd.8.gz ; \
	   cat bootparams.5 | gzip -9c > $(BOOTPARAMD_PKG)/usr/share/man/man5/bootparams.5.gz ; \
	 )
	@( cd $(SRC_DIR)/rpc.bootparamd ; \
	   cat callbootd > $(BOOTPARAMD_PKG)/usr/bin/callbootd ; \
	   chmod 755 $(BOOTPARAMD_PKG)/usr/bin/* ; \
	 )
	# ======= Install Documentation =======
	@( cd $(SRC_DIR) ; \
	   cp -a README \
	         $(BOOTPARAMD_PKG)/usr/share/doc/$(src_dir_name) ; \
	   cp -a rpc.bootparamd/README \
	         $(BOOTPARAMD_PKG)/usr/share/doc/$(src_dir_name)/README.bootparamd ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(BOOTPARAMD_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(BOOTPARAMD_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= Strip binaries =======
	@( cd $(BOOTPARAMD_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(BOOTPARAMD_PKG_DESCRIPTION_FILE): $(BOOTPARAMD_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(BOOTPARAMD_PKG_DESCRIPTION_FILE) $(BOOTPARAMD_PKG_INSTALL_SCRIPT)
	@cp $(BOOTPARAMD_PKG_DESCRIPTION_FILE) $(BOOTPARAMD_PKG)/.DESCRIPTION
	@cp $(BOOTPARAMD_PKG_INSTALL_SCRIPT) $(BOOTPARAMD_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(BOOTPARAMD_PKG)/.REQUIRES
	@echo "pkgname=$(BOOTPARAMD_PKG_NAME)"                            >  $(BOOTPARAMD_PKG)/.PKGINFO ; \
	 echo "pkgver=$(BOOTPARAMD_PKG_VERSION)"                          >> $(BOOTPARAMD_PKG)/.PKGINFO ; \
	 echo "arch=$(BOOTPARAMD_PKG_ARCH)"                               >> $(BOOTPARAMD_PKG)/.PKGINFO ; \
	 echo "distroname=$(BOOTPARAMD_PKG_DISTRO_NAME)"                  >> $(BOOTPARAMD_PKG)/.PKGINFO ; \
	 echo "distrover=$(BOOTPARAMD_PKG_DISTRO_VERSION)"                >> $(BOOTPARAMD_PKG)/.PKGINFO ; \
	 echo "group=$(BOOTPARAMD_PKG_GROUP)"                             >> $(BOOTPARAMD_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(BOOTPARAMD_PKG_SHORT_DESCRIPTION)\"" >> $(BOOTPARAMD_PKG)/.PKGINFO ; \
	 echo "url=$(BOOTPARAMD_PKG_URL)"                                 >> $(BOOTPARAMD_PKG)/.PKGINFO ; \
	 echo "license=$(BOOTPARAMD_PKG_LICENSE)"                         >> $(BOOTPARAMD_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(BOOTPARAMD_PKG)  && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
