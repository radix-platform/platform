
COMPONENT_TARGETS   = $(HARDWARE_PC32)
COMPONENT_TARGETS  += $(HARDWARE_PC64)
COMPONENT_TARGETS  += $(HARDWARE_CB1X)
COMPONENT_TARGETS  += $(HARDWARE_CB2X)
COMPONENT_TARGETS  += $(HARDWARE_VIP1830)
COMPONENT_TARGETS  += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS  += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS  += $(HARDWARE_B74)


NEED_ABS_PATH       = true
COMPONENT_IS_3PP    = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES     = sources/packages/n/bsd-finger

REQUIRES            = libs/eglibc/2.19.1


version             = 0.17
tar_gz_archive      = $(SRC_PACKAGE_PATH)/packages/n/bsd-finger/bsd-finger-$(version).tar.gz
SRC_ARCHIVE         = $(tar_gz_archive)
SRC_DIR             = $(TARGET_BUILD_DIR)/bsd-finger-$(version)
src_dir_name        = bsd-finger-$(version)
src_done            = $(TARGET_BUILD_DIR)/.source-done


PATCHES = PATCHES

build_target        = $(TARGET_BUILD_DIR)/.build_done
install_target      = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
FINGER_PKG_NAME                = bsd-finger
FINGER_PKG_VERSION             = 0.17
FINGER_PKG_ARCH                = $(TOOLCHAIN)
FINGER_PKG_DISTRO_NAME         = $(DISTRO_NAME)
FINGER_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
FINGER_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
FINGER_PKG_SHORT_DESCRIPTION   = user information lookup program
FINGER_PKG_URL                 = $(BUG_URL)
FINGER_PKG_LICENSE             = BSD
FINGER_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(FINGER_PKG_NAME)-pkg-description
FINGER_PKG_DESCRIPTION_FILE_IN = $(FINGER_PKG_NAME)-pkg-description.in
FINGER_PKG_INSTALL_SCRIPT      = $(FINGER_PKG_NAME)-pkg-install.sh

FINGER_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(FINGER_PKG_NAME)-package

pkg_basename     = $(FINGER_PKG_NAME)-$(FINGER_PKG_VERSION)-$(FINGER_PKG_ARCH)-$(FINGER_PKG_DISTRO_NAME)-$(FINGER_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


finger_CFLAGS = -isystem $(TARGET_DEST_DIR)/usr/include $(OPTIMIZATION_FLAGS) $(ARCH_FLAGS) $(HW_FLAGS) -Wall
finger_environment = CFLAGS="$(finger_CFLAGS)"


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(finger_environment) ./configure --prefix=/usr
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(finger_environment) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(FINGER_PKG)/usr/bin
	@mkdir -p $(FINGER_PKG)/usr/sbin
	@mkdir -p $(FINGER_PKG)/usr/share/man/man{1,8}
	@mkdir -p $(FINGER_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR)/finger ; \
	   cat finger > $(FINGER_PKG)/usr/bin/finger ; \
	   chmod 755 $(FINGER_PKG)/usr/bin/* ; \
	   cat finger.1 | gzip -9c > $(FINGER_PKG)/usr/share/man/man1/finger.1.gz ; \
	 )
	@( cd $(SRC_DIR)/fingerd ; \
	   cat fingerd > $(FINGER_PKG)/usr/sbin/in.fingerd ; \
	   chmod 755 $(FINGER_PKG)/usr/sbin/* ; \
	   cat fingerd.8 | gzip -9c > $(FINGER_PKG)/usr/share/man/man8/in.fingerd.8.gz ; \
	 )
	@( cd $(SRC_DIR) ; \
	   cp -a README \
	         $(FINGER_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(FINGER_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(FINGER_PKG) && cp -rf * $(TARGET_DEST_DIR)
	@(cd $(FINGER_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(FINGER_PKG_DESCRIPTION_FILE): $(FINGER_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(FINGER_PKG_DESCRIPTION_FILE) $(FINGER_PKG_INSTALL_SCRIPT)
	@cp $(FINGER_PKG_DESCRIPTION_FILE) $(FINGER_PKG)/.DESCRIPTION
	@cp $(FINGER_PKG_INSTALL_SCRIPT) $(FINGER_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(FINGER_PKG)/.REQUIRES
	@echo "pkgname=$(FINGER_PKG_NAME)"                            >  $(FINGER_PKG)/.PKGINFO ; \
	 echo "pkgver=$(FINGER_PKG_VERSION)"                          >> $(FINGER_PKG)/.PKGINFO ; \
	 echo "arch=$(FINGER_PKG_ARCH)"                               >> $(FINGER_PKG)/.PKGINFO ; \
	 echo "distroname=$(FINGER_PKG_DISTRO_NAME)"                  >> $(FINGER_PKG)/.PKGINFO ; \
	 echo "distrover=$(FINGER_PKG_DISTRO_VERSION)"                >> $(FINGER_PKG)/.PKGINFO ; \
	 echo "group=$(FINGER_PKG_GROUP)"                             >> $(FINGER_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(FINGER_PKG_SHORT_DESCRIPTION)\"" >> $(FINGER_PKG)/.PKGINFO ; \
	 echo "url=$(FINGER_PKG_URL)"                                 >> $(FINGER_PKG)/.PKGINFO ; \
	 echo "license=$(FINGER_PKG_LICENSE)"                         >> $(FINGER_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(FINGER_PKG)  && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
