
COMPONENT_TARGETS  = $(HARDWARE_S824L)
COMPONENT_TARGETS += $(HARDWARE_VESNIN)
COMPONENT_TARGETS += $(HARDWARE_TL2WK2)
COMPONENT_TARGETS += $(HARDWARE_TL2SV2)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_PPC32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/n/npth

REQUIRES           = net/npth/1.6
REQUIRES          += libs/glibc/2.28-ppc32

# ======= __END_OF_REQUIRES__ =======


version            = 1.6
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/n/npth/npth-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/npth-$(version)
src_dir_name       = npth-$(version)
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
NPTH_32_PKG_NAME                = npth-x32
NPTH_32_PKG_VERSION             = 1.6
NPTH_32_PKG_ARCH                = $(TOOLCHAIN)
NPTH_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
NPTH_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
NPTH_32_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
NPTH_32_PKG_SHORT_DESCRIPTION   = The New GNU Portable Threads
NPTH_32_PKG_URL                 = $(BUG_URL)
NPTH_32_PKG_LICENSE             = GPLv2
NPTH_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(NPTH_32_PKG_NAME)-pkg-description
NPTH_32_PKG_DESCRIPTION_FILE_IN = $(NPTH_32_PKG_NAME)-pkg-description.in
NPTH_32_PKG_INSTALL_SCRIPT      = $(NPTH_32_PKG_NAME)-pkg-install.sh

NPTH_32_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(NPTH_32_PKG_NAME)-package

pkg_basename     = $(NPTH_32_PKG_NAME)-$(NPTH_32_PKG_VERSION)-$(NPTH_32_PKG_ARCH)-$(NPTH_32_PKG_DISTRO_NAME)-$(NPTH_32_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(NPTH_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_PPC32_SUFFIX)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc

extra_configure_switches += --bindir=/usr/bin/32

extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --disable-tests
ifeq ($(__ENABLE_STATIC__),yes)
extra_configure_switches += --enable-static=yes
else
extra_configure_switches += --enable-static=no
endif
extra_configure_switches += --enable-shared=yes


LDFLAGS += -Wl,-rpath,/lib$(MULTILIB_PPC32_SUFFIX):/usr/lib$(MULTILIB_PPC32_SUFFIX):/usr/lib/../lib$(MULTILIB_PPC32_SUFFIX)


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
	@mkdir -p $(NPTH_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(NPTH_32_PKG)/usr/include
	@rm -rf $(NPTH_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(NPTH_32_PKG)/usr/lib$(MULTILIB_PPC32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libnpth.la ; \
	 )
	# ======= tune libs path in the target npth-config file =======
	@( cd $(NPTH_32_PKG)/usr/bin/32 ; \
	   sed -i 's,^libs="-L/usr,libs="-L$${prefix},g' npth-config ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(NPTH_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_PPC32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libnpth.la ; \
	 )
	# ======= tune npth-config script to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/bin/32 ; \
	   sed -i "s,^prefix=/usr,prefix=$(TARGET_DEST_DIR)/usr,g" npth-config ; \
	 )
	# ======= Strip binaries =======
	@( cd $(NPTH_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifeq ($(__ENABLE_STATIC__),yes)
	@( cd $(NPTH_32_PKG) ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null ; \
	 )
endif
	@touch $@

$(NPTH_32_PKG_DESCRIPTION_FILE): $(NPTH_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(NPTH_32_PKG_DESCRIPTION_FILE) $(NPTH_32_PKG_INSTALL_SCRIPT)
	@cp $(NPTH_32_PKG_DESCRIPTION_FILE) $(NPTH_32_PKG)/.DESCRIPTION
	@cp $(NPTH_32_PKG_INSTALL_SCRIPT) $(NPTH_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(NPTH_32_PKG)/.REQUIRES
	@echo "pkgname=$(NPTH_32_PKG_NAME)"                            >  $(NPTH_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(NPTH_32_PKG_VERSION)"                          >> $(NPTH_32_PKG)/.PKGINFO ; \
	 echo "arch=$(NPTH_32_PKG_ARCH)"                               >> $(NPTH_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(NPTH_32_PKG_DISTRO_NAME)"                  >> $(NPTH_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(NPTH_32_PKG_DISTRO_VERSION)"                >> $(NPTH_32_PKG)/.PKGINFO ; \
	 echo "group=$(NPTH_32_PKG_GROUP)"                             >> $(NPTH_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(NPTH_32_PKG_SHORT_DESCRIPTION)\"" >> $(NPTH_32_PKG)/.PKGINFO ; \
	 echo "url=$(NPTH_32_PKG_URL)"                                 >> $(NPTH_32_PKG)/.PKGINFO ; \
	 echo "license=$(NPTH_32_PKG_LICENSE)"                         >> $(NPTH_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(NPTH_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
