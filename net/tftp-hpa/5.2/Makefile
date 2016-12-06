
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


SOURCE_REQUIRES    = sources/packages/n/tftp-hpa

REQUIRES           = libs/readline/6.3

# ======= __END_OF_REQUIRES__ =======


version            = 5.2
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/n/tftp-hpa/tftp-hpa-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/tftp-hpa-$(version)
src_dir_name       = tftp-hpa-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source-done


PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
TFTP_PKG_NAME                = tftp-hpa
TFTP_PKG_VERSION             = 5.2
TFTP_PKG_ARCH                = $(TOOLCHAIN)
TFTP_PKG_DISTRO_NAME         = $(DISTRO_NAME)
TFTP_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
TFTP_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
TFTP_PKG_SHORT_DESCRIPTION   = Trivial File Transfer Protocol
TFTP_PKG_URL                 = $(BUG_URL)
TFTP_PKG_LICENSE             = BSD
TFTP_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(TFTP_PKG_NAME)-pkg-description
TFTP_PKG_DESCRIPTION_FILE_IN = $(TFTP_PKG_NAME)-pkg-description.in
TFTP_PKG_INSTALL_SCRIPT      = $(TFTP_PKG_NAME)-pkg-install.sh

TFTP_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(TFTP_PKG_NAME)-package

pkg_basename     = $(TFTP_PKG_NAME)-$(TFTP_PKG_VERSION)-$(TFTP_PKG_ARCH)-$(TFTP_PKG_DISTRO_NAME)-$(TFTP_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


tftp_CFLAGS = -isystem $(TARGET_DEST_DIR)/usr/include $(OPTIMIZATION_FLAGS) $(ARCH_FLAGS) $(HW_FLAGS)
tftp_environment = CFLAGS="$(tftp_CFLAGS)"


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(tftp_environment) ./configure \
	  --prefix=/usr    \
	  --build=$(BUILD) \
	  --host=$(TARGET)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(tftp_environment) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(TFTP_PKG)/usr/{bin,sbin}
	@mkdir -p $(TFTP_PKG)/usr/share/man/man{1,8}
	@mkdir -p $(TFTP_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR)/tftp ; \
	   cat tftp > $(TFTP_PKG)/usr/bin/tftp ; \
	   cat tftp.1 | gzip -9c > $(TFTP_PKG)/usr/share/man/man1/tftp.1.gz ; \
	 )
	@( cd $(SRC_DIR)/tftpd ; \
	   cat tftpd > $(TFTP_PKG)/usr/sbin/in.tftpd ; \
	   cat tftpd.8 | gzip -9c > $(TFTP_PKG)/usr/share/man/man8/in.tftpd.8.gz ; \
	 )
	@chmod 755 $(TFTP_PKG)/usr/bin/*
	@chmod 755 $(TFTP_PKG)/usr/sbin/*
	# ======= Install Documentation =======
	@( cd $(SRC_DIR) ; \
	   cp -a INSTALL* README* \
	         $(TFTP_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r CHANGES ]; then \
	     DOCSDIR=`echo $(TFTP_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat CHANGES | head -n 1000 > $$DOCSDIR/CHANGES ; \
	     touch -r CHANGES $$DOCSDIR/CHANGES ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(TFTP_PKG))
	# ======= Strip binaries =======
	@( cd $(TFTP_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(TFTP_PKG_DESCRIPTION_FILE): $(TFTP_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(TFTP_PKG_DESCRIPTION_FILE) $(TFTP_PKG_INSTALL_SCRIPT)
	@cp $(TFTP_PKG_DESCRIPTION_FILE) $(TFTP_PKG)/.DESCRIPTION
	@cp $(TFTP_PKG_INSTALL_SCRIPT) $(TFTP_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(TFTP_PKG)/.REQUIRES
	@echo "pkgname=$(TFTP_PKG_NAME)"                            >  $(TFTP_PKG)/.PKGINFO ; \
	 echo "pkgver=$(TFTP_PKG_VERSION)"                          >> $(TFTP_PKG)/.PKGINFO ; \
	 echo "arch=$(TFTP_PKG_ARCH)"                               >> $(TFTP_PKG)/.PKGINFO ; \
	 echo "distroname=$(TFTP_PKG_DISTRO_NAME)"                  >> $(TFTP_PKG)/.PKGINFO ; \
	 echo "distrover=$(TFTP_PKG_DISTRO_VERSION)"                >> $(TFTP_PKG)/.PKGINFO ; \
	 echo "group=$(TFTP_PKG_GROUP)"                             >> $(TFTP_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(TFTP_PKG_SHORT_DESCRIPTION)\"" >> $(TFTP_PKG)/.PKGINFO ; \
	 echo "url=$(TFTP_PKG_URL)"                                 >> $(TFTP_PKG)/.PKGINFO ; \
	 echo "license=$(TFTP_PKG_LICENSE)"                         >> $(TFTP_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(TFTP_PKG)  && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
