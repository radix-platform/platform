
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXV)
COMPONENT_TARGETS += $(HARDWARE_P201)
COMPONENT_TARGETS += $(HARDWARE_NEXBOX_A95X)
COMPONENT_TARGETS += $(HARDWARE_ODROID_C2)
COMPONENT_TARGETS += $(HARDWARE_P212)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_VIM)
COMPONENT_TARGETS += $(HARDWARE_Q201)
COMPONENT_TARGETS += $(HARDWARE_ENYBOX_X2)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/n/netkit-ntalk

REQUIRES           = libs/libtermcap/1.2.3

# ======= __END_OF_REQUIRES__ =======


version            = 0.17
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/n/netkit-ntalk/netkit-ntalk-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/netkit-ntalk-$(version)
src_dir_name       = netkit-ntalk-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source-done


PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
NTALK_PKG_NAME                = netkit-ntalk
NTALK_PKG_VERSION             = 0.17
NTALK_PKG_ARCH                = $(TOOLCHAIN)
NTALK_PKG_DISTRO_NAME         = $(DISTRO_NAME)
NTALK_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
NTALK_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
NTALK_PKG_SHORT_DESCRIPTION   = talk client and talkd daemon
NTALK_PKG_URL                 = $(BUG_URL)
NTALK_PKG_LICENSE             = BSD
NTALK_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(NTALK_PKG_NAME)-pkg-description
NTALK_PKG_DESCRIPTION_FILE_IN = $(NTALK_PKG_NAME)-pkg-description.in
NTALK_PKG_INSTALL_SCRIPT      = $(NTALK_PKG_NAME)-pkg-install.sh

NTALK_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(NTALK_PKG_NAME)-package

pkg_basename     = $(NTALK_PKG_NAME)-$(NTALK_PKG_VERSION)-$(NTALK_PKG_ARCH)-$(NTALK_PKG_DISTRO_NAME)-$(NTALK_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


ntalk_CFLAGS = -isystem $(TARGET_DEST_DIR)/usr/include $(OPTIMIZATION_FLAGS) $(ARCH_FLAGS) $(HW_FLAGS)
ntalk_environment = CFLAGS="$(ntalk_CFLAGS)"


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(ntalk_environment) ./configure --prefix=/usr
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(ntalk_environment) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(NTALK_PKG)/usr/{bin,sbin}
	@mkdir -p $(NTALK_PKG)/usr/share/man/man{1,8}
	@mkdir -p $(NTALK_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR)/talk ; \
	   cat talk > $(NTALK_PKG)/usr/bin/talk ; \
	   chmod 755 $(NTALK_PKG)/usr/bin/* ; \
	   cat talk.1 | gzip -9c > $(NTALK_PKG)/usr/share/man/man1/talk.1.gz ; \
	 )
	@( cd $(SRC_DIR)/talkd ; \
	   cat talkd > $(NTALK_PKG)/usr/sbin/in.talkd ; \
	   chmod 755 $(NTALK_PKG)/usr/sbin/* ; \
	   cat talkd.8 | gzip -9c > $(NTALK_PKG)/usr/share/man/man8/talkd.8.gz ; \
	 )
	@( cd $(NTALK_PKG)/usr/sbin ; rm -rf in.ntalkd )
	@( cd $(NTALK_PKG)/usr/sbin ; ln -sf in.talkd in.ntalkd )
	@( cd $(NTALK_PKG)/usr/bin  ; rm -rf ntalk )
	@( cd $(NTALK_PKG)/usr/bin  ; ln -sf talk ntalk )
	# ======= Install Documentation =======
	@( cd $(SRC_DIR) ; \
	   cp -a README \
	         $(NTALK_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(NTALK_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(NTALK_PKG))
	# ======= Strip binaries =======
	@( cd $(NTALK_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(NTALK_PKG_DESCRIPTION_FILE): $(NTALK_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(NTALK_PKG_DESCRIPTION_FILE) $(NTALK_PKG_INSTALL_SCRIPT)
	@cp $(NTALK_PKG_DESCRIPTION_FILE) $(NTALK_PKG)/.DESCRIPTION
	@cp $(NTALK_PKG_INSTALL_SCRIPT) $(NTALK_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(NTALK_PKG)/.REQUIRES
	@echo "pkgname=$(NTALK_PKG_NAME)"                            >  $(NTALK_PKG)/.PKGINFO ; \
	 echo "pkgver=$(NTALK_PKG_VERSION)"                          >> $(NTALK_PKG)/.PKGINFO ; \
	 echo "arch=$(NTALK_PKG_ARCH)"                               >> $(NTALK_PKG)/.PKGINFO ; \
	 echo "distroname=$(NTALK_PKG_DISTRO_NAME)"                  >> $(NTALK_PKG)/.PKGINFO ; \
	 echo "distrover=$(NTALK_PKG_DISTRO_VERSION)"                >> $(NTALK_PKG)/.PKGINFO ; \
	 echo "group=$(NTALK_PKG_GROUP)"                             >> $(NTALK_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(NTALK_PKG_SHORT_DESCRIPTION)\"" >> $(NTALK_PKG)/.PKGINFO ; \
	 echo "url=$(NTALK_PKG_URL)"                                 >> $(NTALK_PKG)/.PKGINFO ; \
	 echo "license=$(NTALK_PKG_LICENSE)"                         >> $(NTALK_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(NTALK_PKG)  && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
