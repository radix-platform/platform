
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/expat

REQUIRES           = libs/expat/2.2.9
REQUIRES          += libs/glibc/2.28-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 2.2.9
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/l/expat/expat-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/expat-$(version)
src_dir_name       = expat-$(version)
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
EXPAT_32_PKG_NAME                = expat-x32
EXPAT_32_PKG_VERSION             = 2.2.9
EXPAT_32_PKG_ARCH                = $(TOOLCHAIN)
EXPAT_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
EXPAT_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
EXPAT_32_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
EXPAT_32_PKG_SHORT_DESCRIPTION   = C library for parsing XML
EXPAT_32_PKG_URL                 = $(BUG_URL)
EXPAT_32_PKG_LICENSE             = GPLv2
EXPAT_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(EXPAT_32_PKG_NAME)-pkg-description
EXPAT_32_PKG_DESCRIPTION_FILE_IN = $(EXPAT_32_PKG_NAME)-pkg-description.in
EXPAT_32_PKG_INSTALL_SCRIPT      = $(EXPAT_32_PKG_NAME)-pkg-install.sh

EXPAT_32_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(EXPAT_32_PKG_NAME)-package

pkg_basename     = $(EXPAT_32_PKG_NAME)-$(EXPAT_32_PKG_VERSION)-$(EXPAT_32_PKG_ARCH)-$(EXPAT_32_PKG_DISTRO_NAME)-$(EXPAT_32_PKG_DISTRO_VERSION)

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


env_sysroot  = DESTDIR=$(EXPAT_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man

extra_configure_switches += --bindir=/usr/bin/32

ifeq ($(__ENABLE_STATIC__),yes)
extra_configure_switches += --enable-static=yes
else
extra_configure_switches += --enable-static=no
endif
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
	@mkdir -p $(EXPAT_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(EXPAT_32_PKG)/usr/include
	@rm -rf $(EXPAT_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(EXPAT_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libexpat.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(EXPAT_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libexpat.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libexpat.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" expat.pc \
	 )
	# =======Strip binaries =======
	@( cd $(EXPAT_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifeq ($(__ENABLE_STATIC__),yes)
	@( cd $(EXPAT_32_PKG) ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null ; \
	 )
endif
	@touch $@

$(EXPAT_32_PKG_DESCRIPTION_FILE): $(EXPAT_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(EXPAT_32_PKG_DESCRIPTION_FILE) $(EXPAT_32_PKG_INSTALL_SCRIPT)
	@cp $(EXPAT_32_PKG_DESCRIPTION_FILE) $(EXPAT_32_PKG)/.DESCRIPTION
	@cp $(EXPAT_32_PKG_INSTALL_SCRIPT) $(EXPAT_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(EXPAT_32_PKG)/.REQUIRES
	@echo "pkgname=$(EXPAT_32_PKG_NAME)"                            >  $(EXPAT_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(EXPAT_32_PKG_VERSION)"                          >> $(EXPAT_32_PKG)/.PKGINFO ; \
	 echo "arch=$(EXPAT_32_PKG_ARCH)"                               >> $(EXPAT_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(EXPAT_32_PKG_DISTRO_NAME)"                  >> $(EXPAT_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(EXPAT_32_PKG_DISTRO_VERSION)"                >> $(EXPAT_32_PKG)/.PKGINFO ; \
	 echo "group=$(EXPAT_32_PKG_GROUP)"                             >> $(EXPAT_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(EXPAT_32_PKG_SHORT_DESCRIPTION)\"" >> $(EXPAT_32_PKG)/.PKGINFO ; \
	 echo "url=$(EXPAT_32_PKG_URL)"                                 >> $(EXPAT_32_PKG)/.PKGINFO ; \
	 echo "license=$(EXPAT_32_PKG_LICENSE)"                         >> $(EXPAT_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(EXPAT_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
