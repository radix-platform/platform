
COMPONENT_TARGETS  = $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXV)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/tools/Amlogic/remotecfg


ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.4.0
else
REQUIRES           = libs/glibc/2.27
endif

# ======= __END_OF_REQUIRES__ =======


version            = 1.0.0
tar_xz_archive     = $(SRC_PACKAGE_PATH)/tools/Amlogic/remotecfg/remotecfg-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/remotecfg-$(version)
src_dir_name       = remotecfg-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source-done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done

default_config     = $(CURDIR)/etc/rcu/remote-$(HARDWARE).conf
rc_remote_script   = $(CURDIR)/etc/rc.d/rc.remote-control

####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
REMOTECFG_PKG_NAME                = remotecfg
REMOTECFG_PKG_VERSION             = 1.0.0
REMOTECFG_PKG_ARCH                = $(TOOLCHAIN)
REMOTECFG_PKG_DISTRO_NAME         = $(DISTRO_NAME)
REMOTECFG_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
REMOTECFG_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
REMOTECFG_PKG_SHORT_DESCRIPTION   = Amlogic remote configuration tool
REMOTECFG_PKG_URL                 = $(BUG_URL)
REMOTECFG_PKG_LICENSE             = BSD
REMOTECFG_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(REMOTECFG_PKG_NAME)-pkg-description
REMOTECFG_PKG_DESCRIPTION_FILE_IN = $(REMOTECFG_PKG_NAME)-pkg-description.in
REMOTECFG_PKG_INSTALL_SCRIPT      = $(REMOTECFG_PKG_NAME)-pkg-install.sh

REMOTECFG_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(REMOTECFG_PKG_NAME)-package

pkg_basename     = $(REMOTECFG_PKG_NAME)-$(REMOTECFG_PKG_VERSION)-$(REMOTECFG_PKG_ARCH)-$(REMOTECFG_PKG_DISTRO_NAME)-$(REMOTECFG_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(REMOTECFG_PKG)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(REMOTECFG_PKG)/sbin
	@mkdir -p $(REMOTECFG_PKG)/usr/sbin
	@mkdir -p $(REMOTECFG_PKG)/etc/rcu
	@mkdir -p $(REMOTECFG_PKG)/etc/rc.d
	# ======= Install remotecfg-$(version) =======
	@cp -a $(default_config) $(REMOTECFG_PKG)/etc/rcu/remote.conf.new
	@cp -a $(rc_remote_script) $(REMOTECFG_PKG)/etc/rc.d/rc.remote-control.new
	@chmod 755 $(REMOTECFG_PKG)/etc/rc.d/rc.remote-control.new
	@( cd $(SRC_DIR) ; \
	   cat remotecfg > $(REMOTECFG_PKG)/sbin/remotecfg ; \
	   chmod 755 $(REMOTECFG_PKG)/sbin/remotecfg ; \
	   mkdir -p $(REMOTECFG_PKG)/usr/doc/remotecfg-$(version) ; \
	   cp -a LICENSE $(REMOTECFG_PKG)/usr/doc/remotecfg-$(version) ; \
	   mkdir -p $(REMOTECFG_PKG)/usr/share/doc/remotecfg-$(version) ; \
	   cp -a LICENSE README $(REMOTECFG_PKG)/usr/share/doc/remotecfg-$(version) ; \
	 )
	@( cd $(REMOTECFG_PKG)/usr/sbin ; \
	   ln -sf ../../sbin/remotecfg remotecfg ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(REMOTECFG_PKG))
	# ======= Strip binaries =======
	@( cd $(REMOTECFG_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(REMOTECFG_PKG_DESCRIPTION_FILE): $(REMOTECFG_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(REMOTECFG_PKG_DESCRIPTION_FILE) $(REMOTECFG_PKG_INSTALL_SCRIPT)
	@cp $(REMOTECFG_PKG_DESCRIPTION_FILE) $(REMOTECFG_PKG)/.DESCRIPTION
	@cp $(REMOTECFG_PKG_INSTALL_SCRIPT) $(REMOTECFG_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(REMOTECFG_PKG)/.REQUIRES
	@echo "pkgname=$(REMOTECFG_PKG_NAME)"                            >  $(REMOTECFG_PKG)/.PKGINFO ; \
	 echo "pkgver=$(REMOTECFG_PKG_VERSION)"                          >> $(REMOTECFG_PKG)/.PKGINFO ; \
	 echo "arch=$(REMOTECFG_PKG_ARCH)"                               >> $(REMOTECFG_PKG)/.PKGINFO ; \
	 echo "distroname=$(REMOTECFG_PKG_DISTRO_NAME)"                  >> $(REMOTECFG_PKG)/.PKGINFO ; \
	 echo "distrover=$(REMOTECFG_PKG_DISTRO_VERSION)"                >> $(REMOTECFG_PKG)/.PKGINFO ; \
	 echo "group=$(REMOTECFG_PKG_GROUP)"                             >> $(REMOTECFG_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(REMOTECFG_PKG_SHORT_DESCRIPTION)\"" >> $(REMOTECFG_PKG)/.PKGINFO ; \
	 echo "url=$(REMOTECFG_PKG_URL)"                                 >> $(REMOTECFG_PKG)/.PKGINFO ; \
	 echo "license=$(REMOTECFG_PKG_LICENSE)"                         >> $(REMOTECFG_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(REMOTECFG_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
