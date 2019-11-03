
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


SOURCE_REQUIRES    = sources/packages/a/pkgtools

REQUIRES           = app/dialog/1.3-20190808
REQUIRES          += app/coreutils/8.31
REQUIRES          += app/findutils/4.7.0
REQUIRES          += app/grep/3.3
REQUIRES          += app/sed/4.7
REQUIRES          += app/tar/1.32
REQUIRES          += app/xz/5.2.4
REQUIRES          += app/gzip/1.10
REQUIRES          += app/bzip2/1.0.6
REQUIRES          += net/gnupg2/2.2.17

# ======= __END_OF_REQUIRES__ =======


version            = 0.1.3
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/a/pkgtools/pkgtools-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/pkgtools-$(version)
src_dir_name       = pkgtools-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/built
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
PKGTOOLS_PKG_NAME                = pkgtools
PKGTOOLS_PKG_VERSION             = 0.1.3
PKGTOOLS_PKG_ARCH                = $(TOOLCHAIN)
PKGTOOLS_PKG_DISTRO_NAME         = $(DISTRO_NAME)
PKGTOOLS_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
PKGTOOLS_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
PKGTOOLS_PKG_SHORT_DESCRIPTION   = Package Tools
PKGTOOLS_PKG_URL                 = $(BUG_URL)
PKGTOOLS_PKG_LICENSE             = Radix.pro
PKGTOOLS_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(PKGTOOLS_PKG_NAME)-pkg-description
PKGTOOLS_PKG_DESCRIPTION_FILE_IN = $(PKGTOOLS_PKG_NAME)-pkg-description.in
PKGTOOLS_PKG_INSTALL_SCRIPT      = $(PKGTOOLS_PKG_NAME)-pkg-install.sh

PKGTOOLS_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(PKGTOOLS_PKG_NAME)-package

pkg_basename     = $(PKGTOOLS_PKG_NAME)-$(PKGTOOLS_PKG_VERSION)-$(PKGTOOLS_PKG_ARCH)-$(PKGTOOLS_PKG_DISTRO_NAME)-$(PKGTOOLS_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(PKGTOOLS_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man

extra_configure_switches += --sbindir=/sbin
extra_configure_switches += --with-dialog=$(TARGET_DEST_DIR)/usr
extra_configure_switches += --with-dialog-test=yes
extra_configure_switches += --with-gpg2=yes
extra_configure_switches += --with-distro-name=$(DISTRO_NAME)
extra_configure_switches += --with-distro-version=$(DISTRO_VERSION)


LDFLAGS=-Wl,-rpath,/lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && ./bootstrap --target-dest-dir=$(TARGET_DEST_DIR)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr \
	  --build=$(BUILD) \
	  --host=$(TARGET)  \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) all
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(PKGTOOLS_PKG)
	@echo -e "\n======= Installing PKGTOOLS binaries =======\n"
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(PKGTOOLS_PKG)/usr/share/man ]; then \
	  ( cd $(PKGTOOLS_PKG)/usr/share/man ; \
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
	@mkdir -p $(PKGTOOLS_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/LICENSE \
	       $(PKGTOOLS_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(PKGTOOLS_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a LICENSE README* doc/autogen-examples doc/dialog \
	         $(PKGTOOLS_PKG)/usr/share/doc/$(src_dir_name) ; \
	   chmod 644 $(PKGTOOLS_PKG)/usr/share/doc/$(src_dir_name)/autogen-examples/* ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(PKGTOOLS_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(PKGTOOLS_PKG))
	# ======= Strip Binaries =======
	@( cd $(PKGTOOLS_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(PKGTOOLS_PKG_DESCRIPTION_FILE): $(PKGTOOLS_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(PKGTOOLS_PKG_DESCRIPTION_FILE) $(PKGTOOLS_PKG_INSTALL_SCRIPT)
	@cp $(PKGTOOLS_PKG_DESCRIPTION_FILE) $(PKGTOOLS_PKG)/.DESCRIPTION
	@cp $(PKGTOOLS_PKG_INSTALL_SCRIPT) $(PKGTOOLS_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(PKGTOOLS_PKG)/.REQUIRES
	@echo "pkgname=$(PKGTOOLS_PKG_NAME)"                            >  $(PKGTOOLS_PKG)/.PKGINFO ; \
	 echo "pkgver=$(PKGTOOLS_PKG_VERSION)"                          >> $(PKGTOOLS_PKG)/.PKGINFO ; \
	 echo "arch=$(PKGTOOLS_PKG_ARCH)"                               >> $(PKGTOOLS_PKG)/.PKGINFO ; \
	 echo "distroname=$(PKGTOOLS_PKG_DISTRO_NAME)"                  >> $(PKGTOOLS_PKG)/.PKGINFO ; \
	 echo "distrover=$(PKGTOOLS_PKG_DISTRO_VERSION)"                >> $(PKGTOOLS_PKG)/.PKGINFO ; \
	 echo "group=$(PKGTOOLS_PKG_GROUP)"                             >> $(PKGTOOLS_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(PKGTOOLS_PKG_SHORT_DESCRIPTION)\"" >> $(PKGTOOLS_PKG)/.PKGINFO ; \
	 echo "url=$(PKGTOOLS_PKG_URL)"                                 >> $(PKGTOOLS_PKG)/.PKGINFO ; \
	 echo "license=$(PKGTOOLS_PKG_LICENSE)"                         >> $(PKGTOOLS_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(PKGTOOLS_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
