
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
COMPONENT_TARGETS += $(HARDWARE_OKMX6DL_C)
COMPONENT_TARGETS += $(HARDWARE_OKMX6Q_C)
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


SOURCE_REQUIRES    = sources/packages/n/netwrite

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/6.5.0
else
REQUIRES           = libs/glibc/2.28
endif

# ======= __END_OF_REQUIRES__ =======


version            = 0.17
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/n/netwrite/netwrite-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/netwrite-$(version)
src_dir_name       = netwrite-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source-done


PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
NETWRITE_PKG_NAME                = netwrite
NETWRITE_PKG_VERSION             = 0.17
NETWRITE_PKG_ARCH                = $(TOOLCHAIN)
NETWRITE_PKG_DISTRO_NAME         = $(DISTRO_NAME)
NETWRITE_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
NETWRITE_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
NETWRITE_PKG_SHORT_DESCRIPTION   = in.writed daemon for accepting network write
NETWRITE_PKG_URL                 = $(BUG_URL)
NETWRITE_PKG_LICENSE             = BSD
NETWRITE_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(NETWRITE_PKG_NAME)-pkg-description
NETWRITE_PKG_DESCRIPTION_FILE_IN = $(NETWRITE_PKG_NAME)-pkg-description.in
NETWRITE_PKG_INSTALL_SCRIPT      = $(NETWRITE_PKG_NAME)-pkg-install.sh

NETWRITE_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(NETWRITE_PKG_NAME)-package

pkg_basename     = $(NETWRITE_PKG_NAME)-$(NETWRITE_PKG_VERSION)-$(NETWRITE_PKG_ARCH)-$(NETWRITE_PKG_DISTRO_NAME)-$(NETWRITE_PKG_DISTRO_VERSION)

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


netwrite_CFLAGS = -isystem $(TARGET_DEST_DIR)/usr/include $(OPTIMIZATION_FLAGS) $(ARCH_FLAGS) $(HW_FLAGS)
netwrite_environment = CFLAGS="$(netwrite_CFLAGS)"


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(netwrite_environment) ./configure --prefix=/usr
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(netwrite_environment) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(NETWRITE_PKG)/usr/sbin
	@mkdir -p $(NETWRITE_PKG)/usr/share/man/man8
	@mkdir -p $(NETWRITE_PKG)/usr/share/doc/$(src_dir_name)
	# the versions in util-linux are better, but we'll keep in.writed
	@( cd $(SRC_DIR)/writed ; \
	   cat writed > $(NETWRITE_PKG)/usr/sbin/in.writed ; \
	   cat writed.8 | gzip -9c > $(NETWRITE_PKG)/usr/share/man/man8/in.writed.8.gz ; \
	 )
	@chmod 755 $(NETWRITE_PKG)/usr/sbin/*
	# ======= Install Documentation =======
	@( cd $(SRC_DIR) ; \
	   cp -a README \
	         $(NETWRITE_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(NETWRITE_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(NETWRITE_PKG))
	# ======= Strip binaries =======
	@( cd $(NETWRITE_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(NETWRITE_PKG_DESCRIPTION_FILE): $(NETWRITE_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(NETWRITE_PKG_DESCRIPTION_FILE) $(NETWRITE_PKG_INSTALL_SCRIPT)
	@cp $(NETWRITE_PKG_DESCRIPTION_FILE) $(NETWRITE_PKG)/.DESCRIPTION
	@cp $(NETWRITE_PKG_INSTALL_SCRIPT) $(NETWRITE_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(NETWRITE_PKG)/.REQUIRES
	@echo "pkgname=$(NETWRITE_PKG_NAME)"                            >  $(NETWRITE_PKG)/.PKGINFO ; \
	 echo "pkgver=$(NETWRITE_PKG_VERSION)"                          >> $(NETWRITE_PKG)/.PKGINFO ; \
	 echo "arch=$(NETWRITE_PKG_ARCH)"                               >> $(NETWRITE_PKG)/.PKGINFO ; \
	 echo "distroname=$(NETWRITE_PKG_DISTRO_NAME)"                  >> $(NETWRITE_PKG)/.PKGINFO ; \
	 echo "distrover=$(NETWRITE_PKG_DISTRO_VERSION)"                >> $(NETWRITE_PKG)/.PKGINFO ; \
	 echo "group=$(NETWRITE_PKG_GROUP)"                             >> $(NETWRITE_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(NETWRITE_PKG_SHORT_DESCRIPTION)\"" >> $(NETWRITE_PKG)/.PKGINFO ; \
	 echo "url=$(NETWRITE_PKG_URL)"                                 >> $(NETWRITE_PKG)/.PKGINFO ; \
	 echo "license=$(NETWRITE_PKG_LICENSE)"                         >> $(NETWRITE_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(NETWRITE_PKG)  && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
