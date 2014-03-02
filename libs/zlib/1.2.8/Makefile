
COMPONENT_TARGETS  = $(TARGET_HOST)
COMPONENT_TARGETS += $(TARGET_PC32)
COMPONENT_TARGETS += $(TARGET_PC64)
COMPONENT_TARGETS += $(TARGET_CB1X)
COMPONENT_TARGETS += $(TARGET_VIP1830)
COMPONENT_TARGETS += $(TARGET_BEAGLE)
COMPONENT_TARGETS += $(TARGET_OMAP5UEVM)
COMPONENT_TARGETS += $(TARGET_B74)

#
# The rest targets links staticaly with newlib or uclibc and not requires zlib libraties
#
# COMPONENT_TARGETS += $(TARGET_CB1N)
# COMPONENT_TARGETS += $(TARGET_GUARD)
# COMPONENT_TARGETS += $(TARGET_VIP1830N)
# COMPONENT_TARGETS += $(TARGET_L17UC)
#


NEED_ABS_PATH      = true

COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = $(SRC_PACKAGE_DIR)/packages/l/zlib


ifneq ($(filter $(TOOLCHAIN),$(X86_64_EGLIBC_TOOLCHAIN_NAME) $(BUILD_TOOLCHAIN_NAME)),)
REQUIRES           = libs/zlib/1.2.8-x86_32
else
REQUIRES           = libs/eglibc/2.18.1
endif

version            = 1.2.8
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/zlib/zlib-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/zlib-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done
build_zlib_pkg     = $(TARGET_BUILD_DIR)/.zlib_pkg_done



####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
ZLIB_PKG_NAME                = zlib
ZLIB_PKG_VERSION             = 1.2.8
ifeq ($(HARDWARE),$(TARGET_HOST))
ZLIB_PKG_ARCH                = $(shell uname -m)
else
ZLIB_PKG_ARCH                = $(TOOLCHAIN)
endif
ZLIB_PKG_DISTRO_NAME         = kxLab
ZLIB_PKG_DISTRO_VERSION      = 1.0
ZLIB_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
ZLIB_PKG_SHORT_DESCRIPTION   = zlib $(version)
ZLIB_PKG_URL                 = http://www.kxLab.com
ZLIB_PKG_LICENSE             = GPLv2
ZLIB_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(ZLIB_PKG_NAME)-pkg-description
ZLIB_PKG_DESCRIPTION_FILE_IN = $(ZLIB_PKG_NAME)-pkg-description.in
ZLIB_PKG_INSTALL_SCRIPT      = $(ZLIB_PKG_NAME)-pkg-install.sh

ZLIB_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(ZLIB_PKG_NAME)-package

pkg_basename     = $(ZLIB_PKG_NAME)-$(ZLIB_PKG_VERSION)-$(ZLIB_PKG_ARCH)-$(ZLIB_PKG_DISTRO_NAME)-$(ZLIB_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(ZLIB_PKG_GROUP)/$(pkg_basename).tgz


BUILD_TARGETS    = $(build_zlib_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../build-system/core.mk


env_sysroot       = DESTDIR=$(ZLIB_PKG)
cross_environment = CROSS_PREFIX=$(CROSS_PREFIX)


ifeq ($(TOOLCHAIN),$(BUILD_TOOLCHAIN_NAME))
LIBSUFFIX=64
else
LIBSUFFIX=
endif

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
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) $(cross_environment) install $(env_sysroot)
	@mkdir -p $(ZLIB_PKG)/lib$(LIBSUFFIX)
	@( cd $(ZLIB_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in lib*.so.?.* ; do \
	     mv $$file ../../lib$(LIBSUFFIX) ; \
	     ln -sf ../../lib$(LIBSUFFIX)/$$file . ; \
	   done ; \
	   cp -a lib*.so.? ../../lib$(LIBSUFFIX) ; \
	 )
	@mkdir -p $(ZLIB_PKG)/usr/doc/zlib-$(version)
	@cp -a $(SRC_DIR)/ChangeLog $(SRC_DIR)/FAQ $(SRC_DIR)/INDEX $(SRC_DIR)/README \
	       $(ZLIB_PKG)/usr/doc/zlib-$(version)
	@mkdir -p $(ZLIB_PKG)/usr/share/doc/zlib-$(version)
	@cp -a $(SRC_DIR)/doc/*.txt \
	       $(ZLIB_PKG)/usr/share/doc/zlib-$(version)
	@(cd $(ZLIB_PKG)/usr/share/man/man3; \
	  for file in *.3 ; do \
	    gzip -9 --force $$file; \
	  done )
	# Install the same to $(TARGET_DEST_DIR)
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(ZLIB_PKG) && cp -rf * $(TARGET_DEST_DIR)
	@(cd $(ZLIB_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(ZLIB_PKG_DESCRIPTION_FILE): $(ZLIB_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(build_zlib_pkg): $(install_target) $(ZLIB_PKG_DESCRIPTION_FILE)
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
	@touch $@