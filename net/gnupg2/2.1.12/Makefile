
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


SOURCE_REQUIRES    = sources/packages/n/gnupg2

REQUIRES           = app/bzip2/1.0.6
REQUIRES          += net/dirmngr/1.1.1
REQUIRES          += net/pinentry/0.9.7
ifeq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC)),)
REQUIRES          += net/curl/7.47.0
REQUIRES          += net/libgcrypt/1.7.0
REQUIRES          += libs/npth/1.2
REQUIRES          += libs/libusb-compat/0.1.5
else
REQUIRES          += net/curl/7.47.0-x86_32
REQUIRES          += net/libgcrypt/1.7.0-x86_32
REQUIRES          += libs/npth/1.2-x86_32
REQUIRES          += libs/libusb-compat/0.1.5-x86_32
endif

# ======= __END_OF_REQUIRES__ =======


version            = 2.1.12
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/n/gnupg2/gnupg-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/gnupg-$(version)
src_dir_name       = gnupg-$(version)
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
GNUPG_PKG_NAME                = gnupg2
GNUPG_PKG_VERSION             = 2.1.12
GNUPG_PKG_ARCH                = $(TOOLCHAIN)
GNUPG_PKG_DISTRO_NAME         = $(DISTRO_NAME)
GNUPG_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
GNUPG_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
GNUPG_PKG_SHORT_DESCRIPTION   = The GNU Privacy Guard version 2.x
GNUPG_PKG_URL                 = $(BUG_URL)
GNUPG_PKG_LICENSE             = GPLv3
GNUPG_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GNUPG_PKG_NAME)-pkg-description
GNUPG_PKG_DESCRIPTION_FILE_IN = $(GNUPG_PKG_NAME)-pkg-description.in
GNUPG_PKG_INSTALL_SCRIPT      = $(GNUPG_PKG_NAME)-pkg-install.sh

GNUPG_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GNUPG_PKG_NAME)-package

pkg_basename     = $(GNUPG_PKG_NAME)-$(GNUPG_PKG_VERSION)-$(GNUPG_PKG_ARCH)-$(GNUPG_PKG_DISTRO_NAME)-$(GNUPG_PKG_DISTRO_VERSION)

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


env_sysroot  = DESTDIR=$(GNUPG_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --program-prefix=""
extra_configure_switches += --program-suffix=""

extra_configure_switches += --disable-dirmngr

extra_configure_switches += --with-libgcrypt-prefix=$(TARGET_DEST_DIR)/usr
extra_configure_switches += --with-libassuan-prefix=$(TARGET_DEST_DIR)/usr

extra_configure_switches += --cache-file=hw.cache


libs_config  = GPG_ERROR_CONFIG=$(TARGET_DEST_DIR)/usr/bin/gpg-error-config
libs_config += NPTH_CONFIG=$(TARGET_DEST_DIR)/usr/bin/npth-config


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@( cd $(build_dir) ; \
	   echo "gnupg_cv_c_endian=little"   > hw.cache ; \
	   echo "ac_cv_func_fork_works=yes" >> hw.cache ; \
	   echo "gnupg_cv_have_regex=yes"   >> hw.cache ; \
	 )
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(libs_config) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(GNUPG_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Create directory for global gpg.conf =======
	@mkdir -p $(GNUPG_PKG)/etc/gnupg
	# ======= Remove dirmngr-client manual page=======
	@rm -f $(GNUPG_PKG)/usr/share/man/man1/dirmngr-client.1
	# ======= Install Documentation =======
	@cd $(build_dir)/doc && $(BUILD_ENVIRONMENT) $(MAKE) gnupg.html
	@rm -f $(GNUPG_PKG)/usr/share/info/dir
	@gzip -9 $(GNUPG_PKG)/usr/share/info/*
	@if [ -d $(GNUPG_PKG)/usr/share/man ]; then \
	  ( cd $(GNUPG_PKG)/usr/share/man ; \
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
	@mkdir -p $(GNUPG_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING* \
	       $(GNUPG_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(GNUPG_PKG)/usr/share/doc/$(src_dir_name)/html
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING* INSTALL NEWS README.GIT THANKS TODO VERSION \
	         $(GNUPG_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(build_dir)/doc/gnupg.html ; \
	   cp -a *.html $(GNUPG_PKG)/usr/share/doc/$(src_dir_name)/html ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(GNUPG_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(GNUPG_PKG))
	# ======= Strip binaries =======
	@( cd $(GNUPG_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(GNUPG_PKG_DESCRIPTION_FILE): $(GNUPG_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(GNUPG_PKG_DESCRIPTION_FILE) $(GNUPG_PKG_INSTALL_SCRIPT)
	@cp $(GNUPG_PKG_DESCRIPTION_FILE) $(GNUPG_PKG)/.DESCRIPTION
	@cp $(GNUPG_PKG_INSTALL_SCRIPT) $(GNUPG_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GNUPG_PKG)/.REQUIRES
	@echo "pkgname=$(GNUPG_PKG_NAME)"                            >  $(GNUPG_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GNUPG_PKG_VERSION)"                          >> $(GNUPG_PKG)/.PKGINFO ; \
	 echo "arch=$(GNUPG_PKG_ARCH)"                               >> $(GNUPG_PKG)/.PKGINFO ; \
	 echo "distroname=$(GNUPG_PKG_DISTRO_NAME)"                  >> $(GNUPG_PKG)/.PKGINFO ; \
	 echo "distrover=$(GNUPG_PKG_DISTRO_VERSION)"                >> $(GNUPG_PKG)/.PKGINFO ; \
	 echo "group=$(GNUPG_PKG_GROUP)"                             >> $(GNUPG_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GNUPG_PKG_SHORT_DESCRIPTION)\"" >> $(GNUPG_PKG)/.PKGINFO ; \
	 echo "url=$(GNUPG_PKG_URL)"                                 >> $(GNUPG_PKG)/.PKGINFO ; \
	 echo "license=$(GNUPG_PKG_LICENSE)"                         >> $(GNUPG_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(GNUPG_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
