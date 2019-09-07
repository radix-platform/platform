
COMPONENT_TARGETS  = $(HARDWARE_MBC4_PC)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_SPARC32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/zlib

REQUIRES           = libs/zlib/1.2.8
REQUIRES          += libs/glibc/2.27-sparc32

# ======= __END_OF_REQUIRES__ =======


version            = 1.2.8
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/zlib/zlib-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/zlib-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
ZLIB32_PKG_NAME                = zlib-x32
ZLIB32_PKG_VERSION             = 1.2.8
ZLIB32_PKG_ARCH                = $(TOOLCHAIN)
ZLIB32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
ZLIB32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
ZLIB32_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
ZLIB32_PKG_SHORT_DESCRIPTION   = compression library
ZLIB32_PKG_URL                 = $(BUG_URL)
ZLIB32_PKG_LICENSE             = GPLv2
ZLIB32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(ZLIB32_PKG_NAME)-pkg-description
ZLIB32_PKG_DESCRIPTION_FILE_IN = $(ZLIB32_PKG_NAME)-pkg-description.in
ZLIB32_PKG_INSTALL_SCRIPT      = $(ZLIB32_PKG_NAME)-pkg-install.sh

ZLIB32_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(ZLIB32_PKG_NAME)-package

pkg_basename     = $(ZLIB32_PKG_NAME)-$(ZLIB32_PKG_VERSION)-$(ZLIB32_PKG_ARCH)-$(ZLIB32_PKG_DISTRO_NAME)-$(ZLIB32_PKG_DISTRO_VERSION)

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


env_sysroot        = DESTDIR=$(ZLIB32_PKG)
cross_environment  = CROSS_PREFIX=$(CROSS_PREFIX)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_SPARC32_SUFFIX)
extra_configure_switches += --shared


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) ./configure \
	  --prefix=/usr                    \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) $(cross_environment)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(ZLIB32_PKG)/usr/lib$(MULTILIB_SPARC32_SUFFIX)
	@cd $(SRC_DIR) && cp -a libz.a libz.so* $(ZLIB32_PKG)/usr/lib$(MULTILIB_SPARC32_SUFFIX)
	@chmod 755 $(ZLIB32_PKG)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/*
	@chmod 644 $(ZLIB32_PKG)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/libz.a
	@mkdir -p $(ZLIB32_PKG)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/pkgconfig
	@cd $(SRC_DIR) && cat zlib.pc > $(ZLIB32_PKG)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/pkgconfig/zlib.pc
	@mkdir -p $(ZLIB32_PKG)/lib$(MULTILIB_SPARC32_SUFFIX)
	@( cd $(ZLIB32_PKG)/usr/lib$(MULTILIB_SPARC32_SUFFIX) ; \
	   for file in lib*.so.?.* ; do \
	     mv $$file ../../lib$(MULTILIB_SPARC32_SUFFIX) ; \
	     ln -sf ../../lib$(MULTILIB_SPARC32_SUFFIX)/$$file . ; \
	   done ; \
	   cp -a lib*.so.? ../../lib$(MULTILIB_SPARC32_SUFFIX) ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(ZLIB32_PKG))
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" zlib.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(ZLIB32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(ZLIB32_PKG_DESCRIPTION_FILE): $(ZLIB32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(ZLIB32_PKG_DESCRIPTION_FILE) $(ZLIB32_PKG_INSTALL_SCRIPT)
	@cp $(ZLIB32_PKG_DESCRIPTION_FILE) $(ZLIB32_PKG)/.DESCRIPTION
	@cp $(ZLIB32_PKG_INSTALL_SCRIPT) $(ZLIB32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(ZLIB32_PKG)/.REQUIRES
	@echo "pkgname=$(ZLIB32_PKG_NAME)"                            >  $(ZLIB32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(ZLIB32_PKG_VERSION)"                          >> $(ZLIB32_PKG)/.PKGINFO ; \
	 echo "arch=$(ZLIB32_PKG_ARCH)"                               >> $(ZLIB32_PKG)/.PKGINFO ; \
	 echo "distroname=$(ZLIB32_PKG_DISTRO_NAME)"                  >> $(ZLIB32_PKG)/.PKGINFO ; \
	 echo "distrover=$(ZLIB32_PKG_DISTRO_VERSION)"                >> $(ZLIB32_PKG)/.PKGINFO ; \
	 echo "group=$(ZLIB32_PKG_GROUP)"                             >> $(ZLIB32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(ZLIB32_PKG_SHORT_DESCRIPTION)\"" >> $(ZLIB32_PKG)/.PKGINFO ; \
	 echo "url=$(ZLIB32_PKG_URL)"                                 >> $(ZLIB32_PKG)/.PKGINFO ; \
	 echo "license=$(ZLIB32_PKG_LICENSE)"                         >> $(ZLIB32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(ZLIB32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
