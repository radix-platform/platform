
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXV)
COMPONENT_TARGETS += $(HARDWARE_P201)
COMPONENT_TARGETS += $(HARDWARE_NEXBOX_A95X)
COMPONENT_TARGETS += $(HARDWARE_P212)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_VIM)
COMPONENT_TARGETS += $(HARDWARE_Q201)
COMPONENT_TARGETS += $(HARDWARE_ENYBOX_X2)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/d/python-modules/pip

REQUIRES           = dev/python-modules/setuptools3/20.10.1

# ======= __END_OF_REQUIRES__ =======

PYTHON_VERSION = 3.5


version            = 8.1.1
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/d/python-modules/pip/pip-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/pip-$(version)
src_dir_name       = pip-$(version)
doc_dir_name       = pip3-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
PIP3_PKG_NAME                = pip3
PIP3_PKG_VERSION             = 8.1.1
PIP3_PKG_ARCH                = $(TOOLCHAIN)
PIP3_PKG_DISTRO_NAME         = $(DISTRO_NAME)
PIP3_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
PIP3_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
PIP3_PKG_SHORT_DESCRIPTION   = Python packages tool
PIP3_PKG_URL                 = $(BUG_URL)
PIP3_PKG_LICENSE             = MIT
PIP3_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(PIP3_PKG_NAME)-pkg-description
PIP3_PKG_DESCRIPTION_FILE_IN = $(PIP3_PKG_NAME)-pkg-description.in
PIP3_PKG_INSTALL_SCRIPT      = $(PIP3_PKG_NAME)-pkg-install.sh

PIP3_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(PIP3_PKG_NAME)-package

pkg_basename     = $(PIP3_PKG_NAME)-$(PIP3_PKG_VERSION)-$(PIP3_PKG_ARCH)-$(PIP3_PKG_DISTRO_NAME)-$(PIP3_PKG_DISTRO_VERSION)

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
	   $(PYTHON3) setup.py build ; \
	 )
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(PIP3_PKG)
	@( cd $(SRC_DIR) ; \
	   $(PYTHON3) setup.py install \
	     --prefix=/usr \
	     --install-lib=/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/site-packages \
	     --root=$(PIP3_PKG)/ ; \
	 )
	@( cd $(PIP3_PKG)/usr/bin ; \
	   rm -f pip ; \
	   sed -i "s,$(BUILDSYSTEM),,g" pip3 pip3.5 ; \
	 )
	# ======= Install Documentation =======
	@mkdir -p $(PIP3_PKG)/usr/doc/$(doc_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS.txt $(SRC_DIR)/LICENSE.txt \
	       $(PIP3_PKG)/usr/doc/$(doc_dir_name)
	@mkdir -p $(PIP3_PKG)/usr/share/doc/$(doc_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS.txt LICENSE.txt \
	         $(PIP3_PKG)/usr/share/doc/$(doc_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r CHANGES.txt ]; then \
	     DOCSDIR=`echo $(PIP3_PKG)/usr/share/doc/$(doc_dir_name)` ; \
	     cat CHANGES.txt | head -n 1000 > $$DOCSDIR/CHANGES.txt ; \
	     touch -r CHANGES.txt $$DOCSDIR/CHANGES.txt ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(PIP3_PKG))
	@touch $@

$(PIP3_PKG_DESCRIPTION_FILE): $(PIP3_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(PIP3_PKG_DESCRIPTION_FILE) $(PIP3_PKG_INSTALL_SCRIPT)
	@cp $(PIP3_PKG_DESCRIPTION_FILE) $(PIP3_PKG)/.DESCRIPTION
	@cp $(PIP3_PKG_INSTALL_SCRIPT) $(PIP3_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(PIP3_PKG)/.REQUIRES
	@echo "pkgname=$(PIP3_PKG_NAME)"                            >  $(PIP3_PKG)/.PKGINFO ; \
	 echo "pkgver=$(PIP3_PKG_VERSION)"                          >> $(PIP3_PKG)/.PKGINFO ; \
	 echo "arch=$(PIP3_PKG_ARCH)"                               >> $(PIP3_PKG)/.PKGINFO ; \
	 echo "distroname=$(PIP3_PKG_DISTRO_NAME)"                  >> $(PIP3_PKG)/.PKGINFO ; \
	 echo "distrover=$(PIP3_PKG_DISTRO_VERSION)"                >> $(PIP3_PKG)/.PKGINFO ; \
	 echo "group=$(PIP3_PKG_GROUP)"                             >> $(PIP3_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(PIP3_PKG_SHORT_DESCRIPTION)\"" >> $(PIP3_PKG)/.PKGINFO ; \
	 echo "url=$(PIP3_PKG_URL)"                                 >> $(PIP3_PKG)/.PKGINFO ; \
	 echo "license=$(PIP3_PKG_LICENSE)"                         >> $(PIP3_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(PIP3_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
