
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/mad/libid3tag

REQUIRES           = libs/libid3tag/0.15.1b
REQUIRES          += libs/zlib/1.2.8-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 0.15.1b
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/m/mad/libid3tag/libid3tag-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libid3tag-$(version)
src_dir_name       = libid3tag-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done

id3tag_pc_in       = $(CURDIR)/id3tag-pc/id3tag.pc.in


####### Targets

PKG_GROUP = libs
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LIBID3TAG_32_PKG_NAME                = libid3tag-x32
LIBID3TAG_32_PKG_VERSION             = 0.15.1b
LIBID3TAG_32_PKG_ARCH                = $(TOOLCHAIN)
LIBID3TAG_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBID3TAG_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBID3TAG_32_PKG_GROUP               = $(PKG_GROUP)
###                                   |---handy-ruler-------------------------------|
LIBID3TAG_32_PKG_SHORT_DESCRIPTION   = ID3 tag manipulation library
LIBID3TAG_32_PKG_URL                 = $(BUG_URL)
LIBID3TAG_32_PKG_LICENSE             = GPLv2
LIBID3TAG_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBID3TAG_32_PKG_NAME)-pkg-description
LIBID3TAG_32_PKG_DESCRIPTION_FILE_IN = $(LIBID3TAG_32_PKG_NAME)-pkg-description.in
LIBID3TAG_32_PKG_INSTALL_SCRIPT      = $(LIBID3TAG_32_PKG_NAME)-pkg-install.sh

LIBID3TAG_32_PKG = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBID3TAG_32_PKG_NAME)-package

pkg_basename     = $(LIBID3TAG_32_PKG_NAME)-$(LIBID3TAG_32_PKG_VERSION)-$(LIBID3TAG_32_PKG_ARCH)-$(LIBID3TAG_32_PKG_DISTRO_NAME)-$(LIBID3TAG_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(LIBID3TAG_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --disable-debugging
extra_configure_switches += --program-prefix=
extra_configure_switches += --program-suffix=
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
	@mkdir -p $(LIBID3TAG_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	# ======= Create package config file =======
	@mkdir -p $(LIBID3TAG_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig
	@sed -e "s,/lib,/lib$(MULTILIB_X86_32_SUFFIX)," $(id3tag_pc_in) \
	  > $(LIBID3TAG_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig/id3tag.pc
	@rm -rf $(LIBID3TAG_32_PKG)/usr/include
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBID3TAG_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	  sed -i "s,$(TARGET_DEST_DIR),,g" libid3tag.la  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBID3TAG_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libid3tag.la ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libid3tag.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" id3tag.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBID3TAG_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBID3TAG_32_PKG_DESCRIPTION_FILE): $(LIBID3TAG_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBID3TAG_32_PKG_DESCRIPTION_FILE) $(LIBID3TAG_32_PKG_INSTALL_SCRIPT)
	@cp $(LIBID3TAG_32_PKG_DESCRIPTION_FILE) $(LIBID3TAG_32_PKG)/.DESCRIPTION
	@cp $(LIBID3TAG_32_PKG_INSTALL_SCRIPT) $(LIBID3TAG_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBID3TAG_32_PKG)/.REQUIRES
	@echo "pkgname=$(LIBID3TAG_32_PKG_NAME)"                            >  $(LIBID3TAG_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBID3TAG_32_PKG_VERSION)"                          >> $(LIBID3TAG_32_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBID3TAG_32_PKG_ARCH)"                               >> $(LIBID3TAG_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBID3TAG_32_PKG_DISTRO_NAME)"                  >> $(LIBID3TAG_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBID3TAG_32_PKG_DISTRO_VERSION)"                >> $(LIBID3TAG_32_PKG)/.PKGINFO ; \
	 echo "group=$(LIBID3TAG_32_PKG_GROUP)"                             >> $(LIBID3TAG_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBID3TAG_32_PKG_SHORT_DESCRIPTION)\"" >> $(LIBID3TAG_32_PKG)/.PKGINFO ; \
	 echo "url=$(LIBID3TAG_32_PKG_URL)"                                 >> $(LIBID3TAG_32_PKG)/.PKGINFO ; \
	 echo "license=$(LIBID3TAG_32_PKG_LICENSE)"                         >> $(LIBID3TAG_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBID3TAG_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
