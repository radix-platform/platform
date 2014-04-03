
COMPONENT_TARGETS  += $(TARGET_PC64)

NEED_ABS_PATH       = true

COMPONENT_IS_3PP    = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES     = $(SRC_PACKAGE_DIR)/packages/n/openssl

REQUIRES            = libs/zlib/1.2.8
REQUIRES           += libs/gmp/5.1.3


version             = 1.0.1f
tar_gz_archive      = $(SRC_PACKAGE_PATH)/packages/n/openssl/openssl-$(version).tar.gz
SRC_ARCHIVE         = $(tar_gz_archive)
SRC_DIR             = $(TARGET_BUILD_DIR)/openssl-$(version)
src_dir_name        = openssl-$(version)
src_done            = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir           = $(TARGET_BUILD_DIR)/build
build_target        = $(TARGET_BUILD_DIR)/.build_done
install_target      = $(TARGET_BUILD_DIR)/.install_done
build_openssl32_pkg = $(TARGET_BUILD_DIR)/.openssl32_pkg_done


####### Targets

PKG_GROUP = net
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
OPENSSL32_PKG_NAME                = openssl32
OPENSSL32_PKG_VERSION             = 1.0.1f
OPENSSL32_PKG_ARCH                = $(TOOLCHAIN)
OPENSSL32_PKG_DISTRO_NAME         = kxLab
OPENSSL32_PKG_DISTRO_VERSION      = 1.0
OPENSSL32_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
OPENSSL32_PKG_SHORT_DESCRIPTION   = openssl32 $(version)
OPENSSL32_PKG_URL                 = http://www.kxLab.com
OPENSSL32_PKG_LICENSE             = GPLv2
OPENSSL32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(OPENSSL32_PKG_NAME)-pkg-description
OPENSSL32_PKG_DESCRIPTION_FILE_IN = $(OPENSSL32_PKG_NAME)-pkg-description.in
OPENSSL32_PKG_INSTALL_SCRIPT      = $(OPENSSL32_PKG_NAME)-pkg-install.sh

OPENSSL32_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(OPENSSL32_PKG_NAME)-package

pkg_basename     = $(OPENSSL32_PKG_NAME)-$(OPENSSL32_PKG_VERSION)-$(OPENSSL32_PKG_ARCH)-$(OPENSSL32_PKG_DISTRO_NAME)-$(OPENSSL32_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(OPENSSL32_PKG_GROUP)/$(pkg_basename).tgz


BUILD_TARGETS    = $(build_openssl32_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../build-system/core.mk


env_sysroot  = INSTALL_PREFIX=$(OPENSSL32_PKG)


CC          += -m32
CXX         += -m32

# owerwrite LDFLAGS:
#
LDFLAGS      = -L$(TARGET_DEST_DIR)/lib$(MULTILIB_X86_32_SUFFIX)
LDFLAGS     += -L$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)

ARCH_FLAGS   = -m32 -g -O3 -march=i486 -mtune=i686

TARGET32     = $(shell echo $(TARGET) | sed 's/x86_64/i486/')


extra_configure_switches  = --libdir=lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --openssldir=/etc/ssl
extra_configure_switches += no-idea
extra_configure_switches += no-rc5
extra_configure_switches += no-sse2
extra_configure_switches += zlib-dynamic
extra_configure_switches += shared

openssl_environment = MACHINE=i486 SYSTEM=Linux

####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(openssl_environment) ./config \
	  --prefix=/usr               \
	  $(extra_configure_switches) \
	  $(ARCH_FLAGS)               \
	  $(HW_FLAGS)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(OPENSSL32_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) MANDIR=/usr/share/man install $(env_sysroot)
	@mkdir -p $(OPENSSL32_PKG)/usr/bin/32
	@( cd $(OPENSSL32_PKG)/usr/bin ; \
	   find . -type f | xargs mv -t 32 ; \
	 )
	@mkdir -p $(OPENSSL32_PKG)/lib$(MULTILIB_X86_32_SUFFIX)
	@( cd $(OPENSSL32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   chmod +w lib*.so.?.?.? ; \
	   mv lib*.so.?.?.? ../../lib$(MULTILIB_X86_32_SUFFIX) ; \
	   ln -sf ../../lib$(MULTILIB_X86_32_SUFFIX)/lib*.so.?.?.? . ; \
	   ln -sf libcrypto.so.?.?.? libcrypto.so.1 ; \
	   ln -sf libssl.so.?.?.? libssl.so.1 ; \
	   cp -a lib*.so.? ../../lib$(MULTILIB_X86_32_SUFFIX) ; \
	 )
	@rm -rf $(OPENSSL32_PKG)/etc
	@rm -rf $(OPENSSL32_PKG)/usr/include
	@rm -rf $(OPENSSL32_PKG)/usr/share
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(OPENSSL32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# tune pkg-config *.pc search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libcrypto.pc libssl.pc openssl.pc \
	 )
	@( cd $(OPENSSL32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(OPENSSL32_PKG_DESCRIPTION_FILE): $(OPENSSL32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(build_openssl32_pkg): $(install_target) $(OPENSSL32_PKG_DESCRIPTION_FILE)
	@cp $(OPENSSL32_PKG_DESCRIPTION_FILE) $(OPENSSL32_PKG)/.DESCRIPTION
	@cp $(OPENSSL32_PKG_INSTALL_SCRIPT) $(OPENSSL32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(OPENSSL32_PKG)/.REQUIRES
	@echo "pkgname=$(OPENSSL32_PKG_NAME)"                            >  $(OPENSSL32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(OPENSSL32_PKG_VERSION)"                          >> $(OPENSSL32_PKG)/.PKGINFO ; \
	 echo "arch=$(OPENSSL32_PKG_ARCH)"                               >> $(OPENSSL32_PKG)/.PKGINFO ; \
	 echo "distroname=$(OPENSSL32_PKG_DISTRO_NAME)"                  >> $(OPENSSL32_PKG)/.PKGINFO ; \
	 echo "distrover=$(OPENSSL32_PKG_DISTRO_VERSION)"                >> $(OPENSSL32_PKG)/.PKGINFO ; \
	 echo "group=$(OPENSSL32_PKG_GROUP)"                             >> $(OPENSSL32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(OPENSSL32_PKG_SHORT_DESCRIPTION)\"" >> $(OPENSSL32_PKG)/.PKGINFO ; \
	 echo "url=$(OPENSSL32_PKG_URL)"                                 >> $(OPENSSL32_PKG)/.PKGINFO ; \
	 echo "license=$(OPENSSL32_PKG_LICENSE)"                         >> $(OPENSSL32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(OPENSSL32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@
