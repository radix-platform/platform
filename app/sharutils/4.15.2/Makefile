
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/GNU/sharutils

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.3.0
else
REQUIRES           = libs/glibc/2.22
endif

# ======= __END_OF_REQUIRES__ =======


version            = 4.15.2
tar_xz_archive     = $(SRC_PACKAGE_PATH)/GNU/sharutils/sharutils-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/sharutils-$(version)
src_dir_name       = sharutils-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
SHARUTILS_PKG_NAME                = sharutils
SHARUTILS_PKG_VERSION             = 4.15.2
SHARUTILS_PKG_ARCH                = $(TOOLCHAIN)
SHARUTILS_PKG_DISTRO_NAME         = $(DISTRO_NAME)
SHARUTILS_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
SHARUTILS_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
SHARUTILS_PKG_SHORT_DESCRIPTION   = GNU shell archive packing utilities
SHARUTILS_PKG_URL                 = $(BUG_URL)
SHARUTILS_PKG_LICENSE             = GPLv3
SHARUTILS_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(SHARUTILS_PKG_NAME)-pkg-description
SHARUTILS_PKG_DESCRIPTION_FILE_IN = $(SHARUTILS_PKG_NAME)-pkg-description.in
SHARUTILS_PKG_INSTALL_SCRIPT      = $(SHARUTILS_PKG_NAME)-pkg-install.sh

SHARUTILS_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(SHARUTILS_PKG_NAME)-package

pkg_basename     = $(SHARUTILS_PKG_NAME)-$(SHARUTILS_PKG_VERSION)-$(SHARUTILS_PKG_ARCH)-$(SHARUTILS_PKG_DISTRO_NAME)-$(SHARUTILS_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(SHARUTILS_PKG)

extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man

extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --disable-rpath


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) $(environment) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(environment) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(SHARUTILS_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(environment) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@rm -f $(SHARUTILS_PKG)/usr/share/info/dir
	@gzip -9 $(SHARUTILS_PKG)/usr/share/info/*
	@if [ -d $(SHARUTILS_PKG)/usr/share/man ]; then \
	  ( cd $(SHARUTILS_PKG)/usr/share/man ; \
	    for manpagedir in `find . -type d -name "man*"` ; do \
	      ( cd $$manpagedir ; \
	        for eachpage in `find . -type l -maxdepth 1` ; do \
	          ln -s `readlink $$eachpage`.gz $$eachpage.gz ; \
	          rm $$eachpage ; \
	        done ; \
	        gzip -9 *.* ; \
	      ) \
	    done \
	  ) \
	 fi
	@mkdir -p $(SHARUTILS_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(SHARUTILS_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(SHARUTILS_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING INSTALL NEWS README THANKS TODO \
	         $(SHARUTILS_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(SHARUTILS_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(SHARUTILS_PKG))
	# ======= Strip binaries =======
	@( cd $(SHARUTILS_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(SHARUTILS_PKG_DESCRIPTION_FILE): $(SHARUTILS_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(SHARUTILS_PKG_DESCRIPTION_FILE) $(SHARUTILS_PKG_INSTALL_SCRIPT)
	@cp $(SHARUTILS_PKG_DESCRIPTION_FILE) $(SHARUTILS_PKG)/.DESCRIPTION
	@cp $(SHARUTILS_PKG_INSTALL_SCRIPT) $(SHARUTILS_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(SHARUTILS_PKG)/.REQUIRES
	@echo "pkgname=$(SHARUTILS_PKG_NAME)"                            >  $(SHARUTILS_PKG)/.PKGINFO ; \
	 echo "pkgver=$(SHARUTILS_PKG_VERSION)"                          >> $(SHARUTILS_PKG)/.PKGINFO ; \
	 echo "arch=$(SHARUTILS_PKG_ARCH)"                               >> $(SHARUTILS_PKG)/.PKGINFO ; \
	 echo "distroname=$(SHARUTILS_PKG_DISTRO_NAME)"                  >> $(SHARUTILS_PKG)/.PKGINFO ; \
	 echo "distrover=$(SHARUTILS_PKG_DISTRO_VERSION)"                >> $(SHARUTILS_PKG)/.PKGINFO ; \
	 echo "group=$(SHARUTILS_PKG_GROUP)"                             >> $(SHARUTILS_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(SHARUTILS_PKG_SHORT_DESCRIPTION)\"" >> $(SHARUTILS_PKG)/.PKGINFO ; \
	 echo "url=$(SHARUTILS_PKG_URL)"                                 >> $(SHARUTILS_PKG)/.PKGINFO ; \
	 echo "license=$(SHARUTILS_PKG_LICENSE)"                         >> $(SHARUTILS_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(SHARUTILS_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
