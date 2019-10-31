
COMPONENT_TARGETS  = $(HARDWARE_S824L)
COMPONENT_TARGETS += $(HARDWARE_VESNIN)
COMPONENT_TARGETS += $(HARDWARE_TL2WK2)
COMPONENT_TARGETS += $(HARDWARE_TL2SV2)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_PPC32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/libedit

REQUIRES           = libs/libedit/20191025-3.1
REQUIRES          += libs/ncurses/6.1-ppc32

# ======= __END_OF_REQUIRES__ =======


version            = 20191025-3.1
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/libedit/libedit-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libedit-$(version)
src_dir_name       = libedit-$(version)
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
LIBEDIT_32_PKG_NAME                = libedit-x32
LIBEDIT_32_PKG_VERSION             = 20191025-3.1
LIBEDIT_32_PKG_ARCH                = $(TOOLCHAIN)
LIBEDIT_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBEDIT_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBEDIT_32_PKG_GROUP               = $(PKG_GROUP)
###                                 |---handy-ruler-------------------------------|
LIBEDIT_32_PKG_SHORT_DESCRIPTION   = Command line editor library
LIBEDIT_32_PKG_URL                 = $(BUG_URL)
LIBEDIT_32_PKG_LICENSE             = BSD
LIBEDIT_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBEDIT_32_PKG_NAME)-pkg-description
LIBEDIT_32_PKG_DESCRIPTION_FILE_IN = $(LIBEDIT_32_PKG_NAME)-pkg-description.in
LIBEDIT_32_PKG_INSTALL_SCRIPT      = $(LIBEDIT_32_PKG_NAME)-pkg-install.sh

LIBEDIT_32_PKG   = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBEDIT_32_PKG_NAME)-package

pkg_basename     = $(LIBEDIT_32_PKG_NAME)-$(LIBEDIT_32_PKG_VERSION)-$(LIBEDIT_32_PKG_ARCH)-$(LIBEDIT_32_PKG_DISTRO_NAME)-$(LIBEDIT_32_PKG_DISTRO_VERSION)

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


env_sysroot  = DESTDIR=$(LIBEDIT_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_PPC32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --enable-widec

ifeq ($(__ENABLE_STATIC__),yes)
extra_configure_switches += --enable-static=yes
else
extra_configure_switches += --enable-static=no
endif
extra_configure_switches += --enable-shared=yes


LDFLAGS += -Wl,-rpath=/lib$(MULTILIB_PPC32_SUFFIX):/usr/lib$(MULTILIB_PPC32_SUFFIX):/usr/lib/../lib$(MULTILIB_PPC32_SUFFIX)


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
	@mkdir -p $(LIBEDIT_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(LIBEDIT_32_PKG)/usr/include
	@rm -rf $(LIBEDIT_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBEDIT_32_PKG)/usr/lib$(MULTILIB_PPC32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libedit.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBEDIT_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_PPC32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g"   libedit.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libedit.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_PPC32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libedit.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBEDIT_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifeq ($(__ENABLE_STATIC__),yes)
	@( cd $(LIBEDIT_32_PKG) ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null ; \
	 )
endif
	@touch $@

$(LIBEDIT_32_PKG_DESCRIPTION_FILE): $(LIBEDIT_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBEDIT_32_PKG_DESCRIPTION_FILE) $(LIBEDIT_32_PKG_INSTALL_SCRIPT)
	@cp $(LIBEDIT_32_PKG_DESCRIPTION_FILE) $(LIBEDIT_32_PKG)/.DESCRIPTION
	@cp $(LIBEDIT_32_PKG_INSTALL_SCRIPT) $(LIBEDIT_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBEDIT_32_PKG)/.REQUIRES
	@echo "pkgname=$(LIBEDIT_32_PKG_NAME)"                            >  $(LIBEDIT_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBEDIT_32_PKG_VERSION)"                          >> $(LIBEDIT_32_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBEDIT_32_PKG_ARCH)"                               >> $(LIBEDIT_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBEDIT_32_PKG_DISTRO_NAME)"                  >> $(LIBEDIT_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBEDIT_32_PKG_DISTRO_VERSION)"                >> $(LIBEDIT_32_PKG)/.PKGINFO ; \
	 echo "group=$(LIBEDIT_32_PKG_GROUP)"                             >> $(LIBEDIT_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBEDIT_32_PKG_SHORT_DESCRIPTION)\"" >> $(LIBEDIT_32_PKG)/.PKGINFO ; \
	 echo "url=$(LIBEDIT_32_PKG_URL)"                                 >> $(LIBEDIT_32_PKG)/.PKGINFO ; \
	 echo "license=$(LIBEDIT_32_PKG_LICENSE)"                         >> $(LIBEDIT_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LIBEDIT_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
