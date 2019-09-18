
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/x265

REQUIRES           = libs/x265/2.1
REQUIRES          += libs/glibc/2.28-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 2.1
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/m/x265/x265-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/x265-$(version)
src_dir_name       = x265-$(version)
doc_dir_name       = x265-$(version)
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
X265_32_PKG_NAME                = x265-x32
X265_32_PKG_VERSION             = 2.1
X265_32_PKG_ARCH                = $(TOOLCHAIN)
X265_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
X265_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
X265_32_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
X265_32_PKG_SHORT_DESCRIPTION   = Open Source H265/HEVC video encoder
X265_32_PKG_URL                 = $(BUG_URL)
X265_32_PKG_LICENSE             = GPLv2
X265_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(X265_32_PKG_NAME)-pkg-description
X265_32_PKG_DESCRIPTION_FILE_IN = $(X265_32_PKG_NAME)-pkg-description.in
X265_32_PKG_INSTALL_SCRIPT      = $(X265_32_PKG_NAME)-pkg-install.sh

X265_32_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(X265_32_PKG_NAME)-package

pkg_basename     = $(X265_32_PKG_NAME)-$(X265_32_PKG_VERSION)-$(X265_32_PKG_ARCH)-$(X265_32_PKG_DISTRO_NAME)-$(X265_32_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(X265_32_PKG)


ARCH_ALIAS = x86


TARGET_BIN_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX)
TARGET_LIB_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib/../lib$(MULTILIB_X86_32_SUFFIX)

configure_switches  = -DCMAKE_BUILD_TYPE='Release'

configure_switches += -DCMAKE_C_COMPILER='$(CROSS_PREFIX)gcc'
configure_switches += -DCMAKE_CXX_COMPILER='$(CROSS_PREFIX)g++'
configure_switches += -DCMAKE_LINKER='$(CROSS_PREFIX)ld'
configure_switches += -DCMAKE_AR='$(CROSS_PREFIX)ar'
configure_switches += -DCMAKE_NM='$(CROSS_PREFIX)nm'
configure_switches += -DCMAKE_RANLIB='$(CROSS_PREFIX)ranlib'
configure_switches += -DCMAKE_OBJCOPY='$(CROSS_PREFIX)objcopy'
configure_switches += -DCMAKE_OBJDUMP='$(CROSS_PREFIX)objdump'
configure_switches += -DCMAKE_STRIP='$(CROSS_PREFIX)strip'

configure_switches += -DCMAKE_C_FLAGS:STRING='--sysroot=$(TARGET_DEST_DIR) -m32 $(CFLAGS) $(ARCH_FLAGS) $(ARCH_DEFS) $(HW_FLAGS) -fPIC'
configure_switches += -DCMAKE_CXX_FLAGS:STRING='--sysroot=$(TARGET_DEST_DIR) -m32 $(CFLAGS) $(ARCH_FLAGS) $(ARCH_DEFS) $(HW_FLAGS) -fPIC'

configure_switches += -DCMAKE_EXE_LINKER_FLAGS='--sysroot=$(TARGET_DEST_DIR) -m32 -Wl,-rpath,$(TARGET_BIN_RPATH) -L$(TARGET_DEST_DIR)/lib$(MULTILIB_X86_32_SUFFIX) -L$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)'
configure_switches += -DCMAKE_MODULE_LINKER_FLAGS='--sysroot=$(TARGET_DEST_DIR) -m32 -Wl,-rpath,$(TARGET_LIB_RPATH) -L$(TARGET_DEST_DIR)/lib$(MULTILIB_X86_32_SUFFIX) -L$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)'
configure_switches += -DCMAKE_SHARED_LINKER_FLAGS='--sysroot=$(TARGET_DEST_DIR) -m32 -Wl,-rpath,$(TARGET_LIB_RPATH) -L$(TARGET_DEST_DIR)/lib$(MULTILIB_X86_32_SUFFIX) -L$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)'

configure_switches += -DCMAKE_INSTALL_PREFIX=/usr

configure_switches += -DBIN_INSTALL_DIR='bin/32'
configure_switches += -DLIB_INSTALL_DIR='lib$(MULTILIB_X86_32_SUFFIX)'

configure_switches += -DCMAKE_CROSSCOMPILING=True

configure_switches += -DCMAKE_SYSTEM_NAME='Linux'
configure_switches += -DCMAKE_SYSTEM_PROCESSOR=$(ARCH_ALIAS)
configure_switches += -DDISABLE_X86_YASM=True

configure_shared_switch  += -DENABLE_SHARED='TRUE'


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@( cd $(build_dir) ; \
	   $(BUILD_ENVIRONMENT) cmake $(configure_switches)        \
	                              $(configure_shared_switch)   \
	                              ../$(src_dir_name)/source  ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) ; \
	 )
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(X265_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(X265_32_PKG)/usr/include
	@rm -rf $(X265_32_PKG)/usr/share
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(X265_32_PKG))
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" x265.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(X265_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(X265_32_PKG)/usr/bin/32 ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(X265_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(X265_32_PKG_DESCRIPTION_FILE): $(X265_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(X265_32_PKG_DESCRIPTION_FILE) $(X265_32_PKG_INSTALL_SCRIPT)
	@cp $(X265_32_PKG_DESCRIPTION_FILE) $(X265_32_PKG)/.DESCRIPTION
	@cp $(X265_32_PKG_INSTALL_SCRIPT) $(X265_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(X265_32_PKG)/.REQUIRES
	@echo "pkgname=$(X265_32_PKG_NAME)"                            >  $(X265_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(X265_32_PKG_VERSION)"                          >> $(X265_32_PKG)/.PKGINFO ; \
	 echo "arch=$(X265_32_PKG_ARCH)"                               >> $(X265_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(X265_32_PKG_DISTRO_NAME)"                  >> $(X265_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(X265_32_PKG_DISTRO_VERSION)"                >> $(X265_32_PKG)/.PKGINFO ; \
	 echo "group=$(X265_32_PKG_GROUP)"                             >> $(X265_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(X265_32_PKG_SHORT_DESCRIPTION)\"" >> $(X265_32_PKG)/.PKGINFO ; \
	 echo "url=$(X265_32_PKG_URL)"                                 >> $(X265_32_PKG)/.PKGINFO ; \
	 echo "license=$(X265_32_PKG_LICENSE)"                         >> $(X265_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(X265_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
