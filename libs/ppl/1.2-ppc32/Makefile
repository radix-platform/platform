
COMPONENT_TARGETS  = $(HARDWARE_S824L)
COMPONENT_TARGETS += $(HARDWARE_VESNIN)
COMPONENT_TARGETS += $(HARDWARE_TL2WK2)
COMPONENT_TARGETS += $(HARDWARE_TL2SV2)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_PPC32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/ppl

REQUIRES           = libs/ppl/1.2
REQUIRES          += libs/gmp/6.1.2-ppc32

# ======= __END_OF_REQUIRES__ =======


version            = 1.2
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/l/ppl/ppl-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/ppl-$(version)
src_dir_name       = ppl-$(version)
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
PPL_32_PKG_NAME                = ppl-x32
PPL_32_PKG_VERSION             = 1.2
PPL_32_PKG_ARCH                = $(TOOLCHAIN)
PPL_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
PPL_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
PPL_32_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
PPL_32_PKG_SHORT_DESCRIPTION   = The Parma Polyhedra Library
PPL_32_PKG_URL                 = $(BUG_URL)
PPL_32_PKG_LICENSE             = GPLv2
PPL_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(PPL_32_PKG_NAME)-pkg-description
PPL_32_PKG_DESCRIPTION_FILE_IN = $(PPL_32_PKG_NAME)-pkg-description.in
PPL_32_PKG_INSTALL_SCRIPT      = $(PPL_32_PKG_NAME)-pkg-install.sh

PPL_32_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(PPL_32_PKG_NAME)-package

pkg_basename     = $(PPL_32_PKG_NAME)-$(PPL_32_PKG_VERSION)-$(PPL_32_PKG_ARCH)-$(PPL_32_PKG_DISTRO_NAME)-$(PPL_32_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(PPL_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_PPC32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --with-libgmp=$(TARGET_DEST_DIR)/usr
extra_configure_switches += --enable-interfaces="c,cxx"
extra_configure_switches += --disable-optimization
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
	@mkdir -p $(PPL_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Save ppl.hh =======
	@for header in ppl ; do \
	   cp -a $(PPL_32_PKG)/usr/include/$$header.hh $(TARGET_BUILD_DIR) ; \
	 done
	@rm -rf $(PPL_32_PKG)/usr/include
	@rm -rf $(PPL_32_PKG)/usr/share
	# ======= Restore ppl-32.hh =======
	@mkdir -p $(PPL_32_PKG)/usr/include
	@for header in ppl ; do \
	   mv $(TARGET_BUILD_DIR)/$$header.hh $(PPL_32_PKG)/usr/include/$$header-32.hh ; \
	 done
	# ======= move 32bit binary files =======
	@( cd $(PPL_32_PKG)/usr/bin ; \
	   mkdir 32 ; \
	   mv ppl* 32 ; \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(PPL_32_PKG)/usr/lib$(MULTILIB_PPC32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libppl.la libppl_c.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(PPL_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_PPC32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libppl.la libppl_c.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libppl.la libppl_c.la \
	 )
	# ======= remove toolchain path from header files =======
	@( cd $(PPL_32_PKG)/usr/include ; \
	   sed -i 's,$(TOOLCHAIN_PATH)/bin/$(TARGET)\-,,g' ppl-32.hh ; \
	   sed -i "s, \-\-sysroot[^']*,,g"                 ppl-32.hh ; \
	   sed -i 's,$(TARGET_DEST_DIR),,g'                ppl-32.hh ; \
	   sed -i 's,$(CCACHE),,g'                         ppl-32.hh ; \
	 )
	# ======= Strip binaries =======
	@( cd $(PPL_32_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifeq ($(__ENABLE_STATIC__),yes)
	@( cd $(PPL_32_PKG) ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null ; \
	 )
endif
	@touch $@

$(PPL_32_PKG_DESCRIPTION_FILE): $(PPL_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(PPL_32_PKG_DESCRIPTION_FILE) $(PPL_32_PKG_INSTALL_SCRIPT)
	@cp $(PPL_32_PKG_DESCRIPTION_FILE) $(PPL_32_PKG)/.DESCRIPTION
	@cp $(PPL_32_PKG_INSTALL_SCRIPT) $(PPL_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(PPL_32_PKG)/.REQUIRES
	@echo "pkgname=$(PPL_32_PKG_NAME)"                            >  $(PPL_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(PPL_32_PKG_VERSION)"                          >> $(PPL_32_PKG)/.PKGINFO ; \
	 echo "arch=$(PPL_32_PKG_ARCH)"                               >> $(PPL_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(PPL_32_PKG_DISTRO_NAME)"                  >> $(PPL_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(PPL_32_PKG_DISTRO_VERSION)"                >> $(PPL_32_PKG)/.PKGINFO ; \
	 echo "group=$(PPL_32_PKG_GROUP)"                             >> $(PPL_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(PPL_32_PKG_SHORT_DESCRIPTION)\"" >> $(PPL_32_PKG)/.PKGINFO ; \
	 echo "url=$(PPL_32_PKG_URL)"                                 >> $(PPL_32_PKG)/.PKGINFO ; \
	 echo "license=$(PPL_32_PKG_LICENSE)"                         >> $(PPL_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(PPL_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
