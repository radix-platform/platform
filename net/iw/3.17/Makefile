
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/n/iw

ifeq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC)),)
REQUIRES           = net/libnl3/3.2.25
else
REQUIRES           = net/libnl3/3.2.25-x86_32
endif

# ======= __END_OF_REQUIRES__ =======


version            = 3.17
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/n/iw/iw-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/iw-$(version)
src_dir_name       = iw-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
IW_PKG_NAME                = iw
IW_PKG_VERSION             = 3.17
IW_PKG_ARCH                = $(TOOLCHAIN)
IW_PKG_DISTRO_NAME         = $(DISTRO_NAME)
IW_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
IW_PKG_GROUP               = $(PKG_GROUP)
###                         |---handy-ruler-------------------------------|
IW_PKG_SHORT_DESCRIPTION   = tool for configuring Linux wireless devices
IW_PKG_URL                 = $(BUG_URL)
IW_PKG_LICENSE             = free
IW_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(IW_PKG_NAME)-pkg-description
IW_PKG_DESCRIPTION_FILE_IN = $(IW_PKG_NAME)-pkg-description.in
IW_PKG_INSTALL_SCRIPT      = $(IW_PKG_NAME)-pkg-install.sh

IW_PKG           = $(CURDIR)/$(TARGET_BUILD_DIR)/$(IW_PKG_NAME)-package

pkg_basename     = $(IW_PKG_NAME)-$(IW_PKG_VERSION)-$(IW_PKG_ARCH)-$(IW_PKG_DISTRO_NAME)-$(IW_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(IW_PKG)

configure_switches  = BINDIR=/usr/sbin
configure_switches += MANDIR=/usr/share/man


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(IW_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(configure_switches) $(env_sysroot)
	# ======= Install Documentation =======
	@mkdir -p $(IW_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/CONTRIBUTING $(SRC_DIR)/COPYING \
	       $(IW_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(IW_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a CONTRIBUTING COPYING README \
	         $(IW_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(IW_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(IW_PKG))
	# ======= Strip binaries =======
	@( cd $(IW_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(IW_PKG_DESCRIPTION_FILE): $(IW_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(IW_PKG_DESCRIPTION_FILE) $(IW_PKG_INSTALL_SCRIPT)
	@cp $(IW_PKG_DESCRIPTION_FILE) $(IW_PKG)/.DESCRIPTION
	@cp $(IW_PKG_INSTALL_SCRIPT) $(IW_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(IW_PKG)/.REQUIRES
	@echo "pkgname=$(IW_PKG_NAME)"                            >  $(IW_PKG)/.PKGINFO ; \
	 echo "pkgver=$(IW_PKG_VERSION)"                          >> $(IW_PKG)/.PKGINFO ; \
	 echo "arch=$(IW_PKG_ARCH)"                               >> $(IW_PKG)/.PKGINFO ; \
	 echo "distroname=$(IW_PKG_DISTRO_NAME)"                  >> $(IW_PKG)/.PKGINFO ; \
	 echo "distrover=$(IW_PKG_DISTRO_VERSION)"                >> $(IW_PKG)/.PKGINFO ; \
	 echo "group=$(IW_PKG_GROUP)"                             >> $(IW_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(IW_PKG_SHORT_DESCRIPTION)\"" >> $(IW_PKG)/.PKGINFO ; \
	 echo "url=$(IW_PKG_URL)"                                 >> $(IW_PKG)/.PKGINFO ; \
	 echo "license=$(IW_PKG_LICENSE)"                         >> $(IW_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(IW_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
