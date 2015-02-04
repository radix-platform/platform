
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/libspectre

REQUIRES           = libs/libspectre/0.2.7
REQUIRES          += app/ghostscript/9.15-x86_32


version            = 0.2.7
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/libspectre/libspectre-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libspectre-$(version)
src_dir_name       = libspectre-$(version)
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
LIBSPECTRE_32_PKG_NAME                = libspectre-x32
LIBSPECTRE_32_PKG_VERSION             = 0.2.7
LIBSPECTRE_32_PKG_ARCH                = $(TOOLCHAIN)
LIBSPECTRE_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBSPECTRE_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBSPECTRE_32_PKG_GROUP               = $(PKG_GROUP)
###                                    |---handy-ruler-------------------------------|
LIBSPECTRE_32_PKG_SHORT_DESCRIPTION   = ghostscript wrapper library
LIBSPECTRE_32_PKG_URL                 = $(BUG_URL)
LIBSPECTRE_32_PKG_LICENSE             = GPLv2
LIBSPECTRE_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBSPECTRE_32_PKG_NAME)-pkg-description
LIBSPECTRE_32_PKG_DESCRIPTION_FILE_IN = $(LIBSPECTRE_32_PKG_NAME)-pkg-description.in
LIBSPECTRE_32_PKG_INSTALL_SCRIPT      = $(LIBSPECTRE_32_PKG_NAME)-pkg-install.sh

LIBSPECTRE_32_PKG = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBSPECTRE_32_PKG_NAME)-package

pkg_basename      = $(LIBSPECTRE_32_PKG_NAME)-$(LIBSPECTRE_32_PKG_VERSION)-$(LIBSPECTRE_32_PKG_ARCH)-$(LIBSPECTRE_32_PKG_DISTRO_NAME)-$(LIBSPECTRE_32_PKG_DISTRO_VERSION)

pkg_archive       = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature     = $(call sign-name,$(pkg_archive))
pkg_description   = $(call desc-name,$(pkg_archive))
products          = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS     = $(build_target)
BUILD_TARGETS    += $(install_target)

PRODUCT_TARGETS   = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(LIBSPECTRE_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var

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
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LIBSPECTRE_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@rm -rf $(LIBSPECTRE_32_PKG)/usr/include
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBSPECTRE_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libspectre.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(LIBSPECTRE_32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libspectre.la  ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libspectre.la  \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libspectre.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBSPECTRE_32_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBSPECTRE_32_PKG_DESCRIPTION_FILE): $(LIBSPECTRE_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBSPECTRE_32_PKG_DESCRIPTION_FILE) $(LIBSPECTRE_32_PKG_INSTALL_SCRIPT)
	@cp $(LIBSPECTRE_32_PKG_DESCRIPTION_FILE) $(LIBSPECTRE_32_PKG)/.DESCRIPTION
	@cp $(LIBSPECTRE_32_PKG_INSTALL_SCRIPT) $(LIBSPECTRE_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBSPECTRE_32_PKG)/.REQUIRES
	@echo "pkgname=$(LIBSPECTRE_32_PKG_NAME)"                            >  $(LIBSPECTRE_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBSPECTRE_32_PKG_VERSION)"                          >> $(LIBSPECTRE_32_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBSPECTRE_32_PKG_ARCH)"                               >> $(LIBSPECTRE_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBSPECTRE_32_PKG_DISTRO_NAME)"                  >> $(LIBSPECTRE_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBSPECTRE_32_PKG_DISTRO_VERSION)"                >> $(LIBSPECTRE_32_PKG)/.PKGINFO ; \
	 echo "group=$(LIBSPECTRE_32_PKG_GROUP)"                             >> $(LIBSPECTRE_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBSPECTRE_32_PKG_SHORT_DESCRIPTION)\"" >> $(LIBSPECTRE_32_PKG)/.PKGINFO ; \
	 echo "url=$(LIBSPECTRE_32_PKG_URL)"                                 >> $(LIBSPECTRE_32_PKG)/.PKGINFO ; \
	 echo "license=$(LIBSPECTRE_32_PKG_LICENSE)"                         >> $(LIBSPECTRE_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBSPECTRE_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
