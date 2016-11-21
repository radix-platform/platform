
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXV)
COMPONENT_TARGETS += $(HARDWARE_P201)
COMPONENT_TARGETS += $(HARDWARE_NEXBOX_A95X)
COMPONENT_TARGETS += $(HARDWARE_P212)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_VIM)
COMPONENT_TARGETS += $(HARDWARE_Q201)
COMPONENT_TARGETS += $(HARDWARE_ENYBOX_X2)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/zlib

REQUIRES           = libs/glibc/2.24

# ======= __END_OF_REQUIRES__ =======


version            = 1.2.8
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/zlib/zlib-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/zlib-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
ZLIB_PKG_NAME                = zlib
ZLIB_PKG_VERSION             = 1.2.8
ZLIB_PKG_ARCH                = $(TOOLCHAIN)
ZLIB_PKG_DISTRO_NAME         = $(DISTRO_NAME)
ZLIB_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
ZLIB_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
ZLIB_PKG_SHORT_DESCRIPTION   = compression library
ZLIB_PKG_URL                 = $(BUG_URL)
ZLIB_PKG_LICENSE             = GPLv2
ZLIB_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(ZLIB_PKG_NAME)-pkg-description
ZLIB_PKG_DESCRIPTION_FILE_IN = $(ZLIB_PKG_NAME)-pkg-description.in
ZLIB_PKG_INSTALL_SCRIPT      = $(ZLIB_PKG_NAME)-pkg-install.sh

ZLIB_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(ZLIB_PKG_NAME)-package

pkg_basename     = $(ZLIB_PKG_NAME)-$(ZLIB_PKG_VERSION)-$(ZLIB_PKG_ARCH)-$(ZLIB_PKG_DISTRO_NAME)-$(ZLIB_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot       = DESTDIR=$(ZLIB_PKG)
cross_environment = CROSS_PREFIX=$(CROSS_PREFIX)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --shared


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && \
	  $(BUILD_ENVIRONMENT) ./configure \
	  --prefix=/usr                    \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) $(cross_environment)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(ZLIB_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(cross_environment) $(env_sysroot)
	@mkdir -p $(ZLIB_PKG)/lib$(LIBSUFFIX)
	@( cd $(ZLIB_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in lib*.so.?.* ; do \
	     mv $$file ../../lib$(LIBSUFFIX) ; \
	     ln -sf ../../lib$(LIBSUFFIX)/$$file . ; \
	   done ; \
	   cp -a lib*.so.? ../../lib$(LIBSUFFIX) ; \
	 )
	# ======= Install Documentation =======
	@mkdir -p $(ZLIB_PKG)/usr/doc/zlib-$(version)
	@cp -a $(SRC_DIR)/ChangeLog $(SRC_DIR)/FAQ $(SRC_DIR)/INDEX $(SRC_DIR)/README \
	       $(ZLIB_PKG)/usr/doc/zlib-$(version)
	@mkdir -p $(ZLIB_PKG)/usr/share/doc/zlib-$(version)
	@cp -a $(SRC_DIR)/doc/*.txt \
	       $(ZLIB_PKG)/usr/share/doc/zlib-$(version)
	@( cd $(ZLIB_PKG)/usr/share/man/man3; \
	   for file in *.3 ; do \
	     gzip -9 --force $$file; \
	   done )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(ZLIB_PKG))
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" zlib.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(ZLIB_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(ZLIB_PKG_DESCRIPTION_FILE): $(ZLIB_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(ZLIB_PKG_DESCRIPTION_FILE) $(ZLIB_PKG_INSTALL_SCRIPT)
	@cp $(ZLIB_PKG_DESCRIPTION_FILE) $(ZLIB_PKG)/.DESCRIPTION
	@cp $(ZLIB_PKG_INSTALL_SCRIPT) $(ZLIB_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(ZLIB_PKG)/.REQUIRES
	@echo "pkgname=$(ZLIB_PKG_NAME)"                            >  $(ZLIB_PKG)/.PKGINFO ; \
	 echo "pkgver=$(ZLIB_PKG_VERSION)"                          >> $(ZLIB_PKG)/.PKGINFO ; \
	 echo "arch=$(ZLIB_PKG_ARCH)"                               >> $(ZLIB_PKG)/.PKGINFO ; \
	 echo "distroname=$(ZLIB_PKG_DISTRO_NAME)"                  >> $(ZLIB_PKG)/.PKGINFO ; \
	 echo "distrover=$(ZLIB_PKG_DISTRO_VERSION)"                >> $(ZLIB_PKG)/.PKGINFO ; \
	 echo "group=$(ZLIB_PKG_GROUP)"                             >> $(ZLIB_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(ZLIB_PKG_SHORT_DESCRIPTION)\"" >> $(ZLIB_PKG)/.PKGINFO ; \
	 echo "url=$(ZLIB_PKG_URL)"                                 >> $(ZLIB_PKG)/.PKGINFO ; \
	 echo "license=$(ZLIB_PKG_LICENSE)"                         >> $(ZLIB_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(ZLIB_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
