
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


SOURCE_REQUIRES    = sources/GNU/patch

REQUIRES           = app/attr/2.4.47

# ======= __END_OF_REQUIRES__ =======


version            = 2.7
tar_xz_archive     = $(SRC_PACKAGE_PATH)/GNU/patch/patch-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/patch-$(version)
src_dir_name       = patch-$(version)
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
PATCH_PKG_NAME                = patch
PATCH_PKG_VERSION             = 2.7
PATCH_PKG_ARCH                = $(TOOLCHAIN)
PATCH_PKG_DISTRO_NAME         = $(DISTRO_NAME)
PATCH_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
PATCH_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
PATCH_PKG_SHORT_DESCRIPTION   = apply diffs or patches to files
PATCH_PKG_URL                 = $(BUG_URL)
PATCH_PKG_LICENSE             = GPLv3
PATCH_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(PATCH_PKG_NAME)-pkg-description
PATCH_PKG_DESCRIPTION_FILE_IN = $(PATCH_PKG_NAME)-pkg-description.in
PATCH_PKG_INSTALL_SCRIPT      = $(PATCH_PKG_NAME)-pkg-install.sh

PATCH_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(PATCH_PKG_NAME)-package

pkg_basename     = $(PATCH_PKG_NAME)-$(PATCH_PKG_VERSION)-$(PATCH_PKG_ARCH)-$(PATCH_PKG_DISTRO_NAME)-$(PATCH_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(PATCH_PKG)

extra_configure_switches  = --libdir=/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking


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
	@mkdir -p $(PATCH_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(PATCH_PKG)/usr/share/man ]; then \
	  ( cd $(PATCH_PKG)/usr/share/man ; \
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
	@mkdir -p $(PATCH_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(PATCH_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(PATCH_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING INSTALL NEWS README TODO \
	         $(PATCH_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(PATCH_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(PATCH_PKG))
	# ======= Strip binaries =======
	@( cd $(PATCH_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null \
	 )
	@touch $@

$(PATCH_PKG_DESCRIPTION_FILE): $(PATCH_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(PATCH_PKG_DESCRIPTION_FILE) $(PATCH_PKG_INSTALL_SCRIPT)
	@cp $(PATCH_PKG_DESCRIPTION_FILE) $(PATCH_PKG)/.DESCRIPTION
	@cp $(PATCH_PKG_INSTALL_SCRIPT) $(PATCH_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(PATCH_PKG)/.REQUIRES
	@echo "pkgname=$(PATCH_PKG_NAME)"                            >  $(PATCH_PKG)/.PKGINFO ; \
	 echo "pkgver=$(PATCH_PKG_VERSION)"                          >> $(PATCH_PKG)/.PKGINFO ; \
	 echo "arch=$(PATCH_PKG_ARCH)"                               >> $(PATCH_PKG)/.PKGINFO ; \
	 echo "distroname=$(PATCH_PKG_DISTRO_NAME)"                  >> $(PATCH_PKG)/.PKGINFO ; \
	 echo "distrover=$(PATCH_PKG_DISTRO_VERSION)"                >> $(PATCH_PKG)/.PKGINFO ; \
	 echo "group=$(PATCH_PKG_GROUP)"                             >> $(PATCH_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(PATCH_PKG_SHORT_DESCRIPTION)\"" >> $(PATCH_PKG)/.PKGINFO ; \
	 echo "url=$(PATCH_PKG_URL)"                                 >> $(PATCH_PKG)/.PKGINFO ; \
	 echo "license=$(PATCH_PKG_LICENSE)"                         >> $(PATCH_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(PATCH_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
