
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


SOURCE_REQUIRES    = sources/packages/n/netkit-routed

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/4.9.2
else
REQUIRES           = libs/glibc/2.21
endif

# ======= __END_OF_REQUIRES__ =======


version            = 0.17
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/n/netkit-routed/netkit-routed-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/netkit-routed-$(version)
src_dir_name       = netkit-routed-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source-done


PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
ROUTED_PKG_NAME                = netkit-routed
ROUTED_PKG_VERSION             = 0.18
ROUTED_PKG_ARCH                = $(TOOLCHAIN)
ROUTED_PKG_DISTRO_NAME         = $(DISTRO_NAME)
ROUTED_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
ROUTED_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
ROUTED_PKG_SHORT_DESCRIPTION   = dynamic network routing daemon
ROUTED_PKG_URL                 = $(BUG_URL)
ROUTED_PKG_LICENSE             = BSD
ROUTED_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(ROUTED_PKG_NAME)-pkg-description
ROUTED_PKG_DESCRIPTION_FILE_IN = $(ROUTED_PKG_NAME)-pkg-description.in
ROUTED_PKG_INSTALL_SCRIPT      = $(ROUTED_PKG_NAME)-pkg-install.sh

ROUTED_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(ROUTED_PKG_NAME)-package

pkg_basename     = $(ROUTED_PKG_NAME)-$(ROUTED_PKG_VERSION)-$(ROUTED_PKG_ARCH)-$(ROUTED_PKG_DISTRO_NAME)-$(ROUTED_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


routed_CFLAGS = -isystem $(TARGET_DEST_DIR)/usr/include $(OPTIMIZATION_FLAGS) $(ARCH_FLAGS) $(HW_FLAGS)
routed_environment = CFLAGS="$(routed_CFLAGS)"


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(routed_environment) ./configure --prefix=/usr
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(routed_environment) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(ROUTED_PKG)/usr/sbin
	@mkdir -p $(ROUTED_PKG)/usr/share/man/man8
	@mkdir -p $(ROUTED_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR)/routed ; \
	   cat routed > $(ROUTED_PKG)/usr/sbin/routed ; \
	   chmod 755 $(ROUTED_PKG)/usr/sbin/* ; \
	   cat routed.8 | gzip -9c > $(ROUTED_PKG)/usr/share/man/man8/routed.8.gz ; \
	 )
	@( cd $(SRC_DIR)/ripquery ; \
	   cat ripquery > $(ROUTED_PKG)/usr/sbin/ripquery ; \
	   chmod 755 $(ROUTED_PKG)/usr/sbin/* ; \
	   cat ripquery.8 | gzip -9c > $(ROUTED_PKG)/usr/share/man/man8/ripquery.8.gz ; \
	 )
	# ======= Install Documentation =======
	@( cd $(SRC_DIR) ; \
	   cp -a README \
	         $(ROUTED_PKG)/usr/share/doc/$(src_dir_name) ; \
	   cp -a routed/README \
	         $(ROUTED_PKG)/usr/share/doc/$(src_dir_name)/README.routed ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(ROUTED_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(ROUTED_PKG))
	# ======= Strip binaries =======
	@( cd $(ROUTED_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(ROUTED_PKG_DESCRIPTION_FILE): $(ROUTED_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/0.18/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(ROUTED_PKG_DESCRIPTION_FILE) $(ROUTED_PKG_INSTALL_SCRIPT)
	@cp $(ROUTED_PKG_DESCRIPTION_FILE) $(ROUTED_PKG)/.DESCRIPTION
	@cp $(ROUTED_PKG_INSTALL_SCRIPT) $(ROUTED_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(ROUTED_PKG)/.REQUIRES
	@echo "pkgname=$(ROUTED_PKG_NAME)"                            >  $(ROUTED_PKG)/.PKGINFO ; \
	 echo "pkgver=$(ROUTED_PKG_VERSION)"                          >> $(ROUTED_PKG)/.PKGINFO ; \
	 echo "arch=$(ROUTED_PKG_ARCH)"                               >> $(ROUTED_PKG)/.PKGINFO ; \
	 echo "distroname=$(ROUTED_PKG_DISTRO_NAME)"                  >> $(ROUTED_PKG)/.PKGINFO ; \
	 echo "distrover=$(ROUTED_PKG_DISTRO_VERSION)"                >> $(ROUTED_PKG)/.PKGINFO ; \
	 echo "group=$(ROUTED_PKG_GROUP)"                             >> $(ROUTED_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(ROUTED_PKG_SHORT_DESCRIPTION)\"" >> $(ROUTED_PKG)/.PKGINFO ; \
	 echo "url=$(ROUTED_PKG_URL)"                                 >> $(ROUTED_PKG)/.PKGINFO ; \
	 echo "license=$(ROUTED_PKG_LICENSE)"                         >> $(ROUTED_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(ROUTED_PKG)  && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
