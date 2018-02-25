
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/vid-stab

REQUIRES           = libs/libvidstab/1.1
REQUIRES          += libs/glibc/2.26-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 1.1
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/m/vid-stab/vid-stab-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/vid-stab-$(version)
src_dir_name       = vid-stab-$(version)
doc_dir_name       = libvidstab-$(version)
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
VIDSTAB_32_PKG_NAME                = libvidstab-x32
VIDSTAB_32_PKG_VERSION             = 1.1
VIDSTAB_32_PKG_ARCH                = $(TOOLCHAIN)
VIDSTAB_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
VIDSTAB_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
VIDSTAB_32_PKG_GROUP               = $(PKG_GROUP)
###                                 |---handy-ruler-------------------------------|
VIDSTAB_32_PKG_SHORT_DESCRIPTION   = video stabilization library
VIDSTAB_32_PKG_URL                 = $(BUG_URL)
VIDSTAB_32_PKG_LICENSE             = GPL
VIDSTAB_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(VIDSTAB_32_PKG_NAME)-pkg-description
VIDSTAB_32_PKG_DESCRIPTION_FILE_IN = $(VIDSTAB_32_PKG_NAME)-pkg-description.in
VIDSTAB_32_PKG_INSTALL_SCRIPT      = $(VIDSTAB_32_PKG_NAME)-pkg-install.sh

VIDSTAB_32_PKG   = $(CURDIR)/$(TARGET_BUILD_DIR)/$(VIDSTAB_32_PKG_NAME)-package

pkg_basename     = $(VIDSTAB_32_PKG_NAME)-$(VIDSTAB_32_PKG_VERSION)-$(VIDSTAB_32_PKG_ARCH)-$(VIDSTAB_32_PKG_DISTRO_NAME)-$(VIDSTAB_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))


BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(VIDSTAB_32_PKG)

TARGET_BIN_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX)
TARGET_LIB_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib/../lib$(MULTILIB_X86_32_SUFFIX)

configure_switches  = -DCMAKE_BUILD_TYPE='Release'

configure_switches += -DCMAKE_C_COMPILER='$(CROSS_PREFIX)gcc'
configure_switches += -DCMAKE_LINKER='$(CROSS_PREFIX)ld'
configure_switches += -DCMAKE_AR='$(CROSS_PREFIX)ar'
configure_switches += -DCMAKE_NM='$(CROSS_PREFIX)nm'
configure_switches += -DCMAKE_RANLIB='$(CROSS_PREFIX)ranlib'
configure_switches += -DCMAKE_OBJCOPY='$(CROSS_PREFIX)objcopy'
configure_switches += -DCMAKE_OBJDUMP='$(CROSS_PREFIX)objdump'
configure_switches += -DCMAKE_STRIP='$(CROSS_PREFIX)strip'

configure_switches += -DCMAKE_C_FLAGS:STRING='--sysroot=$(TARGET_DEST_DIR) -m32 $(CFLAGS) $(ARCH_FLAGS) $(ARCH_DEFS) $(HW_FLAGS) -Wno-unknown-pragmas'

configure_switches += -DCMAKE_EXE_LINKER_FLAGS='--sysroot=$(TARGET_DEST_DIR) -m32 -Wl,-rpath,$(TARGET_BIN_RPATH) -L$(TARGET_DEST_DIR)/lib$(MULTILIB_X86_32_SUFFIX) -L$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)'
configure_switches += -DCMAKE_MODULE_LINKER_FLAGS='--sysroot=$(TARGET_DEST_DIR) -m32 -Wl,-rpath,$(TARGET_LIB_RPATH) -L$(TARGET_DEST_DIR)/lib$(MULTILIB_X86_32_SUFFIX) -L$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)'
configure_switches += -DCMAKE_SHARED_LINKER_FLAGS='--sysroot=$(TARGET_DEST_DIR) -m32 -Wl,-rpath,$(TARGET_LIB_RPATH) -L$(TARGET_DEST_DIR)/lib$(MULTILIB_X86_32_SUFFIX) -L$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)'

configure_switches += -DCMAKE_INSTALL_PREFIX=/usr

configure_switches += -DLIB_SUFFIX=$(MULTILIB_X86_32_SUFFIX)

configure_switches += -DCMAKE_CROSSCOMPILING=True


configure_switches += -DSSE2_FOUND:BOOL=true
configure_switches += -DSSE3_FOUND:BOOL=true
configure_switches += -DSSE4_1_FOUND:BOOL=true
configure_switches += -DSSSE3_FOUND:BOOL=true
configure_switches += -DUSE_OMP:BOOL=ON


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@( cd $(build_dir) ; \
	   $(BUILD_ENVIRONMENT) cmake $(configure_switches) ../$(src_dir_name) ; \
	 )
	@( cd $(build_dir) ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) ; \
	 )
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(VIDSTAB_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(VIDSTAB_32_PKG)/usr/include
	@rm -rf $(VIDSTAB_32_PKG)/usr/share
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(VIDSTAB_32_PKG))
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" vidstab.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(VIDSTAB_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(VIDSTAB_32_PKG_DESCRIPTION_FILE): $(VIDSTAB_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(VIDSTAB_32_PKG_DESCRIPTION_FILE) $(VIDSTAB_32_PKG_INSTALL_SCRIPT)
	@cp $(VIDSTAB_32_PKG_DESCRIPTION_FILE) $(VIDSTAB_32_PKG)/.DESCRIPTION
	@cp $(VIDSTAB_32_PKG_INSTALL_SCRIPT) $(VIDSTAB_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(VIDSTAB_32_PKG)/.REQUIRES
	@echo "pkgname=$(VIDSTAB_32_PKG_NAME)"                            >  $(VIDSTAB_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(VIDSTAB_32_PKG_VERSION)"                          >> $(VIDSTAB_32_PKG)/.PKGINFO ; \
	 echo "arch=$(VIDSTAB_32_PKG_ARCH)"                               >> $(VIDSTAB_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(VIDSTAB_32_PKG_DISTRO_NAME)"                  >> $(VIDSTAB_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(VIDSTAB_32_PKG_DISTRO_VERSION)"                >> $(VIDSTAB_32_PKG)/.PKGINFO ; \
	 echo "group=$(VIDSTAB_32_PKG_GROUP)"                             >> $(VIDSTAB_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(VIDSTAB_32_PKG_SHORT_DESCRIPTION)\"" >> $(VIDSTAB_32_PKG)/.PKGINFO ; \
	 echo "url=$(VIDSTAB_32_PKG_URL)"                                 >> $(VIDSTAB_32_PKG)/.PKGINFO ; \
	 echo "license=$(VIDSTAB_32_PKG_LICENSE)"                         >> $(VIDSTAB_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(VIDSTAB_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
