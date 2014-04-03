
COMPONENT_TARGETS += $(TARGET_PC32)
COMPONENT_TARGETS += $(TARGET_PC64)
COMPONENT_TARGETS += $(TARGET_CB1X)
COMPONENT_TARGETS += $(TARGET_VIP1830)
COMPONENT_TARGETS += $(TARGET_BEAGLE)
COMPONENT_TARGETS += $(TARGET_OMAP5UEVM)
COMPONENT_TARGETS += $(TARGET_B74)

#
# The rest targets links staticaly with newlib or uclibc and not requires xz libraties
#
# COMPONENT_TARGETS += $(TARGET_CB1N)
# COMPONENT_TARGETS += $(TARGET_GUARD)
# COMPONENT_TARGETS += $(TARGET_VIP1830N)
# COMPONENT_TARGETS += $(TARGET_L17UC)
#


NEED_ABS_PATH      = true

COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = $(SRC_PACKAGE_DIR)/packages/l/gamin

REQUIRES           = libs/glib2/2.40.0


version            = 0.1.10
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/gamin/gamin-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/gamin-$(version)
src_dir_name       = gamin-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done
build_gamin_pkg    = $(TARGET_BUILD_DIR)/.gamin_pkg_done

hw_cache           = $(CURDIR)/cross/hw.cache
gamin_config_file  = $(CURDIR)/config/gaminrc


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
GAMIN_PKG_NAME                = gamin
GAMIN_PKG_VERSION             = 0.1.10
GAMIN_PKG_ARCH                = $(TOOLCHAIN)
GAMIN_PKG_DISTRO_NAME         = kxLab
GAMIN_PKG_DISTRO_VERSION      = 1.0
GAMIN_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
GAMIN_PKG_SHORT_DESCRIPTION   = gamin $(version)
GAMIN_PKG_URL                 = http://www.kxLab.com
GAMIN_PKG_LICENSE             = GPLv2
GAMIN_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GAMIN_PKG_NAME)-pkg-description
GAMIN_PKG_DESCRIPTION_FILE_IN = $(GAMIN_PKG_NAME)-pkg-description.in
GAMIN_PKG_INSTALL_SCRIPT      = $(GAMIN_PKG_NAME)-pkg-install.sh

GAMIN_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GAMIN_PKG_NAME)-package

pkg_basename     = $(GAMIN_PKG_NAME)-$(GAMIN_PKG_VERSION)-$(GAMIN_PKG_ARCH)-$(GAMIN_PKG_DISTRO_NAME)-$(GAMIN_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(GAMIN_PKG_GROUP)/$(pkg_basename).tgz


BUILD_TARGETS    = $(build_gamin_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(GAMIN_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --disable-libgamin
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --enable-inotify
extra_configure_switches += --disable-dnotify

extra_configure_switches += --cache-file=$(hw_cache)



####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@chmod a-w $(hw_cache)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@chmod +w $(hw_cache)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(GAMIN_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@mkdir -p $(GAMIN_PKG)/etc/gamin
	@cp -a $(gamin_config_file) $(GAMIN_PKG)/etc/gamin/gaminrc.new
	@chmod 644 $(GAMIN_PKG)/etc/gamin/gaminrc.new
	@rm -rf $(GAMIN_PKG)/usr/lib$(LIBSUFFIX)
	@mkdir -p $(GAMIN_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(GAMIN_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(GAMIN_PKG)/usr/share/doc/$(src_dir_name)
	@( echo    ""                                    > $(GAMIN_PKG)/usr/share/doc/$(src_dir_name)/README ; \
	   echo -n "Please find documentation in "      >> $(GAMIN_PKG)/usr/share/doc/$(src_dir_name)/README ; \
	   echo -n "/usr/share/doc/lib$(src_dir_name) " >> $(GAMIN_PKG)/usr/share/doc/$(src_dir_name)/README ; \
	   echo -n "directory."                         >> $(GAMIN_PKG)/usr/share/doc/$(src_dir_name)/README ; \
	   echo    ""                                   >> $(GAMIN_PKG)/usr/share/doc/$(src_dir_name)/README ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(GAMIN_PKG) && cp -rf * $(TARGET_DEST_DIR)
	@(cd $(GAMIN_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(GAMIN_PKG_DESCRIPTION_FILE): $(GAMIN_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(build_gamin_pkg): $(install_target) $(GAMIN_PKG_DESCRIPTION_FILE)
	@cp $(GAMIN_PKG_DESCRIPTION_FILE) $(GAMIN_PKG)/.DESCRIPTION
	@cp $(GAMIN_PKG_INSTALL_SCRIPT) $(GAMIN_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GAMIN_PKG)/.REQUIRES
	@echo "pkgname=$(GAMIN_PKG_NAME)"                            >  $(GAMIN_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GAMIN_PKG_VERSION)"                          >> $(GAMIN_PKG)/.PKGINFO ; \
	 echo "arch=$(GAMIN_PKG_ARCH)"                               >> $(GAMIN_PKG)/.PKGINFO ; \
	 echo "distroname=$(GAMIN_PKG_DISTRO_NAME)"                  >> $(GAMIN_PKG)/.PKGINFO ; \
	 echo "distrover=$(GAMIN_PKG_DISTRO_VERSION)"                >> $(GAMIN_PKG)/.PKGINFO ; \
	 echo "group=$(GAMIN_PKG_GROUP)"                             >> $(GAMIN_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GAMIN_PKG_SHORT_DESCRIPTION)\"" >> $(GAMIN_PKG)/.PKGINFO ; \
	 echo "url=$(GAMIN_PKG_URL)"                                 >> $(GAMIN_PKG)/.PKGINFO ; \
	 echo "license=$(GAMIN_PKG_LICENSE)"                         >> $(GAMIN_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(GAMIN_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@
