
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_DM64X)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/GNU/automake

REQUIRES           = app/bash/4.3
REQUIRES          += dev/perl/5.18.2
REQUIRES          += dev/autoconf/2.69

# ======= __END_OF_REQUIRES__ =======


version            = 1.11.5
short_version      = $(shell echo $(version) | cut -f1,2 -d .)
tar_xz_archive     = $(SRC_PACKAGE_PATH)/GNU/automake/automake-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/automake-$(version)
src_dir_name       = automake-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = dev

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
AUTOMAKE_PKG_NAME                = automake
AUTOMAKE_PKG_VERSION             = 1.11.5
AUTOMAKE_PKG_ARCH                = $(TOOLCHAIN)
AUTOMAKE_PKG_DISTRO_NAME         = $(DISTRO_NAME)
AUTOMAKE_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
AUTOMAKE_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
AUTOMAKE_PKG_SHORT_DESCRIPTION   = Makefile generator
AUTOMAKE_PKG_URL                 = $(BUG_URL)
AUTOMAKE_PKG_LICENSE             = GPLv2
AUTOMAKE_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(AUTOMAKE_PKG_NAME)-pkg-description
AUTOMAKE_PKG_DESCRIPTION_FILE_IN = $(AUTOMAKE_PKG_NAME)-pkg-description.in
AUTOMAKE_PKG_INSTALL_SCRIPT      = $(AUTOMAKE_PKG_NAME)-pkg-install.sh

AUTOMAKE_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(AUTOMAKE_PKG_NAME)-package

pkg_basename     = $(AUTOMAKE_PKG_NAME)-$(AUTOMAKE_PKG_VERSION)-$(AUTOMAKE_PKG_ARCH)-$(AUTOMAKE_PKG_DISTRO_NAME)-$(AUTOMAKE_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(AUTOMAKE_PKG)


extra_configure_switches  = --libdir=/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(AUTOMAKE_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@( cd $(AUTOMAKE_PKG)/usr/bin ; \
	   rm -f aclocal ; \
	   ln -sf aclocal-$(short_version) aclocal ; \
	   rm -f automake ; \
	   ln -sf automake-$(short_version) automake ; \
	 )
	@( cd $(AUTOMAKE_PKG)/usr/share/man/man1 ; \
	   rm -f aclocal.1 ; \
	   ln -sf aclocal-$(short_version).1 aclocal.1 ; \
	   rm -f automake.1 ; \
	   ln -sf automake-$(short_version).1 automake.1 ; \
	 )
	@mkdir -p $(AUTOMAKE_PKG)/usr/share/aclocal
	@touch $(AUTOMAKE_PKG)/usr/share/aclocal
	# ======= Install Documentation =======
	@rm -f $(AUTOMAKE_PKG)/usr/share/info/dir
	@gzip -9 $(AUTOMAKE_PKG)/usr/share/info/*
	@if [ -d $(AUTOMAKE_PKG)/usr/share/man ]; then \
	  ( cd $(AUTOMAKE_PKG)/usr/share/man ; \
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
	@mkdir -p $(AUTOMAKE_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(AUTOMAKE_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(AUTOMAKE_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING HACKING INSTALL NEWS README THANKS TODO \
	         $(AUTOMAKE_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(AUTOMAKE_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(AUTOMAKE_PKG))
	@touch $@

$(AUTOMAKE_PKG_DESCRIPTION_FILE): $(AUTOMAKE_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(AUTOMAKE_PKG_DESCRIPTION_FILE) $(AUTOMAKE_PKG_INSTALL_SCRIPT)
	@cp $(AUTOMAKE_PKG_DESCRIPTION_FILE) $(AUTOMAKE_PKG)/.DESCRIPTION
	@cp $(AUTOMAKE_PKG_INSTALL_SCRIPT) $(AUTOMAKE_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(AUTOMAKE_PKG)/.REQUIRES
	@echo "pkgname=$(AUTOMAKE_PKG_NAME)"                            >  $(AUTOMAKE_PKG)/.PKGINFO ; \
	 echo "pkgver=$(AUTOMAKE_PKG_VERSION)"                          >> $(AUTOMAKE_PKG)/.PKGINFO ; \
	 echo "arch=$(AUTOMAKE_PKG_ARCH)"                               >> $(AUTOMAKE_PKG)/.PKGINFO ; \
	 echo "distroname=$(AUTOMAKE_PKG_DISTRO_NAME)"                  >> $(AUTOMAKE_PKG)/.PKGINFO ; \
	 echo "distrover=$(AUTOMAKE_PKG_DISTRO_VERSION)"                >> $(AUTOMAKE_PKG)/.PKGINFO ; \
	 echo "group=$(AUTOMAKE_PKG_GROUP)"                             >> $(AUTOMAKE_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(AUTOMAKE_PKG_SHORT_DESCRIPTION)\"" >> $(AUTOMAKE_PKG)/.PKGINFO ; \
	 echo "url=$(AUTOMAKE_PKG_URL)"                                 >> $(AUTOMAKE_PKG)/.PKGINFO ; \
	 echo "license=$(AUTOMAKE_PKG_LICENSE)"                         >> $(AUTOMAKE_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(AUTOMAKE_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
