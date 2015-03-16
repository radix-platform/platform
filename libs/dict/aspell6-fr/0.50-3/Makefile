
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_VIP1830)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES     = sources/dict/aspell/fr

REQUIRES            = libs/aspell/0.60.6.1

# ======= __END_OF_REQUIRES__ =======


language            = French
aspell_base_version = 0.60

version             = 0.50-3
tar_bz2_archive     = $(SRC_PACKAGE_PATH)/dict/aspell/fr/aspell-fr-$(version).tar.bz2
SRC_ARCHIVE         = $(tar_bz2_archive)
SRC_DIR             = $(TARGET_BUILD_DIR)/aspell-fr-$(version)
doc_dir_name        = aspell6-fr-$(version)
src_done            = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target        = $(TARGET_BUILD_DIR)/.build_done
install_target      = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = dict

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
ASPELL6_PKG_NAME                = aspell6-fr
ASPELL6_PKG_VERSION             = 0.50-3
ASPELL6_PKG_ARCH                = $(TOOLCHAIN)
ASPELL6_PKG_DISTRO_NAME         = $(DISTRO_NAME)
ASPELL6_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
ASPELL6_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
ASPELL6_PKG_SHORT_DESCRIPTION   = French dictionary
ASPELL6_PKG_URL                 = $(BUG_URL)
ASPELL6_PKG_LICENSE             = GPLv2
ASPELL6_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(ASPELL6_PKG_NAME)-pkg-description
ASPELL6_PKG_DESCRIPTION_FILE_IN = $(ASPELL6_PKG_NAME)-pkg-description.in
ASPELL6_PKG_INSTALL_SCRIPT      = $(ASPELL6_PKG_NAME)-pkg-install.sh

ASPELL6_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(ASPELL6_PKG_NAME)-package

pkg_basename     = $(ASPELL6_PKG_NAME)-$(ASPELL6_PKG_VERSION)-$(ASPELL6_PKG_ARCH)-$(ASPELL6_PKG_DISTRO_NAME)-$(ASPELL6_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../build-system/core.mk


env_sysroot = DESTDIR=$(ASPELL6_PKG)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@( cd $(SRC_DIR) ; \
	   set -e ; \
	   ./configure ; \
	   sed -i '/^datadir .*=/c datadir = /usr/lib$(LIBSUFFIX)/aspell-$(aspell_base_version)' Makefile ; \
	   sed -i '/^dictdir .*=/c dictdir = /usr/lib$(LIBSUFFIX)/aspell-$(aspell_base_version)' Makefile ; \
	   make ; \
	 )
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(ASPELL6_PKG)
	@cd $(SRC_DIR) && $(MAKE) install $(env_sysroot)
	# ======= Aspell Dictionaries Documentation =======
	@mkdir -p $(ASPELL6_PKG)/usr/doc/dict/$(doc_dir_name)
	@cp -a $(SRC_DIR)/COPYING $(ASPELL6_PKG)/usr/doc/dict/$(doc_dir_name)
	@mkdir -p $(ASPELL6_PKG)/usr/share/doc/dict/$(doc_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING README doc/CHANGE doc/LISEZMOI \
	         $(ASPELL6_PKG)/usr/share/doc/dict/$(doc_dir_name) ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(ASPELL6_PKG) && cp -rf * $(TARGET_DEST_DIR)
	@touch $@

$(ASPELL6_PKG_DESCRIPTION_FILE): $(ASPELL6_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g"           | \
	          $(SED) -e "s/@ABASE@/$(aspell_base_version)/g" | \
	          $(SED) -e "s/@LANGUAGE@/$(language)/g"           > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(ASPELL6_PKG_DESCRIPTION_FILE) $(ASPELL6_PKG_INSTALL_SCRIPT)
	@cp $(ASPELL6_PKG_DESCRIPTION_FILE) $(ASPELL6_PKG)/.DESCRIPTION
	@cp $(ASPELL6_PKG_INSTALL_SCRIPT) $(ASPELL6_PKG)/.INSTALL
	@chmod a+x $(ASPELL6_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(ASPELL6_PKG)/.REQUIRES
	@echo "pkgname=$(ASPELL6_PKG_NAME)"                            >  $(ASPELL6_PKG)/.PKGINFO ; \
	 echo "pkgver=$(ASPELL6_PKG_VERSION)"                          >> $(ASPELL6_PKG)/.PKGINFO ; \
	 echo "arch=$(ASPELL6_PKG_ARCH)"                               >> $(ASPELL6_PKG)/.PKGINFO ; \
	 echo "distroname=$(ASPELL6_PKG_DISTRO_NAME)"                  >> $(ASPELL6_PKG)/.PKGINFO ; \
	 echo "distrover=$(ASPELL6_PKG_DISTRO_VERSION)"                >> $(ASPELL6_PKG)/.PKGINFO ; \
	 echo "group=$(ASPELL6_PKG_GROUP)"                             >> $(ASPELL6_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(ASPELL6_PKG_SHORT_DESCRIPTION)\"" >> $(ASPELL6_PKG)/.PKGINFO ; \
	 echo "url=$(ASPELL6_PKG_URL)"                                 >> $(ASPELL6_PKG)/.PKGINFO ; \
	 echo "license=$(ASPELL6_PKG_LICENSE)"                         >> $(ASPELL6_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(ASPELL6_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
