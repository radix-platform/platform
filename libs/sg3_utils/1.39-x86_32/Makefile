
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/sg3_utils

REQUIRES           = libs/sg3_utils/1.39

# ======= __END_OF_REQUIRES__ =======


version            = 1.39
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/l/sg3_utils/sg3_utils-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/sg3_utils-$(version)
src_dir_name       = sg3_utils-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
SG3_UTILS32_PKG_NAME                = sg3_utils-x32
SG3_UTILS32_PKG_VERSION             = 1.39
SG3_UTILS32_PKG_ARCH                = $(TOOLCHAIN)
SG3_UTILS32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
SG3_UTILS32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
SG3_UTILS32_PKG_GROUP               = $(PKG_GROUP)
###                                  |---handy-ruler-------------------------------|
SG3_UTILS32_PKG_SHORT_DESCRIPTION   = utilities for the linux sg driver
SG3_UTILS32_PKG_URL                 = $(BUG_URL)
SG3_UTILS32_PKG_LICENSE             = GPLv2
SG3_UTILS32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(SG3_UTILS32_PKG_NAME)-pkg-description
SG3_UTILS32_PKG_DESCRIPTION_FILE_IN = $(SG3_UTILS32_PKG_NAME)-pkg-description.in
SG3_UTILS32_PKG_INSTALL_SCRIPT      = $(SG3_UTILS32_PKG_NAME)-pkg-install.sh

SG3_UTILS32_PKG  = $(CURDIR)/$(TARGET_BUILD_DIR)/$(SG3_UTILS32_PKG_NAME)-package

pkg_basename     = $(SG3_UTILS32_PKG_NAME)-$(SG3_UTILS32_PKG_VERSION)-$(SG3_UTILS32_PKG_ARCH)-$(SG3_UTILS32_PKG_DISTRO_NAME)-$(SG3_UTILS32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(SG3_UTILS32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var

extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(SG3_UTILS32_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@mkdir -p $(SG3_UTILS32_PKG)/usr/bin/32
	@( cd $(SG3_UTILS32_PKG)/usr/bin ; \
	   find . -type f | xargs mv -t 32 ; \
	 )
	@rm -rf $(SG3_UTILS32_PKG)/usr/include
	@rm -rf $(SG3_UTILS32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(SG3_UTILS32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libsgutils?.la  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(SG3_UTILS32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libsgutils?.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libsgutils?.la \
	 )
	# ======= Strip binaries =======
	@( cd $(SG3_UTILS32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(SG3_UTILS32_PKG_DESCRIPTION_FILE): $(SG3_UTILS32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(SG3_UTILS32_PKG_DESCRIPTION_FILE) $(SG3_UTILS32_PKG_INSTALL_SCRIPT)
	@cp $(SG3_UTILS32_PKG_DESCRIPTION_FILE) $(SG3_UTILS32_PKG)/.DESCRIPTION
	@cp $(SG3_UTILS32_PKG_INSTALL_SCRIPT) $(SG3_UTILS32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(SG3_UTILS32_PKG)/.REQUIRES
	@echo "pkgname=$(SG3_UTILS32_PKG_NAME)"                            >  $(SG3_UTILS32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(SG3_UTILS32_PKG_VERSION)"                          >> $(SG3_UTILS32_PKG)/.PKGINFO ; \
	 echo "arch=$(SG3_UTILS32_PKG_ARCH)"                               >> $(SG3_UTILS32_PKG)/.PKGINFO ; \
	 echo "distroname=$(SG3_UTILS32_PKG_DISTRO_NAME)"                  >> $(SG3_UTILS32_PKG)/.PKGINFO ; \
	 echo "distrover=$(SG3_UTILS32_PKG_DISTRO_VERSION)"                >> $(SG3_UTILS32_PKG)/.PKGINFO ; \
	 echo "group=$(SG3_UTILS32_PKG_GROUP)"                             >> $(SG3_UTILS32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(SG3_UTILS32_PKG_SHORT_DESCRIPTION)\"" >> $(SG3_UTILS32_PKG)/.PKGINFO ; \
	 echo "url=$(SG3_UTILS32_PKG_URL)"                                 >> $(SG3_UTILS32_PKG)/.PKGINFO ; \
	 echo "license=$(SG3_UTILS32_PKG_LICENSE)"                         >> $(SG3_UTILS32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(SG3_UTILS32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
