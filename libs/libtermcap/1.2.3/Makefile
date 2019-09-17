
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


SOURCE_REQUIRES    = sources/packages/l/termcap-compat

REQUIRES           = libs/ncurses/6.0

# ======= __END_OF_REQUIRES__ =======


version            = 1.2.3
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/termcap-compat/termcap-compat_$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/termcap-compat-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
TERMCAP_PKG_NAME                = libtermcap
TERMCAP_PKG_VERSION             = 1.2.3
TERMCAP_PKG_ARCH                = $(TOOLCHAIN)
TERMCAP_PKG_DISTRO_NAME         = $(DISTRO_NAME)
TERMCAP_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
TERMCAP_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
TERMCAP_PKG_SHORT_DESCRIPTION   = GNU termcap library
TERMCAP_PKG_URL                 = $(BUG_URL)
TERMCAP_PKG_LICENSE             = GPLv2
TERMCAP_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(TERMCAP_PKG_NAME)-pkg-description
TERMCAP_PKG_DESCRIPTION_FILE_IN = $(TERMCAP_PKG_NAME)-pkg-description.in
TERMCAP_PKG_INSTALL_SCRIPT      = $(TERMCAP_PKG_NAME)-pkg-install.sh

TERMCAP_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(TERMCAP_PKG_NAME)-package

pkg_basename     = $(TERMCAP_PKG_NAME)-$(TERMCAP_PKG_VERSION)-$(TERMCAP_PKG_ARCH)-$(TERMCAP_PKG_DISTRO_NAME)-$(TERMCAP_PKG_DISTRO_VERSION)

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
	@mkdir -p $(TERMCAP_PKG)/lib$(LIBSUFFIX)
	@mkdir -p $(TERMCAP_PKG)/usr/lib$(LIBSUFFIX)
	@mkdir -p $(TERMCAP_PKG)/usr/include
	@mkdir -p $(TERMCAP_PKG)/usr/share/info
	@( cd $(SRC_DIR) ; \
	   install -m755 libtermcap.so.* $(TERMCAP_PKG)/lib$(LIBSUFFIX) ; \
	   install -m644 libtermcap.a $(TERMCAP_PKG)/usr/lib$(LIBSUFFIX) ; \
	   install -m644 termcap.h $(TERMCAP_PKG)/usr/include ; \
	   install -m644 termcap.info* $(TERMCAP_PKG)/usr/share/info \
	 )
	# ======= Install Documentation =======
	@gzip -9 $(TERMCAP_PKG)/usr/share/info/*
	@( cd $(TERMCAP_PKG)/lib$(LIBSUFFIX) ; \
	   ln -sf libtermcap.so.?.?.? libtermcap.so.2 \
	 )
	@( cd $(TERMCAP_PKG)/usr/lib$(LIBSUFFIX) ; \
	   ln -sf ../../lib$(LIBSUFFIX)/libtermcap.so.?.?.? . ; \
	   ln -sf libtermcap.so.?.?.? libtermcap.so ; \
	   ln -sf libtermcap.so.?.?.? libtermcap.so.2 \
	 )
	@mkdir -p $(TERMCAP_PKG)/usr/doc/libtermcap-$(version)
	@mkdir -p $(TERMCAP_PKG)/usr/share/doc/libtermcap-$(version)
	@( cd $(SRC_DIR) ; \
	   cp -a README $(TERMCAP_PKG)/usr/doc/libtermcap-$(version) \
	 )
	@( cd $(SRC_DIR) ; \
	   cp -a ChangeLog README \
	         $(TERMCAP_PKG)/usr/share/doc/libtermcap-$(version) \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(TERMCAP_PKG))
	# ======= Strip binaries =======
	@( cd $(TERMCAP_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(TERMCAP_PKG_DESCRIPTION_FILE): $(TERMCAP_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(TERMCAP_PKG_DESCRIPTION_FILE) $(TERMCAP_PKG_INSTALL_SCRIPT)
	@cp $(TERMCAP_PKG_DESCRIPTION_FILE) $(TERMCAP_PKG)/.DESCRIPTION
	@cp $(TERMCAP_PKG_INSTALL_SCRIPT) $(TERMCAP_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(TERMCAP_PKG)/.REQUIRES
	@echo "pkgname=$(TERMCAP_PKG_NAME)"                            >  $(TERMCAP_PKG)/.PKGINFO ; \
	 echo "pkgver=$(TERMCAP_PKG_VERSION)"                          >> $(TERMCAP_PKG)/.PKGINFO ; \
	 echo "arch=$(TERMCAP_PKG_ARCH)"                               >> $(TERMCAP_PKG)/.PKGINFO ; \
	 echo "distroname=$(TERMCAP_PKG_DISTRO_NAME)"                  >> $(TERMCAP_PKG)/.PKGINFO ; \
	 echo "distrover=$(TERMCAP_PKG_DISTRO_VERSION)"                >> $(TERMCAP_PKG)/.PKGINFO ; \
	 echo "group=$(TERMCAP_PKG_GROUP)"                             >> $(TERMCAP_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(TERMCAP_PKG_SHORT_DESCRIPTION)\"" >> $(TERMCAP_PKG)/.PKGINFO ; \
	 echo "url=$(TERMCAP_PKG_URL)"                                 >> $(TERMCAP_PKG)/.PKGINFO ; \
	 echo "license=$(TERMCAP_PKG_LICENSE)"                         >> $(TERMCAP_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(TERMCAP_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
