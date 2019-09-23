
COMPONENT_TARGETS  = $(HARDWARE_S824L)
COMPONENT_TARGETS += $(HARDWARE_VESNIN)
COMPONENT_TARGETS += $(HARDWARE_TL2WK2)
COMPONENT_TARGETS += $(HARDWARE_TL2SV2)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_PPC32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/gpm

REQUIRES           = app/gpm/1.20.7
REQUIRES          += app/inputattach/1.4.9-ppc32

# ======= __END_OF_REQUIRES__ =======


version            = 1.20.7
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/a/gpm/gpm-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/gpm-$(version)
src_dir_name       = gpm-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done

cache_file_in      = $(CURDIR)/disable-emacs.cache
cache_file         = $(CURDIR)/$(SRC_DIR)/disable-emacs.cache


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
GPM32_PKG_NAME                = gpm-x32
GPM32_PKG_VERSION             = 1.20.7
GPM32_PKG_ARCH                = $(TOOLCHAIN)
GPM32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
GPM32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
GPM32_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
GPM32_PKG_SHORT_DESCRIPTION   = general purpose mouse server ppc32 library
GPM32_PKG_URL                 = $(BUG_URL)
GPM32_PKG_LICENSE             = GPLv2
GPM32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GPM32_PKG_NAME)-pkg-description
GPM32_PKG_DESCRIPTION_FILE_IN = $(GPM32_PKG_NAME)-pkg-description.in
GPM32_PKG_INSTALL_SCRIPT      = $(GPM32_PKG_NAME)-pkg-install.sh

GPM32_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GPM32_PKG_NAME)-package

pkg_basename     = $(GPM32_PKG_NAME)-$(GPM32_PKG_VERSION)-$(GPM32_PKG_ARCH)-$(GPM32_PKG_DISTRO_NAME)-$(GPM32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_certificate  = $(call cert-name,$(pkg_archive))
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(GPM32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_PPC32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --cache-file=$(cache_file)

ifeq ($(__ENABLE_STATIC__),yes)
extra_configure_switches += --enable-static=yes
else
extra_configure_switches += --enable-static=no
endif
extra_configure_switches += --enable-shared=yes


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cp -a $(cache_file_in) $(cache_file)
	@cd $(SRC_DIR) && \
	  $(BUILD_ENVIRONMENT) ./configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(GPM32_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@chmod 755 $(GPM32_PKG)/usr/lib$(MULTILIB_PPC32_SUFFIX)/libgpm.so.?.?.?
	@mkdir -p $(GPM32_PKG)/lib$(MULTILIB_PPC32_SUFFIX)
	@( cd $(GPM32_PKG)/usr/lib$(MULTILIB_PPC32_SUFFIX) ; \
	   for file in lib*.so.?.* ; do \
	     mv $$file ../../lib$(MULTILIB_PPC32_SUFFIX) ; \
	     ln -sf ../../lib$(MULTILIB_PPC32_SUFFIX)/$$file . ; \
	   done ; \
	   cp -a lib*.so.? ../../lib$(MULTILIB_PPC32_SUFFIX) \
	 )
	@( cd $(GPM32_PKG)/usr/lib$(MULTILIB_PPC32_SUFFIX) ; \
	   ln -sf libgpm.so.?.?.? libgpm.so \
	 )
	@rm -rf $(GPM32_PKG)/etc
	@rm -rf $(GPM32_PKG)/usr/bin
	@rm -rf $(GPM32_PKG)/usr/doc
	@rm -rf $(GPM32_PKG)/usr/include
	@rm -rf $(GPM32_PKG)/usr/sbin
	@rm -rf $(GPM32_PKG)/usr/share
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(GPM32_PKG))
	# ======= Strip binaries =======
	@( cd $(GPM32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifeq ($(__ENABLE_STATIC__),yes)
	@( cd $(GPM32_PKG) ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null ; \
	 )
endif
	@touch $@

$(GPM32_PKG_DESCRIPTION_FILE): $(GPM32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(GPM32_PKG_DESCRIPTION_FILE) $(GPM32_PKG_INSTALL_SCRIPT)
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
	@$(PSEUDO) sh -c "cd $(GPM32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
