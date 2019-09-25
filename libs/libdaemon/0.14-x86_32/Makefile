
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/libdaemon

REQUIRES           = libs/libdaemon/0.14

# ======= __END_OF_REQUIRES__ =======


version            = 0.14
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/libdaemon/libdaemon-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libdaemon-$(version)
src_dir_name       = libdaemon-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done

hw_cache           = $(CURDIR)/$(build_dir)/hw.cache


####### Targets

PKG_GROUP = libs
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LIBDAEMON_32_PKG_NAME                = libdaemon-x32
LIBDAEMON_32_PKG_VERSION             = 0.14
LIBDAEMON_32_PKG_ARCH                = $(TOOLCHAIN)
LIBDAEMON_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBDAEMON_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBDAEMON_32_PKG_GROUP               = $(PKG_GROUP)
###                                   |---handy-ruler-------------------------------|
LIBDAEMON_32_PKG_SHORT_DESCRIPTION   = library for writing UNIX daemons
LIBDAEMON_32_PKG_URL                 = $(BUG_URL)
LIBDAEMON_32_PKG_LICENSE             = LGPLv2.1
LIBDAEMON_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBDAEMON_32_PKG_NAME)-pkg-description
LIBDAEMON_32_PKG_DESCRIPTION_FILE_IN = $(LIBDAEMON_32_PKG_NAME)-pkg-description.in
LIBDAEMON_32_PKG_INSTALL_SCRIPT      = $(LIBDAEMON_32_PKG_NAME)-pkg-install.sh

LIBDAEMON_32_PKG  = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBDAEMON_32_PKG_NAME)-package

pkg_basename      = $(LIBDAEMON_32_PKG_NAME)-$(LIBDAEMON_32_PKG_VERSION)-$(LIBDAEMON_32_PKG_ARCH)-$(LIBDAEMON_32_PKG_DISTRO_NAME)-$(LIBDAEMON_32_PKG_DISTRO_VERSION)

pkg_archive       = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_certificate  = $(call cert-name,$(pkg_archive))
pkg_signature     = $(call sign-name,$(pkg_archive))
pkg_description   = $(call desc-name,$(pkg_archive))
products          = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS     = $(build_target)
BUILD_TARGETS    += $(install_target)

PRODUCT_TARGETS   = $(products)

ROOTFS_TARGETS    = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(LIBDAEMON_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --disable-lynx

extra_configure_switches += --cache-file=$(hw_cache)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@echo "ac_cv_func_setpgrp_void=yes" > $(hw_cache)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LIBDAEMON_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(LIBDAEMON_32_PKG)/usr/include
	@rm -rf $(LIBDAEMON_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBDAEMON_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libdaemon.la  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBDAEMON_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libdaemon.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libdaemon.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libdaemon.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBDAEMON_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBDAEMON_32_PKG_DESCRIPTION_FILE): $(LIBDAEMON_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBDAEMON_32_PKG_DESCRIPTION_FILE) $(LIBDAEMON_32_PKG_INSTALL_SCRIPT)
	@cp $(LIBDAEMON_32_PKG_DESCRIPTION_FILE) $(LIBDAEMON_32_PKG)/.DESCRIPTION
	@cp $(LIBDAEMON_32_PKG_INSTALL_SCRIPT) $(LIBDAEMON_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBDAEMON_32_PKG)/.REQUIRES
	@echo "pkgname=$(LIBDAEMON_32_PKG_NAME)"                            >  $(LIBDAEMON_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBDAEMON_32_PKG_VERSION)"                          >> $(LIBDAEMON_32_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBDAEMON_32_PKG_ARCH)"                               >> $(LIBDAEMON_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBDAEMON_32_PKG_DISTRO_NAME)"                  >> $(LIBDAEMON_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBDAEMON_32_PKG_DISTRO_VERSION)"                >> $(LIBDAEMON_32_PKG)/.PKGINFO ; \
	 echo "group=$(LIBDAEMON_32_PKG_GROUP)"                             >> $(LIBDAEMON_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBDAEMON_32_PKG_SHORT_DESCRIPTION)\"" >> $(LIBDAEMON_32_PKG)/.PKGINFO ; \
	 echo "url=$(LIBDAEMON_32_PKG_URL)"                                 >> $(LIBDAEMON_32_PKG)/.PKGINFO ; \
	 echo "license=$(LIBDAEMON_32_PKG_LICENSE)"                         >> $(LIBDAEMON_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LIBDAEMON_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
