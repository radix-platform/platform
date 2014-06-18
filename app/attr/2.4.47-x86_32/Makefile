
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/attr

REQUIRES           = app/attr/2.4.47
REQUIRES          += libs/eglibc/2.19.1-x86_32


version            = 2.4.47
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/a/attr/attr-$(version).src.tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/attr-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
ATTR_32_PKG_NAME                = attr-x32
ATTR_32_PKG_VERSION             = 2.4.47
ATTR_32_PKG_ARCH                = $(TOOLCHAIN)
ATTR_32_PKG_DISTRO_NAME         = kxLab
ATTR_32_PKG_DISTRO_VERSION      = 1.0
ATTR_32_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
ATTR_32_PKG_SHORT_DESCRIPTION   = attr-x32 $(version)
ATTR_32_PKG_URL                 = http://www.kxLab.com
ATTR_32_PKG_LICENSE             = GPLv2
ATTR_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(ATTR_32_PKG_NAME)-pkg-description
ATTR_32_PKG_DESCRIPTION_FILE_IN = $(ATTR_32_PKG_NAME)-pkg-description.in
ATTR_32_PKG_INSTALL_SCRIPT      = $(ATTR_32_PKG_NAME)-pkg-install.sh

ATTR_32_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(ATTR_32_PKG_NAME)-package

pkg_basename     = $(ATTR_32_PKG_NAME)-$(ATTR_32_PKG_VERSION)-$(ATTR_32_PKG_ARCH)-$(ATTR_32_PKG_DISTRO_NAME)-$(ATTR_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))


BUILD_TARGETS    = $(build_attr32_pkg)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DIST_ROOT=$(ATTR_32_PKG)

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
	@mkdir -p $(ATTR_32_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) install-dev $(env_sysroot)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) install-lib $(env_sysroot)
	@mkdir -p $(ATTR_32_PKG)/lib$(MULTILIB_X86_32_SUFFIX)
	@( cd $(ATTR_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   chmod 755 libattr.so.?.?.? *.la ; \
	   cp -a libattr.so.? $(ATTR_32_PKG)/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   mv libattr.so.?.?.? $(ATTR_32_PKG)/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   ln -sf ../../lib$(MULTILIB_X86_32_SUFFIX)/libattr.so.?.?.? . \
	 )
	@mkdir -p $(ATTR_32_PKG)/usr/bin/32
	@( cd $(ATTR_32_PKG)/usr/bin ; \
	   mv attr getfattr setfattr ./32 \
	 )
	@rm -rf $(ATTR_32_PKG)/usr/include
	@rm -rf $(ATTR_32_PKG)/usr/share
	# remove target path from target libtool *.la files
	@( cd $(ATTR_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	  sed -i "s,$(TARGET_DEST_DIR),,g" libattr.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(ATTR_32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# tune libtool *.la search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libattr.la ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libattr.la \
	 )
	@(cd $(ATTR_32_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(ATTR_32_PKG_DESCRIPTION_FILE): $(ATTR_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(ATTR_32_PKG_DESCRIPTION_FILE) $(ATTR_32_PKG_INSTALL_SCRIPT)
	@cp $(ATTR_32_PKG_DESCRIPTION_FILE) $(ATTR_32_PKG)/.DESCRIPTION
	@cp $(ATTR_32_PKG_INSTALL_SCRIPT) $(ATTR_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(ATTR_32_PKG)/.REQUIRES
	@echo "pkgname=$(ATTR_32_PKG_NAME)"                            >  $(ATTR_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(ATTR_32_PKG_VERSION)"                          >> $(ATTR_32_PKG)/.PKGINFO ; \
	 echo "arch=$(ATTR_32_PKG_ARCH)"                               >> $(ATTR_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(ATTR_32_PKG_DISTRO_NAME)"                  >> $(ATTR_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(ATTR_32_PKG_DISTRO_VERSION)"                >> $(ATTR_32_PKG)/.PKGINFO ; \
	 echo "group=$(ATTR_32_PKG_GROUP)"                             >> $(ATTR_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(ATTR_32_PKG_SHORT_DESCRIPTION)\"" >> $(ATTR_32_PKG)/.PKGINFO ; \
	 echo "url=$(ATTR_32_PKG_URL)"                                 >> $(ATTR_32_PKG)/.PKGINFO ; \
	 echo "license=$(ATTR_32_PKG_LICENSE)"                         >> $(ATTR_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(ATTR_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
