
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES     = sources/packages/a/getty-ps

REQUIRES            = libs/libtermcap/1.2.3

# ======= __END_OF_REQUIRES__ =======


version             = 2.1.0b
tar_gz_archive      = $(SRC_PACKAGE_PATH)/packages/a/getty-ps/getty_ps-$(version).tar.gz
SRC_ARCHIVE         = $(tar_gz_archive)
SRC_DIR             = $(TARGET_BUILD_DIR)/getty_ps-$(version)
src_dir_name        = getty-ps-$(version)
src_done            = $(TARGET_BUILD_DIR)/.source_done

license             = $(CURDIR)/license/COPYING

PATCHES = PATCHES

build_target        = $(TARGET_BUILD_DIR)/.build_done
install_target      = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
GETTY_PS_PKG_NAME                = getty-ps
GETTY_PS_PKG_VERSION             = 2.1.0b
GETTY_PS_PKG_ARCH                = $(TOOLCHAIN)
GETTY_PS_PKG_DISTRO_NAME         = $(DISTRO_NAME)
GETTY_PS_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
GETTY_PS_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
GETTY_PS_PKG_SHORT_DESCRIPTION   = console or terminal login
GETTY_PS_PKG_URL                 = $(BUG_URL)
GETTY_PS_PKG_LICENSE             = GPLv2
GETTY_PS_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GETTY_PS_PKG_NAME)-pkg-description
GETTY_PS_PKG_DESCRIPTION_FILE_IN = $(GETTY_PS_PKG_NAME)-pkg-description.in
GETTY_PS_PKG_INSTALL_SCRIPT      = $(GETTY_PS_PKG_NAME)-pkg-install.sh

GETTY_PS_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GETTY_PS_PKG_NAME)-package

pkg_basename     = $(GETTY_PS_PKG_NAME)-$(GETTY_PS_PKG_VERSION)-$(GETTY_PS_PKG_ARCH)-$(GETTY_PS_PKG_DISTRO_NAME)-$(GETTY_PS_PKG_DISTRO_VERSION)

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
	# ======= Prevent "error: conflicting types for 'send'"  =======
	# ======= because send is already defined in <sys/net.h> =======
	@( cd $(SRC_DIR) ; sed -i -e "s/send/gettysend/g" funcs.c )
	@cd $(SRC_DIR) && $(MAKE) clean
	@( cd $(SRC_DIR) ; rm getty uugetty )
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(GETTY_PS_PKG)/sbin
	@( cd $(SRC_DIR) ; \
	   cat getty > $(GETTY_PS_PKG)/sbin/getty ; \
	   cat uugetty > $(GETTY_PS_PKG)/sbin/uugetty ; \
	   chmod 0755 $(GETTY_PS_PKG)/sbin/* \
	 )
	@mkdir -p $(GETTY_PS_PKG)/etc/default
	@( cd $(SRC_DIR) ; \
	   cat Examples/gettydefs > $(GETTY_PS_PKG)/etc/gettydefs ; \
	   cp -a Examples/default/* $(GETTY_PS_PKG)/etc/default   ; \
	 )
	# ======= man pages =======
	@mkdir -p $(GETTY_PS_PKG)/usr/share/man/man{1,5}
	@( cd $(SRC_DIR) ; \
	   cat man/getty.1 | gzip -9c > $(GETTY_PS_PKG)/usr/share/man/man1/getty.1.gz ; \
	   cat man/gettydefs.5 | gzip -9c > $(GETTY_PS_PKG)/usr/share/man/man5/gettydefs.5.gz ; \
	 )
	@( cd $(GETTY_PS_PKG)/usr/share/man/man1 ; ln -s getty.1.gz uugetty.1.gz )
	# ======= documentation =======
	@mkdir -p $(GETTY_PS_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(license) $(GETTY_PS_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(GETTY_PS_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a ANNOUNCE ChangeLog README.* Examples *.lsm INSTALL \
	         $(GETTY_PS_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(GETTY_PS_PKG))
	# ======= Strip binaries =======
	@( cd $(GETTY_PS_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null \
	 )
	@touch $@

$(GETTY_PS_PKG_DESCRIPTION_FILE): $(GETTY_PS_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(GETTY_PS_PKG_DESCRIPTION_FILE) $(GETTY_PS_PKG_INSTALL_SCRIPT)
	@cp $(GETTY_PS_PKG_DESCRIPTION_FILE) $(GETTY_PS_PKG)/.DESCRIPTION
	@cp $(GETTY_PS_PKG_INSTALL_SCRIPT) $(GETTY_PS_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GETTY_PS_PKG)/.REQUIRES
	@echo "pkgname=$(GETTY_PS_PKG_NAME)"                            >  $(GETTY_PS_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GETTY_PS_PKG_VERSION)"                          >> $(GETTY_PS_PKG)/.PKGINFO ; \
	 echo "arch=$(GETTY_PS_PKG_ARCH)"                               >> $(GETTY_PS_PKG)/.PKGINFO ; \
	 echo "distroname=$(GETTY_PS_PKG_DISTRO_NAME)"                  >> $(GETTY_PS_PKG)/.PKGINFO ; \
	 echo "distrover=$(GETTY_PS_PKG_DISTRO_VERSION)"                >> $(GETTY_PS_PKG)/.PKGINFO ; \
	 echo "group=$(GETTY_PS_PKG_GROUP)"                             >> $(GETTY_PS_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GETTY_PS_PKG_SHORT_DESCRIPTION)\"" >> $(GETTY_PS_PKG)/.PKGINFO ; \
	 echo "url=$(GETTY_PS_PKG_URL)"                                 >> $(GETTY_PS_PKG)/.PKGINFO ; \
	 echo "license=$(GETTY_PS_PKG_LICENSE)"                         >> $(GETTY_PS_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(GETTY_PS_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
