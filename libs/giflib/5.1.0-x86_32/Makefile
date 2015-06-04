
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/giflib

REQUIRES           = libs/giflib/5.1.0
REQUIRES          += libs/glibc/2.21-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 5.1.0
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/l/giflib/giflib-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/giflib-$(version)
src_dir_name       = giflib-$(version)
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
GIFLIB_32_PKG_NAME                = giflib-x32
GIFLIB_32_PKG_VERSION             = 5.1.0
GIFLIB_32_PKG_ARCH                = $(TOOLCHAIN)
GIFLIB_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
GIFLIB_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
GIFLIB_32_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
GIFLIB_32_PKG_SHORT_DESCRIPTION   = library for reading and writing gif images
GIFLIB_32_PKG_URL                 = $(BUG_URL)
GIFLIB_32_PKG_LICENSE             = MIT
GIFLIB_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GIFLIB_32_PKG_NAME)-pkg-description
GIFLIB_32_PKG_DESCRIPTION_FILE_IN = $(GIFLIB_32_PKG_NAME)-pkg-description.in
GIFLIB_32_PKG_INSTALL_SCRIPT      = $(GIFLIB_32_PKG_NAME)-pkg-install.sh

GIFLIB_32_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GIFLIB_32_PKG_NAME)-package

pkg_basename     = $(GIFLIB_32_PKG_NAME)-$(GIFLIB_32_PKG_VERSION)-$(GIFLIB_32_PKG_ARCH)-$(GIFLIB_32_PKG_DISTRO_NAME)-$(GIFLIB_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(GIFLIB_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man

extra_configure_switches += --bindir=/usr/bin/32

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
	@mkdir -p $(GIFLIB_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@rm -rf $(GIFLIB_32_PKG)/usr/include
	@rm -rf $(GIFLIB_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(GIFLIB_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libgif.la  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(GIFLIB_32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libgif.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libgif.la \
	 )
	# ======= Strip binaries =======
	@( cd $(GIFLIB_32_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(GIFLIB_32_PKG_DESCRIPTION_FILE): $(GIFLIB_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(GIFLIB_32_PKG_DESCRIPTION_FILE) $(GIFLIB_32_PKG_INSTALL_SCRIPT)
	@cp $(GIFLIB_32_PKG_DESCRIPTION_FILE) $(GIFLIB_32_PKG)/.DESCRIPTION
	@cp $(GIFLIB_32_PKG_INSTALL_SCRIPT) $(GIFLIB_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GIFLIB_32_PKG)/.REQUIRES
	@echo "pkgname=$(GIFLIB_32_PKG_NAME)"                            >  $(GIFLIB_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GIFLIB_32_PKG_VERSION)"                          >> $(GIFLIB_32_PKG)/.PKGINFO ; \
	 echo "arch=$(GIFLIB_32_PKG_ARCH)"                               >> $(GIFLIB_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(GIFLIB_32_PKG_DISTRO_NAME)"                  >> $(GIFLIB_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(GIFLIB_32_PKG_DISTRO_VERSION)"                >> $(GIFLIB_32_PKG)/.PKGINFO ; \
	 echo "group=$(GIFLIB_32_PKG_GROUP)"                             >> $(GIFLIB_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GIFLIB_32_PKG_SHORT_DESCRIPTION)\"" >> $(GIFLIB_32_PKG)/.PKGINFO ; \
	 echo "url=$(GIFLIB_32_PKG_URL)"                                 >> $(GIFLIB_32_PKG)/.PKGINFO ; \
	 echo "license=$(GIFLIB_32_PKG_LICENSE)"                         >> $(GIFLIB_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(GIFLIB_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
