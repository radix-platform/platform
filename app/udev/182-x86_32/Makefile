
COMPONENT_TARGETS += $(TARGET_PC64)

NEED_ABS_PATH      = true

COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = $(SRC_PACKAGE_DIR)/packages/a/udev

REQUIRES           = app/kmod/16
REQUIRES          += libs/pcre/8.34
REQUIRES          += app/util-linux/2.24.1
REQUIRES          += libs/glib2/2.40.0
REQUIRES          += app/usbutils/007
REQUIRES          += app/pciutils/3.2.1


version            = 182
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/a/udev/udev-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/udev-$(version)
src_dir_name       = udev-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done
build_udev32_pkg   = $(TARGET_BUILD_DIR)/.udev32_pkg_done


####### Targets

PKG_GROUP = app
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
UDEV32_PKG_NAME                = udev32
UDEV32_PKG_VERSION             = 182
UDEV32_PKG_ARCH                = $(TOOLCHAIN)
UDEV32_PKG_DISTRO_NAME         = kxLab
UDEV32_PKG_DISTRO_VERSION      = 1.0
UDEV32_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
UDEV32_PKG_SHORT_DESCRIPTION   = udev32 $(version)
UDEV32_PKG_URL                 = http://www.kxLab.com
UDEV32_PKG_LICENSE             = GPLv2
UDEV32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(UDEV32_PKG_NAME)-pkg-description
UDEV32_PKG_DESCRIPTION_FILE_IN = $(UDEV32_PKG_NAME)-pkg-description.in
UDEV32_PKG_INSTALL_SCRIPT      = $(UDEV32_PKG_NAME)-pkg-install.sh

UDEV32_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(UDEV32_PKG_NAME)-package

pkg_basename     = $(UDEV32_PKG_NAME)-$(UDEV32_PKG_VERSION)-$(UDEV32_PKG_ARCH)-$(UDEV32_PKG_DISTRO_NAME)-$(UDEV32_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(UDEV32_PKG_GROUP)/$(pkg_basename).tgz


BUILD_TARGETS    = $(build_udev32_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../build-system/core.mk


env_sysroot      = DESTDIR=$(UDEV32_PKG)


CC              += -m32
CXX             += -m32

CFLAGS          += -isystem $(TARGET_DEST_DIR)/usr/include -D__linux__

# owerwrite LDFLAGS:
#
LDFLAGS          = -L$(TARGET_DEST_DIR)/lib$(MULTILIB_X86_32_SUFFIX)
LDFLAGS         += -L$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)

# owerwrite PKG_CONFIG_PATH:
#
PKG_CONFIG_PATH  = $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig

ARCH_FLAGS       = -m32 -g -O3 -march=i486 -mtune=i686

TARGET32         = $(shell echo $(TARGET) | sed 's/x86_64/i486/')


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --with-rootlibdir=/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man

extra_configure_switches += --with-rootprefix=/
extra_configure_switches += --with-firmware-path=/lib/firmware/updates:/lib/firmware
extra_configure_switches += --with-usb-ids-path=/usr/share/hwdata
extra_configure_switches += --with-pci-ids-path=/usr/share/hwdata
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --bindir=/sbin
extra_configure_switches += --sbindir=/sbin
extra_configure_switches += --libexecdir=/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --enable-introspection=no
extra_configure_switches += --enable-floppy
extra_configure_switches += --enable-static
extra_configure_switches += --enable-rule_generator
extra_configure_switches += --with-systemdsystemunitdir=no


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) LIBS=-lrt ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(UDEV32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@rm -rf $(UDEV32_PKG)/etc
	@rm -rf $(UDEV32_PKG)/sbin
	@rm -rf $(UDEV32_PKG)/lib$(MULTILIB_X86_32_SUFFIX)/udev
	@rm -rf $(UDEV32_PKG)/usr/include
	@rm -rf $(UDEV32_PKG)/usr/share
	# remove target destination path from target libtool *.la files and pkgconfig *.pc files
	@( cd $(UDEV32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	  sed -i "s,$(TARGET_DEST_DIR),,g" libgudev-?.?.la libudev.la ; \
	  sed -i "s,-L/usr/lib ,,g" libgudev-?.?.la ; \
	  sed -i "s,-L/lib ,,g" libgudev-?.?.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(UDEV32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# tune libtool *.la search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libgudev-?.?.la libudev.la ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libgudev-?.?.la libudev.la \
	 )
	# tune pkg-config *.pc search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" gudev-?.?.pc libudev.pc \
	 )
	@(cd $(UDEV32_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(UDEV32_PKG_DESCRIPTION_FILE): $(UDEV32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(build_udev32_pkg): $(install_target) $(UDEV32_PKG_DESCRIPTION_FILE)
	@cp $(UDEV32_PKG_DESCRIPTION_FILE) $(UDEV32_PKG)/.DESCRIPTION
	@cp $(UDEV32_PKG_INSTALL_SCRIPT) $(UDEV32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(UDEV32_PKG)/.REQUIRES
	@echo "pkgname=$(UDEV32_PKG_NAME)"                            >  $(UDEV32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(UDEV32_PKG_VERSION)"                          >> $(UDEV32_PKG)/.PKGINFO ; \
	 echo "arch=$(UDEV32_PKG_ARCH)"                               >> $(UDEV32_PKG)/.PKGINFO ; \
	 echo "distroname=$(UDEV32_PKG_DISTRO_NAME)"                  >> $(UDEV32_PKG)/.PKGINFO ; \
	 echo "distrover=$(UDEV32_PKG_DISTRO_VERSION)"                >> $(UDEV32_PKG)/.PKGINFO ; \
	 echo "group=$(UDEV32_PKG_GROUP)"                             >> $(UDEV32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(UDEV32_PKG_SHORT_DESCRIPTION)\"" >> $(UDEV32_PKG)/.PKGINFO ; \
	 echo "url=$(UDEV32_PKG_URL)"                                 >> $(UDEV32_PKG)/.PKGINFO ; \
	 echo "license=$(UDEV32_PKG_LICENSE)"                         >> $(UDEV32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(UDEV32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@
