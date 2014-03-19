
COMPONENT_TARGETS += $(TARGET_PC64)

NEED_ABS_PATH      = true

COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = $(SRC_PACKAGE_DIR)/packages/a/xz

REQUIRES           = libs/eglibc/2.18.1


version            = 5.0.5
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/a/xz/xz-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/xz-$(version)
src_dir_name       = xz-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done
build_xz32_pkg     = $(TARGET_BUILD_DIR)/.xz32_pkg_done


####### Targets

PKG_GROUP = app
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
XZ32_PKG_NAME                = xz32
XZ32_PKG_VERSION             = 5.0.5
XZ32_PKG_ARCH                = $(TOOLCHAIN)
XZ32_PKG_DISTRO_NAME         = kxLab
XZ32_PKG_DISTRO_VERSION      = 1.0
XZ32_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
XZ32_PKG_SHORT_DESCRIPTION   = xz32 $(version)
XZ32_PKG_URL                 = http://www.kxLab.com
XZ32_PKG_LICENSE             = GPLv2
XZ32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(XZ32_PKG_NAME)-pkg-description
XZ32_PKG_DESCRIPTION_FILE_IN = $(XZ32_PKG_NAME)-pkg-description.in
XZ32_PKG_INSTALL_SCRIPT      = $(XZ32_PKG_NAME)-pkg-install.sh

XZ32_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(XZ32_PKG_NAME)-package

pkg_basename     = $(XZ32_PKG_NAME)-$(XZ32_PKG_VERSION)-$(XZ32_PKG_ARCH)-$(XZ32_PKG_DISTRO_NAME)-$(XZ32_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(XZ32_PKG_GROUP)/$(pkg_basename).tgz


BUILD_TARGETS    = $(build_xz32_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../build-system/core.mk


env_sysroot        = DESTDIR=$(XZ32_PKG)


OPTIMIZATION_FLAGS = -O3

ARCH_FLAGS         = -m32 -g -O3 -march=i486 -mtune=i686

TARGET32           = $(shell echo $(TARGET) | sed 's/x86_64/i486/')


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --program-prefix=
extra_configure_switches += --program-suffix=
extra_configure_switches += --disable-rpath
extra_configure_switches += --enable-shared
# uncomment next line to prevent building static *.a library:
# extra_configure_switches += --disable-static


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
	@mkdir -p $(XZ32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) $(env_sysroot) install
	# Move 32-Bit binaries into /usr/bin/32 directory
	@mkdir -p $(XZ32_PKG)/usr/bin/32
	@mv $(XZ32_PKG)/usr/bin/{l,u,x}* $(XZ32_PKG)/usr/bin/32
	@rm -rf $(XZ32_PKG)/usr/include
	@rm -rf $(XZ32_PKG)/usr/share
	# remove toolchain path from target libtool *.la files and
	@( cd $(XZ32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	  sed -i "s,$(TARGET_DEST_DIR),,g" liblzma.la  \
	 )
	# Install the same to $(TARGET_DEST_DIR)
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(XZ32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# tune libtool *.la search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" liblzma.la ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" liblzma.la \
	 )
	# tune pkg-config *.pc search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" liblzma.pc \
	 )
	@(cd $(XZ32_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(XZ32_PKG_DESCRIPTION_FILE): $(XZ32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(build_xz32_pkg): $(install_target) $(XZ32_PKG_DESCRIPTION_FILE)
	@cp $(XZ32_PKG_DESCRIPTION_FILE) $(XZ32_PKG)/.DESCRIPTION
	@cp $(XZ32_PKG_INSTALL_SCRIPT) $(XZ32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(XZ32_PKG)/.REQUIRES
	@echo "pkgname=$(XZ32_PKG_NAME)"                            >  $(XZ32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(XZ32_PKG_VERSION)"                          >> $(XZ32_PKG)/.PKGINFO ; \
	 echo "arch=$(XZ32_PKG_ARCH)"                               >> $(XZ32_PKG)/.PKGINFO ; \
	 echo "distroname=$(XZ32_PKG_DISTRO_NAME)"                  >> $(XZ32_PKG)/.PKGINFO ; \
	 echo "distrover=$(XZ32_PKG_DISTRO_VERSION)"                >> $(XZ32_PKG)/.PKGINFO ; \
	 echo "group=$(XZ32_PKG_GROUP)"                             >> $(XZ32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(XZ32_PKG_SHORT_DESCRIPTION)\"" >> $(XZ32_PKG)/.PKGINFO ; \
	 echo "url=$(XZ32_PKG_URL)"                                 >> $(XZ32_PKG)/.PKGINFO ; \
	 echo "license=$(XZ32_PKG_LICENSE)"                         >> $(XZ32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(XZ32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@
