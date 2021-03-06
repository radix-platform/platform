
COMPONENT_TARGETS     = $(HARDWARE_PC64)

NEED_ABS_PATH         = true
COMPONENT_IS_3PP      = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES       = sources/packages/a/e2fsprogs

REQUIRES              = app/e2fsprogs/1.42.9
REQUIRES             += app/util-linux/2.27.1-x86_32

# ======= __END_OF_REQUIRES__ =======


version               = 1.42.9
tar_xz_archive        = $(SRC_PACKAGE_PATH)/packages/a/e2fsprogs/e2fsprogs-$(version).tar.xz
SRC_ARCHIVE           = $(tar_xz_archive)
SRC_DIR               = $(TARGET_BUILD_DIR)/e2fsprogs-$(version)
src_dir_name          = e2fsprogs-$(version)
src_done              = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir             = $(TARGET_BUILD_DIR)/build
build_target          = $(TARGET_BUILD_DIR)/.build_done
install_target        = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
E2FSPROGS_32_PKG_NAME                = e2fsprogs-x32
E2FSPROGS_32_PKG_VERSION             = 1.42.9
E2FSPROGS_32_PKG_ARCH                = $(TOOLCHAIN)
E2FSPROGS_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
E2FSPROGS_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
E2FSPROGS_32_PKG_GROUP               = $(PKG_GROUP)
###                                   |---handy-ruler-------------------------------|
E2FSPROGS_32_PKG_SHORT_DESCRIPTION   = ext2 and ext3 filesystems utilities
E2FSPROGS_32_PKG_URL                 = $(BUG_URL)
E2FSPROGS_32_PKG_LICENSE             = GPLv2
E2FSPROGS_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(E2FSPROGS_32_PKG_NAME)-pkg-description
E2FSPROGS_32_PKG_DESCRIPTION_FILE_IN = $(E2FSPROGS_32_PKG_NAME)-pkg-description.in
E2FSPROGS_32_PKG_INSTALL_SCRIPT      = $(E2FSPROGS_32_PKG_NAME)-pkg-install.sh

E2FSPROGS_32_PKG = $(CURDIR)/$(TARGET_BUILD_DIR)/$(E2FSPROGS_32_PKG_NAME)-package

pkg_basename     = $(E2FSPROGS_32_PKG_NAME)-$(E2FSPROGS_32_PKG_VERSION)-$(E2FSPROGS_32_PKG_ARCH)-$(E2FSPROGS_32_PKG_DISTRO_NAME)-$(E2FSPROGS_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(E2FSPROGS_32_PKG)

extra_configure_switches  = --libdir=/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --bindir=/usr/bin
extra_configure_switches += --includedir=/usr/include
extra_configure_switches += --datadir=/usr/share
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --enable-elf-shlibs
extra_configure_switches += --disable-libblkid
extra_configure_switches += --disable-libuuid
extra_configure_switches += --disable-uuidd
extra_configure_switches += --enable-shared=yes


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=                   \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(E2FSPROGS_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install-libs $(env_sysroot)
	@mkdir -p $(E2FSPROGS_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)
	@mv $(E2FSPROGS_32_PKG)/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig \
	    $(E2FSPROGS_32_PKG)/lib$(MULTILIB_X86_32_SUFFIX)/*.so \
	    $(E2FSPROGS_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)
	@( cd $(E2FSPROGS_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for i in *.so ; do \
	     ln -sf ../../lib$(MULTILIB_X86_32_SUFFIX)/`readlink $$i` $$i ; \
	   done \
	 )
	@mkdir -p $(E2FSPROGS_32_PKG)/usr/bin/32
	@( cd $(E2FSPROGS_32_PKG)/usr/bin ; \
	   find . -type f | xargs mv -t 32 ; \
	 )
	@rm -rf $(E2FSPROGS_32_PKG)/etc
	@rm -rf $(E2FSPROGS_32_PKG)/sbin
	@rm -rf $(E2FSPROGS_32_PKG)/usr/include
	@rm -rf $(E2FSPROGS_32_PKG)/usr/share
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(E2FSPROGS_32_PKG))
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" com_err.pc e2p.pc ext2fs.pc quota.pc ss.pc ; \
	   sed -i "s,^prefix=,prefix=$(TARGET_DEST_DIR),g" com_err.pc e2p.pc ext2fs.pc quota.pc ss.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(E2FSPROGS_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(E2FSPROGS_32_PKG_DESCRIPTION_FILE): $(E2FSPROGS_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(E2FSPROGS_32_PKG_DESCRIPTION_FILE) $(E2FSPROGS_32_PKG_INSTALL_SCRIPT)
	@cp $(E2FSPROGS_32_PKG_DESCRIPTION_FILE) $(E2FSPROGS_32_PKG)/.DESCRIPTION
	@cp $(E2FSPROGS_32_PKG_INSTALL_SCRIPT) $(E2FSPROGS_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(E2FSPROGS_32_PKG)/.REQUIRES
	@echo "pkgname=$(E2FSPROGS_32_PKG_NAME)"                            >  $(E2FSPROGS_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(E2FSPROGS_32_PKG_VERSION)"                          >> $(E2FSPROGS_32_PKG)/.PKGINFO ; \
	 echo "arch=$(E2FSPROGS_32_PKG_ARCH)"                               >> $(E2FSPROGS_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(E2FSPROGS_32_PKG_DISTRO_NAME)"                  >> $(E2FSPROGS_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(E2FSPROGS_32_PKG_DISTRO_VERSION)"                >> $(E2FSPROGS_32_PKG)/.PKGINFO ; \
	 echo "group=$(E2FSPROGS_32_PKG_GROUP)"                             >> $(E2FSPROGS_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(E2FSPROGS_32_PKG_SHORT_DESCRIPTION)\"" >> $(E2FSPROGS_32_PKG)/.PKGINFO ; \
	 echo "url=$(E2FSPROGS_32_PKG_URL)"                                 >> $(E2FSPROGS_32_PKG)/.PKGINFO ; \
	 echo "license=$(E2FSPROGS_32_PKG_LICENSE)"                         >> $(E2FSPROGS_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(E2FSPROGS_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
