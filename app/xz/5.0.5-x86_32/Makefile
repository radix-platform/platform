
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/xz

REQUIRES           = app/xz/5.0.5
REQUIRES          += libs/eglibc/2.19.1-x86_32


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


####### Targets

PKG_GROUP = app
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
XZ32_PKG_NAME                = xz-x32
XZ32_PKG_VERSION             = 5.0.5
XZ32_PKG_ARCH                = $(TOOLCHAIN)
XZ32_PKG_DISTRO_NAME         = kxLab
XZ32_PKG_DISTRO_VERSION      = 1.0
XZ32_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
XZ32_PKG_SHORT_DESCRIPTION   = xz-x32 $(version)
XZ32_PKG_URL                 = $(BUG_URL)
XZ32_PKG_LICENSE             = GPLv2
XZ32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(XZ32_PKG_NAME)-pkg-description
XZ32_PKG_DESCRIPTION_FILE_IN = $(XZ32_PKG_NAME)-pkg-description.in
XZ32_PKG_INSTALL_SCRIPT      = $(XZ32_PKG_NAME)-pkg-install.sh

XZ32_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(XZ32_PKG_NAME)-package

pkg_basename     = $(XZ32_PKG_NAME)-$(XZ32_PKG_VERSION)-$(XZ32_PKG_ARCH)-$(XZ32_PKG_DISTRO_NAME)-$(XZ32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(XZ32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --program-prefix=
extra_configure_switches += --program-suffix=
extra_configure_switches += --disable-rpath
extra_configure_switches += --enable-shared


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

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(XZ32_PKG_DESCRIPTION_FILE) $(XZ32_PKG_INSTALL_SCRIPT)
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
