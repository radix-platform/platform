
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/libexif

REQUIRES           = libs/libexif/0.6.21
REQUIRES          += libs/glibc/2.21-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 0.6.21
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/m/libexif/libexif-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libexif-$(version)
src_dir_name       = libexif-$(version)
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
LIBEXIF_32_PKG_NAME                = libexif-x32
LIBEXIF_32_PKG_VERSION             = 0.6.21
LIBEXIF_32_PKG_ARCH                = $(TOOLCHAIN)
LIBEXIF_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBEXIF_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBEXIF_32_PKG_GROUP               = $(PKG_GROUP)
###                                 |---handy-ruler-------------------------------|
LIBEXIF_32_PKG_SHORT_DESCRIPTION   = Library for easy access to EXIF data
LIBEXIF_32_PKG_URL                 = $(BUG_URL)
LIBEXIF_32_PKG_LICENSE             = LGPLv2.1
LIBEXIF_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBEXIF_32_PKG_NAME)-pkg-description
LIBEXIF_32_PKG_DESCRIPTION_FILE_IN = $(LIBEXIF_32_PKG_NAME)-pkg-description.in
LIBEXIF_32_PKG_INSTALL_SCRIPT      = $(LIBEXIF_32_PKG_NAME)-pkg-install.sh

LIBEXIF_32_PKG   = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBEXIF_32_PKG_NAME)-package

pkg_basename     = $(LIBEXIF_32_PKG_NAME)-$(LIBEXIF_32_PKG_VERSION)-$(LIBEXIF_32_PKG_ARCH)-$(LIBEXIF_32_PKG_DISTRO_NAME)-$(LIBEXIF_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(LIBEXIF_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --disable-rpath

extra_configure_switches += --with-doc-dir=/usr/share/doc/$(src_dir_name)

extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


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
	@mkdir -p $(LIBEXIF_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@rm -rf $(LIBEXIF_32_PKG)/usr/include
	@rm -rf $(LIBEXIF_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBEXIF_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libexif.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBEXIF_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libexif.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libexif.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libexif.pc \
	 )
	# =======Strip binaries =======
	@( cd $(LIBEXIF_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBEXIF_32_PKG_DESCRIPTION_FILE): $(LIBEXIF_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBEXIF_32_PKG_DESCRIPTION_FILE) $(LIBEXIF_32_PKG_INSTALL_SCRIPT)
	@cp $(LIBEXIF_32_PKG_DESCRIPTION_FILE) $(LIBEXIF_32_PKG)/.DESCRIPTION
	@cp $(LIBEXIF_32_PKG_INSTALL_SCRIPT) $(LIBEXIF_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBEXIF_32_PKG)/.REQUIRES
	@echo "pkgname=$(LIBEXIF_32_PKG_NAME)"                            >  $(LIBEXIF_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBEXIF_32_PKG_VERSION)"                          >> $(LIBEXIF_32_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBEXIF_32_PKG_ARCH)"                               >> $(LIBEXIF_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBEXIF_32_PKG_DISTRO_NAME)"                  >> $(LIBEXIF_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBEXIF_32_PKG_DISTRO_VERSION)"                >> $(LIBEXIF_32_PKG)/.PKGINFO ; \
	 echo "group=$(LIBEXIF_32_PKG_GROUP)"                             >> $(LIBEXIF_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBEXIF_32_PKG_SHORT_DESCRIPTION)\"" >> $(LIBEXIF_32_PKG)/.PKGINFO ; \
	 echo "url=$(LIBEXIF_32_PKG_URL)"                                 >> $(LIBEXIF_32_PKG)/.PKGINFO ; \
	 echo "license=$(LIBEXIF_32_PKG_LICENSE)"                         >> $(LIBEXIF_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBEXIF_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
