
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


include ../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/d/python-modules/setuptools

REQUIRES           = dev/python2/2.7.11

# ======= __END_OF_REQUIRES__ =======

PYTHON_VERSION = 2.7


version            = 20.10.1
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/d/python-modules/setuptools/setuptools-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/setuptools-$(version)
src_dir_name       = setuptools-$(version)
doc_dir_name       = setuptools2-$(version)
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
SETUPTOOLS2_PKG_NAME                = setuptools2
SETUPTOOLS2_PKG_VERSION             = 20.10.1
SETUPTOOLS2_PKG_ARCH                = $(TOOLCHAIN)
SETUPTOOLS2_PKG_DISTRO_NAME         = $(DISTRO_NAME)
SETUPTOOLS2_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
SETUPTOOLS2_PKG_GROUP               = $(PKG_GROUP)
###                                  |---handy-ruler-------------------------------|
SETUPTOOLS2_PKG_SHORT_DESCRIPTION   = Easily Python packages tool
SETUPTOOLS2_PKG_URL                 = $(BUG_URL)
SETUPTOOLS2_PKG_LICENSE             = MIT
SETUPTOOLS2_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(SETUPTOOLS2_PKG_NAME)-pkg-description
SETUPTOOLS2_PKG_DESCRIPTION_FILE_IN = $(SETUPTOOLS2_PKG_NAME)-pkg-description.in
SETUPTOOLS2_PKG_INSTALL_SCRIPT      = $(SETUPTOOLS2_PKG_NAME)-pkg-install.sh

SETUPTOOLS2_PKG  = $(CURDIR)/$(TARGET_BUILD_DIR)/$(SETUPTOOLS2_PKG_NAME)-package

pkg_basename     = $(SETUPTOOLS2_PKG_NAME)-$(SETUPTOOLS2_PKG_VERSION)-$(SETUPTOOLS2_PKG_ARCH)-$(SETUPTOOLS2_PKG_DISTRO_NAME)-$(SETUPTOOLS2_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_certificate  = $(call cert-name,$(pkg_archive))
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
	   python2 setup.py build ; \
	 )
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(SETUPTOOLS2_PKG)
	@( cd $(SRC_DIR) ; \
	   python2 setup.py install \
	     --prefix=/usr \
	     --install-lib=/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/site-packages \
	     --root=$(SETUPTOOLS2_PKG) ; \
	 )
	@( cd $(SETUPTOOLS2_PKG)/usr/bin ; \
	   rm -f easy_install ; ln -sf easy_install-2.7 easy_install ; \
	 )
	# ======= Install Documentation =======
	@mkdir -p $(SETUPTOOLS2_PKG)/usr/doc/$(doc_dir_name)
	@cp -a $(license) \
	       $(SETUPTOOLS2_PKG)/usr/doc/$(doc_dir_name)
	@mkdir -p $(SETUPTOOLS2_PKG)/usr/share/doc/$(doc_dir_name)
	@( cd $(SRC_DIR) ; \
	   chmod a-x README.rst ; \
	   cp -a $(license) README.rst docs/*.txt \
	         $(SETUPTOOLS2_PKG)/usr/share/doc/$(doc_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r CHANGES.rst ]; then \
	     DOCSDIR=`echo $(SETUPTOOLS2_PKG)/usr/share/doc/$(doc_dir_name)` ; \
	     cat CHANGES.rst | head -n 1000 > $$DOCSDIR/CHANGES.rst ; \
	     touch -r CHANGES.rst $$DOCSDIR/CHANGES.rst ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(SETUPTOOLS2_PKG))
	@touch $@

$(SETUPTOOLS2_PKG_DESCRIPTION_FILE): $(SETUPTOOLS2_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(SETUPTOOLS2_PKG_DESCRIPTION_FILE) $(SETUPTOOLS2_PKG_INSTALL_SCRIPT)
	@cp $(SETUPTOOLS2_PKG_DESCRIPTION_FILE) $(SETUPTOOLS2_PKG)/.DESCRIPTION
	@cp $(SETUPTOOLS2_PKG_INSTALL_SCRIPT) $(SETUPTOOLS2_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(SETUPTOOLS2_PKG)/.REQUIRES
	@echo "pkgname=$(SETUPTOOLS2_PKG_NAME)"                            >  $(SETUPTOOLS2_PKG)/.PKGINFO ; \
	 echo "pkgver=$(SETUPTOOLS2_PKG_VERSION)"                          >> $(SETUPTOOLS2_PKG)/.PKGINFO ; \
	 echo "arch=$(SETUPTOOLS2_PKG_ARCH)"                               >> $(SETUPTOOLS2_PKG)/.PKGINFO ; \
	 echo "distroname=$(SETUPTOOLS2_PKG_DISTRO_NAME)"                  >> $(SETUPTOOLS2_PKG)/.PKGINFO ; \
	 echo "distrover=$(SETUPTOOLS2_PKG_DISTRO_VERSION)"                >> $(SETUPTOOLS2_PKG)/.PKGINFO ; \
	 echo "group=$(SETUPTOOLS2_PKG_GROUP)"                             >> $(SETUPTOOLS2_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(SETUPTOOLS2_PKG_SHORT_DESCRIPTION)\"" >> $(SETUPTOOLS2_PKG)/.PKGINFO ; \
	 echo "url=$(SETUPTOOLS2_PKG_URL)"                                 >> $(SETUPTOOLS2_PKG)/.PKGINFO ; \
	 echo "license=$(SETUPTOOLS2_PKG_LICENSE)"                         >> $(SETUPTOOLS2_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(SETUPTOOLS2_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
