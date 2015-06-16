
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/libvisual

REQUIRES           = libs/libvisual/0.4.0
REQUIRES          += libs/glibc/2.21-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 0.4.0
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/l/libvisual/libvisual-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libvisual-$(version)
src_dir_name       = libvisual-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LIBVISUAL_32_PKG_NAME                = libvisual-x32
LIBVISUAL_32_PKG_VERSION             = 0.4.0
LIBVISUAL_32_PKG_ARCH                = $(TOOLCHAIN)
LIBVISUAL_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBVISUAL_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBVISUAL_32_PKG_GROUP               = $(PKG_GROUP)
###                                   |---handy-ruler-------------------------------|
LIBVISUAL_32_PKG_SHORT_DESCRIPTION   = audio visualization library
LIBVISUAL_32_PKG_URL                 = $(BUG_URL)
LIBVISUAL_32_PKG_LICENSE             = LGPLv2
LIBVISUAL_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBVISUAL_32_PKG_NAME)-pkg-description
LIBVISUAL_32_PKG_DESCRIPTION_FILE_IN = $(LIBVISUAL_32_PKG_NAME)-pkg-description.in
LIBVISUAL_32_PKG_INSTALL_SCRIPT      = $(LIBVISUAL_32_PKG_NAME)-pkg-install.sh

LIBVISUAL_32_PKG = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBVISUAL_32_PKG_NAME)-package

pkg_basename     = $(LIBVISUAL_32_PKG_NAME)-$(LIBVISUAL_32_PKG_VERSION)-$(LIBVISUAL_32_PKG_ARCH)-$(LIBVISUAL_32_PKG_DISTRO_NAME)-$(LIBVISUAL_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(LIBVISUAL_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --mandir=/usr/share/man

extra_configure_switches += --disable-rpath

extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


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
	@mkdir -p $(LIBVISUAL_32_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@rm -rf $(LIBVISUAL_32_PKG)/usr/include
	@rm -rf $(LIBVISUAL_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBVISUAL_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libvisual-?.?.la ; \
	   sed -i "s,-L$(CURDIR)/$(SRC_DIR)/libvisual ,,g" libvisual-?.?.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBVISUAL_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libvisual-?.?.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libvisual-?.?.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libvisual-?.?.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBVISUAL_32_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBVISUAL_32_PKG_DESCRIPTION_FILE): $(LIBVISUAL_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBVISUAL_32_PKG_DESCRIPTION_FILE) $(LIBVISUAL_32_PKG_INSTALL_SCRIPT)
	@cp $(LIBVISUAL_32_PKG_DESCRIPTION_FILE) $(LIBVISUAL_32_PKG)/.DESCRIPTION
	@cp $(LIBVISUAL_32_PKG_INSTALL_SCRIPT) $(LIBVISUAL_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBVISUAL_32_PKG)/.REQUIRES
	@echo "pkgname=$(LIBVISUAL_32_PKG_NAME)"                            >  $(LIBVISUAL_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBVISUAL_32_PKG_VERSION)"                          >> $(LIBVISUAL_32_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBVISUAL_32_PKG_ARCH)"                               >> $(LIBVISUAL_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBVISUAL_32_PKG_DISTRO_NAME)"                  >> $(LIBVISUAL_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBVISUAL_32_PKG_DISTRO_VERSION)"                >> $(LIBVISUAL_32_PKG)/.PKGINFO ; \
	 echo "group=$(LIBVISUAL_32_PKG_GROUP)"                             >> $(LIBVISUAL_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBVISUAL_32_PKG_SHORT_DESCRIPTION)\"" >> $(LIBVISUAL_32_PKG)/.PKGINFO ; \
	 echo "url=$(LIBVISUAL_32_PKG_URL)"                                 >> $(LIBVISUAL_32_PKG)/.PKGINFO ; \
	 echo "license=$(LIBVISUAL_32_PKG_LICENSE)"                         >> $(LIBVISUAL_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBVISUAL_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
