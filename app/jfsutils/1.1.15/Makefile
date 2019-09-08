
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


NEED_ABS_PATH       = true
COMPONENT_IS_3PP    = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES     = sources/packages/a/jfsutils

REQUIRES            = app/util-linux/2.27.1

# ======= __END_OF_REQUIRES__ =======


version             = 1.1.15
tar_gz_archive      = $(SRC_PACKAGE_PATH)/packages/a/jfsutils/jfsutils-$(version).tar.gz
SRC_ARCHIVE         = $(tar_gz_archive)
SRC_DIR             = $(TARGET_BUILD_DIR)/jfsutils-$(version)
src_dir_name        = jfsutils-$(version)
src_done            = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir           = $(TARGET_BUILD_DIR)/build
build_target        = $(TARGET_BUILD_DIR)/.build_done
install_target      = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
JFSUTILS_PKG_NAME                = jfsutils
JFSUTILS_PKG_VERSION             = 1.1.15
JFSUTILS_PKG_ARCH                = $(TOOLCHAIN)
JFSUTILS_PKG_DISTRO_NAME         = $(DISTRO_NAME)
JFSUTILS_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
JFSUTILS_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
JFSUTILS_PKG_SHORT_DESCRIPTION   = IBM JFS utilities
JFSUTILS_PKG_URL                 = $(BUG_URL)
JFSUTILS_PKG_LICENSE             = GPLv2
JFSUTILS_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(JFSUTILS_PKG_NAME)-pkg-description
JFSUTILS_PKG_DESCRIPTION_FILE_IN = $(JFSUTILS_PKG_NAME)-pkg-description.in
JFSUTILS_PKG_INSTALL_SCRIPT      = $(JFSUTILS_PKG_NAME)-pkg-install.sh

JFSUTILS_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(JFSUTILS_PKG_NAME)-package

pkg_basename     = $(JFSUTILS_PKG_NAME)-$(JFSUTILS_PKG_VERSION)-$(JFSUTILS_PKG_ARCH)-$(JFSUTILS_PKG_DISTRO_NAME)-$(JFSUTILS_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(JFSUTILS_PKG)


extra_configure_switches  = --sbindir=/sbin
extra_configure_switches += --disable-dependency-tracking


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(JFSUTILS_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@( cd $(JFSUTILS_PKG)/sbin  ; \
	   rm -f fsck.jfs mkfs.jfs  ; \
	   ln -sf jfs_fsck fsck.jfs ; \
	   ln -sf jfs_mkfs mkfs.jfs ; \
	 )
	@( cd $(JFSUTILS_PKG)/usr/share/man/man8 ; \
	   rm -f fsck.jfs.8 mkfs.jfs.8  ; \
	   ln -sf jfs_fsck.8 fsck.jfs.8 ; \
	   ln -sf jfs_mkfs.8 mkfs.jfs.8 ; \
	 )
	@if [ -d $(JFSUTILS_PKG)/usr/share/man ]; then \
	  ( cd $(JFSUTILS_PKG)/usr/share/man ; \
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
	@mkdir -p $(JFSUTILS_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(JFSUTILS_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(JFSUTILS_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING INSTALL NEWS README \
	         $(JFSUTILS_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(JFSUTILS_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(JFSUTILS_PKG))
	# ======= Strip binaries =======
	@( cd $(JFSUTILS_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(JFSUTILS_PKG_DESCRIPTION_FILE): $(JFSUTILS_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(JFSUTILS_PKG_DESCRIPTION_FILE) $(JFSUTILS_PKG_INSTALL_SCRIPT)
	@cp $(JFSUTILS_PKG_DESCRIPTION_FILE) $(JFSUTILS_PKG)/.DESCRIPTION
	@cp $(JFSUTILS_PKG_INSTALL_SCRIPT) $(JFSUTILS_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(JFSUTILS_PKG)/.REQUIRES
	@echo "pkgname=$(JFSUTILS_PKG_NAME)"                            >  $(JFSUTILS_PKG)/.PKGINFO ; \
	 echo "pkgver=$(JFSUTILS_PKG_VERSION)"                          >> $(JFSUTILS_PKG)/.PKGINFO ; \
	 echo "arch=$(JFSUTILS_PKG_ARCH)"                               >> $(JFSUTILS_PKG)/.PKGINFO ; \
	 echo "distroname=$(JFSUTILS_PKG_DISTRO_NAME)"                  >> $(JFSUTILS_PKG)/.PKGINFO ; \
	 echo "distrover=$(JFSUTILS_PKG_DISTRO_VERSION)"                >> $(JFSUTILS_PKG)/.PKGINFO ; \
	 echo "group=$(JFSUTILS_PKG_GROUP)"                             >> $(JFSUTILS_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(JFSUTILS_PKG_SHORT_DESCRIPTION)\"" >> $(JFSUTILS_PKG)/.PKGINFO ; \
	 echo "url=$(JFSUTILS_PKG_URL)"                                 >> $(JFSUTILS_PKG)/.PKGINFO ; \
	 echo "license=$(JFSUTILS_PKG_LICENSE)"                         >> $(JFSUTILS_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(JFSUTILS_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
