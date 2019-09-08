
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_POIN2)
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
COMPONENT_TARGETS += $(HARDWARE_BT1)
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


SOURCE_REQUIRES    = sources/packages/a/foomatic-db

REQUIRES           = app/cups-filters/1.9.0
REQUIRES          += dev/perl/5.22.1
REQUIRES          += libs/libxml2/2.9.3

# ======= __END_OF_REQUIRES__ =======


version            = 20160612
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/a/foomatic-db/foomatic-db-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/foomatic-db-$(version)
src_dir_name       = foomatic-db-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done


PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
FOOMATIC_DB_PKG_NAME                = foomatic-db
FOOMATIC_DB_PKG_VERSION             = 20160612
FOOMATIC_DB_PKG_ARCH                = $(TOOLCHAIN)
FOOMATIC_DB_PKG_DISTRO_NAME         = $(DISTRO_NAME)
FOOMATIC_DB_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
FOOMATIC_DB_PKG_GROUP               = $(PKG_GROUP)
###                                  |---handy-ruler-------------------------------|
FOOMATIC_DB_PKG_SHORT_DESCRIPTION   = Foomatic Database
FOOMATIC_DB_PKG_URL                 = $(BUG_URL)
FOOMATIC_DB_PKG_LICENSE             = GPLv2
FOOMATIC_DB_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(FOOMATIC_DB_PKG_NAME)-pkg-description
FOOMATIC_DB_PKG_DESCRIPTION_FILE_IN = $(FOOMATIC_DB_PKG_NAME)-pkg-description.in
FOOMATIC_DB_PKG_INSTALL_SCRIPT      = $(FOOMATIC_DB_PKG_NAME)-pkg-install.sh

FOOMATIC_DB_PKG  = $(CURDIR)/$(TARGET_BUILD_DIR)/$(FOOMATIC_DB_PKG_NAME)-package

pkg_basename     = $(FOOMATIC_DB_PKG_NAME)-$(FOOMATIC_DB_PKG_VERSION)-$(FOOMATIC_DB_PKG_ARCH)-$(FOOMATIC_DB_PKG_DISTRO_NAME)-$(FOOMATIC_DB_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(FOOMATIC_DB_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man

extra_configure_switches += --with-drivers=NOOBSOLETES

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && \
	  $(BUILD_ENVIRONMENT) $(cups_environment) ./configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(FOOMATIC_DB_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@( cd $(FOOMATIC_DB_PKG)/usr/share/cups/model ; \
	   rm -f foomatic-db-ppds ; \
	   ln -sf ../../foomatic/db/source/PPD foomatic-db-ppds ; \
	 )
	# ======= remove unwanted file that breaks adding printers =======
	@rm -f $(FOOMATIC_DB_PKG)/usr/share/foomatic/db/source/PPD/Kyocera/ReadMe.htm
	# ======= Install Documentation =======
	@if [ -d $(FOOMATIC_DB_PKG)/usr/share/man ]; then \
	  ( cd $(FOOMATIC_DB_PKG)/usr/share/man ; \
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
	@mkdir -p $(FOOMATIC_DB_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(FOOMATIC_DB_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(FOOMATIC_DB_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING README USAGE \
	         $(FOOMATIC_DB_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog -a -s ChangeLog ]; then \
	     DOCSDIR=`echo $(FOOMATIC_DB_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(FOOMATIC_DB_PKG))
	@touch $@

$(FOOMATIC_DB_PKG_DESCRIPTION_FILE): $(FOOMATIC_DB_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(FOOMATIC_DB_PKG_DESCRIPTION_FILE) $(FOOMATIC_DB_PKG_INSTALL_SCRIPT)
	@cp $(FOOMATIC_DB_PKG_DESCRIPTION_FILE) $(FOOMATIC_DB_PKG)/.DESCRIPTION
	@cp $(FOOMATIC_DB_PKG_INSTALL_SCRIPT) $(FOOMATIC_DB_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(FOOMATIC_DB_PKG)/.REQUIRES
	@echo "pkgname=$(FOOMATIC_DB_PKG_NAME)"                            >  $(FOOMATIC_DB_PKG)/.PKGINFO ; \
	 echo "pkgver=$(FOOMATIC_DB_PKG_VERSION)"                          >> $(FOOMATIC_DB_PKG)/.PKGINFO ; \
	 echo "arch=$(FOOMATIC_DB_PKG_ARCH)"                               >> $(FOOMATIC_DB_PKG)/.PKGINFO ; \
	 echo "distroname=$(FOOMATIC_DB_PKG_DISTRO_NAME)"                  >> $(FOOMATIC_DB_PKG)/.PKGINFO ; \
	 echo "distrover=$(FOOMATIC_DB_PKG_DISTRO_VERSION)"                >> $(FOOMATIC_DB_PKG)/.PKGINFO ; \
	 echo "group=$(FOOMATIC_DB_PKG_GROUP)"                             >> $(FOOMATIC_DB_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(FOOMATIC_DB_PKG_SHORT_DESCRIPTION)\"" >> $(FOOMATIC_DB_PKG)/.PKGINFO ; \
	 echo "url=$(FOOMATIC_DB_PKG_URL)"                                 >> $(FOOMATIC_DB_PKG)/.PKGINFO ; \
	 echo "license=$(FOOMATIC_DB_PKG_LICENSE)"                         >> $(FOOMATIC_DB_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(FOOMATIC_DB_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
