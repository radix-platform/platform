
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/GNU/pth

REQUIRES           = libs/eglibc/2.18.1-x86_32


version            = 2.0.7
tar_gz_archive     = $(SRC_PACKAGE_PATH)/GNU/pth/pth-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/pth-$(version)
src_dir_name       = pth-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
PTH32_PKG_NAME                = pth-x32
PTH32_PKG_VERSION             = 2.0.7
PTH32_PKG_ARCH                = $(TOOLCHAIN)
PTH32_PKG_DISTRO_NAME         = kxLab
PTH32_PKG_DISTRO_VERSION      = 1.0
PTH32_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
PTH32_PKG_SHORT_DESCRIPTION   = pth-x32 $(version)
PTH32_PKG_URL                 = http://www.kxLab.com
PTH32_PKG_LICENSE             = GPLv2
PTH32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(PTH32_PKG_NAME)-pkg-description
PTH32_PKG_DESCRIPTION_FILE_IN = $(PTH32_PKG_NAME)-pkg-description.in
PTH32_PKG_INSTALL_SCRIPT      = $(PTH32_PKG_NAME)-pkg-install.sh

PTH32_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(PTH32_PKG_NAME)-package

pkg_basename     = $(PTH32_PKG_NAME)-$(PTH32_PKG_VERSION)-$(PTH32_PKG_ARCH)-$(PTH32_PKG_DISTRO_NAME)-$(PTH32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(PTH32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --enable-pthread=no
extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(PTH32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@mkdir -p $(PTH32_PKG)/usr/bin/32
	@( cd $(PTH32_PKG)/usr/bin ; \
	   find . -type f | xargs mv -t 32 ; \
	 )
	@rm -rf $(PTH32_PKG)/usr/include
	@rm -rf $(PTH32_PKG)/usr/share
	# remove toolchain path from target pth-config file
	@( cd $(PTH32_PKG)/usr/bin/32 ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" pth-config ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(PTH32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# tune libtool *.la search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libpth.la ; \
	 )
	# tune pkg-config *.pc search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/bin/32 ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" pth-config ; \
	  sed -i "s,-L/lib,-L$(TARGET_DEST_DIR)/lib,g" pth-config ; \
	 )
	@(cd $(PTH32_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(PTH32_PKG_DESCRIPTION_FILE): $(PTH32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(PTH32_PKG_DESCRIPTION_FILE) $(PTH32_PKG_INSTALL_SCRIPT)
	@cp $(PTH32_PKG_DESCRIPTION_FILE) $(PTH32_PKG)/.DESCRIPTION
	@cp $(PTH32_PKG_INSTALL_SCRIPT) $(PTH32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(PTH32_PKG)/.REQUIRES
	@echo "pkgname=$(PTH32_PKG_NAME)"                            >  $(PTH32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(PTH32_PKG_VERSION)"                          >> $(PTH32_PKG)/.PKGINFO ; \
	 echo "arch=$(PTH32_PKG_ARCH)"                               >> $(PTH32_PKG)/.PKGINFO ; \
	 echo "distroname=$(PTH32_PKG_DISTRO_NAME)"                  >> $(PTH32_PKG)/.PKGINFO ; \
	 echo "distrover=$(PTH32_PKG_DISTRO_VERSION)"                >> $(PTH32_PKG)/.PKGINFO ; \
	 echo "group=$(PTH32_PKG_GROUP)"                             >> $(PTH32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(PTH32_PKG_SHORT_DESCRIPTION)\"" >> $(PTH32_PKG)/.PKGINFO ; \
	 echo "url=$(PTH32_PKG_URL)"                                 >> $(PTH32_PKG)/.PKGINFO ; \
	 echo "license=$(PTH32_PKG_LICENSE)"                         >> $(PTH32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(PTH32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
