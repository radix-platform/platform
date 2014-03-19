
COMPONENT_TARGETS += $(TARGET_PC64)

NEED_ABS_PATH      = true

COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = $(SRC_PACKAGE_DIR)/packages/a/gpm

REQUIRES           = app/inputattach/1.4.7


version            = 1.20.7
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/a/gpm/gpm-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/gpm-$(version)
src_dir_name       = gpm-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

cache_file         = $(CURDIR)/disable-emacs.cache
build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done
build_gpm32_pkg    = $(TARGET_BUILD_DIR)/.gpm32_pkg_done



####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
GPM32_PKG_NAME                = gpm32
GPM32_PKG_VERSION             = 1.20.7
GPM32_PKG_ARCH                = $(TOOLCHAIN)
GPM32_PKG_DISTRO_NAME         = kxLab
GPM32_PKG_DISTRO_VERSION      = 1.0
GPM32_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
GPM32_PKG_SHORT_DESCRIPTION   = gpm32 $(version) library
GPM32_PKG_URL                 = http://www.kxLab.com
GPM32_PKG_LICENSE             = GPLv2
GPM32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GPM32_PKG_NAME)-pkg-description
GPM32_PKG_DESCRIPTION_FILE_IN = $(GPM32_PKG_NAME)-pkg-description.in
GPM32_PKG_INSTALL_SCRIPT      = $(GPM32_PKG_NAME)-pkg-install.sh

GPM32_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GPM32_PKG_NAME)-package

pkg_basename     = $(GPM32_PKG_NAME)-$(GPM32_PKG_VERSION)-$(GPM32_PKG_ARCH)-$(GPM32_PKG_DISTRO_NAME)-$(GPM32_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(GPM32_PKG_GROUP)/$(pkg_basename).tgz


BUILD_TARGETS    = $(build_gpm32_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../build-system/core.mk


env_sysroot      = DESTDIR=$(GPM32_PKG)


OPTIMIZATION_FLAGS = -O3

CC                += -m32

ARCH_FLAGS         = -m32 -g -O3 -march=i486 -mtune=i686

TARGET32     = $(shell echo $(TARGET) | sed 's/x86_64/i486/')


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --enable-shared
extra_configure_switches += --cache-file=$(cache_file)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@chmod a-w $(cache_file)
	@cd $(SRC_DIR) && \
	  $(BUILD_ENVIRONMENT) ./configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@chmod +w $(cache_file)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(GPM32_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@chmod 755 $(GPM32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/libgpm.so.?.?.?
	@mkdir -p $(GPM32_PKG)/lib$(MULTILIB_X86_32_SUFFIX)
	@( cd $(GPM32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in lib*.so.?.* ; do \
	     mv $$file ../../lib$(MULTILIB_X86_32_SUFFIX) ; \
	     ln -sf ../../lib$(MULTILIB_X86_32_SUFFIX)/$$file . ; \
	   done ; \
	   cp -a lib*.so.? ../../lib$(MULTILIB_X86_32_SUFFIX) \
	 )
	@( cd $(GPM32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   ln -sf libgpm.so.?.?.? libgpm.so \
	 )
	@rm -rf $(GPM32_PKG)/etc
	@rm -rf $(GPM32_PKG)/usr/bin
	@rm -rf $(GPM32_PKG)/usr/doc
	@rm -rf $(GPM32_PKG)/usr/include
	@rm -rf $(GPM32_PKG)/usr/sbin
	@rm -rf $(GPM32_PKG)/usr/share
	# Install the same to $(TARGET_DEST_DIR)
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(GPM32_PKG) && cp -arf * $(TARGET_DEST_DIR)
	@(cd $(GPM32_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(GPM32_PKG_DESCRIPTION_FILE): $(GPM32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(build_gpm32_pkg): $(install_target) $(GPM32_PKG_DESCRIPTION_FILE)
	@cp $(GPM32_PKG_DESCRIPTION_FILE) $(GPM32_PKG)/.DESCRIPTION
	@cp $(GPM32_PKG_INSTALL_SCRIPT) $(GPM32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GPM32_PKG)/.REQUIRES
	@echo "pkgname=$(GPM32_PKG_NAME)"                            >  $(GPM32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GPM32_PKG_VERSION)"                          >> $(GPM32_PKG)/.PKGINFO ; \
	 echo "arch=$(GPM32_PKG_ARCH)"                               >> $(GPM32_PKG)/.PKGINFO ; \
	 echo "distroname=$(GPM32_PKG_DISTRO_NAME)"                  >> $(GPM32_PKG)/.PKGINFO ; \
	 echo "distrover=$(GPM32_PKG_DISTRO_VERSION)"                >> $(GPM32_PKG)/.PKGINFO ; \
	 echo "group=$(GPM32_PKG_GROUP)"                             >> $(GPM32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GPM32_PKG_SHORT_DESCRIPTION)\"" >> $(GPM32_PKG)/.PKGINFO ; \
	 echo "url=$(GPM32_PKG_URL)"                                 >> $(GPM32_PKG)/.PKGINFO ; \
	 echo "license=$(GPM32_PKG_LICENSE)"                         >> $(GPM32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(GPM32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@
