
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/GNU/findutils

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.3.0
else
REQUIRES           = libs/glibc/2.22
endif

# ======= __END_OF_REQUIRES__ =======


version            = 4.4.2
tar_gz_archive     = $(SRC_PACKAGE_PATH)/GNU/findutils/findutils-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/findutils-$(version)
src_dir_name       = findutils-$(version)
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
FINDUTILS_PKG_NAME                = findutils
FINDUTILS_PKG_VERSION             = 4.4.2
FINDUTILS_PKG_ARCH                = $(TOOLCHAIN)
FINDUTILS_PKG_DISTRO_NAME         = $(DISTRO_NAME)
FINDUTILS_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
FINDUTILS_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
FINDUTILS_PKG_SHORT_DESCRIPTION   = utilities to locate files
FINDUTILS_PKG_URL                 = $(BUG_URL)
FINDUTILS_PKG_LICENSE             = GPLv2
FINDUTILS_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(FINDUTILS_PKG_NAME)-pkg-description
FINDUTILS_PKG_DESCRIPTION_FILE_IN = $(FINDUTILS_PKG_NAME)-pkg-description.in
FINDUTILS_PKG_INSTALL_SCRIPT      = $(FINDUTILS_PKG_NAME)-pkg-install.sh

FINDUTILS_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(FINDUTILS_PKG_NAME)-package

pkg_basename     = $(FINDUTILS_PKG_NAME)-$(FINDUTILS_PKG_VERSION)-$(FINDUTILS_PKG_ARCH)-$(FINDUTILS_PKG_DISTRO_NAME)-$(FINDUTILS_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(FINDUTILS_PKG)


extra_configure_switches  = --libdir=/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --disable-rpath
extra_configure_switches += --disable-locate
extra_configure_switches += --without-fts

# http://savannah.gnu.org/bugs/?27299
extra_configure_switches += gl_cv_func_wcwidth_works=yes


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
	@mkdir -p $(FINDUTILS_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(environment) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@rm -f $(FINDUTILS_PKG)/usr/share/info/dir
	@gzip -9 $(FINDUTILS_PKG)/usr/share/info/*
	@if [ -d $(FINDUTILS_PKG)/usr/share/man ]; then \
	  ( cd $(FINDUTILS_PKG)/usr/share/man ; \
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
	@mkdir -p $(FINDUTILS_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING* \
	       $(FINDUTILS_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(FINDUTILS_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING* NEWS README* THANKS TODO \
	         $(FINDUTILS_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(FINDUTILS_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(FINDUTILS_PKG))
	# ======= Strip binaries =======
	@( cd $(FINDUTILS_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(FINDUTILS_PKG_DESCRIPTION_FILE): $(FINDUTILS_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(FINDUTILS_PKG_DESCRIPTION_FILE) $(FINDUTILS_PKG_INSTALL_SCRIPT)
	@cp $(FINDUTILS_PKG_DESCRIPTION_FILE) $(FINDUTILS_PKG)/.DESCRIPTION
	@cp $(FINDUTILS_PKG_INSTALL_SCRIPT) $(FINDUTILS_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(FINDUTILS_PKG)/.REQUIRES
	@echo "pkgname=$(FINDUTILS_PKG_NAME)"                            >  $(FINDUTILS_PKG)/.PKGINFO ; \
	 echo "pkgver=$(FINDUTILS_PKG_VERSION)"                          >> $(FINDUTILS_PKG)/.PKGINFO ; \
	 echo "arch=$(FINDUTILS_PKG_ARCH)"                               >> $(FINDUTILS_PKG)/.PKGINFO ; \
	 echo "distroname=$(FINDUTILS_PKG_DISTRO_NAME)"                  >> $(FINDUTILS_PKG)/.PKGINFO ; \
	 echo "distrover=$(FINDUTILS_PKG_DISTRO_VERSION)"                >> $(FINDUTILS_PKG)/.PKGINFO ; \
	 echo "group=$(FINDUTILS_PKG_GROUP)"                             >> $(FINDUTILS_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(FINDUTILS_PKG_SHORT_DESCRIPTION)\"" >> $(FINDUTILS_PKG)/.PKGINFO ; \
	 echo "url=$(FINDUTILS_PKG_URL)"                                 >> $(FINDUTILS_PKG)/.PKGINFO ; \
	 echo "license=$(FINDUTILS_PKG_LICENSE)"                         >> $(FINDUTILS_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(FINDUTILS_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
