
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


SOURCE_REQUIRES    = sources/packages/l/dmapi

REQUIRES           = app/xfsprogs/3.1.11

# ======= __END_OF_REQUIRES__ =======


version            = 2.2.12
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/dmapi/dmapi-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/dmapi-$(version)
src_dir_name       = dmapi-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
DMAPI_PKG_NAME                = dmapi
DMAPI_PKG_VERSION             = 2.2.12
DMAPI_PKG_ARCH                = $(TOOLCHAIN)
DMAPI_PKG_DISTRO_NAME         = $(DISTRO_NAME)
DMAPI_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
DMAPI_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
DMAPI_PKG_SHORT_DESCRIPTION   = Data Management API library
DMAPI_PKG_URL                 = $(BUG_URL)
DMAPI_PKG_LICENSE             = GPLv2
DMAPI_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(DMAPI_PKG_NAME)-pkg-description
DMAPI_PKG_DESCRIPTION_FILE_IN = $(DMAPI_PKG_NAME)-pkg-description.in
DMAPI_PKG_INSTALL_SCRIPT      = $(DMAPI_PKG_NAME)-pkg-install.sh

DMAPI_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(DMAPI_PKG_NAME)-package

pkg_basename     = $(DMAPI_PKG_NAME)-$(DMAPI_PKG_VERSION)-$(DMAPI_PKG_ARCH)-$(DMAPI_PKG_DISTRO_NAME)-$(DMAPI_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DIST_ROOT=$(DMAPI_PKG)

extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --libexecdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --includedir=/usr/include
extra_configure_switches += --datadir=/usr/share
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --enable-shared


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && \
	  $(BUILD_ENVIRONMENT) ./configure \
	  --prefix=/usr               \
	  --exec-prefix=/usr          \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(DMAPI_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install-dev $(env_sysroot)
	@mkdir -p $(DMAPI_PKG)/lib$(LIBSUFFIX)
	@( cd $(DMAPI_PKG)/usr/lib$(LIBSUFFIX) ; \
	   chmod 755 libdm.so.?.?.? *.la ; \
	   cp -a libdm.so.? $(DMAPI_PKG)/lib$(LIBSUFFIX) ; \
	   mv libdm.so.?.?.? $(DMAPI_PKG)/lib$(LIBSUFFIX) ; \
	   ln -sf ../../lib$(LIBSUFFIX)/libdm.so.?.?.? . \
	 )
	# ====== Install Documentation ======
	@mkdir -p $(DMAPI_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/doc/COPYING* \
	       $(DMAPI_PKG)/usr/doc/$(src_dir_name)
	@mv $(DMAPI_PKG)/usr/share/doc/dmapi $(DMAPI_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a doc/INSTALL \
	         $(DMAPI_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	# ====== remove target path from target libtool *.la files ======
	@( cd $(DMAPI_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libdm.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(DMAPI_PKG))
	# ====== tune libtool *.la search path to the target destination for development ======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libdm.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libdm.la \
	 )
	# ====== Strip binaries ======
	@( cd $(DMAPI_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(DMAPI_PKG_DESCRIPTION_FILE): $(DMAPI_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(DMAPI_PKG_DESCRIPTION_FILE) $(DMAPI_PKG_INSTALL_SCRIPT)
	@cp $(DMAPI_PKG_DESCRIPTION_FILE) $(DMAPI_PKG)/.DESCRIPTION
	@cp $(DMAPI_PKG_INSTALL_SCRIPT) $(DMAPI_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(DMAPI_PKG)/.REQUIRES
	@echo "pkgname=$(DMAPI_PKG_NAME)"                            >  $(DMAPI_PKG)/.PKGINFO ; \
	 echo "pkgver=$(DMAPI_PKG_VERSION)"                          >> $(DMAPI_PKG)/.PKGINFO ; \
	 echo "arch=$(DMAPI_PKG_ARCH)"                               >> $(DMAPI_PKG)/.PKGINFO ; \
	 echo "distroname=$(DMAPI_PKG_DISTRO_NAME)"                  >> $(DMAPI_PKG)/.PKGINFO ; \
	 echo "distrover=$(DMAPI_PKG_DISTRO_VERSION)"                >> $(DMAPI_PKG)/.PKGINFO ; \
	 echo "group=$(DMAPI_PKG_GROUP)"                             >> $(DMAPI_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(DMAPI_PKG_SHORT_DESCRIPTION)\"" >> $(DMAPI_PKG)/.PKGINFO ; \
	 echo "url=$(DMAPI_PKG_URL)"                                 >> $(DMAPI_PKG)/.PKGINFO ; \
	 echo "license=$(DMAPI_PKG_LICENSE)"                         >> $(DMAPI_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(DMAPI_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
