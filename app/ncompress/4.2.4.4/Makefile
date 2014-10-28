
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_VIP1830)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES     = sources/packages/a/ncompress

REQUIRES            = libs/eglibc/2.19.1


version             = 4.2.4.4
tar_gz_archive      = $(SRC_PACKAGE_PATH)/packages/a/ncompress/ncompress-$(version).tar.gz
SRC_ARCHIVE         = $(tar_gz_archive)
SRC_DIR             = $(TARGET_BUILD_DIR)/ncompress-$(version)
src_done            = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target        = $(TARGET_BUILD_DIR)/.build_done
install_target      = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
NCOMPRESS_PKG_NAME                = ncompress
NCOMPRESS_PKG_VERSION             = 4.2.4.4
NCOMPRESS_PKG_ARCH                = $(TOOLCHAIN)
NCOMPRESS_PKG_DISTRO_NAME         = $(DISTRO_NAME)
NCOMPRESS_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
NCOMPRESS_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
NCOMPRESS_PKG_SHORT_DESCRIPTION   = the classic \*nix compression utility
NCOMPRESS_PKG_URL                 = $(BUG_URL)
NCOMPRESS_PKG_LICENSE             = GPLv2
NCOMPRESS_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(NCOMPRESS_PKG_NAME)-pkg-description
NCOMPRESS_PKG_DESCRIPTION_FILE_IN = $(NCOMPRESS_PKG_NAME)-pkg-description.in
NCOMPRESS_PKG_INSTALL_SCRIPT      = $(NCOMPRESS_PKG_NAME)-pkg-install.sh

NCOMPRESS_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(NCOMPRESS_PKG_NAME)-package

pkg_basename     = $(NCOMPRESS_PKG_NAME)-$(NCOMPRESS_PKG_VERSION)-$(NCOMPRESS_PKG_ARCH)-$(NCOMPRESS_PKG_DISTRO_NAME)-$(NCOMPRESS_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
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
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) ENDIAN=4321
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(NCOMPRESS_PKG)/usr/bin
	@cd $(SRC_DIR) && cp -a compress $(NCOMPRESS_PKG)/usr/bin
	@chmod 755 $(NCOMPRESS_PKG)/usr/bin/*
	@( cd $(NCOMPRESS_PKG)/usr/bin ; ln -sf compress uncompress )
	@mkdir -p $(NCOMPRESS_PKG)/bin
	@( cd $(NCOMPRESS_PKG)/bin ; ln -sf ../usr/bin/compress compress )
	@( cd $(NCOMPRESS_PKG)/bin ; ln -sf compress uncompress )
	@mkdir -p $(NCOMPRESS_PKG)/usr/share/man/man1
	@cd $(SRC_DIR) && cat compress.1 | gzip -9c > $(NCOMPRESS_PKG)/usr/share/man/man1/compress.1.gz
	@echo '.so man1/compress.1' | gzip -9c > $(NCOMPRESS_PKG)/usr/share/man/man1/uncompress.1.gz
	@mkdir -p $(NCOMPRESS_PKG)/usr/doc/ncompress-$(version)
	@( cd $(SRC_DIR) ; \
	   cp -a Acknowleds \
	         $(NCOMPRESS_PKG)/usr/doc/ncompress-$(version) \
	 )
	@mkdir -p $(NCOMPRESS_PKG)/usr/share/doc/ncompress-$(version)
	@( cd $(SRC_DIR) ; \
	   cp -a Acknowleds Changes LZW.INFO README \
	         $(NCOMPRESS_PKG)/usr/share/doc/ncompress-$(version) \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(NCOMPRESS_PKG) && cp -rf * $(TARGET_DEST_DIR)
	@(cd $(NCOMPRESS_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null \
	 )
	@touch $@

$(NCOMPRESS_PKG_DESCRIPTION_FILE): $(NCOMPRESS_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(NCOMPRESS_PKG_DESCRIPTION_FILE) $(NCOMPRESS_PKG_INSTALL_SCRIPT)
	@cp $(NCOMPRESS_PKG_DESCRIPTION_FILE) $(NCOMPRESS_PKG)/.DESCRIPTION
	@cp $(NCOMPRESS_PKG_INSTALL_SCRIPT) $(NCOMPRESS_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(NCOMPRESS_PKG)/.REQUIRES
	@echo "pkgname=$(NCOMPRESS_PKG_NAME)"                            >  $(NCOMPRESS_PKG)/.PKGINFO ; \
	 echo "pkgver=$(NCOMPRESS_PKG_VERSION)"                          >> $(NCOMPRESS_PKG)/.PKGINFO ; \
	 echo "arch=$(NCOMPRESS_PKG_ARCH)"                               >> $(NCOMPRESS_PKG)/.PKGINFO ; \
	 echo "distroname=$(NCOMPRESS_PKG_DISTRO_NAME)"                  >> $(NCOMPRESS_PKG)/.PKGINFO ; \
	 echo "distrover=$(NCOMPRESS_PKG_DISTRO_VERSION)"                >> $(NCOMPRESS_PKG)/.PKGINFO ; \
	 echo "group=$(NCOMPRESS_PKG_GROUP)"                             >> $(NCOMPRESS_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(NCOMPRESS_PKG_SHORT_DESCRIPTION)\"" >> $(NCOMPRESS_PKG)/.PKGINFO ; \
	 echo "url=$(NCOMPRESS_PKG_URL)"                                 >> $(NCOMPRESS_PKG)/.PKGINFO ; \
	 echo "license=$(NCOMPRESS_PKG_LICENSE)"                         >> $(NCOMPRESS_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(NCOMPRESS_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
