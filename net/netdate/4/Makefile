
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/n/netdate

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.3.0
else
REQUIRES           = libs/glibc/2.23
endif

# ======= __END_OF_REQUIRES__ =======


version            = 4
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/n/netdate/netdate.tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/netdate
src_dir_name       = netdate
src_done           = $(TARGET_BUILD_DIR)/.source-done


PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done

readme_file        = $(CURDIR)/README


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
NETDATE_PKG_NAME                = netdate
NETDATE_PKG_VERSION             = 4
NETDATE_PKG_ARCH                = $(TOOLCHAIN)
NETDATE_PKG_DISTRO_NAME         = $(DISTRO_NAME)
NETDATE_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
NETDATE_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
NETDATE_PKG_SHORT_DESCRIPTION   = simple network time utility
NETDATE_PKG_URL                 = $(BUG_URL)
NETDATE_PKG_LICENSE             = BSD
NETDATE_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(NETDATE_PKG_NAME)-pkg-description
NETDATE_PKG_DESCRIPTION_FILE_IN = $(NETDATE_PKG_NAME)-pkg-description.in
NETDATE_PKG_INSTALL_SCRIPT      = $(NETDATE_PKG_NAME)-pkg-install.sh

NETDATE_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(NETDATE_PKG_NAME)-package

pkg_basename     = $(NETDATE_PKG_NAME)-$(NETDATE_PKG_VERSION)-$(NETDATE_PKG_ARCH)-$(NETDATE_PKG_DISTRO_NAME)-$(NETDATE_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


netdate_CFLAGS = -isystem $(TARGET_DEST_DIR)/usr/include $(OPTIMIZATION_FLAGS) $(ARCH_FLAGS) $(HW_FLAGS)
netdate_environment = CFLAGS="$(netdate_CFLAGS)"


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(netdate_environment) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(NETDATE_PKG)/usr/sbin
	@mkdir -p $(NETDATE_PKG)/usr/share/man/man8
	@mkdir -p $(NETDATE_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(NETDATE_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cat netdate > $(NETDATE_PKG)/usr/sbin/netdate ; \
	   chmod 755 $(NETDATE_PKG)/usr/sbin/* ; \
	 )
	# ======= Install Documentation =======
	@( cd $(SRC_DIR) ; \
	   cat netdate.8 | gzip -9c > $(NETDATE_PKG)/usr/share/man/man8/netdate.8.gz ; \
	 )
	@( cd $(SRC_DIR) ; \
	   cp -a COPYRIGHT \
	         $(NETDATE_PKG)/usr/doc/$(src_dir_name) ; \
	   cp -a COPYRIGHT \
	         $(NETDATE_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@cp -a $(readme_file) $(NETDATE_PKG)/usr/share/doc/$(src_dir_name)
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(NETDATE_PKG))
	# ======= Strip binaries =======
	@( cd $(NETDATE_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(NETDATE_PKG_DESCRIPTION_FILE): $(NETDATE_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(NETDATE_PKG_DESCRIPTION_FILE) $(NETDATE_PKG_INSTALL_SCRIPT)
	@cp $(NETDATE_PKG_DESCRIPTION_FILE) $(NETDATE_PKG)/.DESCRIPTION
	@cp $(NETDATE_PKG_INSTALL_SCRIPT) $(NETDATE_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(NETDATE_PKG)/.REQUIRES
	@echo "pkgname=$(NETDATE_PKG_NAME)"                            >  $(NETDATE_PKG)/.PKGINFO ; \
	 echo "pkgver=$(NETDATE_PKG_VERSION)"                          >> $(NETDATE_PKG)/.PKGINFO ; \
	 echo "arch=$(NETDATE_PKG_ARCH)"                               >> $(NETDATE_PKG)/.PKGINFO ; \
	 echo "distroname=$(NETDATE_PKG_DISTRO_NAME)"                  >> $(NETDATE_PKG)/.PKGINFO ; \
	 echo "distrover=$(NETDATE_PKG_DISTRO_VERSION)"                >> $(NETDATE_PKG)/.PKGINFO ; \
	 echo "group=$(NETDATE_PKG_GROUP)"                             >> $(NETDATE_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(NETDATE_PKG_SHORT_DESCRIPTION)\"" >> $(NETDATE_PKG)/.PKGINFO ; \
	 echo "url=$(NETDATE_PKG_URL)"                                 >> $(NETDATE_PKG)/.PKGINFO ; \
	 echo "license=$(NETDATE_PKG_LICENSE)"                         >> $(NETDATE_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(NETDATE_PKG)  && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
