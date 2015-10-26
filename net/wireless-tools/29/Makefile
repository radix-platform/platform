
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_VIP1830)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)
COMPONENT_TARGETS += $(HARDWARE_CI20)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/n/wireless-tools

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/4.9.2
else
REQUIRES           = libs/glibc/2.21
endif

# ======= __END_OF_REQUIRES__ =======


version            = 29
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/n/wireless-tools/wireless-tools-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/wireless-tools-$(version)
src_dir_name       = wireless-tools-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
WTOOLS_PKG_NAME                = wireless-tools
WTOOLS_PKG_VERSION             = 29
WTOOLS_PKG_ARCH                = $(TOOLCHAIN)
WTOOLS_PKG_DISTRO_NAME         = $(DISTRO_NAME)
WTOOLS_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
WTOOLS_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
WTOOLS_PKG_SHORT_DESCRIPTION   = utilities for wireless networking
WTOOLS_PKG_URL                 = $(BUG_URL)
WTOOLS_PKG_LICENSE             = GPLv2
WTOOLS_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(WTOOLS_PKG_NAME)-pkg-description
WTOOLS_PKG_DESCRIPTION_FILE_IN = $(WTOOLS_PKG_NAME)-pkg-description.in
WTOOLS_PKG_INSTALL_SCRIPT      = $(WTOOLS_PKG_NAME)-pkg-install.sh

WTOOLS_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(WTOOLS_PKG_NAME)-package

pkg_basename     = $(WTOOLS_PKG_NAME)-$(WTOOLS_PKG_VERSION)-$(WTOOLS_PKG_ARCH)-$(WTOOLS_PKG_DISTRO_NAME)-$(WTOOLS_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(WTOOLS_PKG)


configure_switches  = INSTALL_DIR=$(WTOOLS_PKG)/sbin
configure_switches += INSTALL_LIB=$(WTOOLS_PKG)/usr/lib$(LIBSUFFIX)
configure_switches += INSTALL_INC=$(WTOOLS_PKG)/usr/include
configure_switches += INSTALL_MAN=$(WTOOLS_PKG)/usr/share/man


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) $(configure_switches)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(WTOOLS_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) install $(configure_switches) $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(WTOOLS_PKG)/usr/share/man ]; then \
	  ( cd $(WTOOLS_PKG)/usr/share/man ; \
	    for manpagedir in `find . -type d -name "man*"` ; do \
	      ( cd $$manpagedir ; \
	        for eachpage in `find . -type l -maxdepth 1` ; do \
	          ln -s `readlink $$eachpage`.gz $$eachpage.gz ; \
	          rm $$eachpage ; \
	        done ; \
	        gzip -9 *.? ; \
	      ) \
	    done \
	  ) \
	 fi
	@mkdir -p $(WTOOLS_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(WTOOLS_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(WTOOLS_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING INSTALL README* *.rules *.txt \
	         $(WTOOLS_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(WTOOLS_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(WTOOLS_PKG))
	# ======= Strip binaries =======
	@( cd $(WTOOLS_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(WTOOLS_PKG_DESCRIPTION_FILE): $(WTOOLS_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(WTOOLS_PKG_DESCRIPTION_FILE) $(WTOOLS_PKG_INSTALL_SCRIPT)
	@cp $(WTOOLS_PKG_DESCRIPTION_FILE) $(WTOOLS_PKG)/.DESCRIPTION
	@cp $(WTOOLS_PKG_INSTALL_SCRIPT) $(WTOOLS_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(WTOOLS_PKG)/.REQUIRES
	@echo "pkgname=$(WTOOLS_PKG_NAME)"                            >  $(WTOOLS_PKG)/.PKGINFO ; \
	 echo "pkgver=$(WTOOLS_PKG_VERSION)"                          >> $(WTOOLS_PKG)/.PKGINFO ; \
	 echo "arch=$(WTOOLS_PKG_ARCH)"                               >> $(WTOOLS_PKG)/.PKGINFO ; \
	 echo "distroname=$(WTOOLS_PKG_DISTRO_NAME)"                  >> $(WTOOLS_PKG)/.PKGINFO ; \
	 echo "distrover=$(WTOOLS_PKG_DISTRO_VERSION)"                >> $(WTOOLS_PKG)/.PKGINFO ; \
	 echo "group=$(WTOOLS_PKG_GROUP)"                             >> $(WTOOLS_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(WTOOLS_PKG_SHORT_DESCRIPTION)\"" >> $(WTOOLS_PKG)/.PKGINFO ; \
	 echo "url=$(WTOOLS_PKG_URL)"                                 >> $(WTOOLS_PKG)/.PKGINFO ; \
	 echo "license=$(WTOOLS_PKG_LICENSE)"                         >> $(WTOOLS_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(WTOOLS_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
