
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/xiph/speexdsp

REQUIRES           = libs/speexdsp/1.2rc3

# ======= __END_OF_REQUIRES__ =======


version            = 1.2rc3
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/m/xiph/speexdsp/speexdsp-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/speexdsp-$(version)
src_dir_name       = speexdsp-$(version)
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
SPEEXDSP_32_PKG_NAME                = speexdsp-x32
SPEEXDSP_32_PKG_VERSION             = 1.2rc3
SPEEXDSP_32_PKG_ARCH                = $(TOOLCHAIN)
SPEEXDSP_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
SPEEXDSP_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
SPEEXDSP_32_PKG_GROUP               = $(PKG_GROUP)
###                                  |---handy-ruler-------------------------------|
SPEEXDSP_32_PKG_SHORT_DESCRIPTION   = A patent-free speech codec
SPEEXDSP_32_PKG_URL                 = $(BUG_URL)
SPEEXDSP_32_PKG_LICENSE             = BSD
SPEEXDSP_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(SPEEXDSP_32_PKG_NAME)-pkg-description
SPEEXDSP_32_PKG_DESCRIPTION_FILE_IN = $(SPEEXDSP_32_PKG_NAME)-pkg-description.in
SPEEXDSP_32_PKG_INSTALL_SCRIPT      = $(SPEEXDSP_32_PKG_NAME)-pkg-install.sh

SPEEXDSP_32_PKG   = $(CURDIR)/$(TARGET_BUILD_DIR)/$(SPEEXDSP_32_PKG_NAME)-package

pkg_basename      = $(SPEEXDSP_32_PKG_NAME)-$(SPEEXDSP_32_PKG_VERSION)-$(SPEEXDSP_32_PKG_ARCH)-$(SPEEXDSP_32_PKG_DISTRO_NAME)-$(SPEEXDSP_32_PKG_DISTRO_VERSION)

pkg_archive       = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature     = $(call sign-name,$(pkg_archive))
pkg_description   = $(call desc-name,$(pkg_archive))
products          = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS     = $(build_target)
BUILD_TARGETS    += $(install_target)

PRODUCT_TARGETS   = $(products)

ROOTFS_TARGETS    = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(SPEEXDSP_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --bindir=/usr/bin/32

extra_configure_switches += --sysconfdir=/etc

extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) $(python_environment) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(SPEEXDSP_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@rm -rf $(SPEEXDSP_32_PKG)/usr/include
	@rm -rf $(SPEEXDSP_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(SPEEXDSP_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libspeexdsp.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(SPEEXDSP_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libspeexdsp.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libspeexdsp.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" speexdsp.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(SPEEXDSP_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(SPEEXDSP_32_PKG_DESCRIPTION_FILE): $(SPEEXDSP_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(SPEEXDSP_32_PKG_DESCRIPTION_FILE) $(SPEEXDSP_32_PKG_INSTALL_SCRIPT)
	@cp $(SPEEXDSP_32_PKG_DESCRIPTION_FILE) $(SPEEXDSP_32_PKG)/.DESCRIPTION
	@cp $(SPEEXDSP_32_PKG_INSTALL_SCRIPT) $(SPEEXDSP_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(SPEEXDSP_32_PKG)/.REQUIRES
	@echo "pkgname=$(SPEEXDSP_32_PKG_NAME)"                            >  $(SPEEXDSP_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(SPEEXDSP_32_PKG_VERSION)"                          >> $(SPEEXDSP_32_PKG)/.PKGINFO ; \
	 echo "arch=$(SPEEXDSP_32_PKG_ARCH)"                               >> $(SPEEXDSP_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(SPEEXDSP_32_PKG_DISTRO_NAME)"                  >> $(SPEEXDSP_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(SPEEXDSP_32_PKG_DISTRO_VERSION)"                >> $(SPEEXDSP_32_PKG)/.PKGINFO ; \
	 echo "group=$(SPEEXDSP_32_PKG_GROUP)"                             >> $(SPEEXDSP_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(SPEEXDSP_32_PKG_SHORT_DESCRIPTION)\"" >> $(SPEEXDSP_32_PKG)/.PKGINFO ; \
	 echo "url=$(SPEEXDSP_32_PKG_URL)"                                 >> $(SPEEXDSP_32_PKG)/.PKGINFO ; \
	 echo "license=$(SPEEXDSP_32_PKG_LICENSE)"                         >> $(SPEEXDSP_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(SPEEXDSP_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
