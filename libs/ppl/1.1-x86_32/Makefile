
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/ppl

REQUIRES           = libs/ppl/1.1
REQUIRES          += libs/gmp/6.1.2-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 1.1
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/l/ppl/ppl-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
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
PPL32_PKG_NAME                = ppl-x32
PPL32_PKG_VERSION             = 1.1
PPL32_PKG_ARCH                = $(TOOLCHAIN)
PPL32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
PPL32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
PPL32_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
PPL32_PKG_SHORT_DESCRIPTION   = The Parma Polyhedra Library
PPL32_PKG_URL                 = $(BUG_URL)
PPL32_PKG_LICENSE             = GPLv2
PPL32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(PPL32_PKG_NAME)-pkg-description
PPL32_PKG_DESCRIPTION_FILE_IN = $(PPL32_PKG_NAME)-pkg-description.in
PPL32_PKG_INSTALL_SCRIPT      = $(PPL32_PKG_NAME)-pkg-install.sh

PPL32_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(PPL32_PKG_NAME)-package

pkg_basename     = $(PPL32_PKG_NAME)-$(PPL32_PKG_VERSION)-$(PPL32_PKG_ARCH)-$(PPL32_PKG_DISTRO_NAME)-$(PPL32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(PPL32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --with-libgmp=$(TARGET_DEST_DIR)/usr
extra_configure_switches += --enable-interfaces="c,cxx"
extra_configure_switches += --disable-optimization
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
	@mkdir -p $(PPL32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(PPL32_PKG)/usr/include
	@rm -rf $(PPL32_PKG)/usr/share
	@( cd $(PPL32_PKG)/usr/bin ; \
	   mkdir 32 ; \
	   mv ppl* 32 ; \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(PPL32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libppl.la libppl_c.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(PPL32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libppl.la libppl_c.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libppl.la libppl_c.la \
	 )
	# ======= Strip binaries =======
	@( cd $(PPL32_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(PPL32_PKG_DESCRIPTION_FILE): $(PPL32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(PPL32_PKG_DESCRIPTION_FILE) $(PPL32_PKG_INSTALL_SCRIPT)
	@cp $(PPL32_PKG_DESCRIPTION_FILE) $(PPL32_PKG)/.DESCRIPTION
	@cp $(PPL32_PKG_INSTALL_SCRIPT) $(PPL32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(PPL32_PKG)/.REQUIRES
	@echo "pkgname=$(PPL32_PKG_NAME)"                            >  $(PPL32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(PPL32_PKG_VERSION)"                          >> $(PPL32_PKG)/.PKGINFO ; \
	 echo "arch=$(PPL32_PKG_ARCH)"                               >> $(PPL32_PKG)/.PKGINFO ; \
	 echo "distroname=$(PPL32_PKG_DISTRO_NAME)"                  >> $(PPL32_PKG)/.PKGINFO ; \
	 echo "distrover=$(PPL32_PKG_DISTRO_VERSION)"                >> $(PPL32_PKG)/.PKGINFO ; \
	 echo "group=$(PPL32_PKG_GROUP)"                             >> $(PPL32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(PPL32_PKG_SHORT_DESCRIPTION)\"" >> $(PPL32_PKG)/.PKGINFO ; \
	 echo "url=$(PPL32_PKG_URL)"                                 >> $(PPL32_PKG)/.PKGINFO ; \
	 echo "license=$(PPL32_PKG_LICENSE)"                         >> $(PPL32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(PPL32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
