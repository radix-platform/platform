
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


SOURCE_REQUIRES    = sources/packages/l/pyrex

REQUIRES           = dev/python2/2.7.11

# ======= __END_OF_REQUIRES__ =======

PYTHON_VERSION = 2.7


version            = 0.9.9
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/pyrex/Pyrex-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/Pyrex-$(version)
src_dir_name       = Pyrex-$(version)
doc_dir_name       = pyrex-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
PYREX_PKG_NAME                = pyrex
PYREX_PKG_VERSION             = 0.9.9
PYREX_PKG_ARCH                = $(TOOLCHAIN)
PYREX_PKG_DISTRO_NAME         = $(DISTRO_NAME)
PYREX_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
PYREX_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
PYREX_PKG_SHORT_DESCRIPTION   = A Python extension modules language
PYREX_PKG_URL                 = $(BUG_URL)
PYREX_PKG_LICENSE             = Apache
PYREX_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(PYREX_PKG_NAME)-pkg-description
PYREX_PKG_DESCRIPTION_FILE_IN = $(PYREX_PKG_NAME)-pkg-description.in
PYREX_PKG_INSTALL_SCRIPT      = $(PYREX_PKG_NAME)-pkg-install.sh

PYREX_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(PYREX_PKG_NAME)-package

pkg_basename     = $(PYREX_PKG_NAME)-$(PYREX_PKG_VERSION)-$(PYREX_PKG_ARCH)-$(PYREX_PKG_DISTRO_NAME)-$(PYREX_PKG_DISTRO_VERSION)

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


PYTHON_SITE_PACKAGES = /usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/site-packages


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
	@mkdir -p $(PYREX_PKG)
	@( cd $(SRC_DIR) ; \
	   python setup.py install --root=$(PYREX_PKG) --install-lib=$(PYTHON_SITE_PACKAGES) ; \
	 )
	# ======= Install Documentation =======
	@if [ -d $(PYREX_PKG)/usr/share/man ]; then \
	  ( cd $(PYREX_PKG)/usr/share/man ; \
	    for manpagedir in `find . -type d -name "man*"` ; do \
	      ( cd $$manpagedir ; \
	        for eachpage in `find . -type l -maxdepth 1` ; do \
	          ln -s `readlink $$eachpage`.gz $$eachpage.gz ; \
	          rm $$eachpage ; \
	        done ; \
	        gzip -9 *.?  ; \
	      ) \
	    done \
	  ) \
	 fi
	@mkdir -p $(PYREX_PKG)/usr/doc/$(doc_dir_name)
	@cp -a $(SRC_DIR)/LICENSE.txt \
	       $(PYREX_PKG)/usr/doc/$(doc_dir_name)
	@mkdir -p $(PYREX_PKG)/usr/share/doc/$(doc_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a INSTALL.txt LICENSE.txt README.txt ToDo.txt USAGE.txt Doc \
	         $(PYREX_PKG)/usr/share/doc/$(doc_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r CHANGES.txt ]; then \
	     DOCSDIR=`echo $(PYREX_PKG)/usr/share/doc/$(doc_dir_name)` ; \
	     cat CHANGES.txt | head -n 1000 > $$DOCSDIR/CHANGES.txt ; \
	     touch -r CHANGES.txt $$DOCSDIR/CHANGES.txt ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(PYREX_PKG))
	@touch $@

$(PYREX_PKG_DESCRIPTION_FILE): $(PYREX_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(PYREX_PKG_DESCRIPTION_FILE) $(PYREX_PKG_INSTALL_SCRIPT)
	@cp $(PYREX_PKG_DESCRIPTION_FILE) $(PYREX_PKG)/.DESCRIPTION
	@cp $(PYREX_PKG_INSTALL_SCRIPT) $(PYREX_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(PYREX_PKG)/.REQUIRES
	@echo "pkgname=$(PYREX_PKG_NAME)"                            >  $(PYREX_PKG)/.PKGINFO ; \
	 echo "pkgver=$(PYREX_PKG_VERSION)"                          >> $(PYREX_PKG)/.PKGINFO ; \
	 echo "arch=$(PYREX_PKG_ARCH)"                               >> $(PYREX_PKG)/.PKGINFO ; \
	 echo "distroname=$(PYREX_PKG_DISTRO_NAME)"                  >> $(PYREX_PKG)/.PKGINFO ; \
	 echo "distrover=$(PYREX_PKG_DISTRO_VERSION)"                >> $(PYREX_PKG)/.PKGINFO ; \
	 echo "group=$(PYREX_PKG_GROUP)"                             >> $(PYREX_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(PYREX_PKG_SHORT_DESCRIPTION)\"" >> $(PYREX_PKG)/.PKGINFO ; \
	 echo "url=$(PYREX_PKG_URL)"                                 >> $(PYREX_PKG)/.PKGINFO ; \
	 echo "license=$(PYREX_PKG_LICENSE)"                         >> $(PYREX_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(PYREX_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
