
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_ORANGE_PP2E)
COMPONENT_TARGETS += $(HARDWARE_NANOPI_NEO)
COMPONENT_TARGETS += $(HARDWARE_ORANGE_PP)
COMPONENT_TARGETS += $(HARDWARE_ORANGE_PL2)
COMPONENT_TARGETS += $(HARDWARE_WECHIP_TX6)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_POIN2)
COMPONENT_TARGETS += $(HARDWARE_RK3328_CC)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_EDGE)
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


SOURCE_REQUIRES    = sources/packages/n/netkit-rsh

REQUIRES           = libs/libtermcap/1.2.3

# ======= __END_OF_REQUIRES__ =======


version            = 0.17
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/n/netkit-rsh/netkit-rsh-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/netkit-rsh-$(version)
src_dir_name       = netkit-rsh-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source-done


PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
RSH_PKG_NAME                = netkit-rsh
RSH_PKG_VERSION             = 0.17
RSH_PKG_ARCH                = $(TOOLCHAIN)
RSH_PKG_DISTRO_NAME         = $(DISTRO_NAME)
RSH_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
RSH_PKG_GROUP               = $(PKG_GROUP)
###                          |---handy-ruler-------------------------------|
RSH_PKG_SHORT_DESCRIPTION   = the BSD rsh/rcp/rlogin clients and daemon
RSH_PKG_URL                 = $(BUG_URL)
RSH_PKG_LICENSE             = BSD
RSH_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(RSH_PKG_NAME)-pkg-description
RSH_PKG_DESCRIPTION_FILE_IN = $(RSH_PKG_NAME)-pkg-description.in
RSH_PKG_INSTALL_SCRIPT      = $(RSH_PKG_NAME)-pkg-install.sh

RSH_PKG          = $(CURDIR)/$(TARGET_BUILD_DIR)/$(RSH_PKG_NAME)-package

pkg_basename     = $(RSH_PKG_NAME)-$(RSH_PKG_VERSION)-$(RSH_PKG_ARCH)-$(RSH_PKG_DISTRO_NAME)-$(RSH_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_certificate  = $(call cert-name,$(pkg_archive))
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

ROOTFS_TARGETS   = $(pkg_archive)

PRODUCT_TARGETS  = $(products)


include ../../../build-system/core.mk


rsh_CFLAGS = -isystem $(TARGET_DEST_DIR)/usr/include $(OPTIMIZATION_FLAGS) $(ARCH_FLAGS) $(HW_FLAGS)
rsh_environment = CFLAGS="$(rsh_CFLAGS)"


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(rsh_environment) ./configure --prefix=/usr
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(rsh_environment) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(RSH_PKG)/usr/{bin,sbin}
	@mkdir -p $(RSH_PKG)/usr/share/man/man{1,8}
	@mkdir -p $(RSH_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR)/rsh ; \
	   cat rsh > $(RSH_PKG)/usr/bin/rsh ; \
	   cat rsh.1 | gzip -9c > $(RSH_PKG)/usr/share/man/man1/rsh.1.gz ; \
	 )
	@( cd $(SRC_DIR)/rshd ; \
	   cat rshd > $(RSH_PKG)/usr/sbin/in.rshd ; \
	   cat rshd.8 | gzip -9c > $(RSH_PKG)/usr/share/man/man8/in.rshd.8.gz ; \
	 )
	@( cd $(SRC_DIR)/rcp ; \
	   cat rcp > $(RSH_PKG)/usr/bin/rcp ; \
	   cat rcp.1 | gzip -9c > $(RSH_PKG)/usr/share/man/man1/rcp.1.gz ; \
	 )
	@( cd $(SRC_DIR)/rexec ; \
	   cat rexec > $(RSH_PKG)/usr/bin/rexec ; \
	   cat rexec.1 | gzip -9c > $(RSH_PKG)/usr/share/man/man1/rexec.1.gz ; \
	 )
	@( cd $(SRC_DIR)/rexecd ; \
	   cat rexecd > $(RSH_PKG)/usr/sbin/in.rexecd ; \
	   cat rexecd.8 | gzip -9c > $(RSH_PKG)/usr/share/man/man8/in.rexecd.8.gz ; \
	 )
	@( cd $(SRC_DIR)/rlogin ; \
	   cat rlogin > $(RSH_PKG)/usr/bin/rlogin ; \
	   cat rlogin.1 | gzip -9c > $(RSH_PKG)/usr/share/man/man1/rlogin.1.gz ; \
	 )
	@( cd $(SRC_DIR)/rlogind ; \
	   cat rlogind > $(RSH_PKG)/usr/sbin/in.rlogind ; \
	   cat rlogind.8 | gzip -9c > $(RSH_PKG)/usr/share/man/man8/in.rlogind.8.gz ; \
	 )
	@chmod 4711 $(RSH_PKG)/usr/bin/*
	@chmod  755 $(RSH_PKG)/usr/sbin/*
	# ======= Install Documentation =======
	@( cd $(SRC_DIR) ; \
	   cp -a README \
	         $(RSH_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(RSH_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(RSH_PKG))
	# ======= Strip binaries =======
	@( cd $(RSH_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(RSH_PKG_DESCRIPTION_FILE): $(RSH_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(RSH_PKG_DESCRIPTION_FILE) $(RSH_PKG_INSTALL_SCRIPT)
	@cp $(RSH_PKG_DESCRIPTION_FILE) $(RSH_PKG)/.DESCRIPTION
	@cp $(RSH_PKG_INSTALL_SCRIPT) $(RSH_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(RSH_PKG)/.REQUIRES
	@echo "pkgname=$(RSH_PKG_NAME)"                            >  $(RSH_PKG)/.PKGINFO ; \
	 echo "pkgver=$(RSH_PKG_VERSION)"                          >> $(RSH_PKG)/.PKGINFO ; \
	 echo "arch=$(RSH_PKG_ARCH)"                               >> $(RSH_PKG)/.PKGINFO ; \
	 echo "distroname=$(RSH_PKG_DISTRO_NAME)"                  >> $(RSH_PKG)/.PKGINFO ; \
	 echo "distrover=$(RSH_PKG_DISTRO_VERSION)"                >> $(RSH_PKG)/.PKGINFO ; \
	 echo "group=$(RSH_PKG_GROUP)"                             >> $(RSH_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(RSH_PKG_SHORT_DESCRIPTION)\"" >> $(RSH_PKG)/.PKGINFO ; \
	 echo "url=$(RSH_PKG_URL)"                                 >> $(RSH_PKG)/.PKGINFO ; \
	 echo "license=$(RSH_PKG_LICENSE)"                         >> $(RSH_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(RSH_PKG)  && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
