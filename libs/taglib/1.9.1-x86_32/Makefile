
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/taglib

REQUIRES           = libs/taglib/1.9.1

# ======= __END_OF_REQUIRES__ =======


version            = 1.9.1
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/m/taglib/taglib-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/taglib-$(version)
src_dir_name       = taglib-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
TAGLIB_32_PKG_NAME                = taglib-x32
TAGLIB_32_PKG_VERSION             = 1.9.1
TAGLIB_32_PKG_ARCH                = $(TOOLCHAIN)
TAGLIB_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
TAGLIB_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
TAGLIB_32_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
TAGLIB_32_PKG_SHORT_DESCRIPTION   = audio meta-data library
TAGLIB_32_PKG_URL                 = $(BUG_URL)
TAGLIB_32_PKG_LICENSE             = LGPLv2.1
TAGLIB_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(TAGLIB_32_PKG_NAME)-pkg-description
TAGLIB_32_PKG_DESCRIPTION_FILE_IN = $(TAGLIB_32_PKG_NAME)-pkg-description.in
TAGLIB_32_PKG_INSTALL_SCRIPT      = $(TAGLIB_32_PKG_NAME)-pkg-install.sh

TAGLIB_32_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(TAGLIB_32_PKG_NAME)-package

pkg_basename     = $(TAGLIB_32_PKG_NAME)-$(TAGLIB_32_PKG_VERSION)-$(TAGLIB_32_PKG_ARCH)-$(TAGLIB_32_PKG_DISTRO_NAME)-$(TAGLIB_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(TAGLIB_32_PKG)


configure_switches  = CXX=$(CC)
configure_switches += -DCMAKE_INSTALL_PREFIX=/usr
configure_switches += -DCMAKE_BUILD_TYPE=Release
configure_switches += -DLIB_SUFFIX="$(MULTILIB_X86_32_SUFFIX)"
configure_switches += -DWITH_MP4=ON
configure_switches += -DWITH_ASF=ON


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@( cd $(SRC_DIR) ; \
	   $(BUILD_ENVIRONMENT) cmake $(configure_switches) . ; \
	 )
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) VERBOSE=1 $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(TAGLIB_32_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@mkdir -p $(TAGLIB_32_PKG)/usr/bin/32
	@( cd $(TAGLIB_32_PKG)/usr/bin ; \
	   find . -type f | xargs mv -t 32 ; \
	 )
	@rm -rf $(TAGLIB_32_PKG)/usr/include
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(TAGLIB_32_PKG))
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" taglib.pc taglib_c.pc \
	 )
	# ======= tune taglib-config script the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/bin/32 ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" taglib-config \
	 )
	# ======= Strip binaries =======
	@( cd $(TAGLIB_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(TAGLIB_32_PKG_DESCRIPTION_FILE): $(TAGLIB_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(TAGLIB_32_PKG_DESCRIPTION_FILE) $(TAGLIB_32_PKG_INSTALL_SCRIPT)
	@cp $(TAGLIB_32_PKG_DESCRIPTION_FILE) $(TAGLIB_32_PKG)/.DESCRIPTION
	@cp $(TAGLIB_32_PKG_INSTALL_SCRIPT) $(TAGLIB_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(TAGLIB_32_PKG)/.REQUIRES
	@echo "pkgname=$(TAGLIB_32_PKG_NAME)"                            >  $(TAGLIB_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(TAGLIB_32_PKG_VERSION)"                          >> $(TAGLIB_32_PKG)/.PKGINFO ; \
	 echo "arch=$(TAGLIB_32_PKG_ARCH)"                               >> $(TAGLIB_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(TAGLIB_32_PKG_DISTRO_NAME)"                  >> $(TAGLIB_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(TAGLIB_32_PKG_DISTRO_VERSION)"                >> $(TAGLIB_32_PKG)/.PKGINFO ; \
	 echo "group=$(TAGLIB_32_PKG_GROUP)"                             >> $(TAGLIB_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(TAGLIB_32_PKG_SHORT_DESCRIPTION)\"" >> $(TAGLIB_32_PKG)/.PKGINFO ; \
	 echo "url=$(TAGLIB_32_PKG_URL)"                                 >> $(TAGLIB_32_PKG)/.PKGINFO ; \
	 echo "license=$(TAGLIB_32_PKG_LICENSE)"                         >> $(TAGLIB_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(TAGLIB_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
