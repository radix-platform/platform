
COMPONENT_TARGETS   += $(TARGET_PC64)

NEED_ABS_PATH        = true

COMPONENT_IS_3PP     = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES      = $(SRC_PACKAGE_DIR)/packages/a/pciutils


REQUIRES             = libs/zlib/1.2.8
REQUIRES            += app/kmod/16


version              = 3.2.1
tar_xz_archive       = $(SRC_PACKAGE_PATH)/packages/a/pciutils/pciutils-$(version).tar.xz
SRC_ARCHIVE          = $(tar_xz_archive)
SRC_DIR              = $(TARGET_BUILD_DIR)/pciutils-$(version)
src_dir_name         = pciutils-$(version)
src_done             = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir            = $(TARGET_BUILD_DIR)/build
build_target         = $(TARGET_BUILD_DIR)/.build_done
install_target       = $(TARGET_BUILD_DIR)/.install_done
build_pciutils32_pkg = $(TARGET_BUILD_DIR)/.pciutils32_pkg_done



####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
PCIUTILS32_PKG_NAME                = pciutils32
PCIUTILS32_PKG_VERSION             = 3.2.1
PCIUTILS32_PKG_ARCH                = $(TOOLCHAIN)
PCIUTILS32_PKG_DISTRO_NAME         = kxLab
PCIUTILS32_PKG_DISTRO_VERSION      = 1.0
PCIUTILS32_PKG_GROUP               = $(PKG_GROUP)
###                                 |---handy-ruler-------------------------------|
PCIUTILS32_PKG_SHORT_DESCRIPTION   = pciutils32 $(version)
PCIUTILS32_PKG_URL                 = http://www.kxLab.com
PCIUTILS32_PKG_LICENSE             = GPLv2
PCIUTILS32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(PCIUTILS32_PKG_NAME)-pkg-description
PCIUTILS32_PKG_DESCRIPTION_FILE_IN = $(PCIUTILS32_PKG_NAME)-pkg-description.in
PCIUTILS32_PKG_INSTALL_SCRIPT      = $(PCIUTILS32_PKG_NAME)-pkg-install.sh

PCIUTILS32_PKG   = $(CURDIR)/$(TARGET_BUILD_DIR)/$(PCIUTILS32_PKG_NAME)-package

pkg_basename     = $(PCIUTILS32_PKG_NAME)-$(PCIUTILS32_PKG_VERSION)-$(PCIUTILS32_PKG_ARCH)-$(PCIUTILS32_PKG_DISTRO_NAME)-$(PCIUTILS32_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(PCIUTILS32_PKG_GROUP)/$(pkg_basename).tgz


BUILD_TARGETS    = $(build_pciutils32_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(PCIUTILS32_PKG)


CC         += -m32

# owerwrite LDFLAGS:
#
LDFLAGS     = -L$(TARGET_DEST_DIR)/lib$(MULTILIB_X86_32_SUFFIX)
LDFLAGS    += -L$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)

ARCH_FLAGS  = -m32 -g -O3 -march=i486 -mtune=i686

TARGET32    = $(shell echo $(TARGET) | sed 's/x86_64/i486/')


extra_configure_switches += PREFIX=/usr
extra_configure_switches += SBINDIR=/sbin
extra_configure_switches += LIBDIR=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += MANDIR=/usr/share/man
extra_configure_switches += IDSDIR=/usr/share/hwdata
extra_configure_switches += PCI_IDS=pci.ids
extra_configure_switches += PCI_COMPRESSED_IDS=0
extra_configure_switches += SHARED=yes
extra_configure_switches += LIBKMOD=yes
extra_configure_switches += HOST=$(TARGET32)
extra_configure_switches += OPT="--sysroot=$(TARGET_DEST_DIR) -isystem $(TARGET_DEST_DIR)/usr/include $(ARCH_FLAGS) $(HW_FLAGS)"


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@( cd $(SRC_DIR) ; \
	   rm -f pci.ids ; \
	   ./update-pciids.sh ; \
	 )
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) $(extra_configure_switches)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(PCIUTILS32_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) install install-lib $(extra_configure_switches) $(env_sysroot)
	@chmod a+x $(PCIUTILS32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/libpci.so.?.?.?
	@rm -rf $(PCIUTILS32_PKG)/sbin
	@rm -rf $(PCIUTILS32_PKG)/usr/include
	@rm -rf $(PCIUTILS32_PKG)/usr/share
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(PCIUTILS32_PKG) && cp -arf * $(TARGET_DEST_DIR)
	# tune pkg-config *.pc search path to the target destination of libpci and PCI device database
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libpci.pc \
	 )
	@(cd $(PCIUTILS32_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(PCIUTILS32_PKG_DESCRIPTION_FILE): $(PCIUTILS32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(build_pciutils32_pkg): $(install_target) $(PCIUTILS32_PKG_DESCRIPTION_FILE)
	@cp $(PCIUTILS32_PKG_DESCRIPTION_FILE) $(PCIUTILS32_PKG)/.DESCRIPTION
	@cp $(PCIUTILS32_PKG_INSTALL_SCRIPT) $(PCIUTILS32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(PCIUTILS32_PKG)/.REQUIRES
	@echo "pkgname=$(PCIUTILS32_PKG_NAME)"                            >  $(PCIUTILS32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(PCIUTILS32_PKG_VERSION)"                          >> $(PCIUTILS32_PKG)/.PKGINFO ; \
	 echo "arch=$(PCIUTILS32_PKG_ARCH)"                               >> $(PCIUTILS32_PKG)/.PKGINFO ; \
	 echo "distroname=$(PCIUTILS32_PKG_DISTRO_NAME)"                  >> $(PCIUTILS32_PKG)/.PKGINFO ; \
	 echo "distrover=$(PCIUTILS32_PKG_DISTRO_VERSION)"                >> $(PCIUTILS32_PKG)/.PKGINFO ; \
	 echo "group=$(PCIUTILS32_PKG_GROUP)"                             >> $(PCIUTILS32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(PCIUTILS32_PKG_SHORT_DESCRIPTION)\"" >> $(PCIUTILS32_PKG)/.PKGINFO ; \
	 echo "url=$(PCIUTILS32_PKG_URL)"                                 >> $(PCIUTILS32_PKG)/.PKGINFO ; \
	 echo "license=$(PCIUTILS32_PKG_LICENSE)"                         >> $(PCIUTILS32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(PCIUTILS32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@
