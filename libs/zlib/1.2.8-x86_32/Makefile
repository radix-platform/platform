
COMPONENT_TARGETS += $(TARGET_HOST)
COMPONENT_TARGETS += $(TARGET_PC64)

NEED_ABS_PATH      = true

COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = $(SRC_PACKAGE_DIR)/packages/l/zlib

REQUIRES           = base/pkgtool


version            = 1.2.8
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/zlib/zlib-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/zlib-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(CURDIR)/$(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done
build_zlib32_pkg   = $(TARGET_BUILD_DIR)/.zlib32_pkg_done


env_sysroot        = DESTDIR=$(ZLIB32_BIN_PKG)
cross_environment  = CROSS_PREFIX=$(CROSS_PREFIX)

LIBSUFFIX =

environment               = CFLAGS="-m32 -g -O3 -march=i486 -mtune=i686"

ifeq ($(TOOLCHAIN),$(X86_64_EGLIBC_TOOLCHAIN_NAME))
LIBSUFFIX                 = 32
endif

extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --shared


####### Targets

PKG_GROUP = libs
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
ZLIB32_PKG_NAME                = zlib32
ZLIB32_PKG_VERSION             = 1.2.8
ifeq ($(HARDWARE),$(TARGET_HOST))
ZLIB32_PKG_ARCH                = $(shell uname -m)
else
ZLIB32_PKG_ARCH                = $(TOOLCHAIN)
endif
ZLIB32_PKG_DISTRO_NAME         = kxLab
ZLIB32_PKG_DISTRO_VERSION      = 1.0
ZLIB32_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
ZLIB32_PKG_SHORT_DESCRIPTION   = zlib $(version)
ZLIB32_PKG_URL                 = http://www.kxLab.com
ZLIB32_PKG_LICENSE             = GPLv2
ZLIB32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(ZLIB32_PKG_NAME)-pkg-description
ZLIB32_PKG_DESCRIPTION_FILE_IN = $(ZLIB32_PKG_NAME)-pkg-description.in
ZLIB32_PKG_INSTALL_SCRIPT      = $(ZLIB32_PKG_NAME)-pkg-install.sh

ZLIB32_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(ZLIB32_PKG_NAME)-package

pkg_basename     = $(ZLIB32_PKG_NAME)-$(ZLIB32_PKG_VERSION)-$(ZLIB32_PKG_ARCH)-$(ZLIB32_PKG_DISTRO_NAME)-$(ZLIB32_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(ZLIB32_PKG_GROUP)/$(pkg_basename).tgz


BUILD_TARGETS   += $(build_zlib32_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../build-system/core.mk


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_dir): $(src_done)
	mkdir -p $@

$(build_target): $(build_dir)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) \
	  $(environment) ./configure \
	  --prefix=/usr                    \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(environment) $(MAKE) $(cross_environment)
	@touch $@

$(ZLIB32_PKG): $(build_target)
	@mkdir -p $@

$(install_target): $(ZLIB32_PKG)
	@mkdir -p $(ZLIB32_PKG)/usr/lib$(LIBSUFFIX)
	@cd $(SRC_DIR) && cp -a libz.a libz.so* $(ZLIB32_PKG)/usr/lib$(LIBSUFFIX)
	@chmod 755 $(ZLIB32_PKG)/usr/lib$(LIBSUFFIX)/*
	@chmod 644 $(ZLIB32_PKG)/usr/lib$(LIBSUFFIX)/libz.a
	@mkdir -p $(ZLIB32_PKG)/usr/lib$(LIBSUFFIX)/pkgconfig
	@cd $(SRC_DIR) && cat zlib.pc > $(ZLIB32_PKG)/usr/lib$(LIBSUFFIX)/pkgconfig/zlib.pc
	@mkdir -p $(ZLIB32_PKG)/lib$(LIBSUFFIX)
	@( cd $(ZLIB32_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in lib*.so.?.* ; do \
	     mv $$file ../../lib$(LIBSUFFIX) ; \
	     ln -sf ../../lib$(LIBSUFFIX)/$$file . ; \
	   done ; \
	   cp -a lib*.so.? ../../lib$(LIBSUFFIX) ; \
	 )
	# Install the same to $(TARGET_DEST_DIR)
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(ZLIB32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	@(cd $(ZLIB32_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(ZLIB32_PKG_DESCRIPTION_FILE): $(ZLIB32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(build_zlib32_pkg): $(install_target) $(ZLIB32_PKG_DESCRIPTION_FILE)
	@cp $(ZLIB32_PKG_DESCRIPTION_FILE) $(ZLIB32_PKG)/.DESCRIPTION
	@cp $(ZLIB32_PKG_INSTALL_SCRIPT) $(ZLIB32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(ZLIB32_PKG)/.REQUIRES
	@echo "pkgname=$(ZLIB32_PKG_NAME)"                            >  $(ZLIB32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(ZLIB32_PKG_VERSION)"                          >> $(ZLIB32_PKG)/.PKGINFO ; \
	 echo "arch=$(ZLIB32_PKG_ARCH)"                               >> $(ZLIB32_PKG)/.PKGINFO ; \
	 echo "distroname=$(ZLIB32_PKG_DISTRO_NAME)"                  >> $(ZLIB32_PKG)/.PKGINFO ; \
	 echo "distrover=$(ZLIB32_PKG_DISTRO_VERSION)"                >> $(ZLIB32_PKG)/.PKGINFO ; \
	 echo "group=$(ZLIB32_PKG_GROUP)"                             >> $(ZLIB32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(ZLIB32_PKG_SHORT_DESCRIPTION)\"" >> $(ZLIB32_PKG)/.PKGINFO ; \
	 echo "url=$(ZLIB32_PKG_URL)"                                 >> $(ZLIB32_PKG)/.PKGINFO ; \
	 echo "license=$(ZLIB32_PKG_LICENSE)"                         >> $(ZLIB32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(ZLIB32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@
