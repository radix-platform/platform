
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_ORANGE_PP2E)
COMPONENT_TARGETS += $(HARDWARE_NANOPI_NEO)
COMPONENT_TARGETS += $(HARDWARE_ORANGE_PP)
COMPONENT_TARGETS += $(HARDWARE_ORANGE_PL2)
COMPONENT_TARGETS += $(HARDWARE_WECHIP_TX6)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_POIN2)
COMPONENT_TARGETS += $(HARDWARE_RK3328_CC)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_EDGE)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXV)
COMPONENT_TARGETS += $(HARDWARE_P201)
COMPONENT_TARGETS += $(HARDWARE_NEXBOX_A95X)
COMPONENT_TARGETS += $(HARDWARE_ODROID_C2)
COMPONENT_TARGETS += $(HARDWARE_P212)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_VIM)
COMPONENT_TARGETS += $(HARDWARE_Q201)
COMPONENT_TARGETS += $(HARDWARE_ENYBOX_X2)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_VIM2)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OKMX6DL_C)
COMPONENT_TARGETS += $(HARDWARE_OKMX6Q_C)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BAIKAL_T1)
COMPONENT_TARGETS += $(HARDWARE_MBC4_PC)
COMPONENT_TARGETS += $(HARDWARE_S824L)
COMPONENT_TARGETS += $(HARDWARE_VESNIN)
COMPONENT_TARGETS += $(HARDWARE_S824L_LSB)
COMPONENT_TARGETS += $(HARDWARE_VESNIN_LSB)
COMPONENT_TARGETS += $(HARDWARE_TL2WK2)
COMPONENT_TARGETS += $(HARDWARE_TL2SV2)
COMPONENT_TARGETS += $(HARDWARE_TL2WK2_LSB)
COMPONENT_TARGETS += $(HARDWARE_TL2SV2_LSB)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/btrfs-progs

ifeq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC)),)
REQUIRES           = app/acl/2.2.53
REQUIRES          += libs/lzo/2.10
REQUIRES          += app/e2fsprogs/1.42.9
else
REQUIRES           = app/acl/2.2.53-x86_32
REQUIRES          += libs/lzo/2.10-x86_32
REQUIRES          += app/e2fsprogs/1.42.9-x86_32
endif

# ======= __END_OF_REQUIRES__ =======


version            = 4.4
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
BTRFS_PKG_VERSION             = 4.4
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
pkg_certificate  = $(call cert-name,$(pkg_archive))
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))


BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(BTRFS_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --includedir=/usr/include
extra_configure_switches += --datadir=/usr/share
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)

extra_configure_switches += --bindir=/sbin
extra_configure_switches += --sysconfdir=/etc


SHIP_LIBRARIES = false


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@( cd $(SRC_DIR) ; \
	   ./autogen.sh ; \
	 )
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && \
	  $(BUILD_ENVIRONMENT) ./configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(BTRFS_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@mkdir -p $(BTRFS_PKG)/lib$(LIBSUFFIX)
	@( cd $(BTRFS_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in lib*.so.?.* ; do \
	     mv $$file ../../lib$(LIBSUFFIX) ; \
	     ln -sf ../../lib$(LIBSUFFIX)/$$file . ; \
	   done ; \
	   cp -a lib*.so.? ../../lib$(LIBSUFFIX) ; \
	 )
	# ======= According to
	# ======= https://btrfs.wiki.kernel.org/index.php/FAQ#When_will_Btrfs_have_a_fsck_like_tool.3F
	# ======= it is safe and recommended to make fsck.btrfs a no-op by linking it to /bin/true
	@ln -sf /bin/true $(BTRFS_PKG)/sbin/fsck.btrfs
ifneq ($(SHIP_LIBRARIES),true)
	@rm -rf $(BTRFS_PKG)/usr/include
	@rm -rf $(BTRFS_PKG)/usr/lib$(LIBSUFFIX)
	@rm -rf $(BTRFS_PKG)/lib$(LIBSUFFIX)
else
	@( cd $(BTRFS_PKG)/usr/lib$(LIBSUFFIX) ; \
	   chmod 0644 lib*.a ; \
	 )
endif
	# ======= Install Documentatiom =======
	@mkdir -p $(BTRFS_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(BTRFS_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(BTRFS_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING INSTALL README* \
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

$(pkg_certificate) : $(pkg_archive) ;
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
	@$(PSEUDO) sh -c "cd $(BTRFS_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
