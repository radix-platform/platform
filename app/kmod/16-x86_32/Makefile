
COMPONENT_TARGETS += $(TARGET_PC64)

NEED_ABS_PATH      = true

COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = $(SRC_PACKAGE_DIR)/packages/a/kmod


REQUIRES           = libs/zlib/1.2.8
REQUIRES          += app/xz/5.0.5


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
build_kmod32_pkg   = $(TARGET_BUILD_DIR)/.kmod32_pkg_done



####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
KMOD32_PKG_NAME                = kmod32
KMOD32_PKG_VERSION             = 16
KMOD32_PKG_ARCH                = $(TOOLCHAIN)
KMOD32_PKG_DISTRO_NAME         = kxLab
KMOD32_PKG_DISTRO_VERSION      = 1.0
KMOD32_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
KMOD32_PKG_SHORT_DESCRIPTION   = kmod32 $(version)
KMOD32_PKG_URL                 = http://www.kxLab.com
KMOD32_PKG_LICENSE             = GPLv2
KMOD32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(KMOD32_PKG_NAME)-pkg-description
KMOD32_PKG_DESCRIPTION_FILE_IN = $(KMOD32_PKG_NAME)-pkg-description.in
KMOD32_PKG_INSTALL_SCRIPT      = $(KMOD32_PKG_NAME)-pkg-install.sh

KMOD32_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(KMOD32_PKG_NAME)-package

pkg_basename     = $(KMOD32_PKG_NAME)-$(KMOD32_PKG_VERSION)-$(KMOD32_PKG_ARCH)-$(KMOD32_PKG_DISTRO_NAME)-$(KMOD32_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(KMOD32_PKG_GROUP)/$(pkg_basename).tgz


BUILD_TARGETS    = $(build_kmod32_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(KMOD32_PKG)


# owerwrite LDFLAGS:
#
LDFLAGS     = -L$(TARGET_DEST_DIR)/lib$(MULTILIB_X86_32_SUFFIX)
LDFLAGS    += -L$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)

ARCH_FLAGS  = -m32 -g -O3 -march=i486 -mtune=i686

TARGET32    = $(shell echo $(TARGET) | sed 's/x86_64/i486/')

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

$(build_kmod32_pkg): $(install_target) $(KMOD32_PKG_DESCRIPTION_FILE)
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
	@touch $@
