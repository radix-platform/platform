
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/rtmpdump

REQUIRES           = app/rtmpdump/2.4
REQUIRES          += libs/zlib/1.2.8-x86_32
REQUIRES          += net/openssl/1.0.2f-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 2.4
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/m/rtmpdump/rtmpdump-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/rtmpdump-$(version)
src_dir_name       = rtmpdump-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
RTMPDUMP_32_PKG_NAME                = rtmpdump-x32
RTMPDUMP_32_PKG_VERSION             = 2.4
RTMPDUMP_32_PKG_ARCH                = $(TOOLCHAIN)
RTMPDUMP_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
RTMPDUMP_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
RTMPDUMP_32_PKG_GROUP               = $(PKG_GROUP)
###                                  |---handy-ruler-------------------------------|
RTMPDUMP_32_PKG_SHORT_DESCRIPTION   = RTMP streaming media client
RTMPDUMP_32_PKG_URL                 = $(BUG_URL)
RTMPDUMP_32_PKG_LICENSE             = GPLv2
RTMPDUMP_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(RTMPDUMP_32_PKG_NAME)-pkg-description
RTMPDUMP_32_PKG_DESCRIPTION_FILE_IN = $(RTMPDUMP_32_PKG_NAME)-pkg-description.in
RTMPDUMP_32_PKG_INSTALL_SCRIPT      = $(RTMPDUMP_32_PKG_NAME)-pkg-install.sh

RTMPDUMP_32_PKG   = $(CURDIR)/$(TARGET_BUILD_DIR)/$(RTMPDUMP_32_PKG_NAME)-package

pkg_basename      = $(RTMPDUMP_32_PKG_NAME)-$(RTMPDUMP_32_PKG_VERSION)-$(RTMPDUMP_32_PKG_ARCH)-$(RTMPDUMP_32_PKG_DISTRO_NAME)-$(RTMPDUMP_32_PKG_DISTRO_VERSION)

pkg_archive       = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature     = $(call sign-name,$(pkg_archive))
pkg_description   = $(call desc-name,$(pkg_archive))
products          = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS     = $(build_target)
BUILD_TARGETS    += $(install_target)

PRODUCT_TARGETS   = $(products)

ROOTFS_TARGETS    = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(RTMPDUMP_32_PKG)


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
	   $(BUILD_ENVIRONMENT) $(MAKE) prefix="/usr"                               \
	                                bindir="/usr/bin/32"                        \
	                                sbindir="/usr/sbin/32"                      \
	                                libdir="/usr/lib$(MULTILIB_X86_32_SUFFIX)"  \
	                                mandir="/usr/share/man"                   ; \
	 )
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(RTMPDUMP_32_PKG)
	@( cd $(SRC_DIR) ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) -j1 prefix="/usr"                                    \
	                                    bindir="/usr/bin/32"                             \
	                                    sbindir="/usr/sbin/32"                           \
	                                    libdir="/usr/lib$(MULTILIB_X86_32_SUFFIX)"       \
	                                    mandir="/usr/share/man" $(env_sysroot) install ; \
	 )
	@rm -rf $(RTMPDUMP_32_PKG)/usr/include
	@rm -rf $(RTMPDUMP_32_PKG)/usr/share
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(RTMPDUMP_32_PKG))
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" librtmp.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(RTMPDUMP_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(RTMPDUMP_32_PKG_DESCRIPTION_FILE): $(RTMPDUMP_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(RTMPDUMP_32_PKG_DESCRIPTION_FILE) $(RTMPDUMP_32_PKG_INSTALL_SCRIPT)
	@cp $(RTMPDUMP_32_PKG_DESCRIPTION_FILE) $(RTMPDUMP_32_PKG)/.DESCRIPTION
	@cp $(RTMPDUMP_32_PKG_INSTALL_SCRIPT) $(RTMPDUMP_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(RTMPDUMP_32_PKG)/.REQUIRES
	@echo "pkgname=$(RTMPDUMP_32_PKG_NAME)"                            >  $(RTMPDUMP_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(RTMPDUMP_32_PKG_VERSION)"                          >> $(RTMPDUMP_32_PKG)/.PKGINFO ; \
	 echo "arch=$(RTMPDUMP_32_PKG_ARCH)"                               >> $(RTMPDUMP_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(RTMPDUMP_32_PKG_DISTRO_NAME)"                  >> $(RTMPDUMP_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(RTMPDUMP_32_PKG_DISTRO_VERSION)"                >> $(RTMPDUMP_32_PKG)/.PKGINFO ; \
	 echo "group=$(RTMPDUMP_32_PKG_GROUP)"                             >> $(RTMPDUMP_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(RTMPDUMP_32_PKG_SHORT_DESCRIPTION)\"" >> $(RTMPDUMP_32_PKG)/.PKGINFO ; \
	 echo "url=$(RTMPDUMP_32_PKG_URL)"                                 >> $(RTMPDUMP_32_PKG)/.PKGINFO ; \
	 echo "license=$(RTMPDUMP_32_PKG_LICENSE)"                         >> $(RTMPDUMP_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(RTMPDUMP_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
