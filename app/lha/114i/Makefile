
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_DM64X)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES     = sources/packages/a/lha

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.3.0
else
REQUIRES           = libs/glibc/2.22
endif

# ======= __END_OF_REQUIRES__ =======


version             = 114i
tar_gz_archive      = $(SRC_PACKAGE_PATH)/packages/a/lha/lha-$(version).tar.gz
SRC_ARCHIVE         = $(tar_gz_archive)
SRC_DIR             = $(TARGET_BUILD_DIR)/lha-$(version)
src_dir_name        = lha-$(version)
src_done            = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target        = $(TARGET_BUILD_DIR)/.build_done
install_target      = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LHA_PKG_NAME                = lha
LHA_PKG_VERSION             = 114i
LHA_PKG_ARCH                = $(TOOLCHAIN)
LHA_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LHA_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LHA_PKG_GROUP               = $(PKG_GROUP)
###                          |---handy-ruler-------------------------------|
LHA_PKG_SHORT_DESCRIPTION   = LHa archive utility
LHA_PKG_URL                 = $(BUG_URL)
LHA_PKG_LICENSE             = GPLv2
LHA_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LHA_PKG_NAME)-pkg-description
LHA_PKG_DESCRIPTION_FILE_IN = $(LHA_PKG_NAME)-pkg-description.in
LHA_PKG_INSTALL_SCRIPT      = $(LHA_PKG_NAME)-pkg-install.sh

LHA_PKG          = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LHA_PKG_NAME)-package

pkg_basename     = $(LHA_PKG_NAME)-$(LHA_PKG_VERSION)-$(LHA_PKG_ARCH)-$(LHA_PKG_DISTRO_NAME)-$(LHA_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
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
	@mkdir -p $(LHA_PKG)/usr/bin
	@( cd $(SRC_DIR) ; \
	   cat src/lha > $(LHA_PKG)/usr/bin/lha ; \
	   chmod 0755 $(LHA_PKG)/usr/bin/* \
	 )
	# ======= man pages =======
	@mkdir -p $(LHA_PKG)/usr/share/man/man1
	@( cd $(SRC_DIR) ; \
	   cat debian/lha.1 | gzip -9c > $(LHA_PKG)/usr/share/man/man1/lha.1.gz ; \
	 )
	# ======= documentation =======
	@mkdir -p $(LHA_PKG)/usr/share/doc/$(src_dir_name)/jp
	@( cd $(SRC_DIR) ; \
	   cp -a change-$(version).txt \
	         debian/header-e.doc   \
	         $(LHA_PKG)/usr/share/doc/$(src_dir_name) ; \
	   cp -a *.euc \
	         $(LHA_PKG)/usr/share/doc/$(src_dir_name)/jp ; \
	   chmod a-x $(LHA_PKG)/usr/share/doc/$(src_dir_name)/jp/* \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LHA_PKG))
	# ======= Strip binaries =======
	@( cd $(LHA_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null \
	 )
	@touch $@

$(LHA_PKG_DESCRIPTION_FILE): $(LHA_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LHA_PKG_DESCRIPTION_FILE) $(LHA_PKG_INSTALL_SCRIPT)
	@cp $(LHA_PKG_DESCRIPTION_FILE) $(LHA_PKG)/.DESCRIPTION
	@cp $(LHA_PKG_INSTALL_SCRIPT) $(LHA_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LHA_PKG)/.REQUIRES
	@echo "pkgname=$(LHA_PKG_NAME)"                            >  $(LHA_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LHA_PKG_VERSION)"                          >> $(LHA_PKG)/.PKGINFO ; \
	 echo "arch=$(LHA_PKG_ARCH)"                               >> $(LHA_PKG)/.PKGINFO ; \
	 echo "distroname=$(LHA_PKG_DISTRO_NAME)"                  >> $(LHA_PKG)/.PKGINFO ; \
	 echo "distrover=$(LHA_PKG_DISTRO_VERSION)"                >> $(LHA_PKG)/.PKGINFO ; \
	 echo "group=$(LHA_PKG_GROUP)"                             >> $(LHA_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LHA_PKG_SHORT_DESCRIPTION)\"" >> $(LHA_PKG)/.PKGINFO ; \
	 echo "url=$(LHA_PKG_URL)"                                 >> $(LHA_PKG)/.PKGINFO ; \
	 echo "license=$(LHA_PKG_LICENSE)"                         >> $(LHA_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LHA_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
