
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/jbigkit

REQUIRES           = app/jbigkit/2.1

# ======= __END_OF_REQUIRES__ =======


version            = 2.1
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/a/jbigkit/jbigkit-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/jbigkit-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
JBIGKIT_32_PKG_NAME                = jbigkit-x32
JBIGKIT_32_PKG_VERSION             = 2.1
JBIGKIT_32_PKG_ARCH                = $(TOOLCHAIN)
JBIGKIT_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
JBIGKIT_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
JBIGKIT_32_PKG_GROUP               = $(PKG_GROUP)
###                                 |---handy-ruler-------------------------------|
JBIGKIT_32_PKG_SHORT_DESCRIPTION   = lossless image compression library
JBIGKIT_32_PKG_URL                 = $(BUG_URL)
JBIGKIT_32_PKG_LICENSE             = GPLv2
JBIGKIT_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(JBIGKIT_32_PKG_NAME)-pkg-description
JBIGKIT_32_PKG_DESCRIPTION_FILE_IN = $(JBIGKIT_32_PKG_NAME)-pkg-description.in
JBIGKIT_32_PKG_INSTALL_SCRIPT      = $(JBIGKIT_32_PKG_NAME)-pkg-install.sh

JBIGKIT_32_PKG   = $(CURDIR)/$(TARGET_BUILD_DIR)/$(JBIGKIT_32_PKG_NAME)-package

pkg_basename     = $(JBIGKIT_32_PKG_NAME)-$(JBIGKIT_32_PKG_VERSION)-$(JBIGKIT_32_PKG_ARCH)-$(JBIGKIT_32_PKG_DISTRO_NAME)-$(JBIGKIT_32_PKG_DISTRO_VERSION)

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


CFLAGS += -fPIC -W -Wall -Wno-unused-result -I../libjbig


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(JBIGKIT_32_PKG)/usr/bin/32
	@mkdir -p $(JBIGKIT_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)
	@( cd $(SRC_DIR)/libjbig ; \
	   cp -a libjbig.a libjbig85.a $(JBIGKIT_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	 )
	@( cd $(SRC_DIR)/pbmtools ; \
	   cp -a jbgtopbm pbmtojbg jbgtopbm85 pbmtojbg85 $(JBIGKIT_32_PKG)/usr/bin/32 ; \
	 )
	@chmod 0755 $(JBIGKIT_32_PKG)/usr/bin/32/*
	@chmod 0644 $(JBIGKIT_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/*
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(JBIGKIT_32_PKG))
	# ======= Strip binaries =======
	@( cd $(JBIGKIT_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(JBIGKIT_32_PKG_DESCRIPTION_FILE): $(JBIGKIT_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(JBIGKIT_32_PKG_DESCRIPTION_FILE) $(JBIGKIT_32_PKG_INSTALL_SCRIPT)
	@cp $(JBIGKIT_32_PKG_DESCRIPTION_FILE) $(JBIGKIT_32_PKG)/.DESCRIPTION
	@cp $(JBIGKIT_32_PKG_INSTALL_SCRIPT) $(JBIGKIT_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(JBIGKIT_32_PKG)/.REQUIRES
	@echo "pkgname=$(JBIGKIT_32_PKG_NAME)"                            >  $(JBIGKIT_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(JBIGKIT_32_PKG_VERSION)"                          >> $(JBIGKIT_32_PKG)/.PKGINFO ; \
	 echo "arch=$(JBIGKIT_32_PKG_ARCH)"                               >> $(JBIGKIT_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(JBIGKIT_32_PKG_DISTRO_NAME)"                  >> $(JBIGKIT_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(JBIGKIT_32_PKG_DISTRO_VERSION)"                >> $(JBIGKIT_32_PKG)/.PKGINFO ; \
	 echo "group=$(JBIGKIT_32_PKG_GROUP)"                             >> $(JBIGKIT_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(JBIGKIT_32_PKG_SHORT_DESCRIPTION)\"" >> $(JBIGKIT_32_PKG)/.PKGINFO ; \
	 echo "url=$(JBIGKIT_32_PKG_URL)"                                 >> $(JBIGKIT_32_PKG)/.PKGINFO ; \
	 echo "license=$(JBIGKIT_32_PKG_LICENSE)"                         >> $(JBIGKIT_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(JBIGKIT_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
