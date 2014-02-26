
COMPONENT_TARGETS  = $(TARGET_HOST)
COMPONENT_TARGETS += $(TARGET_PC32)
COMPONENT_TARGETS += $(TARGET_PC64)
COMPONENT_TARGETS += $(TARGET_CB1X)
COMPONENT_TARGETS += $(TARGET_VIP1830)
COMPONENT_TARGETS += $(TARGET_BEAGLE)
COMPONENT_TARGETS += $(TARGET_OMAP5UEVM)
COMPONENT_TARGETS += $(TARGET_B74)

#
# The rest targets links staticaly with newlib or uclibc and not requires eglibc libraties
#
# COMPONENT_TARGETS += $(TARGET_CB1N)
# COMPONENT_TARGETS += $(TARGET_GUARD)
# COMPONENT_TARGETS += $(TARGET_VIP1830N)
# COMPONENT_TARGETS += $(TARGET_L17UC)
#

NEED_ABS_PATH      = true

COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


version = 2.18.1

SOURCE_REQUIRES = $(SRC_PACKAGE_DIR)/GNU/EGLIBC/$(version)


# NOTE when we will create common kernel headers package we should move to dev/kernel/headers
REQUIRES        = base/pkgtool


tar_bz2_archive = $(SRC_PACKAGE_PATH)/GNU/EGLIBC/$(version)/eglibc-$(version).tar.bz2
tar_bz2_archive_ports = $(SRC_PACKAGE_PATH)/GNU/EGLIBC/2.18.1/eglibc-ports-2.18.1.tar.bz2

SRC_ARCHIVE       = $(tar_bz2_archive)
SRC_DIR           = $(TARGET_BUILD_DIR)/eglibc-$(version)
src_dir_name      = eglibc-$(version)
src_done          = $(TARGET_BUILD_DIR)/.source-done

PATCHES           = PATCHES

build_dir         = $(TARGET_BUILD_DIR)/build
install_target    = $(TARGET_BUILD_DIR)/.headers_installed

ifneq ($(filter $(TOOLCHAIN),$(X86_64_EGLIBC_TOOLCHAIN_NAME) $(BUILD_TOOLCHAIN_NAME)),)
build_32_dir      = $(TARGET_BUILD_DIR)/build32
install_32_target = $(TARGET_BUILD_DIR)/.headers_32_installed
endif

build_hdr_pkg     = $(TARGET_BUILD_DIR)/.headers_pkg_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
EGLIBC_H_DEV_PKG_NAME                = eglibc-headers
EGLIBC_H_DEV_PKG_VERSION             = 2.18.1
ifeq ($(HARDWARE),$(TARGET_HOST))
EGLIBC_H_DEV_PKG_ARCH                = $(shell uname -m)
else
EGLIBC_H_DEV_PKG_ARCH                = $(TOOLCHAIN)
endif
EGLIBC_H_DEV_PKG_DISTRO_NAME         = kxLab
EGLIBC_H_DEV_PKG_DISTRO_VERSION      = 1.0
EGLIBC_H_DEV_PKG_GROUP               = $(PKG_GROUP)
###                                   |---handy-ruler-------------------------------|
EGLIBC_H_DEV_PKG_SHORT_DESCRIPTION   = eglibc $(version) header files
EGLIBC_H_DEV_PKG_URL                 = http://www.kxLab.com
EGLIBC_H_DEV_PKG_LICENSE             = GPLv2
EGLIBC_H_DEV_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(EGLIBC_H_DEV_PKG_NAME)-pkg-description
EGLIBC_H_DEV_PKG_DESCRIPTION_FILE_IN = $(EGLIBC_H_DEV_PKG_NAME)-pkg-description.in
EGLIBC_H_DEV_PKG_INSTALL_SCRIPT      = $(EGLIBC_H_DEV_PKG_NAME)-pkg-install.sh

EGLIBC_H_DEV_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(EGLIBC_H_DEV_PKG_NAME)-package

