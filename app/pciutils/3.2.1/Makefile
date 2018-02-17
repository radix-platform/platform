
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_POIN2)
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
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)
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


SOURCE_REQUIRES    = sources/packages/a/pciutils
SOURCE_REQUIRES   += sources/packages/l/pciids

REQUIRES           = app/kmod/22

# ======= __END_OF_REQUIRES__ =======


version            = 3.2.1
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/a/pciutils/pciutils-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/pciutils-$(version)
src_dir_name       = pciutils-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

pci_ids_version    = 20150210
pci_ids_archive    = $(SRC_PACKAGE_PATH)/packages/l/pciids/pciids-$(pci_ids_version).tar.xz


PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
PCIUTILS_PKG_NAME                = pciutils
PCIUTILS_PKG_VERSION             = 3.2.1
PCIUTILS_PKG_ARCH                = $(TOOLCHAIN)
PCIUTILS_PKG_DISTRO_NAME         = $(DISTRO_NAME)
PCIUTILS_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
PCIUTILS_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
PCIUTILS_PKG_SHORT_DESCRIPTION   = PCI utilities
PCIUTILS_PKG_URL                 = $(BUG_URL)
PCIUTILS_PKG_LICENSE             = GPLv2
PCIUTILS_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(PCIUTILS_PKG_NAME)-pkg-description
PCIUTILS_PKG_DESCRIPTION_FILE_IN = $(PCIUTILS_PKG_NAME)-pkg-description.in
PCIUTILS_PKG_INSTALL_SCRIPT      = $(PCIUTILS_PKG_NAME)-pkg-install.sh

PCIUTILS_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(PCIUTILS_PKG_NAME)-package

pkg_basename     = $(PCIUTILS_PKG_NAME)-$(PCIUTILS_PKG_VERSION)-$(PCIUTILS_PKG_ARCH)-$(PCIUTILS_PKG_DISTRO_NAME)-$(PCIUTILS_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(PCIUTILS_PKG)


extra_configure_switches += PREFIX=/usr
extra_configure_switches += SBINDIR=/sbin
extra_configure_switches += LIBDIR=/usr/lib$(LIBSUFFIX)
extra_configure_switches += MANDIR=/usr/share/man
extra_configure_switches += IDSDIR=/usr/share/hwdata
extra_configure_switches += PCI_IDS=pci.ids
extra_configure_switches += PCI_COMPRESSED_IDS=0
extra_configure_switches += SHARED=yes
extra_configure_switches += LIBKMOD=yes
extra_configure_switches += HOST=$(TARGET)
extra_configure_switches += OPT="-isystem $(TARGET_DEST_DIR)/usr/include $(ARCH_FLAGS) $(HW_FLAGS)"


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	# ======= Expanding $(pci_ids_archive) =======
	@tar xJf $(pci_ids_archive) -C $(SRC_DIR)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) $(extra_configure_switches)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(PCIUTILS_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install install-lib $(extra_configure_switches) $(env_sysroot)
	@chmod a+x $(PCIUTILS_PKG)/usr/lib$(LIBSUFFIX)/libpci.so.?.?.?
	@mkdir -p $(PCIUTILS_PKG)/usr/sbin
	@mv $(PCIUTILS_PKG)/sbin/update-pciids $(PCIUTILS_PKG)/usr/sbin/update-pciids
	# ======= Install Documentation =======
	@if [ -d $(PCIUTILS_PKG)/usr/share/man ]; then \
	  ( cd $(PCIUTILS_PKG)/usr/share/man ; \
	    for manpagedir in `find . -type d -name "man*"` ; do \
	      ( cd $$manpagedir ; \
	        for eachpage in `find . -type l -maxdepth 1` ; do \
	          ln -s `readlink $$eachpage`.gz $$eachpage.gz ; \
	          rm $$eachpage ; \
	        done ; \
	        gzip -9 *.?  ; \
	      ) \
	    done \
	  ) \
	 fi
	@mkdir -p $(PCIUTILS_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(PCIUTILS_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(PCIUTILS_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING README* TODO \
	         $(PCIUTILS_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(PCIUTILS_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(PCIUTILS_PKG))
	# ======= tune pkg-config *.pc search path to the target destination of libpci and PCI device database =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libpci.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(PCIUTILS_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(PCIUTILS_PKG_DESCRIPTION_FILE): $(PCIUTILS_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(PCIUTILS_PKG_DESCRIPTION_FILE) $(PCIUTILS_PKG_INSTALL_SCRIPT)
	@cp $(PCIUTILS_PKG_DESCRIPTION_FILE) $(PCIUTILS_PKG)/.DESCRIPTION
	@cp $(PCIUTILS_PKG_INSTALL_SCRIPT) $(PCIUTILS_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(PCIUTILS_PKG)/.REQUIRES
	@echo "pkgname=$(PCIUTILS_PKG_NAME)"                            >  $(PCIUTILS_PKG)/.PKGINFO ; \
	 echo "pkgver=$(PCIUTILS_PKG_VERSION)"                          >> $(PCIUTILS_PKG)/.PKGINFO ; \
	 echo "arch=$(PCIUTILS_PKG_ARCH)"                               >> $(PCIUTILS_PKG)/.PKGINFO ; \
	 echo "distroname=$(PCIUTILS_PKG_DISTRO_NAME)"                  >> $(PCIUTILS_PKG)/.PKGINFO ; \
	 echo "distrover=$(PCIUTILS_PKG_DISTRO_VERSION)"                >> $(PCIUTILS_PKG)/.PKGINFO ; \
	 echo "group=$(PCIUTILS_PKG_GROUP)"                             >> $(PCIUTILS_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(PCIUTILS_PKG_SHORT_DESCRIPTION)\"" >> $(PCIUTILS_PKG)/.PKGINFO ; \
	 echo "url=$(PCIUTILS_PKG_URL)"                                 >> $(PCIUTILS_PKG)/.PKGINFO ; \
	 echo "license=$(PCIUTILS_PKG_LICENSE)"                         >> $(PCIUTILS_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(PCIUTILS_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
