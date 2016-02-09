
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/eudev-git

REQUIRES           = libs/eudev/3.1.5
REQUIRES          += app/util-linux/2.27.1-x86_32
REQUIRES          += app/kmod/22-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 3.1.5
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/a/eudev-git/eudev-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/eudev-$(version)
src_dir_name       = eudev-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
EUDEV_32_PKG_NAME                = libeudev-x32
EUDEV_32_PKG_VERSION             = 3.1.5
EUDEV_32_PKG_ARCH                = $(TOOLCHAIN)
EUDEV_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
EUDEV_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
EUDEV_32_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
EUDEV_32_PKG_SHORT_DESCRIPTION   = libraries for eudev
EUDEV_32_PKG_URL                 = $(BUG_URL)
EUDEV_32_PKG_LICENSE             = GPLv2
EUDEV_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(EUDEV_32_PKG_NAME)-pkg-description
EUDEV_32_PKG_DESCRIPTION_FILE_IN = $(EUDEV_32_PKG_NAME)-pkg-description.in
EUDEV_32_PKG_INSTALL_SCRIPT      = $(EUDEV_32_PKG_NAME)-pkg-install.sh

EUDEV_32_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(EUDEV_32_PKG_NAME)-package

pkg_basename     = $(EUDEV_32_PKG_NAME)-$(EUDEV_32_PKG_VERSION)-$(EUDEV_32_PKG_ARCH)-$(EUDEV_32_PKG_DISTRO_NAME)-$(EUDEV_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot      = DESTDIR=$(EUDEV_32_PKG)

CFLAGS          += -isystem $(TARGET_DEST_DIR)/usr/include -D__linux__


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(doc_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --with-rootprefix=/
extra_configure_switches += --with-rootlibdir=/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --with-rootlibexecdir=/lib/udev
extra_configure_switches += --with-rootrundir=/run

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --bindir=/sbin
extra_configure_switches += --sbindir=/sbin
extra_configure_switches += --libexecdir=/lib

extra_configure_switches += --with-usb-ids-path=/usr/share/hwdata
extra_configure_switches += --with-pci-ids-path=/usr/share/hwdata

extra_configure_switches += --enable-hwdb
extra_configure_switches += --enable-rule-generator
extra_configure_switches += --enable-kmod
extra_configure_switches += --enable-manpages
extra_configure_switches += --disable-selinux

extra_configure_switches += --enable-static
extra_configure_switches += --with-gnu-ld


LDFLAGS += -Wl,-rpath,/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib/../lib$(MULTILIB_X86_32_SUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@( cd $(SRC_DIR) ; \
	   ./autogen.sh ; \
	 )
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
	@mkdir -p $(EUDEV_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(EUDEV_32_PKG)/etc
	@rm -rf $(EUDEV_32_PKG)/sbin
	@rm -rf $(EUDEV_32_PKG)/lib/udev
	@if [ -n "$(MULTILIB_X86_32_SUFFIX)" ] ; then \
	   rm -rf $(EUDEV_32_PKG)/lib ; \
	 fi
	@rm -rf $(EUDEV_32_PKG)/usr/include
	@rm -rf $(EUDEV_32_PKG)/usr/share
	@( cd $(EUDEV_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   rm -f libudev.so ; \
	   cp -a  ../../lib$(MULTILIB_X86_32_SUFFIX)/libudev.so.? . ; \
	   ln -sf ../../lib$(MULTILIB_X86_32_SUFFIX)/libudev.so.?.?.?  . ; \
	   ln -sf libudev.so.?.?.? libudev.so ; \
	 )
	# ======= remove target destination path from target libtool *.la files and pkgconfig *.pc files =======
	@( cd $(EUDEV_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libudev.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(EUDEV_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libudev.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libudev.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libudev.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(EUDEV_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(EUDEV_32_PKG_DESCRIPTION_FILE): $(EUDEV_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(EUDEV_32_PKG_DESCRIPTION_FILE) $(EUDEV_32_PKG_INSTALL_SCRIPT)
	@cp $(EUDEV_32_PKG_DESCRIPTION_FILE) $(EUDEV_32_PKG)/.DESCRIPTION
	@cp $(EUDEV_32_PKG_INSTALL_SCRIPT) $(EUDEV_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(EUDEV_32_PKG)/.REQUIRES
	@echo "pkgname=$(EUDEV_32_PKG_NAME)"                            >  $(EUDEV_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(EUDEV_32_PKG_VERSION)"                          >> $(EUDEV_32_PKG)/.PKGINFO ; \
	 echo "arch=$(EUDEV_32_PKG_ARCH)"                               >> $(EUDEV_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(EUDEV_32_PKG_DISTRO_NAME)"                  >> $(EUDEV_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(EUDEV_32_PKG_DISTRO_VERSION)"                >> $(EUDEV_32_PKG)/.PKGINFO ; \
	 echo "group=$(EUDEV_32_PKG_GROUP)"                             >> $(EUDEV_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(EUDEV_32_PKG_SHORT_DESCRIPTION)\"" >> $(EUDEV_32_PKG)/.PKGINFO ; \
	 echo "url=$(EUDEV_32_PKG_URL)"                                 >> $(EUDEV_32_PKG)/.PKGINFO ; \
	 echo "license=$(EUDEV_32_PKG_LICENSE)"                         >> $(EUDEV_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(EUDEV_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
