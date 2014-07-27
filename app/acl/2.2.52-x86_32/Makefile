
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/acl

REQUIRES           = app/acl/2.2.52
REQUIRES          += app/attr/2.4.47-x86_32


version            = 2.2.52
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/a/acl/acl-$(version).src.tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/acl-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
ACL_32_PKG_NAME                = acl-x32
ACL_32_PKG_VERSION             = 2.2.52
ACL_32_PKG_ARCH                = $(TOOLCHAIN)
ACL_32_PKG_DISTRO_NAME         = kxLab
ACL_32_PKG_DISTRO_VERSION      = 1.0
ACL_32_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
ACL_32_PKG_SHORT_DESCRIPTION   = acl-x32 $(version)
ACL_32_PKG_URL                 = $(BUG_URL)
ACL_32_PKG_LICENSE             = GPLv2
ACL_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(ACL_32_PKG_NAME)-pkg-description
ACL_32_PKG_DESCRIPTION_FILE_IN = $(ACL_32_PKG_NAME)-pkg-description.in
ACL_32_PKG_INSTALL_SCRIPT      = $(ACL_32_PKG_NAME)-pkg-install.sh

ACL_32_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(ACL_32_PKG_NAME)-package

pkg_basename     = $(ACL_32_PKG_NAME)-$(ACL_32_PKG_VERSION)-$(ACL_32_PKG_ARCH)-$(ACL_32_PKG_DISTRO_NAME)-$(ACL_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))


BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DIST_ROOT=$(ACL_32_PKG)

extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --libexecdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --sbindir=/usr/sbin
extra_configure_switches += --bindir=/usr/bin
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
	@mkdir -p $(ACL_32_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) install-dev $(env_sysroot)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) install-lib $(env_sysroot)
	@mkdir -p $(ACL_32_PKG)/lib$(MULTILIB_X86_32_SUFFIX)
	@( cd $(ACL_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   chmod 755 libacl.so.?.?.? *.la ; \
	   cp -a libacl.so.? $(ACL_32_PKG)/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   mv libacl.so.?.?.? $(ACL_32_PKG)/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   ln -sf ../../lib$(MULTILIB_X86_32_SUFFIX)/libacl.so.?.?.? . \
	 )
	@mkdir -p $(ACL_32_PKG)/usr/bin/32
	@( cd $(ACL_32_PKG)/usr/bin ; \
	   mv chacl getfacl setfacl ./32 \
	 )
	@rm -rf $(ACL_32_PKG)/usr/include
	@rm -rf $(ACL_32_PKG)/usr/share
	# remove target path from target libtool *.la files
	@( cd $(ACL_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	  sed -i "s,$(TARGET_DEST_DIR),,g" libacl.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(ACL_32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# tune libtool *.la search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libacl.la ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libacl.la \
	 )
	@(cd $(ACL_32_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(ACL_32_PKG_DESCRIPTION_FILE): $(ACL_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(ACL_32_PKG_DESCRIPTION_FILE) $(ACL_32_PKG_INSTALL_SCRIPT)
	@cp $(ACL_32_PKG_DESCRIPTION_FILE) $(ACL_32_PKG)/.DESCRIPTION
	@cp $(ACL_32_PKG_INSTALL_SCRIPT) $(ACL_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(ACL_32_PKG)/.REQUIRES
	@echo "pkgname=$(ACL_32_PKG_NAME)"                            >  $(ACL_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(ACL_32_PKG_VERSION)"                          >> $(ACL_32_PKG)/.PKGINFO ; \
	 echo "arch=$(ACL_32_PKG_ARCH)"                               >> $(ACL_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(ACL_32_PKG_DISTRO_NAME)"                  >> $(ACL_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(ACL_32_PKG_DISTRO_VERSION)"                >> $(ACL_32_PKG)/.PKGINFO ; \
	 echo "group=$(ACL_32_PKG_GROUP)"                             >> $(ACL_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(ACL_32_PKG_SHORT_DESCRIPTION)\"" >> $(ACL_32_PKG)/.PKGINFO ; \
	 echo "url=$(ACL_32_PKG_URL)"                                 >> $(ACL_32_PKG)/.PKGINFO ; \
	 echo "license=$(ACL_32_PKG_LICENSE)"                         >> $(ACL_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(ACL_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
