
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/xvidcore

REQUIRES           = libs/xvidcore/1.3.4

# ======= __END_OF_REQUIRES__ =======


version            = 1.3.4
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/m/xvidcore/xvidcore-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/xvidcore
src_dir_name       = xvidcore
doc_dir_name       = xvidcore-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
XVID_32_PKG_NAME                = xvidcore-x32
XVID_32_PKG_VERSION             = 1.3.4
XVID_32_PKG_ARCH                = $(TOOLCHAIN)
XVID_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
XVID_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
XVID_32_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
XVID_32_PKG_SHORT_DESCRIPTION   = XviD MPEG-4 video codec
XVID_32_PKG_URL                 = $(BUG_URL)
XVID_32_PKG_LICENSE             = GPLv2
XVID_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(XVID_32_PKG_NAME)-pkg-description
XVID_32_PKG_DESCRIPTION_FILE_IN = $(XVID_32_PKG_NAME)-pkg-description.in
XVID_32_PKG_INSTALL_SCRIPT      = $(XVID_32_PKG_NAME)-pkg-install.sh

XVID_32_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(XVID_32_PKG_NAME)-package

pkg_basename     = $(XVID_32_PKG_NAME)-$(XVID_32_PKG_VERSION)-$(XVID_32_PKG_ARCH)-$(XVID_32_PKG_DISTRO_NAME)-$(XVID_32_PKG_DISTRO_VERSION)

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


env_sysroot  = DESTDIR=$(XVID_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(doc_dir_name)
extra_configure_switches += --mandir=/usr/share/man


TARGET_LIB_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib/../lib$(MULTILIB_X86_32_SUFFIX)

LDFLAGS += -Wl,-rpath,$(TARGET_LIB_RPATH)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR)/build/generic && $(BUILD_ENVIRONMENT) ./configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(SRC_DIR)/build/generic && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(XVID_32_PKG)
	@cd $(SRC_DIR)/build/generic && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@chmod 755 $(XVID_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/libxvidcore.so.?.*
	@rm -rf $(XVID_32_PKG)/usr/include
	@rm -rf $(XVID_32_PKG)/usr/share
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(XVID_32_PKG))
	# =======Strip binaries =======
	@( cd $(XVID_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(XVID_32_PKG_DESCRIPTION_FILE): $(XVID_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(XVID_32_PKG_DESCRIPTION_FILE) $(XVID_32_PKG_INSTALL_SCRIPT)
	@cp $(XVID_32_PKG_DESCRIPTION_FILE) $(XVID_32_PKG)/.DESCRIPTION
	@cp $(XVID_32_PKG_INSTALL_SCRIPT) $(XVID_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(XVID_32_PKG)/.REQUIRES
	@echo "pkgname=$(XVID_32_PKG_NAME)"                            >  $(XVID_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(XVID_32_PKG_VERSION)"                          >> $(XVID_32_PKG)/.PKGINFO ; \
	 echo "arch=$(XVID_32_PKG_ARCH)"                               >> $(XVID_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(XVID_32_PKG_DISTRO_NAME)"                  >> $(XVID_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(XVID_32_PKG_DISTRO_VERSION)"                >> $(XVID_32_PKG)/.PKGINFO ; \
	 echo "group=$(XVID_32_PKG_GROUP)"                             >> $(XVID_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(XVID_32_PKG_SHORT_DESCRIPTION)\"" >> $(XVID_32_PKG)/.PKGINFO ; \
	 echo "url=$(XVID_32_PKG_URL)"                                 >> $(XVID_32_PKG)/.PKGINFO ; \
	 echo "license=$(XVID_32_PKG_LICENSE)"                         >> $(XVID_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(XVID_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
