
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/dcadec

REQUIRES           = app/dcadec/0.2.0
REQUIRES          += libs/glibc/2.26-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 0.2.0
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/m/dcadec/dcadec-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/dcadec-$(version)
src_dir_name       = dcadec-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
DCADEC_32_PKG_NAME                = dcadec-x32
DCADEC_32_PKG_VERSION             = 0.2.0
DCADEC_32_PKG_ARCH                = $(TOOLCHAIN)
DCADEC_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
DCADEC_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
DCADEC_32_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
DCADEC_32_PKG_SHORT_DESCRIPTION   = DTS Coherent Acoustics decoder
DCADEC_32_PKG_URL                 = $(BUG_URL)
DCADEC_32_PKG_LICENSE             = LGPLv2.1
DCADEC_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(DCADEC_32_PKG_NAME)-pkg-description
DCADEC_32_PKG_DESCRIPTION_FILE_IN = $(DCADEC_32_PKG_NAME)-pkg-description.in
DCADEC_32_PKG_INSTALL_SCRIPT      = $(DCADEC_32_PKG_NAME)-pkg-install.sh

DCADEC_32_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(DCADEC_32_PKG_NAME)-package

pkg_basename      = $(DCADEC_32_PKG_NAME)-$(DCADEC_32_PKG_VERSION)-$(DCADEC_32_PKG_ARCH)-$(DCADEC_32_PKG_DISTRO_NAME)-$(DCADEC_32_PKG_DISTRO_VERSION)

pkg_archive       = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature     = $(call sign-name,$(pkg_archive))
pkg_description   = $(call desc-name,$(pkg_archive))
products          = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS     = $(build_target)
BUILD_TARGETS    += $(install_target)

PRODUCT_TARGETS   = $(products)

ROOTFS_TARGETS    = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(DCADEC_32_PKG)


CFLAGS += -Wno-unused-but-set-variable


TARGET_LIB_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib/../lib$(MULTILIB_X86_32_SUFFIX)

LDFLAGS += -Wl,-rpath,$(TARGET_LIB_RPATH)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@( cd $(SRC_DIR) ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) CONFIG_SHARED=yes                            \
	                                PREFIX="/usr"                                \
	                                BINDIR="/usr/bin/32"                         \
	                                LIBDIR="/usr/lib$(MULTILIB_X86_32_SUFFIX)" ; \
	 )
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(DCADEC_32_PKG)
	@( cd $(SRC_DIR) ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) -j1 CONFIG_SHARED=yes                           \
	                                    PREFIX="/usr"                               \
	                                    BINDIR="/usr/bin/32"                        \
	                                    LIBDIR="/usr/lib$(MULTILIB_X86_32_SUFFIX)"  \
	                                                       $(env_sysroot) install ; \
	 )
	@mv $(DCADEC_32_PKG)/usr/bin/32/dcadec{,-hd}
	@chmod 755 $(DCADEC_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/libdcadec.so.?.?.?
	@rm -rf $(DCADEC_32_PKG)/usr/include
	@rm -rf $(DCADEC_32_PKG)/usr/share
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(DCADEC_32_PKG))
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" dcadec.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(DCADEC_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(DCADEC_32_PKG_DESCRIPTION_FILE): $(DCADEC_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(DCADEC_32_PKG_DESCRIPTION_FILE) $(DCADEC_32_PKG_INSTALL_SCRIPT)
	@cp $(DCADEC_32_PKG_DESCRIPTION_FILE) $(DCADEC_32_PKG)/.DESCRIPTION
	@cp $(DCADEC_32_PKG_INSTALL_SCRIPT) $(DCADEC_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(DCADEC_32_PKG)/.REQUIRES
	@echo "pkgname=$(DCADEC_32_PKG_NAME)"                            >  $(DCADEC_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(DCADEC_32_PKG_VERSION)"                          >> $(DCADEC_32_PKG)/.PKGINFO ; \
	 echo "arch=$(DCADEC_32_PKG_ARCH)"                               >> $(DCADEC_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(DCADEC_32_PKG_DISTRO_NAME)"                  >> $(DCADEC_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(DCADEC_32_PKG_DISTRO_VERSION)"                >> $(DCADEC_32_PKG)/.PKGINFO ; \
	 echo "group=$(DCADEC_32_PKG_GROUP)"                             >> $(DCADEC_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(DCADEC_32_PKG_SHORT_DESCRIPTION)\"" >> $(DCADEC_32_PKG)/.PKGINFO ; \
	 echo "url=$(DCADEC_32_PKG_URL)"                                 >> $(DCADEC_32_PKG)/.PKGINFO ; \
	 echo "license=$(DCADEC_32_PKG_LICENSE)"                         >> $(DCADEC_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(DCADEC_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
