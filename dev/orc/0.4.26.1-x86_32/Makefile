
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/d/orc

REQUIRES           = dev/orc/0.4.26.1

# ======= __END_OF_REQUIRES__ =======


version            = 0.4.26.1
short_version      = $(shell echo $(version) | cut -f 1,2 -d '.' )
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/d/orc/orc-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/orc-$(version)
src_dir_name       = orc-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = dev
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
ORC_32_PKG_NAME                = orc-x32
ORC_32_PKG_VERSION             = 0.4.26.1
ORC_32_PKG_ARCH                = $(TOOLCHAIN)
ORC_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
ORC_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
ORC_32_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
ORC_32_PKG_SHORT_DESCRIPTION   = Optimized Inner Loop Runtime Compiler
ORC_32_PKG_URL                 = $(BUG_URL)
ORC_32_PKG_LICENSE             = custom
ORC_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(ORC_32_PKG_NAME)-pkg-description
ORC_32_PKG_DESCRIPTION_FILE_IN = $(ORC_32_PKG_NAME)-pkg-description.in
ORC_32_PKG_INSTALL_SCRIPT      = $(ORC_32_PKG_NAME)-pkg-install.sh

ORC_32_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(ORC_32_PKG_NAME)-package

pkg_basename     = $(ORC_32_PKG_NAME)-$(ORC_32_PKG_VERSION)-$(ORC_32_PKG_ARCH)-$(ORC_32_PKG_DISTRO_NAME)-$(ORC_32_PKG_DISTRO_VERSION)

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


env_sysroot  = DESTDIR=$(ORC_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --bindir=/usr/bin/32

extra_configure_switches += --enable-backend=sse,mmx

extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


TARGET_LIB_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib/../lib$(MULTILIB_X86_32_SUFFIX)

LDFLAGS += -Wl,-rpath,$(TARGET_LIB_RPATH)


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
	@mkdir -p $(ORC_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(ORC_32_PKG)/usr/include
	@rm -rf $(ORC_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(ORC_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" liborc-$(short_version).la liborc-test-$(short_version).la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(ORC_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" liborc-$(short_version).la liborc-test-$(short_version).la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" liborc-$(short_version).la liborc-test-$(short_version).la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" orc-$(short_version).pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(ORC_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(ORC_32_PKG_DESCRIPTION_FILE): $(ORC_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(ORC_32_PKG_DESCRIPTION_FILE) $(ORC_32_PKG_INSTALL_SCRIPT)
	@cp $(ORC_32_PKG_DESCRIPTION_FILE) $(ORC_32_PKG)/.DESCRIPTION
	@cp $(ORC_32_PKG_INSTALL_SCRIPT) $(ORC_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(ORC_32_PKG)/.REQUIRES
	@echo "pkgname=$(ORC_32_PKG_NAME)"                            >  $(ORC_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(ORC_32_PKG_VERSION)"                          >> $(ORC_32_PKG)/.PKGINFO ; \
	 echo "arch=$(ORC_32_PKG_ARCH)"                               >> $(ORC_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(ORC_32_PKG_DISTRO_NAME)"                  >> $(ORC_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(ORC_32_PKG_DISTRO_VERSION)"                >> $(ORC_32_PKG)/.PKGINFO ; \
	 echo "group=$(ORC_32_PKG_GROUP)"                             >> $(ORC_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(ORC_32_PKG_SHORT_DESCRIPTION)\"" >> $(ORC_32_PKG)/.PKGINFO ; \
	 echo "url=$(ORC_32_PKG_URL)"                                 >> $(ORC_32_PKG)/.PKGINFO ; \
	 echo "license=$(ORC_32_PKG_LICENSE)"                         >> $(ORC_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(ORC_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
