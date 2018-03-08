
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/ladspa

REQUIRES           = libs/ladspa/1.13
REQUIRES          += libs/glibc/2.27-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 1.13
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/m/ladspa/ladspa-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/ladspa-$(version)
src_dir_name       = ladspa-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LADSPA_32_PKG_NAME                = ladspa-x32
LADSPA_32_PKG_VERSION             = 1.13
LADSPA_32_PKG_ARCH                = $(TOOLCHAIN)
LADSPA_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LADSPA_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LADSPA_32_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
LADSPA_32_PKG_SHORT_DESCRIPTION   = Simple Plugin API
LADSPA_32_PKG_URL                 = $(BUG_URL)
LADSPA_32_PKG_LICENSE             = LGPLv2.1
LADSPA_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LADSPA_32_PKG_NAME)-pkg-description
LADSPA_32_PKG_DESCRIPTION_FILE_IN = $(LADSPA_32_PKG_NAME)-pkg-description.in
LADSPA_32_PKG_INSTALL_SCRIPT      = $(LADSPA_32_PKG_NAME)-pkg-install.sh

LADSPA_32_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LADSPA_32_PKG_NAME)-package

pkg_basename      = $(LADSPA_32_PKG_NAME)-$(LADSPA_32_PKG_VERSION)-$(LADSPA_32_PKG_ARCH)-$(LADSPA_32_PKG_DISTRO_NAME)-$(LADSPA_32_PKG_DISTRO_VERSION)

pkg_archive       = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature     = $(call sign-name,$(pkg_archive))
pkg_description   = $(call desc-name,$(pkg_archive))
products          = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS     = $(build_target)
BUILD_TARGETS    += $(install_target)

PRODUCT_TARGETS   = $(products)

ROOTFS_TARGETS    = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(LADSPA_32_PKG)


TARGET_LIB_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib/../lib$(MULTILIB_X86_32_SUFFIX)

LD      += -melf_i386
LDFLAGS += -Wl,-rpath,$(TARGET_LIB_RPATH)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@( cd $(SRC_DIR)/src ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) INSTALL_PLUGINS_DIR="/usr/lib$(MULTILIB_X86_32_SUFFIX)/ladspa" \
	                                INSTALL_INCLUDE_DIR="/usr/include"         \
	                                INSTALL_BINARY_DIR="/usr/bin/32" targets ; \
	 )
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LADSPA_32_PKG)
	@( cd $(SRC_DIR)/src ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) -j1 INSTALL_PLUGINS_DIR="/usr/lib$(MULTILIB_X86_32_SUFFIX)/ladspa" \
	                                    INSTALL_INCLUDE_DIR="/usr/include"                        \
	                                    INSTALL_BINARY_DIR="/usr/bin/32" $(env_sysroot) install ; \
	 )
	@rm -rf $(LADSPA_32_PKG)/usr/include
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LADSPA_32_PKG))
	# ======= Strip binaries =======
	@( cd $(LADSPA_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(LADSPA_32_PKG_DESCRIPTION_FILE): $(LADSPA_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LADSPA_32_PKG_DESCRIPTION_FILE) $(LADSPA_32_PKG_INSTALL_SCRIPT)
	@cp $(LADSPA_32_PKG_DESCRIPTION_FILE) $(LADSPA_32_PKG)/.DESCRIPTION
	@cp $(LADSPA_32_PKG_INSTALL_SCRIPT) $(LADSPA_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LADSPA_32_PKG)/.REQUIRES
	@echo "pkgname=$(LADSPA_32_PKG_NAME)"                            >  $(LADSPA_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LADSPA_32_PKG_VERSION)"                          >> $(LADSPA_32_PKG)/.PKGINFO ; \
	 echo "arch=$(LADSPA_32_PKG_ARCH)"                               >> $(LADSPA_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LADSPA_32_PKG_DISTRO_NAME)"                  >> $(LADSPA_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LADSPA_32_PKG_DISTRO_VERSION)"                >> $(LADSPA_32_PKG)/.PKGINFO ; \
	 echo "group=$(LADSPA_32_PKG_GROUP)"                             >> $(LADSPA_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LADSPA_32_PKG_SHORT_DESCRIPTION)\"" >> $(LADSPA_32_PKG)/.PKGINFO ; \
	 echo "url=$(LADSPA_32_PKG_URL)"                                 >> $(LADSPA_32_PKG)/.PKGINFO ; \
	 echo "license=$(LADSPA_32_PKG_LICENSE)"                         >> $(LADSPA_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LADSPA_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
