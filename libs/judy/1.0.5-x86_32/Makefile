
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/judy

REQUIRES           = libs/judy/1.0.5

# ======= __END_OF_REQUIRES__ =======


version            = 1.0.5
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/judy/judy-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/judy-$(version)
src_dir_name       = judy-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
JUDY_32_PKG_NAME                = judy-x32
JUDY_32_PKG_VERSION             = 1.0.5
JUDY_32_PKG_ARCH                = $(TOOLCHAIN)
JUDY_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
JUDY_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
JUDY_32_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
JUDY_32_PKG_SHORT_DESCRIPTION   = C library for creating dynamic arrays
JUDY_32_PKG_URL                 = $(BUG_URL)
JUDY_32_PKG_LICENSE             = LGPLv2.1
JUDY_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(JUDY_32_PKG_NAME)-pkg-description
JUDY_32_PKG_DESCRIPTION_FILE_IN = $(JUDY_32_PKG_NAME)-pkg-description.in
JUDY_32_PKG_INSTALL_SCRIPT      = $(JUDY_32_PKG_NAME)-pkg-install.sh

JUDY_32_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(JUDY_32_PKG_NAME)-package

pkg_basename     = $(JUDY_32_PKG_NAME)-$(JUDY_32_PKG_VERSION)-$(JUDY_32_PKG_ARCH)-$(JUDY_32_PKG_DISTRO_NAME)-$(JUDY_32_PKG_DISTRO_VERSION)

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


env_sysroot  = DESTDIR=$(JUDY_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man

extra_configure_switches += --bindir=/usr/bin/32

extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes

extra_environment  = BUILD_CC="gcc"
extra_environment += BUILD_CC_CFLAGS=""


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && \
	  $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) $(extra_environment)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(JUDY_32_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) $(extra_environment) -j1 install $(env_sysroot)
	@rm -rf $(JUDY_32_PKG)/usr/include
	@rm -rf $(JUDY_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(JUDY_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libJudy.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(JUDY_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libJudy.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libJudy.la \
	 )
	# =======Strip binaries =======
	@( cd $(JUDY_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(JUDY_32_PKG_DESCRIPTION_FILE): $(JUDY_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(JUDY_32_PKG_DESCRIPTION_FILE) $(JUDY_32_PKG_INSTALL_SCRIPT)
	@cp $(JUDY_32_PKG_DESCRIPTION_FILE) $(JUDY_32_PKG)/.DESCRIPTION
	@cp $(JUDY_32_PKG_INSTALL_SCRIPT) $(JUDY_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(JUDY_32_PKG)/.REQUIRES
	@echo "pkgname=$(JUDY_32_PKG_NAME)"                            >  $(JUDY_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(JUDY_32_PKG_VERSION)"                          >> $(JUDY_32_PKG)/.PKGINFO ; \
	 echo "arch=$(JUDY_32_PKG_ARCH)"                               >> $(JUDY_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(JUDY_32_PKG_DISTRO_NAME)"                  >> $(JUDY_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(JUDY_32_PKG_DISTRO_VERSION)"                >> $(JUDY_32_PKG)/.PKGINFO ; \
	 echo "group=$(JUDY_32_PKG_GROUP)"                             >> $(JUDY_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(JUDY_32_PKG_SHORT_DESCRIPTION)\"" >> $(JUDY_32_PKG)/.PKGINFO ; \
	 echo "url=$(JUDY_32_PKG_URL)"                                 >> $(JUDY_32_PKG)/.PKGINFO ; \
	 echo "license=$(JUDY_32_PKG_LICENSE)"                         >> $(JUDY_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(JUDY_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
