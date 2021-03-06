
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/amr/fdk-aac

REQUIRES           = libs/fdk-aac/0.1.4

# ======= __END_OF_REQUIRES__ =======


version            = 0.1.4
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/m/amr/fdk-aac/fdk-aac-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/fdk-aac-$(version)
src_dir_name       = fdk-aac-$(version)
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
FDK_AAC_32_PKG_NAME                = fdk-aac-x32
FDK_AAC_32_PKG_VERSION             = 0.1.4
FDK_AAC_32_PKG_ARCH                = $(TOOLCHAIN)
FDK_AAC_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
FDK_AAC_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
FDK_AAC_32_PKG_GROUP               = $(PKG_GROUP)
###                                 |---handy-ruler-------------------------------|
FDK_AAC_32_PKG_SHORT_DESCRIPTION   = The Fraunhofer FDK AAC Codec Library
FDK_AAC_32_PKG_URL                 = $(BUG_URL)
FDK_AAC_32_PKG_LICENSE             = Fraunhofer
FDK_AAC_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(FDK_AAC_32_PKG_NAME)-pkg-description
FDK_AAC_32_PKG_DESCRIPTION_FILE_IN = $(FDK_AAC_32_PKG_NAME)-pkg-description.in
FDK_AAC_32_PKG_INSTALL_SCRIPT      = $(FDK_AAC_32_PKG_NAME)-pkg-install.sh

FDK_AAC_32_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(FDK_AAC_32_PKG_NAME)-package

pkg_basename        = $(FDK_AAC_32_PKG_NAME)-$(FDK_AAC_32_PKG_VERSION)-$(FDK_AAC_32_PKG_ARCH)-$(FDK_AAC_32_PKG_DISTRO_NAME)-$(FDK_AAC_32_PKG_DISTRO_VERSION)

pkg_archive         = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature       = $(call sign-name,$(pkg_archive))
pkg_description     = $(call desc-name,$(pkg_archive))
products            = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS       = $(build_target)
BUILD_TARGETS      += $(install_target)

PRODUCT_TARGETS     = $(products)

ROOTFS_TARGETS      = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(FDK_AAC_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


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
	@mkdir -p $(FDK_AAC_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(FDK_AAC_32_PKG)/usr/include
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(FDK_AAC_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libfdk-aac.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(FDK_AAC_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libfdk-aac.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libfdk-aac.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" fdk-aac.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(FDK_AAC_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(FDK_AAC_32_PKG_DESCRIPTION_FILE): $(FDK_AAC_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(FDK_AAC_32_PKG_DESCRIPTION_FILE) $(FDK_AAC_32_PKG_INSTALL_SCRIPT)
	@cp $(FDK_AAC_32_PKG_DESCRIPTION_FILE) $(FDK_AAC_32_PKG)/.DESCRIPTION
	@cp $(FDK_AAC_32_PKG_INSTALL_SCRIPT) $(FDK_AAC_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(FDK_AAC_32_PKG)/.REQUIRES
	@echo "pkgname=$(FDK_AAC_32_PKG_NAME)"                            >  $(FDK_AAC_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(FDK_AAC_32_PKG_VERSION)"                          >> $(FDK_AAC_32_PKG)/.PKGINFO ; \
	 echo "arch=$(FDK_AAC_32_PKG_ARCH)"                               >> $(FDK_AAC_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(FDK_AAC_32_PKG_DISTRO_NAME)"                  >> $(FDK_AAC_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(FDK_AAC_32_PKG_DISTRO_VERSION)"                >> $(FDK_AAC_32_PKG)/.PKGINFO ; \
	 echo "group=$(FDK_AAC_32_PKG_GROUP)"                             >> $(FDK_AAC_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(FDK_AAC_32_PKG_SHORT_DESCRIPTION)\"" >> $(FDK_AAC_32_PKG)/.PKGINFO ; \
	 echo "url=$(FDK_AAC_32_PKG_URL)"                                 >> $(FDK_AAC_32_PKG)/.PKGINFO ; \
	 echo "license=$(FDK_AAC_32_PKG_LICENSE)"                         >> $(FDK_AAC_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(FDK_AAC_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
