
COMPONENT_TARGETS += $(TARGET_HOST)
COMPONENT_TARGETS += $(TARGET_PC64)

NEED_ABS_PATH      = true

COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = $(SRC_PACKAGE_DIR)/packages/l/libelf

REQUIRES           = libs/eglibc/2.18.1


version            = 0.8.13
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/libelf/libelf-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libelf-$(version)
src_dir_name       = libelf-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done
build_libelf32_pkg = $(TARGET_BUILD_DIR)/.libelf32_pkg_done


####### Targets

PKG_GROUP = libs
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LIBELF32_PKG_NAME                = libelf32
LIBELF32_PKG_VERSION             = 0.8.13
ifeq ($(HARDWARE),$(TARGET_HOST))
LIBELF32_PKG_ARCH                = $(shell uname -m)
else
LIBELF32_PKG_ARCH                = $(TOOLCHAIN)
endif
LIBELF32_PKG_DISTRO_NAME         = kxLab
LIBELF32_PKG_DISTRO_VERSION      = 1.0
LIBELF32_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
LIBELF32_PKG_SHORT_DESCRIPTION   = libelf32 $(version)
LIBELF32_PKG_URL                 = http://www.kxLab.com
LIBELF32_PKG_LICENSE             = GPLv2
LIBELF32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBELF32_PKG_NAME)-pkg-description
LIBELF32_PKG_DESCRIPTION_FILE_IN = $(LIBELF32_PKG_NAME)-pkg-description.in
LIBELF32_PKG_INSTALL_SCRIPT      = $(LIBELF32_PKG_NAME)-pkg-install.sh

LIBELF32_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBELF32_PKG_NAME)-package

pkg_basename     = $(LIBELF32_PKG_NAME)-$(LIBELF32_PKG_VERSION)-$(LIBELF32_PKG_ARCH)-$(LIBELF32_PKG_DISTRO_NAME)-$(LIBELF32_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(LIBELF32_PKG_GROUP)/$(pkg_basename).tgz


BUILD_TARGETS    = $(build_libelf32_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../build-system/core.mk


env_sysroot        = instroot=$(LIBELF32_PKG)


OPTIMIZATION_FLAGS = -O3

CC                += -m32

ARCH_FLAGS         = -m32 -g -O3 -march=i486 -mtune=i686

ifeq ($(TOOLCHAIN),$(X86_64_EGLIBC_TOOLCHAIN_NAME))
LIBSUFFIX          = 32
else
LIBSUFFIX          =
endif

TARGET32     = $(shell echo $(TARGET) | sed 's/x86_64/i486/')


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --disable-compat


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
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LIBELF32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) $(env_sysroot) install
	@rm -rf $(LIBELF32_PKG)/usr/include
	@rm -rf $(LIBELF32_PKG)/usr/share
	# Install the same to $(TARGET_DEST_DIR)
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(LIBELF32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# tune pkg-config *.pc search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libelf.pc \
	 )
	@(cd $(LIBELF32_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBELF32_PKG_DESCRIPTION_FILE): $(LIBELF32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(build_libelf32_pkg): $(install_target) $(LIBELF32_PKG_DESCRIPTION_FILE)
	@cp $(LIBELF32_PKG_DESCRIPTION_FILE) $(LIBELF32_PKG)/.DESCRIPTION
	@cp $(LIBELF32_PKG_INSTALL_SCRIPT) $(LIBELF32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBELF32_PKG)/.REQUIRES
	@echo "pkgname=$(LIBELF32_PKG_NAME)"                            >  $(LIBELF32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBELF32_PKG_VERSION)"                          >> $(LIBELF32_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBELF32_PKG_ARCH)"                               >> $(LIBELF32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBELF32_PKG_DISTRO_NAME)"                  >> $(LIBELF32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBELF32_PKG_DISTRO_VERSION)"                >> $(LIBELF32_PKG)/.PKGINFO ; \
	 echo "group=$(LIBELF32_PKG_GROUP)"                             >> $(LIBELF32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBELF32_PKG_SHORT_DESCRIPTION)\"" >> $(LIBELF32_PKG)/.PKGINFO ; \
	 echo "url=$(LIBELF32_PKG_URL)"                                 >> $(LIBELF32_PKG)/.PKGINFO ; \
	 echo "license=$(LIBELF32_PKG_LICENSE)"                         >> $(LIBELF32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBELF32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@
