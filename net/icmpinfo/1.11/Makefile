
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


SOURCE_REQUIRES    = sources/packages/n/icmpinfo

REQUIRES           = libs/glibc/2.21

# ======= __END_OF_REQUIRES__ =======


version            = 1.11
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/n/icmpinfo/icmpinfo-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/icmpinfo-$(version)
src_dir_name       = icmpinfo-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source-done


PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
ICMPINFO_PKG_NAME                = icmpinfo
ICMPINFO_PKG_VERSION             = 1.11
ICMPINFO_PKG_ARCH                = $(TOOLCHAIN)
ICMPINFO_PKG_DISTRO_NAME         = $(DISTRO_NAME)
ICMPINFO_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
ICMPINFO_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
ICMPINFO_PKG_SHORT_DESCRIPTION   = ICMP monitoring utility
ICMPINFO_PKG_URL                 = $(BUG_URL)
ICMPINFO_PKG_LICENSE             = GPLv2
ICMPINFO_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(ICMPINFO_PKG_NAME)-pkg-description
ICMPINFO_PKG_DESCRIPTION_FILE_IN = $(ICMPINFO_PKG_NAME)-pkg-description.in
ICMPINFO_PKG_INSTALL_SCRIPT      = $(ICMPINFO_PKG_NAME)-pkg-install.sh

ICMPINFO_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(ICMPINFO_PKG_NAME)-package

pkg_basename     = $(ICMPINFO_PKG_NAME)-$(ICMPINFO_PKG_VERSION)-$(ICMPINFO_PKG_ARCH)-$(ICMPINFO_PKG_DISTRO_NAME)-$(ICMPINFO_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(ICMPINFO_PKG)/usr/sbin
	# ======= Install Documentation =======
	@mkdir -p $(ICMPINFO_PKG)/usr/share/man/man1
	@mkdir -p $(ICMPINFO_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cat icmpinfo > $(ICMPINFO_PKG)/usr/sbin/icmpinfo ; \
	   chmod 755 $(ICMPINFO_PKG)/usr/sbin/* ; \
	   cat icmpinfo.man | gzip -9c > $(ICMPINFO_PKG)/usr/share/man/man1/icmpinfo.1.gz ; \
	   cp -a CHANGES DOC README TODO \
	         $(ICMPINFO_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(ICMPINFO_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= Strip binaries =======
	@( cd $(ICMPINFO_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(ICMPINFO_PKG_DESCRIPTION_FILE): $(ICMPINFO_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(ICMPINFO_PKG_DESCRIPTION_FILE) $(ICMPINFO_PKG_INSTALL_SCRIPT)
	@cp $(ICMPINFO_PKG_DESCRIPTION_FILE) $(ICMPINFO_PKG)/.DESCRIPTION
	@cp $(ICMPINFO_PKG_INSTALL_SCRIPT) $(ICMPINFO_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(ICMPINFO_PKG)/.REQUIRES
	@echo "pkgname=$(ICMPINFO_PKG_NAME)"                            >  $(ICMPINFO_PKG)/.PKGINFO ; \
	 echo "pkgver=$(ICMPINFO_PKG_VERSION)"                          >> $(ICMPINFO_PKG)/.PKGINFO ; \
	 echo "arch=$(ICMPINFO_PKG_ARCH)"                               >> $(ICMPINFO_PKG)/.PKGINFO ; \
	 echo "distroname=$(ICMPINFO_PKG_DISTRO_NAME)"                  >> $(ICMPINFO_PKG)/.PKGINFO ; \
	 echo "distrover=$(ICMPINFO_PKG_DISTRO_VERSION)"                >> $(ICMPINFO_PKG)/.PKGINFO ; \
	 echo "group=$(ICMPINFO_PKG_GROUP)"                             >> $(ICMPINFO_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(ICMPINFO_PKG_SHORT_DESCRIPTION)\"" >> $(ICMPINFO_PKG)/.PKGINFO ; \
	 echo "url=$(ICMPINFO_PKG_URL)"                                 >> $(ICMPINFO_PKG)/.PKGINFO ; \
	 echo "license=$(ICMPINFO_PKG_LICENSE)"                         >> $(ICMPINFO_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(ICMPINFO_PKG)  && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
