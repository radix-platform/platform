
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/kmod

REQUIRES           = app/kmod/16
REQUIRES          += libs/zlib/1.2.8-x86_32
REQUIRES          += app/xz/5.0.5-x86_32


version            = 16
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/a/kmod/kmod-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/kmod-$(version)
src_dir_name       = kmod-$(version)
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
KMOD32_PKG_NAME                = kmod-x32
KMOD32_PKG_VERSION             = 16
KMOD32_PKG_ARCH                = $(TOOLCHAIN)
KMOD32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
KMOD32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
KMOD32_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
KMOD32_PKG_SHORT_DESCRIPTION   = kernel module x86_32 library
KMOD32_PKG_URL                 = $(BUG_URL)
KMOD32_PKG_LICENSE             = GPLv2
KMOD32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(KMOD32_PKG_NAME)-pkg-description
KMOD32_PKG_DESCRIPTION_FILE_IN = $(KMOD32_PKG_NAME)-pkg-description.in
KMOD32_PKG_INSTALL_SCRIPT      = $(KMOD32_PKG_NAME)-pkg-install.sh

KMOD32_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(KMOD32_PKG_NAME)-package

pkg_basename     = $(KMOD32_PKG_NAME)-$(KMOD32_PKG_VERSION)-$(KMOD32_PKG_ARCH)-$(KMOD32_PKG_DISTRO_NAME)-$(KMOD32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(KMOD32_PKG)


extra_configure_switches  = --libdir=/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --bindir=/sbin
extra_configure_switches += --sbindir=/sbin
extra_configure_switches += --with-xz
extra_configure_switches += --with-zlib


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(KMOD32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@rm -rf $(KMOD32_PKG)/sbin
	@rm -rf $(KMOD32_PKG)/usr/include
	@rm -rf $(KMOD32_PKG)/usr/share
	@mkdir -p $(KMOD32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)
	@mv $(KMOD32_PKG)/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig $(KMOD32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)
	@mv $(KMOD32_PKG)/lib$(MULTILIB_X86_32_SUFFIX)/{*.so,*.la} $(KMOD32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)
	@cp -a $(KMOD32_PKG)/lib$(MULTILIB_X86_32_SUFFIX)/libkmod.so.2 $(KMOD32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)
	@( cd $(KMOD32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	  ln -sf ../../lib$(MULTILIB_X86_32_SUFFIX)/libkmod.so.2.2.6 libkmod.so.2.2.6 ; \
	  sed -i "s,libdir='/lib,libdir='/usr/lib,g" libkmod.la ; \
	  sed -i "s,libdir=/lib,libdir=/usr/lib,g" pkgconfig/libkmod.pc \
	 )
	# remove toolchain path from target libtool *.la files
	@( cd $(KMOD32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	  sed -i "s,$(TARGET_DEST_DIR),,g" libkmod.la  \
	 )
	# remove -L/lib, -L/usr/lib options from target libtool *.la files
	@( cd $(KMOD32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	  sed -i "s,-L/usr/lib ,,g" libkmod.la ; \
	  sed -i "s,-L/lib ,,g" libkmod.la  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(KMOD32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# tune libtool *.la search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libkmod.la ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libkmod.la \
	 )
	# tune pkg-config *.pc search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libkmod.pc \
	 )
	@(cd $(KMOD32_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(KMOD32_PKG_DESCRIPTION_FILE): $(KMOD32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(KMOD32_PKG_DESCRIPTION_FILE) $(KMOD32_PKG_INSTALL_SCRIPT)
	@cp $(KMOD32_PKG_DESCRIPTION_FILE) $(KMOD32_PKG)/.DESCRIPTION
	@cp $(KMOD32_PKG_INSTALL_SCRIPT) $(KMOD32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(KMOD32_PKG)/.REQUIRES
	@echo "pkgname=$(KMOD32_PKG_NAME)"                            >  $(KMOD32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(KMOD32_PKG_VERSION)"                          >> $(KMOD32_PKG)/.PKGINFO ; \
	 echo "arch=$(KMOD32_PKG_ARCH)"                               >> $(KMOD32_PKG)/.PKGINFO ; \
	 echo "distroname=$(KMOD32_PKG_DISTRO_NAME)"                  >> $(KMOD32_PKG)/.PKGINFO ; \
	 echo "distrover=$(KMOD32_PKG_DISTRO_VERSION)"                >> $(KMOD32_PKG)/.PKGINFO ; \
	 echo "group=$(KMOD32_PKG_GROUP)"                             >> $(KMOD32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(KMOD32_PKG_SHORT_DESCRIPTION)\"" >> $(KMOD32_PKG)/.PKGINFO ; \
	 echo "url=$(KMOD32_PKG_URL)"                                 >> $(KMOD32_PKG)/.PKGINFO ; \
	 echo "license=$(KMOD32_PKG_LICENSE)"                         >> $(KMOD32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(KMOD32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
