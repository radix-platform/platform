
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


SOURCE_REQUIRES    = sources/packages/a/hdparm

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.3.0
else
REQUIRES           = libs/glibc/2.24
endif

# ======= __END_OF_REQUIRES__ =======


version             = 9.43
tar_gz_archive      = $(SRC_PACKAGE_PATH)/packages/a/hdparm/hdparm-$(version).tar.gz
SRC_ARCHIVE         = $(tar_gz_archive)
SRC_DIR             = $(TARGET_BUILD_DIR)/hdparm-$(version)
src_dir_name        = hdparm-$(version)
src_done            = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target        = $(TARGET_BUILD_DIR)/.build_done
install_target      = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
HDPARM_PKG_NAME                = hdparm
HDPARM_PKG_VERSION             = 9.43
HDPARM_PKG_ARCH                = $(TOOLCHAIN)
HDPARM_PKG_DISTRO_NAME         = $(DISTRO_NAME)
HDPARM_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
HDPARM_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
HDPARM_PKG_SHORT_DESCRIPTION   = read/set hard drive parameters
HDPARM_PKG_URL                 = $(BUG_URL)
HDPARM_PKG_LICENSE             = GPLv2
HDPARM_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(HDPARM_PKG_NAME)-pkg-description
HDPARM_PKG_DESCRIPTION_FILE_IN = $(HDPARM_PKG_NAME)-pkg-description.in
HDPARM_PKG_INSTALL_SCRIPT      = $(HDPARM_PKG_NAME)-pkg-install.sh

HDPARM_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(HDPARM_PKG_NAME)-package

pkg_basename     = $(HDPARM_PKG_NAME)-$(HDPARM_PKG_VERSION)-$(HDPARM_PKG_ARCH)-$(HDPARM_PKG_DISTRO_NAME)-$(HDPARM_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_certificate  = $(call cert-name,$(pkg_archive))
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(HDPARM_PKG)/sbin
	@( cd $(SRC_DIR) ; \
	   cat hdparm > $(HDPARM_PKG)/sbin/hdparm ; \
	   chmod 0755 $(HDPARM_PKG)/sbin/* \
	 )
	@mkdir -p $(HDPARM_PKG)/usr/sbin
	@( cd $(HDPARM_PKG)/usr/sbin ; \
	   ln -sf ../../sbin/hdparm . ; \
	 )
	# ======= man pages =======
	@mkdir -p $(HDPARM_PKG)/usr/share/man/man8
	@( cd $(SRC_DIR) ; \
	   cat hdparm.8 | gzip -9c > $(HDPARM_PKG)/usr/share/man/man8/hdparm.8.gz ; \
	 )
	# ======= documentation =======
	@mkdir -p $(HDPARM_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/LICENSE.TXT $(HDPARM_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(HDPARM_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a LICENSE.TXT README.* contrib *.lsm TODO \
	         $(HDPARM_PKG)/usr/share/doc/$(src_dir_name) ; \
	   rm -f $(HDPARM_PKG)/usr/share/doc/$(src_dir_name)/contrib/fix_standby \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r Changelog ]; then \
	     DOCSDIR=`echo $(HDPARM_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat Changelog | head -n 1000 > $$DOCSDIR/Changelog ; \
	     touch -r Changelog $$DOCSDIR/Changelog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(HDPARM_PKG))
	# ======= Strip binaries =======
	@( cd $(HDPARM_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null \
	 )
	@touch $@

$(HDPARM_PKG_DESCRIPTION_FILE): $(HDPARM_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(HDPARM_PKG_DESCRIPTION_FILE) $(HDPARM_PKG_INSTALL_SCRIPT)
	@cp $(HDPARM_PKG_DESCRIPTION_FILE) $(HDPARM_PKG)/.DESCRIPTION
	@cp $(HDPARM_PKG_INSTALL_SCRIPT) $(HDPARM_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(HDPARM_PKG)/.REQUIRES
	@echo "pkgname=$(HDPARM_PKG_NAME)"                            >  $(HDPARM_PKG)/.PKGINFO ; \
	 echo "pkgver=$(HDPARM_PKG_VERSION)"                          >> $(HDPARM_PKG)/.PKGINFO ; \
	 echo "arch=$(HDPARM_PKG_ARCH)"                               >> $(HDPARM_PKG)/.PKGINFO ; \
	 echo "distroname=$(HDPARM_PKG_DISTRO_NAME)"                  >> $(HDPARM_PKG)/.PKGINFO ; \
	 echo "distrover=$(HDPARM_PKG_DISTRO_VERSION)"                >> $(HDPARM_PKG)/.PKGINFO ; \
	 echo "group=$(HDPARM_PKG_GROUP)"                             >> $(HDPARM_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(HDPARM_PKG_SHORT_DESCRIPTION)\"" >> $(HDPARM_PKG)/.PKGINFO ; \
	 echo "url=$(HDPARM_PKG_URL)"                                 >> $(HDPARM_PKG)/.PKGINFO ; \
	 echo "license=$(HDPARM_PKG_LICENSE)"                         >> $(HDPARM_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(HDPARM_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