pkg_basename     = $(EGLIBC_H_DEV_PKG_NAME)-$(EGLIBC_H_DEV_PKG_VERSION)-$(EGLIBC_H_DEV_PKG_ARCH)-$(EGLIBC_H_DEV_PKG_DISTRO_NAME)-$(EGLIBC_H_DEV_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(EGLIBC_H_DEV_PKG_GROUP)/$(pkg_basename).tgz


BUILD_TARGETS = $(build_hdr_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../build-system/core.mk


sysroot_dir  = $(EGLIBC_H_DEV_PKG)
env_sysroot  = install_root=$(sysroot_dir)

environment  = CFLAGS="-g -O3"

ifeq ($(TOOLCHAIN),$(BUILD_TOOLCHAIN_NAME))
LIBSUFFIX    = 64
else
LIBSUFFIX    =
endif

ifneq ($(filter $(TOOLCHAIN),$(X86_64_EGLIBC_TOOLCHAIN_NAME) $(BUILD_TOOLCHAIN_NAME)),)
CC32                   = $(TOOLCHAIN_PATH)/bin/$(TARGET)-gcc -m32
TARGET32               = $(shell echo $(TARGET) | sed 's/x86_64/i486/')
LIBSUFFIX32            = 32
endif

ifeq ($(TOOLCHAIN),$(BUILD_TOOLCHAIN_NAME))
CC32                   = gcc -m32
LIBSUFFIX32            =
endif

environment_32_compat  = CC="$(CC32)" CFLAGS="-g -O3 -march=i486 -mtune=i686"



# NOTE when we will create common kernel headers package we should move to $(TARGET_DEST_DIR)/usr/include
#extra_configure_switches  += --with-headers=$(TARGET_DEST_DIR)/usr/include

ifeq ($(TOOLCHAIN),$(BUILD_TOOLCHAIN_NAME))
extra_configure_switches  += --with-headers=/usr/include
else
extra_configure_switches  += --with-headers=$(TOOLCHAIN_PATH)/$(TARGET)/sys-root/usr/include
endif

extra_configure_switches  += --enable-add-ons=libidn,nptl,ports
extra_configure_switches  += --with-binutils=$(TOOLCHAIN_PATH)/bin
extra_configure_switches  += --enable-kernel=2.6.36
extra_configure_switches  += --disable-profile
extra_configure_switches  += --without-gd
extra_configure_switches  += --without-cvs
extra_configure_switches  += --with-tls
extra_configure_switches  += --with-__thread


ifeq ($(TOOLCHAIN),$(DM644X_EGLIBC_TOOLCHAIN_NAME))
extra_configure_switches  += --without-fp
endif



$(SRC_DIR): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(src_done): $(SRC_DIR)
	tar xjf $(tar_bz2_archive_ports) -C $<
	mv $(SRC_DIR)/eglibc-ports-2.18.1 $(SRC_DIR)/ports
	touch $@

$(build_dir): $(src_done)
	mkdir -p $@

$(build_32_dir): $(src_done)
	mkdir -p $@

$(EGLIBC_H_DEV_PKG): $(build_dir) $(build_32_dir)
	@mkdir -p $@

$(install_32_target): $(EGLIBC_H_DEV_PKG)
	@cd $(build_32_dir) && $(env_sysroot) $(BUILD_ENVIRONMENT) $(environment_32_compat) ../$(src_dir_name)/configure \
	  --prefix=/usr                   \
	  --build=$(BUILD)                \
	  --host=$(TARGET32)              \
	  --libdir=/usr/lib$(LIBSUFFIX32) \
	  $(extra_configure_switches)
	@cd $(build_32_dir) && $(MAKE) install-headers \
	                              install-bootstrap-headers=yes $(env_sysroot)
	@cd $(build_32_dir) && $(BUILD_ENVIRONMENT) $(environment_32_compat) $(MAKE) csu/subdir_lib
	@cd $(build_32_dir) && $(BUILD_ENVIRONMENT) $(environment_32_compat) $(MAKE) csu/subdir_install $(env_sysroot)
	@$(BUILD_ENVIRONMENT) $(environment_32_compat) $(CC32) -nostdlib -nostartfiles -shared -x c /dev/null \
	                                                       -o $(sysroot_dir)/usr/lib$(LIBSUFFIX32)/libc.so
	@touch $@

$(install_target): $(EGLIBC_H_DEV_PKG) $(install_32_target)
	@cd $(build_dir) && $(env_sysroot) $(BUILD_ENVIRONMENT) $(environment) ../$(src_dir_name)/configure \
	  --prefix=/usr                 \
	  --build=$(BUILD)              \
	  --host=$(TARGET)              \
	  --libdir=/usr/lib$(LIBSUFFIX) \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(MAKE) install-headers \
	                           install-bootstrap-headers=yes $(env_sysroot)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(environment) $(MAKE) csu/subdir_lib
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(environment) $(MAKE) csu/subdir_install $(env_sysroot)
	@$(BUILD_ENVIRONMENT) $(environment) $(CC) -nostdlib -nostartfiles -shared -x c /dev/null \
	                                           -o $(sysroot_dir)/usr/lib$(LIBSUFFIX)/libc.so
	@touch $@


$(EGLIBC_H_DEV_PKG_DESCRIPTION_FILE): $(EGLIBC_H_DEV_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@


$(build_hdr_pkg): $(install_target) $(EGLIBC_H_DEV_PKG_DESCRIPTION_FILE)
	# Install the same to $(TARGET_DEST_DIR)
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(EGLIBC_H_DEV_PKG) && cp -rf * $(TARGET_DEST_DIR)
	@cd $(EGLIBC_H_DEV_PKG) && rm -rf usr/lib$(LIBSUFFIX)
ifneq ($(filter $(TOOLCHAIN),$(X86_64_EGLIBC_TOOLCHAIN_NAME) $(BUILD_TOOLCHAIN_NAME)),)
	@cd $(EGLIBC_H_DEV_PKG) && rm -rf usr/lib$(LIBSUFFIX32)
endif
	@cp $(EGLIBC_H_DEV_PKG_DESCRIPTION_FILE) $(EGLIBC_H_DEV_PKG)/.DESCRIPTION
	@cp $(EGLIBC_H_DEV_PKG_INSTALL_SCRIPT) $(EGLIBC_H_DEV_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(EGLIBC_H_DEV_PKG)/.REQUIRES
	@echo "pkgname=$(EGLIBC_H_DEV_PKG_NAME)"                            >  $(EGLIBC_H_DEV_PKG)/.PKGINFO ; \
	 echo "pkgver=$(EGLIBC_H_DEV_PKG_VERSION)"                          >> $(EGLIBC_H_DEV_PKG)/.PKGINFO ; \
	 echo "arch=$(EGLIBC_H_DEV_PKG_ARCH)"                               >> $(EGLIBC_H_DEV_PKG)/.PKGINFO ; \
	 echo "distroname=$(EGLIBC_H_DEV_PKG_DISTRO_NAME)"                  >> $(EGLIBC_H_DEV_PKG)/.PKGINFO ; \
	 echo "distrover=$(EGLIBC_H_DEV_PKG_DISTRO_VERSION)"                >> $(EGLIBC_H_DEV_PKG)/.PKGINFO ; \
	 echo "group=$(EGLIBC_H_DEV_PKG_GROUP)"                             >> $(EGLIBC_H_DEV_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(EGLIBC_H_DEV_PKG_SHORT_DESCRIPTION)\"" >> $(EGLIBC_H_DEV_PKG)/.PKGINFO ; \
	 echo "url=$(EGLIBC_H_DEV_PKG_URL)"                                 >> $(EGLIBC_H_DEV_PKG)/.PKGINFO ; \
	 echo "license=$(EGLIBC_H_DEV_PKG_LICENSE)"                         >> $(EGLIBC_H_DEV_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(EGLIBC_H_DEV_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@
