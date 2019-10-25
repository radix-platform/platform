
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/dmapi

REQUIRES           = libs/dmapi/2.2.12
REQUIRES          += app/xfsprogs/5.2.1-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 2.2.12
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/dmapi/dmapi-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/dmapi-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
DMAPI_32_PKG_NAME                = dmapi-x32
DMAPI_32_PKG_VERSION             = 2.2.12
DMAPI_32_PKG_ARCH                = $(TOOLCHAIN)
DMAPI_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
DMAPI_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
DMAPI_32_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
DMAPI_32_PKG_SHORT_DESCRIPTION   = Data Management API library
DMAPI_32_PKG_URL                 = $(BUG_URL)
DMAPI_32_PKG_LICENSE             = GPLv2
DMAPI_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(DMAPI_32_PKG_NAME)-pkg-description
DMAPI_32_PKG_DESCRIPTION_FILE_IN = $(DMAPI_32_PKG_NAME)-pkg-description.in
DMAPI_32_PKG_INSTALL_SCRIPT      = $(DMAPI_32_PKG_NAME)-pkg-install.sh

DMAPI_32_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(DMAPI_32_PKG_NAME)-package

pkg_basename     = $(DMAPI_32_PKG_NAME)-$(DMAPI_32_PKG_VERSION)-$(DMAPI_32_PKG_ARCH)-$(DMAPI_32_PKG_DISTRO_NAME)-$(DMAPI_32_PKG_DISTRO_VERSION)

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


env_sysroot = DIST_ROOT=$(DMAPI_32_PKG)

extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --libexecdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
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
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(DMAPI_32_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install-dev $(env_sysroot)
	@mkdir -p $(DMAPI_32_PKG)/lib$(MULTILIB_X86_32_SUFFIX)
	@( cd $(DMAPI_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   chmod 755 libdm.so.?.?.? *.la ; \
	   cp -a libdm.so.? $(DMAPI_32_PKG)/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   mv libdm.so.?.?.? $(DMAPI_32_PKG)/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   ln -sf ../../lib$(MULTILIB_X86_32_SUFFIX)/libdm.so.?.?.? . \
	 )
	@rm -rf $(DMAPI_32_PKG)/usr/include
	@rm -rf $(DMAPI_32_PKG)/usr/share
	# ======= remove target path from target libtool *.la files =======
	@( cd $(DMAPI_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libdm.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(DMAPI_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libdm.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libdm.la \
	 )
	# ======= Strip binaries =======
	@( cd $(DMAPI_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(DMAPI_32_PKG_DESCRIPTION_FILE): $(DMAPI_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(DMAPI_32_PKG_DESCRIPTION_FILE) $(DMAPI_32_PKG_INSTALL_SCRIPT)
	@cp $(DMAPI_32_PKG_DESCRIPTION_FILE) $(DMAPI_32_PKG)/.DESCRIPTION
	@cp $(DMAPI_32_PKG_INSTALL_SCRIPT) $(DMAPI_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(DMAPI_32_PKG)/.REQUIRES
	@echo "pkgname=$(DMAPI_32_PKG_NAME)"                            >  $(DMAPI_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(DMAPI_32_PKG_VERSION)"                          >> $(DMAPI_32_PKG)/.PKGINFO ; \
	 echo "arch=$(DMAPI_32_PKG_ARCH)"                               >> $(DMAPI_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(DMAPI_32_PKG_DISTRO_NAME)"                  >> $(DMAPI_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(DMAPI_32_PKG_DISTRO_VERSION)"                >> $(DMAPI_32_PKG)/.PKGINFO ; \
	 echo "group=$(DMAPI_32_PKG_GROUP)"                             >> $(DMAPI_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(DMAPI_32_PKG_SHORT_DESCRIPTION)\"" >> $(DMAPI_32_PKG)/.PKGINFO ; \
	 echo "url=$(DMAPI_32_PKG_URL)"                                 >> $(DMAPI_32_PKG)/.PKGINFO ; \
	 echo "license=$(DMAPI_32_PKG_LICENSE)"                         >> $(DMAPI_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(DMAPI_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
