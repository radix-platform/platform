
COMPONENT_TARGETS  = $(HARDWARE_MBC4_PC)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_SPARC32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/lzo

REQUIRES           = libs/lzo/2.10
REQUIRES          += libs/glibc/2.28-sparc32

# ======= __END_OF_REQUIRES__ =======


version            = 2.10
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/lzo/lzo-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/lzo-$(version)
src_dir_name       = lzo-$(version)
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
LZO_32_PKG_NAME                = lzo-x32
LZO_32_PKG_VERSION             = 2.10
LZO_32_PKG_ARCH                = $(TOOLCHAIN)
LZO_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LZO_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LZO_32_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
LZO_32_PKG_SHORT_DESCRIPTION   = LZO Compression Library
LZO_32_PKG_URL                 = $(BUG_URL)
LZO_32_PKG_LICENSE             = GPLv2
LZO_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LZO_32_PKG_NAME)-pkg-description
LZO_32_PKG_DESCRIPTION_FILE_IN = $(LZO_32_PKG_NAME)-pkg-description.in
LZO_32_PKG_INSTALL_SCRIPT      = $(LZO_32_PKG_NAME)-pkg-install.sh

LZO_32_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LZO_32_PKG_NAME)-package

pkg_basename     = $(LZO_32_PKG_NAME)-$(LZO_32_PKG_VERSION)-$(LZO_32_PKG_ARCH)-$(LZO_32_PKG_DISTRO_NAME)-$(LZO_32_PKG_DISTRO_VERSION)

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


env_sysroot  = DESTDIR=$(LZO_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_SPARC32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
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
	@mkdir -p $(LZO_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(LZO_32_PKG)/usr/include
	@rm -rf $(LZO_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LZO_32_PKG)/usr/lib$(MULTILIB_SPARC32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" liblzo?.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LZO_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_SPARC32_SUFFIX) ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" liblzo?.la  ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" liblzo?.la  \
	 )
	# ======= Strip binaries =======
	@( cd $(LZO_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifeq ($(__ENABLE_STATIC__),yes)
	@( cd $(LZO_32_PKG) ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null ; \
	 )
endif
	@touch $@

$(LZO_32_PKG_DESCRIPTION_FILE): $(LZO_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LZO_32_PKG_DESCRIPTION_FILE) $(LZO_32_PKG_INSTALL_SCRIPT)
	@cp $(LZO_32_PKG_DESCRIPTION_FILE) $(LZO_32_PKG)/.DESCRIPTION
	@cp $(LZO_32_PKG_INSTALL_SCRIPT) $(LZO_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LZO_32_PKG)/.REQUIRES
	@echo "pkgname=$(LZO_32_PKG_NAME)"                            >  $(LZO_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LZO_32_PKG_VERSION)"                          >> $(LZO_32_PKG)/.PKGINFO ; \
	 echo "arch=$(LZO_32_PKG_ARCH)"                               >> $(LZO_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LZO_32_PKG_DISTRO_NAME)"                  >> $(LZO_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LZO_32_PKG_DISTRO_VERSION)"                >> $(LZO_32_PKG)/.PKGINFO ; \
	 echo "group=$(LZO_32_PKG_GROUP)"                             >> $(LZO_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LZO_32_PKG_SHORT_DESCRIPTION)\"" >> $(LZO_32_PKG)/.PKGINFO ; \
	 echo "url=$(LZO_32_PKG_URL)"                                 >> $(LZO_32_PKG)/.PKGINFO ; \
	 echo "license=$(LZO_32_PKG_LICENSE)"                         >> $(LZO_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LZO_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
