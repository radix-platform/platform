
COMPONENT_TARGETS  = $(HARDWARE_MBC4_PC)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_SPARC32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/GNU/libunistring

REQUIRES           = libs/libunistring/0.9.10
REQUIRES          += libs/glibc/2.28-sparc32

# ======= __END_OF_REQUIRES__ =======


version            = 0.9.10
tar_xz_archive     = $(SRC_PACKAGE_PATH)/GNU/libunistring/libunistring-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libunistring-$(version)
src_dir_name       = libunistring-$(version)
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
LIBUNISTR32_PKG_NAME                = libunistring-x32
LIBUNISTR32_PKG_VERSION             = 0.9.10
LIBUNISTR32_PKG_ARCH                = $(TOOLCHAIN)
LIBUNISTR32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBUNISTR32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBUNISTR32_PKG_GROUP               = $(PKG_GROUP)
###                                  |---handy-ruler-------------------------------|
LIBUNISTR32_PKG_SHORT_DESCRIPTION   = GNU Unicode string library
LIBUNISTR32_PKG_URL                 = $(BUG_URL)
LIBUNISTR32_PKG_LICENSE             = GPLv2
LIBUNISTR32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBUNISTR32_PKG_NAME)-pkg-description
LIBUNISTR32_PKG_DESCRIPTION_FILE_IN = $(LIBUNISTR32_PKG_NAME)-pkg-description.in
LIBUNISTR32_PKG_INSTALL_SCRIPT      = $(LIBUNISTR32_PKG_NAME)-pkg-install.sh

LIBUNISTR32_PKG  = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBUNISTR32_PKG_NAME)-package

pkg_basename     = $(LIBUNISTR32_PKG_NAME)-$(LIBUNISTR32_PKG_VERSION)-$(LIBUNISTR32_PKG_ARCH)-$(LIBUNISTR32_PKG_DISTRO_NAME)-$(LIBUNISTR32_PKG_DISTRO_VERSION)

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


env_sysroot  = DESTDIR=$(LIBUNISTR32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_SPARC32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --disable-rpath
ifeq ($(__ENABLE_STATIC__),yes)
extra_configure_switches += --enable-static=yes
else
extra_configure_switches += --enable-static=no
endif
extra_configure_switches += --enable-shared=yes


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
	@mkdir -p $(LIBUNISTR32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(LIBUNISTR32_PKG)/usr/include
	@rm -rf $(LIBUNISTR32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBUNISTR32_PKG)/usr/lib$(MULTILIB_SPARC32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libunistring.la  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBUNISTR32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_SPARC32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libunistring.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libunistring.la \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBUNISTR32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifeq ($(__ENABLE_STATIC__),yes)
	@( cd $(LIBUNISTR32_PKG) ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null ; \
	 )
endif
	@touch $@

$(LIBUNISTR32_PKG_DESCRIPTION_FILE): $(LIBUNISTR32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBUNISTR32_PKG_DESCRIPTION_FILE) $(LIBUNISTR32_PKG_INSTALL_SCRIPT)
	@cp $(LIBUNISTR32_PKG_DESCRIPTION_FILE) $(LIBUNISTR32_PKG)/.DESCRIPTION
	@cp $(LIBUNISTR32_PKG_INSTALL_SCRIPT) $(LIBUNISTR32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBUNISTR32_PKG)/.REQUIRES
	@echo "pkgname=$(LIBUNISTR32_PKG_NAME)"                            >  $(LIBUNISTR32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBUNISTR32_PKG_VERSION)"                          >> $(LIBUNISTR32_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBUNISTR32_PKG_ARCH)"                               >> $(LIBUNISTR32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBUNISTR32_PKG_DISTRO_NAME)"                  >> $(LIBUNISTR32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBUNISTR32_PKG_DISTRO_VERSION)"                >> $(LIBUNISTR32_PKG)/.PKGINFO ; \
	 echo "group=$(LIBUNISTR32_PKG_GROUP)"                             >> $(LIBUNISTR32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBUNISTR32_PKG_SHORT_DESCRIPTION)\"" >> $(LIBUNISTR32_PKG)/.PKGINFO ; \
	 echo "url=$(LIBUNISTR32_PKG_URL)"                                 >> $(LIBUNISTR32_PKG)/.PKGINFO ; \
	 echo "license=$(LIBUNISTR32_PKG_LICENSE)"                         >> $(LIBUNISTR32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LIBUNISTR32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
