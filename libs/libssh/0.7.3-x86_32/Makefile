
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/libssh

REQUIRES           = libs/libssh/0.7.3
REQUIRES          += net/openssl/1.1.1d-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 0.7.3
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/l/libssh/libssh-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libssh-$(version)
src_dir_name       = libssh-$(version)
doc_dir_name       = libssh-$(version)
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
LIBSSH_32_PKG_NAME                = libssh-x32
LIBSSH_32_PKG_VERSION             = 0.7.3
LIBSSH_32_PKG_ARCH                = $(TOOLCHAIN)
LIBSSH_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBSSH_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBSSH_32_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
LIBSSH_32_PKG_SHORT_DESCRIPTION   = C implementation of SSH protocol
LIBSSH_32_PKG_URL                 = $(BUG_URL)
LIBSSH_32_PKG_LICENSE             = LGPLv2.1
LIBSSH_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBSSH_32_PKG_NAME)-pkg-description
LIBSSH_32_PKG_DESCRIPTION_FILE_IN = $(LIBSSH_32_PKG_NAME)-pkg-description.in
LIBSSH_32_PKG_INSTALL_SCRIPT      = $(LIBSSH_32_PKG_NAME)-pkg-install.sh

LIBSSH_32_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBSSH_32_PKG_NAME)-package

pkg_basename     = $(LIBSSH_32_PKG_NAME)-$(LIBSSH_32_PKG_VERSION)-$(LIBSSH_32_PKG_ARCH)-$(LIBSSH_32_PKG_DISTRO_NAME)-$(LIBSSH_32_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(LIBSSH_32_PKG)

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

configure_switches += -DCMAKE_C_FLAGS:STRING='--sysroot=$(TARGET_DEST_DIR) -m32 $(CFLAGS) $(ARCH_FLAGS) $(ARCH_DEFS) $(HW_FLAGS)'

configure_switches += -DCMAKE_EXE_LINKER_FLAGS='--sysroot=$(TARGET_DEST_DIR) -m32 -Wl,-rpath,$(TARGET_BIN_RPATH) -L$(TARGET_DEST_DIR)/lib$(MULTILIB_X86_32_SUFFIX) -L$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)'
configure_switches += -DCMAKE_MODULE_LINKER_FLAGS='--sysroot=$(TARGET_DEST_DIR) -m32 -Wl,-rpath,$(TARGET_LIB_RPATH) -L$(TARGET_DEST_DIR)/lib$(MULTILIB_X86_32_SUFFIX) -L$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)'
configure_switches += -DCMAKE_SHARED_LINKER_FLAGS='--sysroot=$(TARGET_DEST_DIR) -m32 -Wl,-rpath,$(TARGET_LIB_RPATH) -L$(TARGET_DEST_DIR)/lib$(MULTILIB_X86_32_SUFFIX) -L$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)'

configure_switches += -DCMAKE_INSTALL_PREFIX=/usr

configure_switches += -DMAN_INSTALL_DIR='/usr/share/man'
configure_switches += -DLIB_INSTALL_DIR='/usr/lib$(MULTILIB_X86_32_SUFFIX)'
configure_switches += -DLIB_SUFFIX:STRING='$(MULTILIB_X86_32_SUFFIX)'

configure_switches += -DCMAKE_CROSSCOMPILING=True

configure_switches += -DWITH_TESTING=OFF
configure_switches += -DWITH_GSSAPI=OFF

configure_switches += -DSHARE_INSTALL_PREFIX:PATH=/usr/share
configure_switches += -DSYSCONF_INSTALL_DIR:PATH=/usr/etc
configure_switches += -DWITH_EXAMPLES:BOOL=ON
configure_switches += -DWITH_STATIC_LIB:BOOL=ON
configure_switches += -DWITH_ZLIB:BOOL=ON


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
	@mkdir -p $(LIBSSH_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(LIBSSH_32_PKG)/usr/include
	@rm -rf $(LIBSSH_32_PKG)/usr/share
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBSSH_32_PKG))
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libssh.pc libssh_threads.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBSSH_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(LIBSSH_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(LIBSSH_32_PKG_DESCRIPTION_FILE): $(LIBSSH_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBSSH_32_PKG_DESCRIPTION_FILE) $(LIBSSH_32_PKG_INSTALL_SCRIPT)
	@cp $(LIBSSH_32_PKG_DESCRIPTION_FILE) $(LIBSSH_32_PKG)/.DESCRIPTION
	@cp $(LIBSSH_32_PKG_INSTALL_SCRIPT) $(LIBSSH_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBSSH_32_PKG)/.REQUIRES
	@echo "pkgname=$(LIBSSH_32_PKG_NAME)"                            >  $(LIBSSH_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBSSH_32_PKG_VERSION)"                          >> $(LIBSSH_32_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBSSH_32_PKG_ARCH)"                               >> $(LIBSSH_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBSSH_32_PKG_DISTRO_NAME)"                  >> $(LIBSSH_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBSSH_32_PKG_DISTRO_VERSION)"                >> $(LIBSSH_32_PKG)/.PKGINFO ; \
	 echo "group=$(LIBSSH_32_PKG_GROUP)"                             >> $(LIBSSH_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBSSH_32_PKG_SHORT_DESCRIPTION)\"" >> $(LIBSSH_32_PKG)/.PKGINFO ; \
	 echo "url=$(LIBSSH_32_PKG_URL)"                                 >> $(LIBSSH_32_PKG)/.PKGINFO ; \
	 echo "license=$(LIBSSH_32_PKG_LICENSE)"                         >> $(LIBSSH_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LIBSSH_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
