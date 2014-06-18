
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/libffi

REQUIRES           = libs/libffi/3.0.13
REQUIRES          += libs/eglibc/2.19.1-x86_32


version            = 3.0.13
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/libffi/libffi-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libffi-$(version)
src_dir_name       = libffi-$(version)
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
LIBFFI32_PKG_NAME                = libffi-x32
LIBFFI32_PKG_VERSION             = 3.0.13
LIBFFI32_PKG_ARCH                = $(TOOLCHAIN)
LIBFFI32_PKG_DISTRO_NAME         = kxLab
LIBFFI32_PKG_DISTRO_VERSION      = 1.0
LIBFFI32_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
LIBFFI32_PKG_SHORT_DESCRIPTION   = libffi-x32 $(version)
LIBFFI32_PKG_URL                 = http://www.kxLab.com
LIBFFI32_PKG_LICENSE             = GPLv2
LIBFFI32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBFFI32_PKG_NAME)-pkg-description
LIBFFI32_PKG_DESCRIPTION_FILE_IN = $(LIBFFI32_PKG_NAME)-pkg-description.in
LIBFFI32_PKG_INSTALL_SCRIPT      = $(LIBFFI32_PKG_NAME)-pkg-install.sh

LIBFFI32_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBFFI32_PKG_NAME)-package

pkg_basename     = $(LIBFFI32_PKG_NAME)-$(LIBFFI32_PKG_VERSION)-$(LIBFFI32_PKG_ARCH)-$(LIBFFI32_PKG_DISTRO_NAME)-$(LIBFFI32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(LIBFFI32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --enable-shared


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
	@mkdir -p $(LIBFFI32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@rm -rf $(LIBFFI32_PKG)/usr/include
	@rm -rf $(LIBFFI32_PKG)/usr/share
	# remove toolchain path from target libtool *.la files and
	@( cd $(LIBFFI32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	  sed -i "s,$(TARGET_DEST_DIR),,g" libffi.la  \
	 )
	# Install the same to $(TARGET_DEST_DIR)
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(LIBFFI32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# tune libtool *.la search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libffi.la ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libffi.la \
	 )
	# tune pkg-config *.pc search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libffi.pc \
	 )
	@(cd $(LIBFFI32_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBFFI32_PKG_DESCRIPTION_FILE): $(LIBFFI32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBFFI32_PKG_DESCRIPTION_FILE) $(LIBFFI32_PKG_INSTALL_SCRIPT)
	@cp $(LIBFFI32_PKG_DESCRIPTION_FILE) $(LIBFFI32_PKG)/.DESCRIPTION
	@cp $(LIBFFI32_PKG_INSTALL_SCRIPT) $(LIBFFI32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBFFI32_PKG)/.REQUIRES
	@echo "pkgname=$(LIBFFI32_PKG_NAME)"                            >  $(LIBFFI32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBFFI32_PKG_VERSION)"                          >> $(LIBFFI32_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBFFI32_PKG_ARCH)"                               >> $(LIBFFI32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBFFI32_PKG_DISTRO_NAME)"                  >> $(LIBFFI32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBFFI32_PKG_DISTRO_VERSION)"                >> $(LIBFFI32_PKG)/.PKGINFO ; \
	 echo "group=$(LIBFFI32_PKG_GROUP)"                             >> $(LIBFFI32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBFFI32_PKG_SHORT_DESCRIPTION)\"" >> $(LIBFFI32_PKG)/.PKGINFO ; \
	 echo "url=$(LIBFFI32_PKG_URL)"                                 >> $(LIBFFI32_PKG)/.PKGINFO ; \
	 echo "license=$(LIBFFI32_PKG_LICENSE)"                         >> $(LIBFFI32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBFFI32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
