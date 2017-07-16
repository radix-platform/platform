
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/lvm2

REQUIRES           = app/lvm2/2.02.132
REQUIRES          += libs/eudev/3.1.5-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 2.02.132
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/a/lvm2/LVM2-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/LVM2-$(version)
src_dir_name       = LVM2-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LVM2_32_PKG_NAME                = lvm2-x32
LVM2_32_PKG_VERSION             = 2.02.132
LVM2_32_PKG_ARCH                = $(TOOLCHAIN)
LVM2_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LVM2_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LVM2_32_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
LVM2_32_PKG_SHORT_DESCRIPTION   = Logical Volume Manager
LVM2_32_PKG_URL                 = $(BUG_URL)
LVM2_32_PKG_LICENSE             = GPLv2
LVM2_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LVM2_32_PKG_NAME)-pkg-description
LVM2_32_PKG_DESCRIPTION_FILE_IN = $(LVM2_32_PKG_NAME)-pkg-description.in
LVM2_32_PKG_INSTALL_SCRIPT      = $(LVM2_32_PKG_NAME)-pkg-install.sh

LVM2_32_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LVM2_32_PKG_NAME)-package

pkg_basename      = $(LVM2_32_PKG_NAME)-$(LVM2_32_PKG_VERSION)-$(LVM2_32_PKG_ARCH)-$(LVM2_32_PKG_DISTRO_NAME)-$(LVM2_32_PKG_DISTRO_VERSION)

pkg_archive       = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature     = $(call sign-name,$(pkg_archive))
pkg_description   = $(call desc-name,$(pkg_archive))
products          = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS     = $(build_target)
BUILD_TARGETS    += $(install_target)

PRODUCT_TARGETS   = $(products)

ROOTFS_TARGETS    = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(LVM2_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man

extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --disable-readline
extra_configure_switches += --enable-cmdlib
extra_configure_switches += --enable-dmeventd
extra_configure_switches += --enable-applib
extra_configure_switches += --with-usrlibdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --enable-realtime
extra_configure_switches += --with-lvm1=internal
extra_configure_switches += --enable-pkgconfig
extra_configure_switches += --enable-udev_sync
extra_configure_switches += --enable-udev_rules
extra_configure_switches += --with-udev-prefix=""
extra_configure_switches += --with-device-uid=0
extra_configure_switches += --with-device-gid=6
extra_configure_switches += --with-device-mode=0660
extra_configure_switches += --with-default-locking-dir=/run/lock/lvm
extra_configure_switches += --with-default-run-dir=/run/lvm
extra_configure_switches += --with-clvmd-pidfile=/run/lvm/clvmd.pid
extra_configure_switches += --with-cmirrord-pidfile=/run/lvm/cmirrord.pid
extra_configure_switches += --with-dmeventd-pidfile=/run/lvm/dmeventd.pid


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) ./configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LVM2_32_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@( cd $(LVM2_32_PKG) ; \
	   for file in `find . -type f -name "*"` ; do \
	     chmod u+w $$file ; \
	   done ; \
	 )
	@mkdir -p $(LVM2_32_PKG)/lib$(MULTILIB_X86_32_SUFFIX)
	@( cd $(LVM2_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in lib*.so.?.* ; do \
	     mv $$file ../../lib$(MULTILIB_X86_32_SUFFIX) ; \
	     ln -sf ../../lib$(MULTILIB_X86_32_SUFFIX)/$$file . ; \
	   done ; \
	 )
	@rm -rf $(LVM2_32_PKG)/etc
	@rm -rf $(LVM2_32_PKG)/lib
	@rm -rf $(LVM2_32_PKG)/usr/include
	@rm -rf $(LVM2_32_PKG)/usr/sbin
	@rm -rf $(LVM2_32_PKG)/usr/share
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LVM2_32_PKG))
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" devmapper-event.pc devmapper.pc lvm2app.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(LVM2_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(LVM2_32_PKG_DESCRIPTION_FILE): $(LVM2_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LVM2_32_PKG_DESCRIPTION_FILE) $(LVM2_32_PKG_INSTALL_SCRIPT)
	@cp $(LVM2_32_PKG_DESCRIPTION_FILE) $(LVM2_32_PKG)/.DESCRIPTION
	@cp $(LVM2_32_PKG_INSTALL_SCRIPT) $(LVM2_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LVM2_32_PKG)/.REQUIRES
	@echo "pkgname=$(LVM2_32_PKG_NAME)"                            >  $(LVM2_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LVM2_32_PKG_VERSION)"                          >> $(LVM2_32_PKG)/.PKGINFO ; \
	 echo "arch=$(LVM2_32_PKG_ARCH)"                               >> $(LVM2_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LVM2_32_PKG_DISTRO_NAME)"                  >> $(LVM2_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LVM2_32_PKG_DISTRO_VERSION)"                >> $(LVM2_32_PKG)/.PKGINFO ; \
	 echo "group=$(LVM2_32_PKG_GROUP)"                             >> $(LVM2_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LVM2_32_PKG_SHORT_DESCRIPTION)\"" >> $(LVM2_32_PKG)/.PKGINFO ; \
	 echo "url=$(LVM2_32_PKG_URL)"                                 >> $(LVM2_32_PKG)/.PKGINFO ; \
	 echo "license=$(LVM2_32_PKG_LICENSE)"                         >> $(LVM2_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LVM2_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
