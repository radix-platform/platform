
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


SOURCE_REQUIRES    = sources/packages/n/net-tools

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.4.0
else
REQUIRES           = libs/glibc/2.27
endif

# ======= __END_OF_REQUIRES__ =======


version            = 1.60-20160127
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/n/net-tools/net-tools-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/net-tools-$(version)
src_dir_name       = net-tools-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source-done


PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
NETTOOLS_PKG_NAME                = net-tools
NETTOOLS_PKG_VERSION             = 1.60
NETTOOLS_PKG_ARCH                = $(TOOLCHAIN)
NETTOOLS_PKG_DISTRO_NAME         = $(DISTRO_NAME)
NETTOOLS_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
NETTOOLS_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
NETTOOLS_PKG_SHORT_DESCRIPTION   = base Linux networking utilities
NETTOOLS_PKG_URL                 = $(BUG_URL)
NETTOOLS_PKG_LICENSE             = GPLv2
NETTOOLS_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(NETTOOLS_PKG_NAME)-pkg-description
NETTOOLS_PKG_DESCRIPTION_FILE_IN = $(NETTOOLS_PKG_NAME)-pkg-description.in
NETTOOLS_PKG_INSTALL_SCRIPT      = $(NETTOOLS_PKG_NAME)-pkg-install.sh

NETTOOLS_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(NETTOOLS_PKG_NAME)-package

pkg_basename     = $(NETTOOLS_PKG_NAME)-$(NETTOOLS_PKG_VERSION)-$(NETTOOLS_PKG_ARCH)-$(NETTOOLS_PKG_DISTRO_NAME)-$(NETTOOLS_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


nettools_CFLAGS = -isystem $(TARGET_DEST_DIR)/usr/include $(OPTIMIZATION_FLAGS) $(ARCH_FLAGS) $(HW_FLAGS) -Wall
nettools_environment = CFLAGS="$(nettools_CFLAGS)"


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
ifeq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_A1X_GLIBC)),)
	@cd $(SRC_DIR) && sed -i "s,HAVE_HWSTRIP 1,HAVE_HWSTRIP 0,g" config.h
endif
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(nettools_environment) HAVE_IP_TOOLS=1 HAVE_MII=1 $(MAKE)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(CC) $(nettools_CFLAGS) -o ipmask ipmask.c
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(NETTOOLS_PKG)/bin
	@mkdir -p $(NETTOOLS_PKG)/sbin
	@mkdir -p $(NETTOOLS_PKG)/usr/sbin
	@mkdir -p $(NETTOOLS_PKG)/usr/share/man/man{5,8}
	@mkdir -p $(NETTOOLS_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(NETTOOLS_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cat arp        > $(NETTOOLS_PKG)/sbin/arp          ; \
	   cat ifconfig   > $(NETTOOLS_PKG)/sbin/ifconfig     ; \
	   cat rarp       > $(NETTOOLS_PKG)/sbin/rarp         ; \
	   cat route      > $(NETTOOLS_PKG)/sbin/route        ; \
	   cat mii-tool   > $(NETTOOLS_PKG)/sbin/mii-tool     ; \
	   cat nameif     > $(NETTOOLS_PKG)/sbin/nameif       ; \
	   cat netstat    > $(NETTOOLS_PKG)/bin/netstat       ; \
	   cat plipconfig > $(NETTOOLS_PKG)/sbin/plipconfig   ; \
	   cat slattach   > $(NETTOOLS_PKG)/usr/sbin/slattach ; \
	   cat ipmaddr    > $(NETTOOLS_PKG)/sbin/ipmaddr      ; \
	   cat iptunnel   > $(NETTOOLS_PKG)/sbin/iptunnel     ; \
	   cat ipmask     > $(NETTOOLS_PKG)/bin/ipmask        ; \
	   chmod 755 $(NETTOOLS_PKG)/sbin/* $(NETTOOLS_PKG)/bin/* $(NETTOOLS_PKG)/usr/sbin/* ; \
	 )
	# ======= Install Documentation =======
	@( cd $(SRC_DIR)/man/en_US ; \
	   cat ethers.5 | gzip -9c > $(NETTOOLS_PKG)/usr/share/man/man5/ethers.5.gz ; \
	   for page in arp.8 ifconfig.8 mii-tool.8 nameif.8 \
	               netstat.8 plipconfig.8 rarp.8 route.8 slattach.8 ; do \
	     cat $$page | gzip -9c > $(NETTOOLS_PKG)/usr/share/man/man8/$$page.gz ; \
	   done \
	 )
	@( cd $(SRC_DIR) ; \
	   cat ipmask.8 | gzip -9c > $(NETTOOLS_PKG)/usr/share/man/man8/ipmask.8.gz ; \
	 )
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING \
	         $(NETTOOLS_PKG)/usr/doc/$(src_dir_name) ; \
	   cp -a COPYING INSTALLING README* TODO \
	         $(NETTOOLS_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(NETTOOLS_PKG))
	# ======= Strip binaries =======
	@( cd $(NETTOOLS_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(NETTOOLS_PKG_DESCRIPTION_FILE): $(NETTOOLS_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(NETTOOLS_PKG_DESCRIPTION_FILE) $(NETTOOLS_PKG_INSTALL_SCRIPT)
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
	@$(PSEUDO) sh -c "cd $(NETTOOLS_PKG)  && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
