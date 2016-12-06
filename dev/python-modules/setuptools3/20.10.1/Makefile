
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


SOURCE_REQUIRES    = sources/packages/d/python-modules/setuptools

REQUIRES           = dev/python3/3.5.1

# ======= __END_OF_REQUIRES__ =======

PYTHON_VERSION = 3.5


version            = 20.10.1
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/d/python-modules/setuptools/setuptools-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/setuptools-$(version)
src_dir_name       = setuptools-$(version)
doc_dir_name       = setuptools3-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done

license            = $(CURDIR)/license/LICENSE.txt


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
SETUPTOOLS3_PKG_NAME                = setuptools3
SETUPTOOLS3_PKG_VERSION             = 20.10.1
SETUPTOOLS3_PKG_ARCH                = $(TOOLCHAIN)
SETUPTOOLS3_PKG_DISTRO_NAME         = $(DISTRO_NAME)
SETUPTOOLS3_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
SETUPTOOLS3_PKG_GROUP               = $(PKG_GROUP)
###                                  |---handy-ruler-------------------------------|
SETUPTOOLS3_PKG_SHORT_DESCRIPTION   = Easily Python packages tool
SETUPTOOLS3_PKG_URL                 = $(BUG_URL)
SETUPTOOLS3_PKG_LICENSE             = MIT
SETUPTOOLS3_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(SETUPTOOLS3_PKG_NAME)-pkg-description
SETUPTOOLS3_PKG_DESCRIPTION_FILE_IN = $(SETUPTOOLS3_PKG_NAME)-pkg-description.in
SETUPTOOLS3_PKG_INSTALL_SCRIPT      = $(SETUPTOOLS3_PKG_NAME)-pkg-install.sh

SETUPTOOLS3_PKG  = $(CURDIR)/$(TARGET_BUILD_DIR)/$(SETUPTOOLS3_PKG_NAME)-package

pkg_basename     = $(SETUPTOOLS3_PKG_NAME)-$(SETUPTOOLS3_PKG_VERSION)-$(SETUPTOOLS3_PKG_ARCH)-$(SETUPTOOLS3_PKG_DISTRO_NAME)-$(SETUPTOOLS3_PKG_DISTRO_VERSION)

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
	   sed -i "s,^\(commit =\).*,\1 False," setup.cfg ; \
	   sed -i "s,^\(tag =\).*,\1 False," setup.cfg ; \
	   sed -i "s,^\(tag_build =\).*,," setup.cfg ; \
	   sed -i "s,^\(tag_date =\).*,," setup.cfg ; \
	 )
	@( cd $(SRC_DIR) ; \
	   $(PYTHON3) setup.py build ; \
	 )
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(SETUPTOOLS3_PKG)
	@( cd $(SRC_DIR) ; \
	   $(PYTHON3) setup.py install \
	     --prefix=/usr \
	     --install-lib=/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/site-packages \
	     --root=$(SETUPTOOLS3_PKG) ; \
	 )
	@( cd $(SETUPTOOLS3_PKG)/usr/bin ; \
	   rm -f easy_install ; \
	   sed -i "s,$(BUILDSYSTEM),,g" easy_install-3.5 ; \
	 )
	# ======= Install Documentation =======
	@mkdir -p $(SETUPTOOLS3_PKG)/usr/doc/$(doc_dir_name)
	@cp -a $(license) \
	       $(SETUPTOOLS3_PKG)/usr/doc/$(doc_dir_name)
	@mkdir -p $(SETUPTOOLS3_PKG)/usr/share/doc/$(doc_dir_name)
	@( cd $(SRC_DIR) ; \
	   chmod a-x README.rst ; \
	   cp -a $(license) README.rst docs/*.txt \
	         $(SETUPTOOLS3_PKG)/usr/share/doc/$(doc_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r CHANGES.rst ]; then \
	     DOCSDIR=`echo $(SETUPTOOLS3_PKG)/usr/share/doc/$(doc_dir_name)` ; \
	     cat CHANGES.rst | head -n 1000 > $$DOCSDIR/CHANGES.rst ; \
	     touch -r CHANGES.rst $$DOCSDIR/CHANGES.rst ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(SETUPTOOLS3_PKG))
	@touch $@

$(SETUPTOOLS3_PKG_DESCRIPTION_FILE): $(SETUPTOOLS3_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(SETUPTOOLS3_PKG_DESCRIPTION_FILE) $(SETUPTOOLS3_PKG_INSTALL_SCRIPT)
	@cp $(SETUPTOOLS3_PKG_DESCRIPTION_FILE) $(SETUPTOOLS3_PKG)/.DESCRIPTION
	@cp $(SETUPTOOLS3_PKG_INSTALL_SCRIPT) $(SETUPTOOLS3_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(SETUPTOOLS3_PKG)/.REQUIRES
	@echo "pkgname=$(SETUPTOOLS3_PKG_NAME)"                            >  $(SETUPTOOLS3_PKG)/.PKGINFO ; \
	 echo "pkgver=$(SETUPTOOLS3_PKG_VERSION)"                          >> $(SETUPTOOLS3_PKG)/.PKGINFO ; \
	 echo "arch=$(SETUPTOOLS3_PKG_ARCH)"                               >> $(SETUPTOOLS3_PKG)/.PKGINFO ; \
	 echo "distroname=$(SETUPTOOLS3_PKG_DISTRO_NAME)"                  >> $(SETUPTOOLS3_PKG)/.PKGINFO ; \
	 echo "distrover=$(SETUPTOOLS3_PKG_DISTRO_VERSION)"                >> $(SETUPTOOLS3_PKG)/.PKGINFO ; \
	 echo "group=$(SETUPTOOLS3_PKG_GROUP)"                             >> $(SETUPTOOLS3_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(SETUPTOOLS3_PKG_SHORT_DESCRIPTION)\"" >> $(SETUPTOOLS3_PKG)/.PKGINFO ; \
	 echo "url=$(SETUPTOOLS3_PKG_URL)"                                 >> $(SETUPTOOLS3_PKG)/.PKGINFO ; \
	 echo "license=$(SETUPTOOLS3_PKG_LICENSE)"                         >> $(SETUPTOOLS3_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(SETUPTOOLS3_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
