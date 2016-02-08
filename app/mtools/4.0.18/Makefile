
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


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/GNU/mtools

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/4.9.2
else
REQUIRES           = libs/glibc/2.21
endif


# ======= __END_OF_REQUIRES__ =======


version            = 4.0.18
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/GNU/mtools/mtools-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/mtools-$(version)
src_dir_name       = mtools-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done

hw_cache           = $(CURDIR)/$(build_dir)/hw.cache

mtools_conf        = $(CURDIR)/etc/mtools.conf


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
MTOOLS_PKG_NAME                = mtools
MTOOLS_PKG_VERSION             = 4.0.18
MTOOLS_PKG_ARCH                = $(TOOLCHAIN)
MTOOLS_PKG_DISTRO_NAME         = $(DISTRO_NAME)
MTOOLS_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
MTOOLS_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
MTOOLS_PKG_SHORT_DESCRIPTION   = utilities to access DOS disks in Unix
MTOOLS_PKG_URL                 = $(BUG_URL)
MTOOLS_PKG_LICENSE             = GPLv3
MTOOLS_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(MTOOLS_PKG_NAME)-pkg-description
MTOOLS_PKG_DESCRIPTION_FILE_IN = $(MTOOLS_PKG_NAME)-pkg-description.in
MTOOLS_PKG_INSTALL_SCRIPT      = $(MTOOLS_PKG_NAME)-pkg-install.sh

MTOOLS_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(MTOOLS_PKG_NAME)-package

pkg_basename     = $(MTOOLS_PKG_NAME)-$(MTOOLS_PKG_VERSION)-$(MTOOLS_PKG_ARCH)-$(MTOOLS_PKG_DISTRO_NAME)-$(MTOOLS_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(MTOOLS_PKG)

extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --enable-floppyd=no

extra_configure_switches += --cache-file=$(hw_cache)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@echo "ac_cv_func_setpgrp_void=yes" > $(hw_cache)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) $(environment) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(environment) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(MTOOLS_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(environment) $(MAKE) -j1 install $(env_sysroot)
	@mkdir -p $(MTOOLS_PKG)/etc
	@cp -a $(mtools_conf) $(MTOOLS_PKG)/etc
	# ======= Remove obsolete files =======
	@rm -f $(MTOOLS_PKG)/usr/bin/lz
	@rm -f $(MTOOLS_PKG)/usr/bin/mcheck
	@rm -f $(MTOOLS_PKG)/usr/bin/mcomp
	@rm -f $(MTOOLS_PKG)/usr/bin/mxtar
	@rm -f $(MTOOLS_PKG)/usr/bin/tgz
	@rm -f $(MTOOLS_PKG)/usr/bin/uz
	# ======= Install Documentation =======
	@rm -f $(MTOOLS_PKG)/usr/share/info/dir
	@gzip -9 $(MTOOLS_PKG)/usr/share/info/*
	@rm -f $(MTOOLS_PKG)/usr/share/man/man1/floppyd*
	@if [ -d $(MTOOLS_PKG)/usr/share/man ]; then \
	  ( cd $(MTOOLS_PKG)/usr/share/man ; \
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
	@mkdir -p $(MTOOLS_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(MTOOLS_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(MTOOLS_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING INSTALL NEWS README Release.notes \
	         $(MTOOLS_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(MTOOLS_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(MTOOLS_PKG))
	# ======= Strip binaries =======
	@( cd $(MTOOLS_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(MTOOLS_PKG_DESCRIPTION_FILE): $(MTOOLS_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(MTOOLS_PKG_DESCRIPTION_FILE) $(MTOOLS_PKG_INSTALL_SCRIPT)
	@cp $(MTOOLS_PKG_DESCRIPTION_FILE) $(MTOOLS_PKG)/.DESCRIPTION
	@cp $(MTOOLS_PKG_INSTALL_SCRIPT) $(MTOOLS_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(MTOOLS_PKG)/.REQUIRES
	@echo "pkgname=$(MTOOLS_PKG_NAME)"                            >  $(MTOOLS_PKG)/.PKGINFO ; \
	 echo "pkgver=$(MTOOLS_PKG_VERSION)"                          >> $(MTOOLS_PKG)/.PKGINFO ; \
	 echo "arch=$(MTOOLS_PKG_ARCH)"                               >> $(MTOOLS_PKG)/.PKGINFO ; \
	 echo "distroname=$(MTOOLS_PKG_DISTRO_NAME)"                  >> $(MTOOLS_PKG)/.PKGINFO ; \
	 echo "distrover=$(MTOOLS_PKG_DISTRO_VERSION)"                >> $(MTOOLS_PKG)/.PKGINFO ; \
	 echo "group=$(MTOOLS_PKG_GROUP)"                             >> $(MTOOLS_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(MTOOLS_PKG_SHORT_DESCRIPTION)\"" >> $(MTOOLS_PKG)/.PKGINFO ; \
	 echo "url=$(MTOOLS_PKG_URL)"                                 >> $(MTOOLS_PKG)/.PKGINFO ; \
	 echo "license=$(MTOOLS_PKG_LICENSE)"                         >> $(MTOOLS_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(MTOOLS_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
