
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXQ)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/btrfs-progs

ifeq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC)),)
REQUIRES           = app/acl/2.2.52
REQUIRES          += libs/lzo/2.09
REQUIRES          += app/e2fsprogs/1.42.9
else
REQUIRES           = app/acl/2.2.52-x86_32
REQUIRES          += libs/lzo/2.09-x86_32
REQUIRES          += app/e2fsprogs/1.42.9-x86_32
endif

# ======= __END_OF_REQUIRES__ =======


version            = 3.16
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/a/btrfs-progs/btrfs-progs-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/btrfs-progs-$(version)
src_dir_name       = btrfs-progs-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
BTRFS_PKG_NAME                = btrfs-progs
BTRFS_PKG_VERSION             = 3.16
BTRFS_PKG_ARCH                = $(TOOLCHAIN)
BTRFS_PKG_DISTRO_NAME         = $(DISTRO_NAME)
BTRFS_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
BTRFS_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
BTRFS_PKG_SHORT_DESCRIPTION   = Btrfs filesystem utilities
BTRFS_PKG_URL                 = $(BUG_URL)
BTRFS_PKG_LICENSE             = GPLv2
BTRFS_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(BTRFS_PKG_NAME)-pkg-description
BTRFS_PKG_DESCRIPTION_FILE_IN = $(BTRFS_PKG_NAME)-pkg-description.in
BTRFS_PKG_INSTALL_SCRIPT      = $(BTRFS_PKG_NAME)-pkg-install.sh

BTRFS_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(BTRFS_PKG_NAME)-package

pkg_basename     = $(BTRFS_PKG_NAME)-$(BTRFS_PKG_VERSION)-$(BTRFS_PKG_ARCH)-$(BTRFS_PKG_DISTRO_NAME)-$(BTRFS_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))


BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(BTRFS_PKG)

environment  = prefix=/usr
environment += libdir=/usr/lib$(LIBSUFFIX)

SHIP_LIBRARIES = false

####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(environment) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(BTRFS_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(environment) $(MAKE) -j1 install $(env_sysroot)
	@mv $(BTRFS_PKG)/usr/bin $(BTRFS_PKG)/sbin
ifneq ($(SHIP_LIBRARIES),true)
	@rm -rf $(BTRFS_PKG)/usr/include
	@rm -rf $(BTRFS_PKG)/usr/lib$(LIBSUFFIX)
else
	@chmod a-x $(BTRFS_PKG)/usr/lib$(LIBSUFFIX)/libbtrfs.a
endif
	# ======= Install Documentatiom =======
	@mkdir -p $(BTRFS_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(BTRFS_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(BTRFS_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING INSTALL \
	         $(BTRFS_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(BTRFS_PKG))
	# ======= Strip binaries =======
	@( cd $(BTRFS_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifeq ($(SHIP_LIBRARIES),true)
	@( cd $(BTRFS_PKG) ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
endif
	@touch $@

$(BTRFS_PKG_DESCRIPTION_FILE): $(BTRFS_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(BTRFS_PKG_DESCRIPTION_FILE) $(BTRFS_PKG_INSTALL_SCRIPT)
	@cp $(BTRFS_PKG_DESCRIPTION_FILE) $(BTRFS_PKG)/.DESCRIPTION
	@cp $(BTRFS_PKG_INSTALL_SCRIPT) $(BTRFS_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(BTRFS_PKG)/.REQUIRES
	@echo "pkgname=$(BTRFS_PKG_NAME)"                            >  $(BTRFS_PKG)/.PKGINFO ; \
	 echo "pkgver=$(BTRFS_PKG_VERSION)"                          >> $(BTRFS_PKG)/.PKGINFO ; \
	 echo "arch=$(BTRFS_PKG_ARCH)"                               >> $(BTRFS_PKG)/.PKGINFO ; \
	 echo "distroname=$(BTRFS_PKG_DISTRO_NAME)"                  >> $(BTRFS_PKG)/.PKGINFO ; \
	 echo "distrover=$(BTRFS_PKG_DISTRO_VERSION)"                >> $(BTRFS_PKG)/.PKGINFO ; \
	 echo "group=$(BTRFS_PKG_GROUP)"                             >> $(BTRFS_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(BTRFS_PKG_SHORT_DESCRIPTION)\"" >> $(BTRFS_PKG)/.PKGINFO ; \
	 echo "url=$(BTRFS_PKG_URL)"                                 >> $(BTRFS_PKG)/.PKGINFO ; \
	 echo "license=$(BTRFS_PKG_LICENSE)"                         >> $(BTRFS_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(BTRFS_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
