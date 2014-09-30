
COMPONENT_TARGETS   = $(HARDWARE_PC32)
COMPONENT_TARGETS  += $(HARDWARE_PC64)
COMPONENT_TARGETS  += $(HARDWARE_CB1X)
COMPONENT_TARGETS  += $(HARDWARE_CB2X)
COMPONENT_TARGETS  += $(HARDWARE_VIP1830)
COMPONENT_TARGETS  += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS  += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS  += $(HARDWARE_B74)


NEED_ABS_PATH       = true
COMPONENT_IS_3PP    = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES     = sources/packages/n/netkit-rwall

REQUIRES            = libs/eglibc/2.19.1


version             = 0.17
tar_gz_archive      = $(SRC_PACKAGE_PATH)/packages/n/netkit-rwall/netkit-rwall-$(version).tar.gz
SRC_ARCHIVE         = $(tar_gz_archive)
SRC_DIR             = $(TARGET_BUILD_DIR)/netkit-rwall-$(version)
src_dir_name        = netkit-rwall-$(version)
src_done            = $(TARGET_BUILD_DIR)/.source-done


PATCHES = PATCHES

build_target        = $(TARGET_BUILD_DIR)/.build_done
install_target      = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
RWALL_PKG_NAME                = netkit-rwall
RWALL_PKG_VERSION             = 0.17
RWALL_PKG_ARCH                = $(TOOLCHAIN)
RWALL_PKG_DISTRO_NAME         = $(DISTRO_NAME)
RWALL_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
RWALL_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
RWALL_PKG_SHORT_DESCRIPTION   = netkit-rwall $(version)
RWALL_PKG_URL                 = $(BUG_URL)
RWALL_PKG_LICENSE             = BSD
RWALL_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(RWALL_PKG_NAME)-pkg-description
RWALL_PKG_DESCRIPTION_FILE_IN = $(RWALL_PKG_NAME)-pkg-description.in
RWALL_PKG_INSTALL_SCRIPT      = $(RWALL_PKG_NAME)-pkg-install.sh

RWALL_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(RWALL_PKG_NAME)-package

pkg_basename     = $(RWALL_PKG_NAME)-$(RWALL_PKG_VERSION)-$(RWALL_PKG_ARCH)-$(RWALL_PKG_DISTRO_NAME)-$(RWALL_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


rwall_CFLAGS = -isystem $(TARGET_DEST_DIR)/usr/include $(OPTIMIZATION_FLAGS) $(ARCH_FLAGS) $(HW_FLAGS)
rwall_environment = CFLAGS="$(rwall_CFLAGS)"


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(rwall_environment) ./configure --prefix=/usr
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(rwall_environment) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(RWALL_PKG)/usr/{bin,sbin}
	@mkdir -p $(RWALL_PKG)/usr/share/man/man{1,8}
	@mkdir -p $(RWALL_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR)/rwall ; \
	   cat rwall > $(RWALL_PKG)/usr/bin/rwall ; \
	   cat rwall.1 | gzip -9c > $(RWALL_PKG)/usr/share/man/man1/rwall.1.gz ; \
	 )
	@( cd $(SRC_DIR)/rpc.rwalld ; \
	   cat rwalld > $(RWALL_PKG)/usr/sbin/rpc.rwalld ; \
	   cat rpc.rwalld.8 | gzip -9c > $(RWALL_PKG)/usr/share/man/man8/rpc.rwalld.8.gz ; \
	 )
	@chmod 755 $(RWALL_PKG)/usr/bin/*
	@chmod 755 $(RWALL_PKG)/usr/sbin/*
	@( cd $(SRC_DIR) ; \
	   cp -a README \
	         $(RWALL_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(RWALL_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(RWALL_PKG) && cp -rf * $(TARGET_DEST_DIR)
	@(cd $(RWALL_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(RWALL_PKG_DESCRIPTION_FILE): $(RWALL_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(RWALL_PKG_DESCRIPTION_FILE) $(RWALL_PKG_INSTALL_SCRIPT)
	@cp $(RWALL_PKG_DESCRIPTION_FILE) $(RWALL_PKG)/.DESCRIPTION
	@cp $(RWALL_PKG_INSTALL_SCRIPT) $(RWALL_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(RWALL_PKG)/.REQUIRES
	@echo "pkgname=$(RWALL_PKG_NAME)"                            >  $(RWALL_PKG)/.PKGINFO ; \
	 echo "pkgver=$(RWALL_PKG_VERSION)"                          >> $(RWALL_PKG)/.PKGINFO ; \
	 echo "arch=$(RWALL_PKG_ARCH)"                               >> $(RWALL_PKG)/.PKGINFO ; \
	 echo "distroname=$(RWALL_PKG_DISTRO_NAME)"                  >> $(RWALL_PKG)/.PKGINFO ; \
	 echo "distrover=$(RWALL_PKG_DISTRO_VERSION)"                >> $(RWALL_PKG)/.PKGINFO ; \
	 echo "group=$(RWALL_PKG_GROUP)"                             >> $(RWALL_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(RWALL_PKG_SHORT_DESCRIPTION)\"" >> $(RWALL_PKG)/.PKGINFO ; \
	 echo "url=$(RWALL_PKG_URL)"                                 >> $(RWALL_PKG)/.PKGINFO ; \
	 echo "license=$(RWALL_PKG_LICENSE)"                         >> $(RWALL_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(RWALL_PKG)  && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
