
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


SOURCE_REQUIRES     = sources/packages/n/biff+comsat

REQUIRES            = libs/eglibc/2.19.1

# ======= __END_OF_REQUIRES__ =======


version             = 0.17
tar_gz_archive      = $(SRC_PACKAGE_PATH)/packages/n/biff+comsat/biff+comsat-$(version).tar.gz
SRC_ARCHIVE         = $(tar_gz_archive)
SRC_DIR             = $(TARGET_BUILD_DIR)/biff+comsat-$(version)
src_dir_name        = biff+comsat-$(version)
src_done            = $(TARGET_BUILD_DIR)/.source-done


PATCHES = PATCHES

build_target        = $(TARGET_BUILD_DIR)/.build_done
install_target      = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
COMSAT_PKG_NAME                = biff+comsat
COMSAT_PKG_VERSION             = 0.17
COMSAT_PKG_ARCH                = $(TOOLCHAIN)
COMSAT_PKG_DISTRO_NAME         = $(DISTRO_NAME)
COMSAT_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
COMSAT_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
COMSAT_PKG_SHORT_DESCRIPTION   = mail arrival notification daemon
COMSAT_PKG_URL                 = $(BUG_URL)
COMSAT_PKG_LICENSE             = BSD
COMSAT_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(COMSAT_PKG_NAME)-pkg-description
COMSAT_PKG_DESCRIPTION_FILE_IN = $(COMSAT_PKG_NAME)-pkg-description.in
COMSAT_PKG_INSTALL_SCRIPT      = $(COMSAT_PKG_NAME)-pkg-install.sh

COMSAT_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(COMSAT_PKG_NAME)-package

pkg_basename     = $(COMSAT_PKG_NAME)-$(COMSAT_PKG_VERSION)-$(COMSAT_PKG_ARCH)-$(COMSAT_PKG_DISTRO_NAME)-$(COMSAT_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


comsat_CFLAGS = -isystem $(TARGET_DEST_DIR)/usr/include $(OPTIMIZATION_FLAGS) $(ARCH_FLAGS) $(HW_FLAGS) -Wall
comsat_environment = CFLAGS="$(comsat_CFLAGS)"


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(comsat_environment) ./configure --prefix=/usr
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(comsat_environment) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(COMSAT_PKG)/usr/bin
	@mkdir -p $(COMSAT_PKG)/usr/sbin
	@mkdir -p $(COMSAT_PKG)/usr/share/man/man{1,8}
	@mkdir -p $(COMSAT_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR)/biff ; \
	   cat biff > $(COMSAT_PKG)/usr/bin/biff ; \
	   chmod 755 $(COMSAT_PKG)/usr/bin/* ; \
	   cat biff.1 | gzip -9c > $(COMSAT_PKG)/usr/share/man/man1/biff.1.gz ; \
	 )
	@( cd $(SRC_DIR)/comsat ; \
	   cat comsat > $(COMSAT_PKG)/usr/sbin/in.comsat ; \
	   chmod 755 $(COMSAT_PKG)/usr/sbin/* ; \
	   cat comsat.8 | gzip -9c > $(COMSAT_PKG)/usr/share/man/man8/in.comsat.8.gz ; \
	 )
	@( cd $(SRC_DIR) ; \
	   cp -a README \
	         $(COMSAT_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(COMSAT_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(COMSAT_PKG) && cp -rf * $(TARGET_DEST_DIR)
	@(cd $(COMSAT_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(COMSAT_PKG_DESCRIPTION_FILE): $(COMSAT_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(COMSAT_PKG_DESCRIPTION_FILE) $(COMSAT_PKG_INSTALL_SCRIPT)
	@cp $(COMSAT_PKG_DESCRIPTION_FILE) $(COMSAT_PKG)/.DESCRIPTION
	@cp $(COMSAT_PKG_INSTALL_SCRIPT) $(COMSAT_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(COMSAT_PKG)/.REQUIRES
	@echo "pkgname=$(COMSAT_PKG_NAME)"                            >  $(COMSAT_PKG)/.PKGINFO ; \
	 echo "pkgver=$(COMSAT_PKG_VERSION)"                          >> $(COMSAT_PKG)/.PKGINFO ; \
	 echo "arch=$(COMSAT_PKG_ARCH)"                               >> $(COMSAT_PKG)/.PKGINFO ; \
	 echo "distroname=$(COMSAT_PKG_DISTRO_NAME)"                  >> $(COMSAT_PKG)/.PKGINFO ; \
	 echo "distrover=$(COMSAT_PKG_DISTRO_VERSION)"                >> $(COMSAT_PKG)/.PKGINFO ; \
	 echo "group=$(COMSAT_PKG_GROUP)"                             >> $(COMSAT_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(COMSAT_PKG_SHORT_DESCRIPTION)\"" >> $(COMSAT_PKG)/.PKGINFO ; \
	 echo "url=$(COMSAT_PKG_URL)"                                 >> $(COMSAT_PKG)/.PKGINFO ; \
	 echo "license=$(COMSAT_PKG_LICENSE)"                         >> $(COMSAT_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(COMSAT_PKG)  && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
