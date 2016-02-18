
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_DM64X)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)
COMPONENT_TARGETS += $(HARDWARE_CI20)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/n/netkit-rusers

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/4.9.2
else
REQUIRES           = libs/glibc/2.21
endif

# ======= __END_OF_REQUIRES__ =======


version            = 0.17
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/n/netkit-rusers/netkit-rusers-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/netkit-rusers-$(version)
src_dir_name       = netkit-rusers-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source-done


PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
RUSERS_PKG_NAME                = netkit-rusers
RUSERS_PKG_VERSION             = 0.17
RUSERS_PKG_ARCH                = $(TOOLCHAIN)
RUSERS_PKG_DISTRO_NAME         = $(DISTRO_NAME)
RUSERS_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
RUSERS_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
RUSERS_PKG_SHORT_DESCRIPTION   = show users logged in to machines on local net
RUSERS_PKG_URL                 = $(BUG_URL)
RUSERS_PKG_LICENSE             = BSD
RUSERS_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(RUSERS_PKG_NAME)-pkg-description
RUSERS_PKG_DESCRIPTION_FILE_IN = $(RUSERS_PKG_NAME)-pkg-description.in
RUSERS_PKG_INSTALL_SCRIPT      = $(RUSERS_PKG_NAME)-pkg-install.sh

RUSERS_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(RUSERS_PKG_NAME)-package

pkg_basename     = $(RUSERS_PKG_NAME)-$(RUSERS_PKG_VERSION)-$(RUSERS_PKG_ARCH)-$(RUSERS_PKG_DISTRO_NAME)-$(RUSERS_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


rusers_CFLAGS = -isystem $(TARGET_DEST_DIR)/usr/include $(OPTIMIZATION_FLAGS) $(ARCH_FLAGS) $(HW_FLAGS)
rusers_environment = CFLAGS="$(rusers_CFLAGS)"


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(rusers_environment) ./configure --prefix=/usr
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(rusers_environment) $(MAKE) -j1
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(RUSERS_PKG)/usr/{bin,sbin}
	@mkdir -p $(RUSERS_PKG)/usr/share/man/man{1,8}
	@mkdir -p $(RUSERS_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR)/rusers ; \
	   cat rusers > $(RUSERS_PKG)/usr/bin/rusers ; \
	   cat rusers.1 | gzip -9c > $(RUSERS_PKG)/usr/share/man/man1/rusers.1.gz ; \
	 )
	@( cd $(SRC_DIR)/rpc.rusersd ; \
	   cat rusersd > $(RUSERS_PKG)/usr/sbin/rpc.rusersd ; \
	   cat rpc.rusersd.8 | gzip -9c > $(RUSERS_PKG)/usr/share/man/man8/rpc.rusersd.8.gz ; \
	 )
	@( cd $(SRC_DIR)/rup ; \
	   cat rup > $(RUSERS_PKG)/usr/bin/rup ; \
	   cat rup.1 | gzip -9c > $(RUSERS_PKG)/usr/share/man/man1/rup.1.gz ; \
	 )
	@chmod 755 $(RUSERS_PKG)/usr/bin/*
	@chmod 755 $(RUSERS_PKG)/usr/sbin/*
	# ======= Install Documentation =======
	@( cd $(SRC_DIR) ; \
	   cp -a README \
	         $(RUSERS_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(RUSERS_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(RUSERS_PKG))
	# ======= Strip binaries =======
	@( cd $(RUSERS_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(RUSERS_PKG_DESCRIPTION_FILE): $(RUSERS_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(RUSERS_PKG_DESCRIPTION_FILE) $(RUSERS_PKG_INSTALL_SCRIPT)
	@cp $(RUSERS_PKG_DESCRIPTION_FILE) $(RUSERS_PKG)/.DESCRIPTION
	@cp $(RUSERS_PKG_INSTALL_SCRIPT) $(RUSERS_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(RUSERS_PKG)/.REQUIRES
	@echo "pkgname=$(RUSERS_PKG_NAME)"                            >  $(RUSERS_PKG)/.PKGINFO ; \
	 echo "pkgver=$(RUSERS_PKG_VERSION)"                          >> $(RUSERS_PKG)/.PKGINFO ; \
	 echo "arch=$(RUSERS_PKG_ARCH)"                               >> $(RUSERS_PKG)/.PKGINFO ; \
	 echo "distroname=$(RUSERS_PKG_DISTRO_NAME)"                  >> $(RUSERS_PKG)/.PKGINFO ; \
	 echo "distrover=$(RUSERS_PKG_DISTRO_VERSION)"                >> $(RUSERS_PKG)/.PKGINFO ; \
	 echo "group=$(RUSERS_PKG_GROUP)"                             >> $(RUSERS_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(RUSERS_PKG_SHORT_DESCRIPTION)\"" >> $(RUSERS_PKG)/.PKGINFO ; \
	 echo "url=$(RUSERS_PKG_URL)"                                 >> $(RUSERS_PKG)/.PKGINFO ; \
	 echo "license=$(RUSERS_PKG_LICENSE)"                         >> $(RUSERS_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(RUSERS_PKG)  && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
