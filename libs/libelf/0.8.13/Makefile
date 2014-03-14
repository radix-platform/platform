
COMPONENT_TARGETS  = $(TARGET_HOST)
COMPONENT_TARGETS += $(TARGET_PC32)
COMPONENT_TARGETS += $(TARGET_PC64)
COMPONENT_TARGETS += $(TARGET_CB1X)
COMPONENT_TARGETS += $(TARGET_VIP1830)
COMPONENT_TARGETS += $(TARGET_BEAGLE)
COMPONENT_TARGETS += $(TARGET_OMAP5UEVM)
COMPONENT_TARGETS += $(TARGET_B74)

#
# The rest targets links staticaly with newlib or uclibc and not requires xz libraties
#
# COMPONENT_TARGETS += $(TARGET_CB1N)
# COMPONENT_TARGETS += $(TARGET_GUARD)
# COMPONENT_TARGETS += $(TARGET_VIP1830N)
# COMPONENT_TARGETS += $(TARGET_L17UC)
#


NEED_ABS_PATH      = true

COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = $(SRC_PACKAGE_DIR)/packages/l/libelf


ifneq ($(filter $(TOOLCHAIN),$(X86_64_EGLIBC_TOOLCHAIN_NAME) $(BUILD_TOOLCHAIN_NAME)),)
REQUIRES           = libs/libelf/0.8.13-x86_32
else
REQUIRES           = libs/eglibc/2.18.1
endif

version            = 0.8.13
tar_gz_archive    = $(SRC_PACKAGE_PATH)/packages/l/libelf/libelf-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libelf-$(version)
src_dir_name       = libelf-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done
build_libelf_pkg   = $(TARGET_BUILD_DIR)/.libelf_pkg_done



####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LIBELF_PKG_NAME                = libelf
LIBELF_PKG_VERSION             = 0.8.13
ifeq ($(HARDWARE),$(TARGET_HOST))
LIBELF_PKG_ARCH                = $(shell uname -m)
else
LIBELF_PKG_ARCH                = $(TOOLCHAIN)
endif
LIBELF_PKG_DISTRO_NAME         = kxLab
LIBELF_PKG_DISTRO_VERSION      = 1.0
LIBELF_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
LIBELF_PKG_SHORT_DESCRIPTION   = libelf $(version)
LIBELF_PKG_URL                 = http://www.kxLab.com
LIBELF_PKG_LICENSE             = GPLv2
LIBELF_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBELF_PKG_NAME)-pkg-description
LIBELF_PKG_DESCRIPTION_FILE_IN = $(LIBELF_PKG_NAME)-pkg-description.in
LIBELF_PKG_INSTALL_SCRIPT      = $(LIBELF_PKG_NAME)-pkg-install.sh

LIBELF_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBELF_PKG_NAME)-package

pkg_basename     = $(LIBELF_PKG_NAME)-$(LIBELF_PKG_VERSION)-$(LIBELF_PKG_ARCH)-$(LIBELF_PKG_DISTRO_NAME)-$(LIBELF_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(LIBELF_PKG_GROUP)/$(pkg_basename).tgz


BUILD_TARGETS    = $(build_libelf_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../build-system/core.mk


env_sysroot        = instroot=$(LIBELF_PKG)

OPTIMIZATION_FLAGS = -O3


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --disable-compat

extra_configure_switches += --enable-shared


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
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LIBELF_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) $(env_sysroot) install
	@mkdir -p $(LIBELF_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING* $(SRC_DIR)/INSTALL \
	       $(SRC_DIR)/MANIFEST $(SRC_DIR)/README $(SRC_DIR)/VERSION \
	       $(LIBELF_PKG)/usr/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(LIBELF_PKG)/usr/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# Install the same to $(TARGET_DEST_DIR)
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(LIBELF_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# tune pkg-config *.pc search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libelf.pc \
	 )
	@(cd $(LIBELF_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBELF_PKG_DESCRIPTION_FILE): $(LIBELF_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(build_libelf_pkg): $(install_target) $(LIBELF_PKG_DESCRIPTION_FILE)
	@cp $(LIBELF_PKG_DESCRIPTION_FILE) $(LIBELF_PKG)/.DESCRIPTION
	@cp $(LIBELF_PKG_INSTALL_SCRIPT) $(LIBELF_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBELF_PKG)/.REQUIRES
	@echo "pkgname=$(LIBELF_PKG_NAME)"                            >  $(LIBELF_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBELF_PKG_VERSION)"                          >> $(LIBELF_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBELF_PKG_ARCH)"                               >> $(LIBELF_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBELF_PKG_DISTRO_NAME)"                  >> $(LIBELF_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBELF_PKG_DISTRO_VERSION)"                >> $(LIBELF_PKG)/.PKGINFO ; \
	 echo "group=$(LIBELF_PKG_GROUP)"                             >> $(LIBELF_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBELF_PKG_SHORT_DESCRIPTION)\"" >> $(LIBELF_PKG)/.PKGINFO ; \
	 echo "url=$(LIBELF_PKG_URL)"                                 >> $(LIBELF_PKG)/.PKGINFO ; \
	 echo "license=$(LIBELF_PKG_LICENSE)"                         >> $(LIBELF_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBELF_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@