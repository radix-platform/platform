
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/pyrex

REQUIRES           = libs/pyrex/0.9.9
REQUIRES          += dev/python2/2.7.6-x86_32

# ======= __END_OF_REQUIRES__ =======

PYTHON_VERSION = 2.7


version            = 0.9.9
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/pyrex/Pyrex-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/Pyrex-$(version)
src_dir_name       = Pyrex-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
PYREX_32_PKG_NAME                = pyrex-x32
PYREX_32_PKG_VERSION             = 0.9.90
PYREX_32_PKG_ARCH                = $(TOOLCHAIN)
PYREX_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
PYREX_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
PYREX_32_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
PYREX_32_PKG_SHORT_DESCRIPTION   = A Python extension modules language
PYREX_32_PKG_URL                 = $(BUG_URL)
PYREX_32_PKG_LICENSE             = Apache
PYREX_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(PYREX_32_PKG_NAME)-pkg-description
PYREX_32_PKG_DESCRIPTION_FILE_IN = $(PYREX_32_PKG_NAME)-pkg-description.in
PYREX_32_PKG_INSTALL_SCRIPT      = $(PYREX_32_PKG_NAME)-pkg-install.sh

PYREX_32_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(PYREX_32_PKG_NAME)-package

pkg_basename     = $(PYREX_32_PKG_NAME)-$(PYREX_32_PKG_VERSION)-$(PYREX_32_PKG_ARCH)-$(PYREX_32_PKG_DISTRO_NAME)-$(PYREX_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


PYTHON_SITE_PACKAGES = /usr/lib$(MULTILIB_X86_32_SUFFIX)/python$(PYTHON_VERSION)/site-packages


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@( cd $(SRC_DIR) ; \
	   sed -i "s,get_python_lib(prefix=''),'$(PYTHON_SITE_PACKAGES)'," setup.py ; \
	 )
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(PYREX_32_PKG)
	@( cd $(SRC_DIR) ; \
	   python setup.py install --root=$(PYREX_32_PKG) --install-scripts=/usr/bin/32 --install-lib=$(PYTHON_SITE_PACKAGES) ; \
	 )
	@( cd $(PYREX_32_PKG)/usr/bin/32 ; \
	   sed -i "s,usr/bin/python,usr/bin/32/python," pyrexc ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(PYREX_32_PKG))
	@touch $@

$(PYREX_32_PKG_DESCRIPTION_FILE): $(PYREX_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(PYREX_32_PKG_DESCRIPTION_FILE) $(PYREX_32_PKG_INSTALL_SCRIPT)
	@cp $(PYREX_32_PKG_DESCRIPTION_FILE) $(PYREX_32_PKG)/.DESCRIPTION
	@cp $(PYREX_32_PKG_INSTALL_SCRIPT) $(PYREX_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(PYREX_32_PKG)/.REQUIRES
	@echo "pkgname=$(PYREX_32_PKG_NAME)"                            >  $(PYREX_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(PYREX_32_PKG_VERSION)"                          >> $(PYREX_32_PKG)/.PKGINFO ; \
	 echo "arch=$(PYREX_32_PKG_ARCH)"                               >> $(PYREX_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(PYREX_32_PKG_DISTRO_NAME)"                  >> $(PYREX_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(PYREX_32_PKG_DISTRO_VERSION)"                >> $(PYREX_32_PKG)/.PKGINFO ; \
	 echo "group=$(PYREX_32_PKG_GROUP)"                             >> $(PYREX_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(PYREX_32_PKG_SHORT_DESCRIPTION)\"" >> $(PYREX_32_PKG)/.PKGINFO ; \
	 echo "url=$(PYREX_32_PKG_URL)"                                 >> $(PYREX_32_PKG)/.PKGINFO ; \
	 echo "license=$(PYREX_32_PKG_LICENSE)"                         >> $(PYREX_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(PYREX_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
