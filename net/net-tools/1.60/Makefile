
COMPONENT_TARGETS  += $(TARGET_PC32)
COMPONENT_TARGETS  += $(TARGET_PC64)
COMPONENT_TARGETS  += $(TARGET_CB1X)
COMPONENT_TARGETS  += $(TARGET_VIP1830)
COMPONENT_TARGETS  += $(TARGET_BEAGLE)
COMPONENT_TARGETS  += $(TARGET_OMAP5UEVM)
COMPONENT_TARGETS  += $(TARGET_B74)

#
# The rest targets links staticaly with newlib or uclibc and not requires xz libraties
#
# COMPONENT_TARGETS  += $(TARGET_CB1N)
# COMPONENT_TARGETS  += $(TARGET_GUARD)
# COMPONENT_TARGETS  += $(TARGET_VIP1830N)
# COMPONENT_TARGETS  += $(TARGET_L17UC)
#


NEED_ABS_PATH       = true

COMPONENT_IS_3PP    = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES     = $(SRC_PACKAGE_DIR)/packages/n/net-tools


REQUIRES            = libs/eglibc/2.18.1


version             = 1.60-20140218
tar_bz2_archive     = $(SRC_PACKAGE_PATH)/packages/n/net-tools/net-tools-$(version).tar.bz2
SRC_ARCHIVE         = $(tar_bz2_archive)
SRC_DIR             = $(TARGET_BUILD_DIR)/net-tools-$(version)
src_dir_name        = net-tools-$(version)
src_done            = $(TARGET_BUILD_DIR)/.source-done


PATCHES = PATCHES

build_target        = $(TARGET_BUILD_DIR)/.build_done
install_target      = $(TARGET_BUILD_DIR)/.install_done
build_nettools_pkg  = $(TARGET_BUILD_DIR)/.nettools_pkg_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
NETTOOLS_PKG_NAME                = net-tools
NETTOOLS_PKG_VERSION             = 1.60
NETTOOLS_PKG_ARCH                = $(TOOLCHAIN)
NETTOOLS_PKG_DISTRO_NAME         = kxLab
NETTOOLS_PKG_DISTRO_VERSION      = 1.0
NETTOOLS_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
NETTOOLS_PKG_SHORT_DESCRIPTION   = net-tools $(version)
NETTOOLS_PKG_URL                 = http://www.kxLab.com
NETTOOLS_PKG_LICENSE             = GPLv2
NETTOOLS_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(NETTOOLS_PKG_NAME)-pkg-description
NETTOOLS_PKG_DESCRIPTION_FILE_IN = $(NETTOOLS_PKG_NAME)-pkg-description.in
NETTOOLS_PKG_INSTALL_SCRIPT      = $(NETTOOLS_PKG_NAME)-pkg-install.sh

NETTOOLS_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(NETTOOLS_PKG_NAME)-package

pkg_basename     = $(NETTOOLS_PKG_NAME)-$(NETTOOLS_PKG_VERSION)-$(NETTOOLS_PKG_ARCH)-$(NETTOOLS_PKG_DISTRO_NAME)-$(NETTOOLS_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(NETTOOLS_PKG_GROUP)/$(pkg_basename).tgz


BUILD_TARGETS    = $(build_nettools_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../build-system/core.mk


nettools_CFLAGS = -isystem $(TARGET_DEST_DIR)/usr/include $(OPTIMIZATION_FLAGS) $(ARCH_FLAGS) $(HW_FLAGS) -Wall
nettools_environment = CFLAGS="$(nettools_CFLAGS)"



####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
ifeq ($(filter $(TOOLCHAIN),$(BCM74X_EGLIBC_TOOLCHAIN_NAME) $(A1X_EGLIBC_TOOLCHAIN_NAME) $(OMAP35X_EGLIBC_TOOLCHAIN_NAME) $(DM644X_EGLIBC_TOOLCHAIN_NAME)),)
	@cd $(SRC_DIR) && sed -i "s,HAVE_HWSTRIP 1,HAVE_HWSTRIP 0,g" config.h
endif
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(nettools_environment) HAVE_IP_TOOLS=1 HAVE_MII=1 $(MAKE)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(nettools_environment) HAVE_IP_TOOLS=1 HAVE_MII=1 $(MAKE) hostname
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(CC) $(nettools_CFLAGS) -o ipmask ipmask.c
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(NETTOOLS_PKG)/bin
	@mkdir -p $(NETTOOLS_PKG)/sbin
	@mkdir -p $(NETTOOLS_PKG)/usr/sbin
	@mkdir -p $(NETTOOLS_PKG)/usr/share/man/man{1,5,8}
	@mkdir -p $(NETTOOLS_PKG)/usr/share/doc/$(src_dir_name)
	exit 1
	@( cd $(SRC_DIR) ; \
	   cat icmpinfo > $(NETTOOLS_PKG)/usr/sbin/icmpinfo ; \
	   chmod 755 $(NETTOOLS_PKG)/usr/sbin/* ; \
	   cat icmpinfo.man | gzip -9c > $(NETTOOLS_PKG)/usr/share/man/man1/icmpinfo.1.gz ; \
	   cp -a CHANGES DOC README TODO \
	         $(NETTOOLS_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(NETTOOLS_PKG) && cp -rf * $(TARGET_DEST_DIR)
	@(cd $(NETTOOLS_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(NETTOOLS_PKG_DESCRIPTION_FILE): $(NETTOOLS_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(build_nettools_pkg): $(install_target) $(NETTOOLS_PKG_DESCRIPTION_FILE)
	@cp $(NETTOOLS_PKG_DESCRIPTION_FILE) $(NETTOOLS_PKG)/.DESCRIPTION
	@cp $(NETTOOLS_PKG_INSTALL_SCRIPT) $(NETTOOLS_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(NETTOOLS_PKG)/.REQUIRES
	@echo "pkgname=$(NETTOOLS_PKG_NAME)"                            >  $(NETTOOLS_PKG)/.PKGINFO ; \
	 echo "pkgver=$(NETTOOLS_PKG_VERSION)"                          >> $(NETTOOLS_PKG)/.PKGINFO ; \
	 echo "arch=$(NETTOOLS_PKG_ARCH)"                               >> $(NETTOOLS_PKG)/.PKGINFO ; \
	 echo "distroname=$(NETTOOLS_PKG_DISTRO_NAME)"                  >> $(NETTOOLS_PKG)/.PKGINFO ; \
	 echo "distrover=$(NETTOOLS_PKG_DISTRO_VERSION)"                >> $(NETTOOLS_PKG)/.PKGINFO ; \
	 echo "group=$(NETTOOLS_PKG_GROUP)"                             >> $(NETTOOLS_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(NETTOOLS_PKG_SHORT_DESCRIPTION)\"" >> $(NETTOOLS_PKG)/.PKGINFO ; \
	 echo "url=$(NETTOOLS_PKG_URL)"                                 >> $(NETTOOLS_PKG)/.PKGINFO ; \
	 echo "license=$(NETTOOLS_PKG_LICENSE)"                         >> $(NETTOOLS_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(NETTOOLS_PKG)  && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@
