
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXQ)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH       = true
COMPONENT_IS_3PP    = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES     = sources/packages/a/dosfstools

REQUIRES            = app/util-linux/2.27.1

# ======= __END_OF_REQUIRES__ =======


version             = 3.0.26
tar_xz_archive      = $(SRC_PACKAGE_PATH)/packages/a/dosfstools/dosfstools-$(version).tar.xz
SRC_ARCHIVE         = $(tar_xz_archive)
SRC_DIR             = $(TARGET_BUILD_DIR)/dosfstools-$(version)
src_dir_name        = dosfstools-$(version)
src_done            = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target        = $(TARGET_BUILD_DIR)/.build_done
install_target      = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
DOSFS_PKG_NAME                = dosfstools
DOSFS_PKG_VERSION             = 3.0.26
DOSFS_PKG_ARCH                = $(TOOLCHAIN)
DOSFS_PKG_DISTRO_NAME         = $(DISTRO_NAME)
DOSFS_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
DOSFS_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
DOSFS_PKG_SHORT_DESCRIPTION   = FAT filesystems utilities
DOSFS_PKG_URL                 = $(BUG_URL)
DOSFS_PKG_LICENSE             = GPLv2
DOSFS_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(DOSFS_PKG_NAME)-pkg-description
DOSFS_PKG_DESCRIPTION_FILE_IN = $(DOSFS_PKG_NAME)-pkg-description.in
DOSFS_PKG_INSTALL_SCRIPT      = $(DOSFS_PKG_NAME)-pkg-install.sh

DOSFS_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(DOSFS_PKG_NAME)-package

pkg_basename     = $(DOSFS_PKG_NAME)-$(DOSFS_PKG_VERSION)-$(DOSFS_PKG_ARCH)-$(DOSFS_PKG_DISTRO_NAME)-$(DOSFS_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(DOSFS_PKG)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(DOSFS_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(DOSFS_PKG)/usr/share/man ]; then \
	  ( cd $(DOSFS_PKG)/usr/share/man ; \
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
	@mkdir -p $(DOSFS_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(DOSFS_PKG)/usr/doc/$(src_dir_name)
	@mv $(DOSFS_PKG)/usr/share/doc/dosfstools $(DOSFS_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING \
	         $(DOSFS_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@rm -f $(DOSFS_PKG)/usr/share/doc/$(src_dir_name)/ChangeLog
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(DOSFS_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(DOSFS_PKG))
	# ======= Strip binaries =======
	@( cd $(DOSFS_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(DOSFS_PKG_DESCRIPTION_FILE): $(DOSFS_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(DOSFS_PKG_DESCRIPTION_FILE) $(DOSFS_PKG_INSTALL_SCRIPT)
	@cp $(DOSFS_PKG_DESCRIPTION_FILE) $(DOSFS_PKG)/.DESCRIPTION
	@cp $(DOSFS_PKG_INSTALL_SCRIPT) $(DOSFS_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(DOSFS_PKG)/.REQUIRES
	@echo "pkgname=$(DOSFS_PKG_NAME)"                            >  $(DOSFS_PKG)/.PKGINFO ; \
	 echo "pkgver=$(DOSFS_PKG_VERSION)"                          >> $(DOSFS_PKG)/.PKGINFO ; \
	 echo "arch=$(DOSFS_PKG_ARCH)"                               >> $(DOSFS_PKG)/.PKGINFO ; \
	 echo "distroname=$(DOSFS_PKG_DISTRO_NAME)"                  >> $(DOSFS_PKG)/.PKGINFO ; \
	 echo "distrover=$(DOSFS_PKG_DISTRO_VERSION)"                >> $(DOSFS_PKG)/.PKGINFO ; \
	 echo "group=$(DOSFS_PKG_GROUP)"                             >> $(DOSFS_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(DOSFS_PKG_SHORT_DESCRIPTION)\"" >> $(DOSFS_PKG)/.PKGINFO ; \
	 echo "url=$(DOSFS_PKG_URL)"                                 >> $(DOSFS_PKG)/.PKGINFO ; \
	 echo "license=$(DOSFS_PKG_LICENSE)"                         >> $(DOSFS_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(DOSFS_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
