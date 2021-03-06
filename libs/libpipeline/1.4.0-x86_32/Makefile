
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/libpipeline

REQUIRES           = libs/libpipeline/1.4.0

# ======= __END_OF_REQUIRES__ =======


version            = 1.4.0
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/libpipeline/libpipeline-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libpipeline-$(version)
src_dir_name       = libpipeline-$(version)
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
PIPELINE_32_PKG_NAME                = libpipeline-x32
PIPELINE_32_PKG_VERSION             = 1.4.0
PIPELINE_32_PKG_ARCH                = $(TOOLCHAIN)
PIPELINE_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
PIPELINE_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
PIPELINE_32_PKG_GROUP               = $(PKG_GROUP)
###                                  |---handy-ruler-------------------------------|
PIPELINE_32_PKG_SHORT_DESCRIPTION   = pipeline manipulation library
PIPELINE_32_PKG_URL                 = $(BUG_URL)
PIPELINE_32_PKG_LICENSE             = GPLv3
PIPELINE_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(PIPELINE_32_PKG_NAME)-pkg-description
PIPELINE_32_PKG_DESCRIPTION_FILE_IN = $(PIPELINE_32_PKG_NAME)-pkg-description.in
PIPELINE_32_PKG_INSTALL_SCRIPT      = $(PIPELINE_32_PKG_NAME)-pkg-install.sh

PIPELINE_32_PKG  = $(CURDIR)/$(TARGET_BUILD_DIR)/$(PIPELINE_32_PKG_NAME)-package

pkg_basename     = $(PIPELINE_32_PKG_NAME)-$(PIPELINE_32_PKG_VERSION)-$(PIPELINE_32_PKG_ARCH)-$(PIPELINE_32_PKG_DISTRO_NAME)-$(PIPELINE_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(PIPELINE_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --disable-rpath
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
	@mkdir -p $(PIPELINE_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(PIPELINE_32_PKG)/usr/include
	@rm -rf $(PIPELINE_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(PIPELINE_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libpipeline.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(PIPELINE_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libpipeline.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libpipeline.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libpipeline.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(PIPELINE_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(PIPELINE_32_PKG_DESCRIPTION_FILE): $(PIPELINE_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(PIPELINE_32_PKG_DESCRIPTION_FILE) $(PIPELINE_32_PKG_INSTALL_SCRIPT)
	@cp $(PIPELINE_32_PKG_DESCRIPTION_FILE) $(PIPELINE_32_PKG)/.DESCRIPTION
	@cp $(PIPELINE_32_PKG_INSTALL_SCRIPT) $(PIPELINE_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(PIPELINE_32_PKG)/.REQUIRES
	@echo "pkgname=$(PIPELINE_32_PKG_NAME)"                            >  $(PIPELINE_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(PIPELINE_32_PKG_VERSION)"                          >> $(PIPELINE_32_PKG)/.PKGINFO ; \
	 echo "arch=$(PIPELINE_32_PKG_ARCH)"                               >> $(PIPELINE_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(PIPELINE_32_PKG_DISTRO_NAME)"                  >> $(PIPELINE_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(PIPELINE_32_PKG_DISTRO_VERSION)"                >> $(PIPELINE_32_PKG)/.PKGINFO ; \
	 echo "group=$(PIPELINE_32_PKG_GROUP)"                             >> $(PIPELINE_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(PIPELINE_32_PKG_SHORT_DESCRIPTION)\"" >> $(PIPELINE_32_PKG)/.PKGINFO ; \
	 echo "url=$(PIPELINE_32_PKG_URL)"                                 >> $(PIPELINE_32_PKG)/.PKGINFO ; \
	 echo "license=$(PIPELINE_32_PKG_LICENSE)"                         >> $(PIPELINE_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(PIPELINE_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
