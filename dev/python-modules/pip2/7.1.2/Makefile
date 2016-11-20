
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXV)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/d/python-modules/pip

REQUIRES           = dev/python2/2.7.11

# ======= __END_OF_REQUIRES__ =======

PYTHON_VERSION = 2.7


version            = 7.1.2
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/d/python-modules/pip/pip-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/pip-$(version)
src_dir_name       = pip-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
PIP2_PKG_NAME                = pip2
PIP2_PKG_VERSION             = 7.1.2
PIP2_PKG_ARCH                = $(TOOLCHAIN)
PIP2_PKG_DISTRO_NAME         = $(DISTRO_NAME)
PIP2_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
PIP2_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
PIP2_PKG_SHORT_DESCRIPTION   = Python packages tool
PIP2_PKG_URL                 = $(BUG_URL)
PIP2_PKG_LICENSE             = custom
PIP2_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(PIP2_PKG_NAME)-pkg-description
PIP2_PKG_DESCRIPTION_FILE_IN = $(PIP2_PKG_NAME)-pkg-description.in
PIP2_PKG_INSTALL_SCRIPT      = $(PIP2_PKG_NAME)-pkg-install.sh

PIP2_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(PIP2_PKG_NAME)-package

pkg_basename     = $(PIP2_PKG_NAME)-$(PIP2_PKG_VERSION)-$(PIP2_PKG_ARCH)-$(PIP2_PKG_DISTRO_NAME)-$(PIP2_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../build-system/core.mk



####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@( cd $(SRC_DIR) ; \
	   python2 setup.py build ; \
	 )
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(PIP2_PKG)
	@( cd $(SRC_DIR) ; \
	   python2 setup.py install \
	     --install-lib=/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/site-packages \
	     --root=$(PIP2_PKG) ; \
	 )
	@( cd $(PIP2_PKG)/usr/bin ; \
	   rm -f pip ; ln -sf pip2 pip ; \
	 )
	# ======= Install Documentation =======
	@mkdir -p $(PIP2_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS.txt $(SRC_DIR)/LICENSE.txt \
	       $(PIP2_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(PIP2_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS.txt LICENSE.txt \
	         $(PIP2_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r CHANGES.txt ]; then \
	     DOCSDIR=`echo $(PIP2_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat CHANGES.txt | head -n 1000 > $$DOCSDIR/CHANGES.txt ; \
	     touch -r CHANGES.txt $$DOCSDIR/CHANGES.txt ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(PIP2_PKG))
	@touch $@

$(PIP2_PKG_DESCRIPTION_FILE): $(PIP2_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(PIP2_PKG_DESCRIPTION_FILE) $(PIP2_PKG_INSTALL_SCRIPT)
	@cp $(PIP2_PKG_DESCRIPTION_FILE) $(PIP2_PKG)/.DESCRIPTION
	@cp $(PIP2_PKG_INSTALL_SCRIPT) $(PIP2_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(PIP2_PKG)/.REQUIRES
	@echo "pkgname=$(PIP2_PKG_NAME)"                            >  $(PIP2_PKG)/.PKGINFO ; \
	 echo "pkgver=$(PIP2_PKG_VERSION)"                          >> $(PIP2_PKG)/.PKGINFO ; \
	 echo "arch=$(PIP2_PKG_ARCH)"                               >> $(PIP2_PKG)/.PKGINFO ; \
	 echo "distroname=$(PIP2_PKG_DISTRO_NAME)"                  >> $(PIP2_PKG)/.PKGINFO ; \
	 echo "distrover=$(PIP2_PKG_DISTRO_VERSION)"                >> $(PIP2_PKG)/.PKGINFO ; \
	 echo "group=$(PIP2_PKG_GROUP)"                             >> $(PIP2_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(PIP2_PKG_SHORT_DESCRIPTION)\"" >> $(PIP2_PKG)/.PKGINFO ; \
	 echo "url=$(PIP2_PKG_URL)"                                 >> $(PIP2_PKG)/.PKGINFO ; \
	 echo "license=$(PIP2_PKG_LICENSE)"                         >> $(PIP2_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(PIP2_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
