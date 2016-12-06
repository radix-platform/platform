
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/GNU/gdbm

REQUIRES           = libs/gdbm/1.11

# ======= __END_OF_REQUIRES__ =======


version            = 1.11
tar_gz_archive     = $(SRC_PACKAGE_PATH)/GNU/gdbm/gdbm-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/gdbm-$(version)
src_dir_name       = gdbm-$(version)
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
GDBM_32_PKG_NAME                = gdbm-x32
GDBM_32_PKG_VERSION             = 1.11
GDBM_32_PKG_ARCH                = $(TOOLCHAIN)
GDBM_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
GDBM_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
GDBM_32_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
GDBM_32_PKG_SHORT_DESCRIPTION   = GNU database routines
GDBM_32_PKG_URL                 = $(BUG_URL)
GDBM_32_PKG_LICENSE             = GPLv3
GDBM_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GDBM_32_PKG_NAME)-pkg-description
GDBM_32_PKG_DESCRIPTION_FILE_IN = $(GDBM_32_PKG_NAME)-pkg-description.in
GDBM_32_PKG_INSTALL_SCRIPT      = $(GDBM_32_PKG_NAME)-pkg-install.sh

GDBM_32_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GDBM_32_PKG_NAME)-package

pkg_basename     = $(GDBM_32_PKG_NAME)-$(GDBM_32_PKG_VERSION)-$(GDBM_32_PKG_ARCH)-$(GDBM_32_PKG_DISTRO_NAME)-$(GDBM_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(GDBM_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --enable-libgdbm-compat
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
	@mkdir -p $(GDBM_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@mkdir -p $(GDBM_32_PKG)/usr/bin/32
	@( cd $(GDBM_32_PKG)/usr/bin ; \
	   find . -type f | xargs mv -t 32 ; \
	 )
	@rm -rf $(GDBM_32_PKG)/usr/include
	@rm -rf $(GDBM_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(GDBM_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libgdbm.la libgdbm_compat.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(GDBM_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libgdbm.la libgdbm_compat.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libgdbm.la libgdbm_compat.la \
	 )
	# ======= Strip binaries =======
	@( cd $(GDBM_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(GDBM_32_PKG_DESCRIPTION_FILE): $(GDBM_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(GDBM_32_PKG_DESCRIPTION_FILE) $(GDBM_32_PKG_INSTALL_SCRIPT)
	@cp $(GDBM_32_PKG_DESCRIPTION_FILE) $(GDBM_32_PKG)/.DESCRIPTION
	@cp $(GDBM_32_PKG_INSTALL_SCRIPT) $(GDBM_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GDBM_32_PKG)/.REQUIRES
	@echo "pkgname=$(GDBM_32_PKG_NAME)"                            >  $(GDBM_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GDBM_32_PKG_VERSION)"                          >> $(GDBM_32_PKG)/.PKGINFO ; \
	 echo "arch=$(GDBM_32_PKG_ARCH)"                               >> $(GDBM_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(GDBM_32_PKG_DISTRO_NAME)"                  >> $(GDBM_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(GDBM_32_PKG_DISTRO_VERSION)"                >> $(GDBM_32_PKG)/.PKGINFO ; \
	 echo "group=$(GDBM_32_PKG_GROUP)"                             >> $(GDBM_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GDBM_32_PKG_SHORT_DESCRIPTION)\"" >> $(GDBM_32_PKG)/.PKGINFO ; \
	 echo "url=$(GDBM_32_PKG_URL)"                                 >> $(GDBM_32_PKG)/.PKGINFO ; \
	 echo "license=$(GDBM_32_PKG_LICENSE)"                         >> $(GDBM_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(GDBM_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
