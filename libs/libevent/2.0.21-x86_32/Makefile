
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/libevent

REQUIRES           = libs/libevent/2.0.21
REQUIRES          += net/openssl/1.0.1g-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 2.0.21
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/libevent/libevent-$(version)-stable.tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libevent-$(version)-stable
src_dir_name       = libevent-$(version)-stable
doc_dir_name       = libevent-$(version)
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
LIBEVENT_32_PKG_NAME                = libevent-x32
LIBEVENT_32_PKG_VERSION             = 2.0.21
LIBEVENT_32_PKG_ARCH                = $(TOOLCHAIN)
LIBEVENT_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBEVENT_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBEVENT_32_PKG_GROUP               = $(PKG_GROUP)
###                                  |---handy-ruler-------------------------------|
LIBEVENT_32_PKG_SHORT_DESCRIPTION   = event loop library
LIBEVENT_32_PKG_URL                 = $(BUG_URL)
LIBEVENT_32_PKG_LICENSE             = BSD
LIBEVENT_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBEVENT_32_PKG_NAME)-pkg-description
LIBEVENT_32_PKG_DESCRIPTION_FILE_IN = $(LIBEVENT_32_PKG_NAME)-pkg-description.in
LIBEVENT_32_PKG_INSTALL_SCRIPT      = $(LIBEVENT_32_PKG_NAME)-pkg-install.sh

LIBEVENT_32_PKG  = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBEVENT_32_PKG_NAME)-package

pkg_basename     = $(LIBEVENT_32_PKG_NAME)-$(LIBEVENT_32_PKG_VERSION)-$(LIBEVENT_32_PKG_ARCH)-$(LIBEVENT_32_PKG_DISTRO_NAME)-$(LIBEVENT_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(LIBEVENT_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(doc_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --enable-shared
extra_configure_switches += --enable-static


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
	@mkdir -p $(LIBEVENT_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@rm -rf $(LIBEVENT_32_PKG)/usr/bin
	@rm -rf $(LIBEVENT_32_PKG)/usr/include
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBEVENT_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libevent.la          \
	                                    libevent_core.la     \
	                                    libevent_extra.la    \
	                                    libevent_openssl.la  \
	                                    libevent_pthreads.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBEVENT_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libevent.la            \
	                                            libevent_core.la       \
	                                            libevent_extra.la      \
	                                            libevent_openssl.la    \
	                                            libevent_pthreads.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libevent.la          \
	                                              libevent_core.la     \
	                                              libevent_extra.la    \
	                                              libevent_openssl.la  \
	                                              libevent_pthreads.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libevent.pc          \
	                                            libevent_openssl.pc  \
	                                            libevent_pthreads.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBEVENT_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBEVENT_32_PKG_DESCRIPTION_FILE): $(LIBEVENT_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBEVENT_32_PKG_DESCRIPTION_FILE) $(LIBEVENT_32_PKG_INSTALL_SCRIPT)
	@cp $(LIBEVENT_32_PKG_DESCRIPTION_FILE) $(LIBEVENT_32_PKG)/.DESCRIPTION
	@cp $(LIBEVENT_32_PKG_INSTALL_SCRIPT) $(LIBEVENT_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBEVENT_32_PKG)/.REQUIRES
	@echo "pkgname=$(LIBEVENT_32_PKG_NAME)"                            >  $(LIBEVENT_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBEVENT_32_PKG_VERSION)"                          >> $(LIBEVENT_32_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBEVENT_32_PKG_ARCH)"                               >> $(LIBEVENT_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBEVENT_32_PKG_DISTRO_NAME)"                  >> $(LIBEVENT_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBEVENT_32_PKG_DISTRO_VERSION)"                >> $(LIBEVENT_32_PKG)/.PKGINFO ; \
	 echo "group=$(LIBEVENT_32_PKG_GROUP)"                             >> $(LIBEVENT_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBEVENT_32_PKG_SHORT_DESCRIPTION)\"" >> $(LIBEVENT_32_PKG)/.PKGINFO ; \
	 echo "url=$(LIBEVENT_32_PKG_URL)"                                 >> $(LIBEVENT_32_PKG)/.PKGINFO ; \
	 echo "license=$(LIBEVENT_32_PKG_LICENSE)"                         >> $(LIBEVENT_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBEVENT_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
