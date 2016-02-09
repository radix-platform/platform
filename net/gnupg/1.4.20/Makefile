
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_DM64X)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/n/gnupg

REQUIRES           = app/bzip2/1.0.6
REQUIRES          += net/dirmngr/1.1.1
REQUIRES          += net/pinentry/0.9.7
ifeq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC)),)
REQUIRES          += net/curl/7.38.0
REQUIRES          += libs/libusb-compat/0.1.5
else
REQUIRES          += net/curl/7.38.0-x86_32
REQUIRES          += libs/libusb-compat/0.1.5-x86_32
endif

# ======= __END_OF_REQUIRES__ =======


version            = 1.4.20
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/n/gnupg/gnupg-$(version).tar.bz2
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
GNUPG_PKG_NAME                = gnupg
GNUPG_PKG_VERSION             = 1.4.20
GNUPG_PKG_ARCH                = $(TOOLCHAIN)
GNUPG_PKG_DISTRO_NAME         = $(DISTRO_NAME)
GNUPG_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
GNUPG_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
GNUPG_PKG_SHORT_DESCRIPTION   = The GNU Privacy Guard
GNUPG_PKG_URL                 = $(BUG_URL)
GNUPG_PKG_LICENSE             = GPLv3
GNUPG_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GNUPG_PKG_NAME)-pkg-description
GNUPG_PKG_DESCRIPTION_FILE_IN = $(GNUPG_PKG_NAME)-pkg-description.in
GNUPG_PKG_INSTALL_SCRIPT      = $(GNUPG_PKG_NAME)-pkg-install.sh

GNUPG_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GNUPG_PKG_NAME)-package

pkg_basename     = $(GNUPG_PKG_NAME)-$(GNUPG_PKG_VERSION)-$(GNUPG_PKG_ARCH)-$(GNUPG_PKG_DISTRO_NAME)-$(GNUPG_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
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

ifneq ($(filter $(HARDWARE),$(HARDWARE_PC32)),)
extra_configure_switches += --disable-asm
endif

extra_configure_switches += --cache-file=hw.cache


libs_config  = GPG_ERROR_CONFIG=$(TARGET_DEST_DIR)/usr/bin/gpg-error-config
libs_config += PTH_CONFIG=$(TARGET_DEST_DIR)/usr/bin/pth-config


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
	# ======= Install Documentation =======
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
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(GNUPG_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(GNUPG_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS BUGS COPYING INSTALL NEWS PROJECTS README THANKS TODO VERSION \
	         doc/DETAILS doc/HACKING doc/OpenPGP \
	         $(GNUPG_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@if [ -r $(GNUPG_PKG)/usr/share/gnupg/FAQ ]; then \
	  ( cd $(GNUPG_PKG)/usr/share/doc/$(src_dir_name) ; ln -sf ../../gnupg/FAQ . ) ; \
	 fi
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
	@$(FAKEROOT) sh -c "cd $(GNUPG_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
