
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


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/n/ethtool

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.3.0
else
REQUIRES           = libs/glibc/2.23
endif

# ======= __END_OF_REQUIRES__ =======


version            = 3.12
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/n/ethtool/ethtool-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/ethtool-$(version)
src_dir_name       = ethtool-$(version)
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
ETHTOOL_PKG_NAME                = ethtool
ETHTOOL_PKG_VERSION             = 3.12
ETHTOOL_PKG_ARCH                = $(TOOLCHAIN)
ETHTOOL_PKG_DISTRO_NAME         = $(DISTRO_NAME)
ETHTOOL_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
ETHTOOL_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
ETHTOOL_PKG_SHORT_DESCRIPTION   = examining and tuning a network interface tool
ETHTOOL_PKG_URL                 = $(BUG_URL)
ETHTOOL_PKG_LICENSE             = GPLv2
ETHTOOL_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(ETHTOOL_PKG_NAME)-pkg-description
ETHTOOL_PKG_DESCRIPTION_FILE_IN = $(ETHTOOL_PKG_NAME)-pkg-description.in
ETHTOOL_PKG_INSTALL_SCRIPT      = $(ETHTOOL_PKG_NAME)-pkg-install.sh

ETHTOOL_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(ETHTOOL_PKG_NAME)-package

pkg_basename     = $(ETHTOOL_PKG_NAME)-$(ETHTOOL_PKG_VERSION)-$(ETHTOOL_PKG_ARCH)-$(ETHTOOL_PKG_DISTRO_NAME)-$(ETHTOOL_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(ETHTOOL_PKG)


extra_configure_switches  = --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(ETHTOOL_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(ETHTOOL_PKG)/usr/share/man ]; then \
	  ( cd $(ETHTOOL_PKG)/usr/share/man ; \
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
	@mkdir -p $(ETHTOOL_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING $(SRC_DIR)/LICENSE \
	       $(ETHTOOL_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(ETHTOOL_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING INSTALL LICENSE NEWS README \
	         $(ETHTOOL_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(ETHTOOL_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(ETHTOOL_PKG))
	# ======= Strip binaries =======
	@( cd $(ETHTOOL_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(ETHTOOL_PKG_DESCRIPTION_FILE): $(ETHTOOL_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(ETHTOOL_PKG_DESCRIPTION_FILE) $(ETHTOOL_PKG_INSTALL_SCRIPT)
	@cp $(ETHTOOL_PKG_DESCRIPTION_FILE) $(ETHTOOL_PKG)/.DESCRIPTION
	@cp $(ETHTOOL_PKG_INSTALL_SCRIPT) $(ETHTOOL_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(ETHTOOL_PKG)/.REQUIRES
	@echo "pkgname=$(ETHTOOL_PKG_NAME)"                            >  $(ETHTOOL_PKG)/.PKGINFO ; \
	 echo "pkgver=$(ETHTOOL_PKG_VERSION)"                          >> $(ETHTOOL_PKG)/.PKGINFO ; \
	 echo "arch=$(ETHTOOL_PKG_ARCH)"                               >> $(ETHTOOL_PKG)/.PKGINFO ; \
	 echo "distroname=$(ETHTOOL_PKG_DISTRO_NAME)"                  >> $(ETHTOOL_PKG)/.PKGINFO ; \
	 echo "distrover=$(ETHTOOL_PKG_DISTRO_VERSION)"                >> $(ETHTOOL_PKG)/.PKGINFO ; \
	 echo "group=$(ETHTOOL_PKG_GROUP)"                             >> $(ETHTOOL_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(ETHTOOL_PKG_SHORT_DESCRIPTION)\"" >> $(ETHTOOL_PKG)/.PKGINFO ; \
	 echo "url=$(ETHTOOL_PKG_URL)"                                 >> $(ETHTOOL_PKG)/.PKGINFO ; \
	 echo "license=$(ETHTOOL_PKG_LICENSE)"                         >> $(ETHTOOL_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(ETHTOOL_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
