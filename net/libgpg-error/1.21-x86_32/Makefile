
COMPONENT_TARGETS    = $(HARDWARE_PC64)

NEED_ABS_PATH        = true
COMPONENT_IS_3PP     = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES      = sources/packages/n/libgpg-error

REQUIRES             = net/libgpg-error/1.21

# ======= __END_OF_REQUIRES__ =======


version              = 1.21
tar_bz2_archive      = $(SRC_PACKAGE_PATH)/packages/n/libgpg-error/libgpg-error-$(version).tar.bz2
SRC_ARCHIVE          = $(tar_bz2_archive)
SRC_DIR              = $(TARGET_BUILD_DIR)/libgpg-error-$(version)
src_dir_name         = libgpg-error-$(version)
src_done             = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir            = $(TARGET_BUILD_DIR)/build
build_target         = $(TARGET_BUILD_DIR)/.build_done
install_target       = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
GPGERROR32_PKG_NAME                = libgpg-error-x32
GPGERROR32_PKG_VERSION             = 1.21
GPGERROR32_PKG_ARCH                = $(TOOLCHAIN)
GPGERROR32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
GPGERROR32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
GPGERROR32_PKG_GROUP               = $(PKG_GROUP)
###                                 |---handy-ruler-------------------------------|
GPGERROR32_PKG_SHORT_DESCRIPTION   = GnuPG Error Definitions Library
GPGERROR32_PKG_URL                 = $(BUG_URL)
GPGERROR32_PKG_LICENSE             = GPLv2
GPGERROR32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GPGERROR32_PKG_NAME)-pkg-description
GPGERROR32_PKG_DESCRIPTION_FILE_IN = $(GPGERROR32_PKG_NAME)-pkg-description.in
GPGERROR32_PKG_INSTALL_SCRIPT      = $(GPGERROR32_PKG_NAME)-pkg-install.sh

GPGERROR32_PKG   = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GPGERROR32_PKG_NAME)-package

pkg_basename     = $(GPGERROR32_PKG_NAME)-$(GPGERROR32_PKG_VERSION)-$(GPGERROR32_PKG_ARCH)-$(GPGERROR32_PKG_DISTRO_NAME)-$(GPGERROR32_PKG_DISTRO_VERSION)

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


env_sysroot  = DESTDIR=$(GPGERROR32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --with-gnu-ld
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


gpgrt_lock_t_name = i686-pc-linux-gnu


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@( cd $(SRC_DIR)/src/syscfg ; \
	   ln -sf lock-obj-pub.$(gpgrt_lock_t_name).h lock-obj-pub.$(TARGET32).h ; \
	 )
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(GPGERROR32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@mkdir -p $(GPGERROR32_PKG)/usr/bin/32
	@( cd $(GPGERROR32_PKG)/usr/bin ; \
	   find . -type f | xargs mv -t 32 ; \
	 )
	@mkdir -p $(GPGERROR32_PKG)/lib$(MULTILIB_X86_32_SUFFIX)
	@( cd $(GPGERROR32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   chmod +w lib*.so.?.*.? ; \
	   mv lib*.so.?.*.? ../../lib$(MULTILIB_X86_32_SUFFIX) ; \
	   ln -sf ../../lib$(MULTILIB_X86_32_SUFFIX)/lib*.so.?.*.? . ; \
	   cp -a lib*.so.? ../../lib$(MULTILIB_X86_32_SUFFIX) ; \
	 )
	@rm -rf $(GPGERROR32_PKG)/usr/include
	@rm -rf $(GPGERROR32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(GPGERROR32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libgpg-error.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(GPGERROR32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libgpg-error.la  ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libgpg-error.la  \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/bin/32 ; \
	   sed -i "s,prefix=/usr,prefix=$(TARGET_DEST_DIR)/usr,g" gpg-error-config ; \
	   sed -i "s,libdir=/usr,libdir=$(TARGET_DEST_DIR)/usr,g" gpg-error-config ; \
	 )
	# ======= Strip binaries =======
	@( cd $(GPGERROR32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(GPGERROR32_PKG_DESCRIPTION_FILE): $(GPGERROR32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(GPGERROR32_PKG_DESCRIPTION_FILE) $(GPGERROR32_PKG_INSTALL_SCRIPT)
	@cp $(GPGERROR32_PKG_DESCRIPTION_FILE) $(GPGERROR32_PKG)/.DESCRIPTION
	@cp $(GPGERROR32_PKG_INSTALL_SCRIPT) $(GPGERROR32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GPGERROR32_PKG)/.REQUIRES
	@echo "pkgname=$(GPGERROR32_PKG_NAME)"                            >  $(GPGERROR32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GPGERROR32_PKG_VERSION)"                          >> $(GPGERROR32_PKG)/.PKGINFO ; \
	 echo "arch=$(GPGERROR32_PKG_ARCH)"                               >> $(GPGERROR32_PKG)/.PKGINFO ; \
	 echo "distroname=$(GPGERROR32_PKG_DISTRO_NAME)"                  >> $(GPGERROR32_PKG)/.PKGINFO ; \
	 echo "distrover=$(GPGERROR32_PKG_DISTRO_VERSION)"                >> $(GPGERROR32_PKG)/.PKGINFO ; \
	 echo "group=$(GPGERROR32_PKG_GROUP)"                             >> $(GPGERROR32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GPGERROR32_PKG_SHORT_DESCRIPTION)\"" >> $(GPGERROR32_PKG)/.PKGINFO ; \
	 echo "url=$(GPGERROR32_PKG_URL)"                                 >> $(GPGERROR32_PKG)/.PKGINFO ; \
	 echo "license=$(GPGERROR32_PKG_LICENSE)"                         >> $(GPGERROR32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(GPGERROR32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
