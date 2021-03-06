
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/lame/lame

REQUIRES           = libs/lame/3.99.5
REQUIRES          += libs/ncurses/6.0-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 3.99.5
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/m/lame/lame/lame-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/lame-$(version)
src_dir_name       = lame-$(version)
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
LAME_32_PKG_NAME                = lame-x32
LAME_32_PKG_VERSION             = 3.99.5
LAME_32_PKG_ARCH                = $(TOOLCHAIN)
LAME_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LAME_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LAME_32_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
LAME_32_PKG_SHORT_DESCRIPTION   = MPEG Audio Layer III encoder
LAME_32_PKG_URL                 = $(BUG_URL)
LAME_32_PKG_LICENSE             = LGPLv2
LAME_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LAME_32_PKG_NAME)-pkg-description
LAME_32_PKG_DESCRIPTION_FILE_IN = $(LAME_32_PKG_NAME)-pkg-description.in
LAME_32_PKG_INSTALL_SCRIPT      = $(LAME_32_PKG_NAME)-pkg-install.sh

LAME_32_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LAME_32_PKG_NAME)-package

pkg_basename     = $(LAME_32_PKG_NAME)-$(LAME_32_PKG_VERSION)-$(LAME_32_PKG_ARCH)-$(LAME_32_PKG_DISTRO_NAME)-$(LAME_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(LAME_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --bindir=/usr/bin/32
extra_configure_switches += --disable-rpath
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


OPTIMIZATION_FLAGS := -Os -msse2


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
	@mkdir -p $(LAME_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(LAME_32_PKG)/usr/include
	@rm -rf $(LAME_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LAME_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libmp3lame.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LAME_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libmp3lame.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libmp3lame.la \
	 )
	# ======= Strip binaries =======
	@( cd $(LAME_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LAME_32_PKG_DESCRIPTION_FILE): $(LAME_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LAME_32_PKG_DESCRIPTION_FILE) $(LAME_32_PKG_INSTALL_SCRIPT)
	@cp $(LAME_32_PKG_DESCRIPTION_FILE) $(LAME_32_PKG)/.DESCRIPTION
	@cp $(LAME_32_PKG_INSTALL_SCRIPT) $(LAME_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LAME_32_PKG)/.REQUIRES
	@echo "pkgname=$(LAME_32_PKG_NAME)"                            >  $(LAME_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LAME_32_PKG_VERSION)"                          >> $(LAME_32_PKG)/.PKGINFO ; \
	 echo "arch=$(LAME_32_PKG_ARCH)"                               >> $(LAME_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LAME_32_PKG_DISTRO_NAME)"                  >> $(LAME_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LAME_32_PKG_DISTRO_VERSION)"                >> $(LAME_32_PKG)/.PKGINFO ; \
	 echo "group=$(LAME_32_PKG_GROUP)"                             >> $(LAME_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LAME_32_PKG_SHORT_DESCRIPTION)\"" >> $(LAME_32_PKG)/.PKGINFO ; \
	 echo "url=$(LAME_32_PKG_URL)"                                 >> $(LAME_32_PKG)/.PKGINFO ; \
	 echo "license=$(LAME_32_PKG_LICENSE)"                         >> $(LAME_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LAME_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
