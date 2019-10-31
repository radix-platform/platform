
COMPONENT_TARGETS  = $(HARDWARE_MBC4_PC)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_SPARC32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/bzip2

REQUIRES           = app/bzip2/1.0.6
REQUIRES          += libs/glibc/2.28-sparc32

# ======= __END_OF_REQUIRES__ =======


version            = 1.0.6
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/a/bzip2/bzip2-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/bzip2-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
BZIP2_32_PKG_NAME                = bzip2-x32
BZIP2_32_PKG_VERSION             = 1.0.6
BZIP2_32_PKG_ARCH                = $(TOOLCHAIN)
BZIP2_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
BZIP2_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
BZIP2_32_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
BZIP2_32_PKG_SHORT_DESCRIPTION   = block-sorting file compressor
BZIP2_32_PKG_URL                 = $(BUG_URL)
BZIP2_32_PKG_LICENSE             = GPLv2
BZIP2_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(BZIP2_32_PKG_NAME)-pkg-description
BZIP2_32_PKG_DESCRIPTION_FILE_IN = $(BZIP2_32_PKG_NAME)-pkg-description.in
BZIP2_32_PKG_INSTALL_SCRIPT      = $(BZIP2_32_PKG_NAME)-pkg-install.sh

BZIP2_32_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(BZIP2_32_PKG_NAME)-package

pkg_basename     = $(BZIP2_32_PKG_NAME)-$(BZIP2_32_PKG_VERSION)-$(BZIP2_32_PKG_ARCH)-$(BZIP2_32_PKG_DISTRO_NAME)-$(BZIP2_32_PKG_DISTRO_VERSION)

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


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -f Makefile-libbz2_so
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(BZIP2_32_PKG)/usr/lib$(MULTILIB_SPARC32_SUFFIX)
ifeq ($(__ENABLE_STATIC__),yes)
	@cd $(SRC_DIR) && cp -a libbz2.a $(BZIP2_32_PKG)/usr/lib$(MULTILIB_SPARC32_SUFFIX)
	@chmod 644 $(BZIP2_32_PKG)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/libbz2.a
endif
	@mkdir -p $(BZIP2_32_PKG)/lib$(MULTILIB_SPARC32_SUFFIX)
	@cd $(SRC_DIR) && cp -a libbz2.so.$(version) $(BZIP2_32_PKG)/lib$(MULTILIB_SPARC32_SUFFIX)
	@chmod 755 $(BZIP2_32_PKG)/lib$(MULTILIB_SPARC32_SUFFIX)/libbz2.so.$(version)
	@mkdir -p $(BZIP2_32_PKG)/bin/32
	@mkdir -p $(BZIP2_32_PKG)/usr/bin/32
	@cd $(SRC_DIR) && cat bzip2-shared > $(BZIP2_32_PKG)/bin/32/bzip2
	@cd $(SRC_DIR) && cat bzip2recover > $(BZIP2_32_PKG)/bin/32/bzip2recover
	@chmod 755 $(BZIP2_32_PKG)/bin/32/bzip2
	@chmod 755 $(BZIP2_32_PKG)/bin/32/bzip2recover
	@( cd $(BZIP2_32_PKG)/lib$(MULTILIB_SPARC32_SUFFIX) ; \
	   rm -f libbz2.so.1.0 libbz2.so.1 ; \
	   ln -sf libbz2.so.$(version) libbz2.so.1.0 ; \
	   ln -sf libbz2.so.1.0 libbz2.so.1 \
	 )
	@( cd $(BZIP2_32_PKG)/usr/lib$(MULTILIB_SPARC32_SUFFIX) ; \
	   ln -sf ../../lib$(MULTILIB_SPARC32_SUFFIX)/libbz2.so.$(version) libbz2.so.$(version) ; \
	   ln -sf libbz2.so.$(version) libbz2.so.1.0 ; \
	   ln -sf libbz2.so.1.0 libbz2.so.1 ; \
	   ln -sf libbz2.so.1 libbz2.so \
	 )
	@( cd $(BZIP2_32_PKG)/bin/32 ; \
	   ln -sf bzip2 bunzip2 ; \
	   ln -sf bzip2 bzcat \
	 )
	@( cd $(BZIP2_32_PKG)/usr/bin/32 ; \
	   ln -sf ../../../bin/32/bzip2 . ; \
	   ln -sf ../../../bin/32/bzip2 bunzip2 ; \
	   ln -sf ../../../bin/32/bzip2 bzcat \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(BZIP2_32_PKG))
	# ======= Strip binaries =======
	@( cd $(BZIP2_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifeq ($(__ENABLE_STATIC__),yes)
	@( cd $(BZIP2_32_PKG) ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null ; \
	 )
endif
	@touch $@

$(BZIP2_32_PKG_DESCRIPTION_FILE): $(BZIP2_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(BZIP2_32_PKG_DESCRIPTION_FILE) $(BZIP2_32_PKG_INSTALL_SCRIPT)
	@cp $(BZIP2_32_PKG_DESCRIPTION_FILE) $(BZIP2_32_PKG)/.DESCRIPTION
	@cp $(BZIP2_32_PKG_INSTALL_SCRIPT) $(BZIP2_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(BZIP2_32_PKG)/.REQUIRES
	@echo "pkgname=$(BZIP2_32_PKG_NAME)"                            >  $(BZIP2_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(BZIP2_32_PKG_VERSION)"                          >> $(BZIP2_32_PKG)/.PKGINFO ; \
	 echo "arch=$(BZIP2_32_PKG_ARCH)"                               >> $(BZIP2_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(BZIP2_32_PKG_DISTRO_NAME)"                  >> $(BZIP2_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(BZIP2_32_PKG_DISTRO_VERSION)"                >> $(BZIP2_32_PKG)/.PKGINFO ; \
	 echo "group=$(BZIP2_32_PKG_GROUP)"                             >> $(BZIP2_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(BZIP2_32_PKG_SHORT_DESCRIPTION)\"" >> $(BZIP2_32_PKG)/.PKGINFO ; \
	 echo "url=$(BZIP2_32_PKG_URL)"                                 >> $(BZIP2_32_PKG)/.PKGINFO ; \
	 echo "license=$(BZIP2_32_PKG_LICENSE)"                         >> $(BZIP2_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(BZIP2_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
