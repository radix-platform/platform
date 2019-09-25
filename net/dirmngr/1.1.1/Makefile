
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


SOURCE_REQUIRES    = sources/packages/n/dirmngr

ifeq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC)),)
REQUIRES           = net/libgcrypt/1.7.0
REQUIRES          += net/openldap-client/2.4.43
else
REQUIRES           = net/libgcrypt/1.7.0-x86_32
REQUIRES          += net/openldap-client/2.4.43-x86_32
endif

# ======= __END_OF_REQUIRES__ =======


version            = 1.1.1
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/n/dirmngr/dirmngr-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/dirmngr-$(version)
src_dir_name       = dirmngr-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
DIRMNGR_PKG_NAME                = dirmngr
DIRMNGR_PKG_VERSION             = 1.1.1
DIRMNGR_PKG_ARCH                = $(TOOLCHAIN)
DIRMNGR_PKG_DISTRO_NAME         = $(DISTRO_NAME)
DIRMNGR_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
DIRMNGR_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
DIRMNGR_PKG_SHORT_DESCRIPTION   = Certificate Revocation Lists Manager
DIRMNGR_PKG_URL                 = $(BUG_URL)
DIRMNGR_PKG_LICENSE             = GPLv3
DIRMNGR_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(DIRMNGR_PKG_NAME)-pkg-description
DIRMNGR_PKG_DESCRIPTION_FILE_IN = $(DIRMNGR_PKG_NAME)-pkg-description.in
DIRMNGR_PKG_INSTALL_SCRIPT      = $(DIRMNGR_PKG_NAME)-pkg-install.sh

DIRMNGR_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(DIRMNGR_PKG_NAME)-package

pkg_basename     = $(DIRMNGR_PKG_NAME)-$(DIRMNGR_PKG_VERSION)-$(DIRMNGR_PKG_ARCH)-$(DIRMNGR_PKG_DISTRO_NAME)-$(DIRMNGR_PKG_DISTRO_VERSION)

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


env_sysroot  = DESTDIR=$(DIRMNGR_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var


libs_config  = GPG_ERROR_CONFIG=$(TARGET_DEST_DIR)/usr/bin/gpg-error-config
libs_config += PTH_CONFIG=$(TARGET_DEST_DIR)/usr/bin/pth-config


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(libs_config) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(DIRMNGR_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@rm -f $(DIRMNGR_PKG)/usr/share/info/dir
	@gzip -9 $(DIRMNGR_PKG)/usr/share/info/*
	@if [ -d $(DIRMNGR_PKG)/usr/share/man ]; then \
	  ( cd $(DIRMNGR_PKG)/usr/share/man ; \
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
	@mkdir -p $(DIRMNGR_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(DIRMNGR_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(DIRMNGR_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING INSTALL NEWS README THANKS TODO VERSION \
	         $(DIRMNGR_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(DIRMNGR_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(DIRMNGR_PKG))
	# ======= Strip binaries =======
	@( cd $(DIRMNGR_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(DIRMNGR_PKG_DESCRIPTION_FILE): $(DIRMNGR_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(DIRMNGR_PKG_DESCRIPTION_FILE) $(DIRMNGR_PKG_INSTALL_SCRIPT)
	@cp $(DIRMNGR_PKG_DESCRIPTION_FILE) $(DIRMNGR_PKG)/.DESCRIPTION
	@cp $(DIRMNGR_PKG_INSTALL_SCRIPT) $(DIRMNGR_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(DIRMNGR_PKG)/.REQUIRES
	@echo "pkgname=$(DIRMNGR_PKG_NAME)"                            >  $(DIRMNGR_PKG)/.PKGINFO ; \
	 echo "pkgver=$(DIRMNGR_PKG_VERSION)"                          >> $(DIRMNGR_PKG)/.PKGINFO ; \
	 echo "arch=$(DIRMNGR_PKG_ARCH)"                               >> $(DIRMNGR_PKG)/.PKGINFO ; \
	 echo "distroname=$(DIRMNGR_PKG_DISTRO_NAME)"                  >> $(DIRMNGR_PKG)/.PKGINFO ; \
	 echo "distrover=$(DIRMNGR_PKG_DISTRO_VERSION)"                >> $(DIRMNGR_PKG)/.PKGINFO ; \
	 echo "group=$(DIRMNGR_PKG_GROUP)"                             >> $(DIRMNGR_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(DIRMNGR_PKG_SHORT_DESCRIPTION)\"" >> $(DIRMNGR_PKG)/.PKGINFO ; \
	 echo "url=$(DIRMNGR_PKG_URL)"                                 >> $(DIRMNGR_PKG)/.PKGINFO ; \
	 echo "license=$(DIRMNGR_PKG_LICENSE)"                         >> $(DIRMNGR_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(DIRMNGR_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
