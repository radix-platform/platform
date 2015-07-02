
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/GNU/libidn

REQUIRES           = libs/libidn/1.28
REQUIRES          += libs/glibc/2.21-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 1.28
tar_gz_archive     = $(SRC_PACKAGE_PATH)/GNU/libidn/libidn-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libidn-$(version)
src_dir_name       = libidn-$(version)
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
LIBIDN32_PKG_NAME                = libidn-x32
LIBIDN32_PKG_VERSION             = 1.28
LIBIDN32_PKG_ARCH                = $(TOOLCHAIN)
LIBIDN32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBIDN32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBIDN32_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
LIBIDN32_PKG_SHORT_DESCRIPTION   = GNU Internationalized Domain Name library
LIBIDN32_PKG_URL                 = $(BUG_URL)
LIBIDN32_PKG_LICENSE             = GPLv2
LIBIDN32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBIDN32_PKG_NAME)-pkg-description
LIBIDN32_PKG_DESCRIPTION_FILE_IN = $(LIBIDN32_PKG_NAME)-pkg-description.in
LIBIDN32_PKG_INSTALL_SCRIPT      = $(LIBIDN32_PKG_NAME)-pkg-install.sh

LIBIDN32_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBIDN32_PKG_NAME)-package

pkg_basename     = $(LIBIDN32_PKG_NAME)-$(LIBIDN32_PKG_VERSION)-$(LIBIDN32_PKG_ARCH)-$(LIBIDN32_PKG_DISTRO_NAME)-$(LIBIDN32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(LIBIDN32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
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
	@mkdir -p $(LIBIDN32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@mkdir -p $(LIBIDN32_PKG)/usr/bin/32
	@( cd $(LIBIDN32_PKG)/usr/bin ; \
	   find . -type f | xargs mv -t 32 ; \
	 )
	@rm -rf $(LIBIDN32_PKG)/usr/include
	@rm -rf $(LIBIDN32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBIDN32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libidn.la  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBIDN32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libidn.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libidn.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libidn.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBIDN32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBIDN32_PKG_DESCRIPTION_FILE): $(LIBIDN32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBIDN32_PKG_DESCRIPTION_FILE) $(LIBIDN32_PKG_INSTALL_SCRIPT)
	@cp $(LIBIDN32_PKG_DESCRIPTION_FILE) $(LIBIDN32_PKG)/.DESCRIPTION
	@cp $(LIBIDN32_PKG_INSTALL_SCRIPT) $(LIBIDN32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBIDN32_PKG)/.REQUIRES
	@echo "pkgname=$(LIBIDN32_PKG_NAME)"                            >  $(LIBIDN32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBIDN32_PKG_VERSION)"                          >> $(LIBIDN32_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBIDN32_PKG_ARCH)"                               >> $(LIBIDN32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBIDN32_PKG_DISTRO_NAME)"                  >> $(LIBIDN32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBIDN32_PKG_DISTRO_VERSION)"                >> $(LIBIDN32_PKG)/.PKGINFO ; \
	 echo "group=$(LIBIDN32_PKG_GROUP)"                             >> $(LIBIDN32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBIDN32_PKG_SHORT_DESCRIPTION)\"" >> $(LIBIDN32_PKG)/.PKGINFO ; \
	 echo "url=$(LIBIDN32_PKG_URL)"                                 >> $(LIBIDN32_PKG)/.PKGINFO ; \
	 echo "license=$(LIBIDN32_PKG_LICENSE)"                         >> $(LIBIDN32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBIDN32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
