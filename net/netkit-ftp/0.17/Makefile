
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
COMPONENT_TARGETS += $(HARDWARE_BT1)
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


SOURCE_REQUIRES    = sources/packages/n/netkit-ftp

REQUIRES           = libs/readline/6.3

# ======= __END_OF_REQUIRES__ =======


version            = 0.17
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/n/netkit-ftp/netkit-ftp-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/netkit-ftp-$(version)
src_dir_name       = netkit-ftp-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source-done


PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
FTP_PKG_NAME                = netkit-ftp
FTP_PKG_VERSION             = 0.17
FTP_PKG_ARCH                = $(TOOLCHAIN)
FTP_PKG_DISTRO_NAME         = $(DISTRO_NAME)
FTP_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
FTP_PKG_GROUP               = $(PKG_GROUP)
###                          |---handy-ruler-------------------------------|
FTP_PKG_SHORT_DESCRIPTION   = the old BSD FTP client
FTP_PKG_URL                 = $(BUG_URL)
FTP_PKG_LICENSE             = BSD
FTP_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(FTP_PKG_NAME)-pkg-description
FTP_PKG_DESCRIPTION_FILE_IN = $(FTP_PKG_NAME)-pkg-description.in
FTP_PKG_INSTALL_SCRIPT      = $(FTP_PKG_NAME)-pkg-install.sh

FTP_PKG          = $(CURDIR)/$(TARGET_BUILD_DIR)/$(FTP_PKG_NAME)-package

pkg_basename     = $(FTP_PKG_NAME)-$(FTP_PKG_VERSION)-$(FTP_PKG_ARCH)-$(FTP_PKG_DISTRO_NAME)-$(FTP_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


ftp_CFLAGS = -isystem $(TARGET_DEST_DIR)/usr/include $(OPTIMIZATION_FLAGS) $(ARCH_FLAGS) $(HW_FLAGS)
ftp_environment = CFLAGS="$(ftp_CFLAGS)"


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(ftp_environment) ./configure --prefix=/usr
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(ftp_environment) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(FTP_PKG)/bin
	@mkdir -p $(FTP_PKG)/usr/share/man/man{1,5}
	@mkdir -p $(FTP_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR)/ftp ; \
	   cat ftp > $(FTP_PKG)/bin/ftp ; \
	   chmod 755 $(FTP_PKG)/bin/* ; \
	   cat ftp.1 | gzip -9c > $(FTP_PKG)/usr/share/man/man1/ftp.1.gz ; \
	   cat netrc.5 | gzip -9c > $(FTP_PKG)/usr/share/man/man5/netrc.5.gz ; \
	 )
	# ======= Install Documentation =======
	@( cd $(SRC_DIR) ; \
	   cp -a README \
	         $(FTP_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(FTP_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(FTP_PKG))
	# ======= Strip binaries =======
	@( cd $(FTP_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(FTP_PKG_DESCRIPTION_FILE): $(FTP_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(FTP_PKG_DESCRIPTION_FILE) $(FTP_PKG_INSTALL_SCRIPT)
	@cp $(FTP_PKG_DESCRIPTION_FILE) $(FTP_PKG)/.DESCRIPTION
	@cp $(FTP_PKG_INSTALL_SCRIPT) $(FTP_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(FTP_PKG)/.REQUIRES
	@echo "pkgname=$(FTP_PKG_NAME)"                            >  $(FTP_PKG)/.PKGINFO ; \
	 echo "pkgver=$(FTP_PKG_VERSION)"                          >> $(FTP_PKG)/.PKGINFO ; \
	 echo "arch=$(FTP_PKG_ARCH)"                               >> $(FTP_PKG)/.PKGINFO ; \
	 echo "distroname=$(FTP_PKG_DISTRO_NAME)"                  >> $(FTP_PKG)/.PKGINFO ; \
	 echo "distrover=$(FTP_PKG_DISTRO_VERSION)"                >> $(FTP_PKG)/.PKGINFO ; \
	 echo "group=$(FTP_PKG_GROUP)"                             >> $(FTP_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(FTP_PKG_SHORT_DESCRIPTION)\"" >> $(FTP_PKG)/.PKGINFO ; \
	 echo "url=$(FTP_PKG_URL)"                                 >> $(FTP_PKG)/.PKGINFO ; \
	 echo "license=$(FTP_PKG_LICENSE)"                         >> $(FTP_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(FTP_PKG)  && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
