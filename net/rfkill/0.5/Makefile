
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


SOURCE_REQUIRES    = sources/packages/n/rfkill

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.4.0
else
REQUIRES           = libs/glibc/2.26
endif

# ======= __END_OF_REQUIRES__ =======


version            = 0.5
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/n/rfkill/rfkill-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/rfkill-$(version)
src_dir_name       = rfkill-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
RFKILL_PKG_NAME                = rfkill
RFKILL_PKG_VERSION             = 0.5
RFKILL_PKG_ARCH                = $(TOOLCHAIN)
RFKILL_PKG_DISTRO_NAME         = $(DISTRO_NAME)
RFKILL_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
RFKILL_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
RFKILL_PKG_SHORT_DESCRIPTION   = tool to query subsystem interfaces
RFKILL_PKG_URL                 = $(BUG_URL)
RFKILL_PKG_LICENSE             = free
RFKILL_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(RFKILL_PKG_NAME)-pkg-description
RFKILL_PKG_DESCRIPTION_FILE_IN = $(RFKILL_PKG_NAME)-pkg-description.in
RFKILL_PKG_INSTALL_SCRIPT      = $(RFKILL_PKG_NAME)-pkg-install.sh

RFKILL_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(RFKILL_PKG_NAME)-package

pkg_basename     = $(RFKILL_PKG_NAME)-$(RFKILL_PKG_VERSION)-$(RFKILL_PKG_ARCH)-$(RFKILL_PKG_DISTRO_NAME)-$(RFKILL_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(RFKILL_PKG)

configure_switches  = PREFIX=/usr
configure_switches += MANDIR=/usr/share/man


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) $(configure_switches)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(RFKILL_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(configure_switches) $(env_sysroot)
	# ======= Install Documentation =======
	@mkdir -p $(RFKILL_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(RFKILL_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(RFKILL_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING README \
	         $(RFKILL_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(RFKILL_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(RFKILL_PKG))
	# ======= Strip binaries =======
	@( cd $(RFKILL_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(RFKILL_PKG_DESCRIPTION_FILE): $(RFKILL_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(RFKILL_PKG_DESCRIPTION_FILE) $(RFKILL_PKG_INSTALL_SCRIPT)
	@cp $(RFKILL_PKG_DESCRIPTION_FILE) $(RFKILL_PKG)/.DESCRIPTION
	@cp $(RFKILL_PKG_INSTALL_SCRIPT) $(RFKILL_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(RFKILL_PKG)/.REQUIRES
	@echo "pkgname=$(RFKILL_PKG_NAME)"                            >  $(RFKILL_PKG)/.PKGINFO ; \
	 echo "pkgver=$(RFKILL_PKG_VERSION)"                          >> $(RFKILL_PKG)/.PKGINFO ; \
	 echo "arch=$(RFKILL_PKG_ARCH)"                               >> $(RFKILL_PKG)/.PKGINFO ; \
	 echo "distroname=$(RFKILL_PKG_DISTRO_NAME)"                  >> $(RFKILL_PKG)/.PKGINFO ; \
	 echo "distrover=$(RFKILL_PKG_DISTRO_VERSION)"                >> $(RFKILL_PKG)/.PKGINFO ; \
	 echo "group=$(RFKILL_PKG_GROUP)"                             >> $(RFKILL_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(RFKILL_PKG_SHORT_DESCRIPTION)\"" >> $(RFKILL_PKG)/.PKGINFO ; \
	 echo "url=$(RFKILL_PKG_URL)"                                 >> $(RFKILL_PKG)/.PKGINFO ; \
	 echo "license=$(RFKILL_PKG_LICENSE)"                         >> $(RFKILL_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(RFKILL_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
