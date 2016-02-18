
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


SOURCE_REQUIRES    = sources/packages/n/netkit-telnet
SOURCE_REQUIRES   += sources/packages/n/telnet-OpenBSD


REQUIRES           = libs/libtermcap/1.2.3

# ======= __END_OF_REQUIRES__ =======


version            = 0.17
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/n/netkit-telnet/netkit-telnet-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/netkit-telnet-$(version)
src_dir_name       = netkit-telnet-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source-done

tar_bsd_archive    = $(SRC_PACKAGE_PATH)/packages/n/telnet-OpenBSD/telnet-OpenBSD-20020321.tar.gz


PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
TELNET_PKG_NAME                = netkit-telnet
TELNET_PKG_VERSION             = 0.17
TELNET_PKG_ARCH                = $(TOOLCHAIN)
TELNET_PKG_DISTRO_NAME         = $(DISTRO_NAME)
TELNET_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
TELNET_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
TELNET_PKG_SHORT_DESCRIPTION   = the telnet client and daemon
TELNET_PKG_URL                 = $(BUG_URL)
TELNET_PKG_LICENSE             = BSD
TELNET_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(TELNET_PKG_NAME)-pkg-description
TELNET_PKG_DESCRIPTION_FILE_IN = $(TELNET_PKG_NAME)-pkg-description.in
TELNET_PKG_INSTALL_SCRIPT      = $(TELNET_PKG_NAME)-pkg-install.sh

TELNET_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(TELNET_PKG_NAME)-package

pkg_basename     = $(TELNET_PKG_NAME)-$(TELNET_PKG_VERSION)-$(TELNET_PKG_ARCH)-$(TELNET_PKG_DISTRO_NAME)-$(TELNET_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

ROOTFS_TARGETS   = $(pkg_archive)

PRODUCT_TARGETS  = $(products)


include ../../../build-system/core.mk


telnet_CFLAGS = -isystem $(TARGET_DEST_DIR)/usr/include $(OPTIMIZATION_FLAGS) $(ARCH_FLAGS) $(HW_FLAGS)
telnet_environment = CFLAGS="$(telnet_CFLAGS)" CXXFLAGS="$(telnet_CFLAGS)"


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	rm -rf $(SRC_DIR)/telnet
	tar -C $(SRC_DIR) -xzf $(tar_bsd_archive)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(telnet_environment) ./configure --prefix=/usr
	@cd $(SRC_DIR)/telnetd && $(BUILD_ENVIRONMENT) $(telnet_environment) $(MAKE)
	@cd $(SRC_DIR)/telnet  && $(BUILD_ENVIRONMENT) $(telnet_environment) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(TELNET_PKG)/bin
	@mkdir -p $(TELNET_PKG)/usr/sbin
	@mkdir -p $(TELNET_PKG)/usr/share/man/man{1,8}
	@mkdir -p $(TELNET_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR)/telnet ; \
	   cat telnet > $(TELNET_PKG)/bin/telnet ; \
	   cat telnet.1 | gzip -9c > $(TELNET_PKG)/usr/share/man/man1/telnet.1.gz ; \
	 )
	@( cd $(SRC_DIR)/telnetd ; \
	   cat telnetd > $(TELNET_PKG)/usr/sbin/in.telnetd ; \
	   cat telnetd.8 | gzip -9c > $(TELNET_PKG)/usr/share/man/man8/in.telnetd.8.gz ; \
	 )
	@chmod 755 $(TELNET_PKG)/bin/*
	@chmod 755 $(TELNET_PKG)/usr/sbin/*
	# ======= Install Documentation =======
	@( cd $(SRC_DIR) ; \
	   cp -a README \
	         $(TELNET_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(TELNET_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(TELNET_PKG))
	# ======= Strip binaries =======
	@( cd $(TELNET_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(TELNET_PKG_DESCRIPTION_FILE): $(TELNET_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(TELNET_PKG_DESCRIPTION_FILE) $(TELNET_PKG_INSTALL_SCRIPT)
	@cp $(TELNET_PKG_DESCRIPTION_FILE) $(TELNET_PKG)/.DESCRIPTION
	@cp $(TELNET_PKG_INSTALL_SCRIPT) $(TELNET_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(TELNET_PKG)/.REQUIRES
	@echo "pkgname=$(TELNET_PKG_NAME)"                            >  $(TELNET_PKG)/.PKGINFO ; \
	 echo "pkgver=$(TELNET_PKG_VERSION)"                          >> $(TELNET_PKG)/.PKGINFO ; \
	 echo "arch=$(TELNET_PKG_ARCH)"                               >> $(TELNET_PKG)/.PKGINFO ; \
	 echo "distroname=$(TELNET_PKG_DISTRO_NAME)"                  >> $(TELNET_PKG)/.PKGINFO ; \
	 echo "distrover=$(TELNET_PKG_DISTRO_VERSION)"                >> $(TELNET_PKG)/.PKGINFO ; \
	 echo "group=$(TELNET_PKG_GROUP)"                             >> $(TELNET_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(TELNET_PKG_SHORT_DESCRIPTION)\"" >> $(TELNET_PKG)/.PKGINFO ; \
	 echo "url=$(TELNET_PKG_URL)"                                 >> $(TELNET_PKG)/.PKGINFO ; \
	 echo "license=$(TELNET_PKG_LICENSE)"                         >> $(TELNET_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(TELNET_PKG)  && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
