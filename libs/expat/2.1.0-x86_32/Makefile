
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/expat

REQUIRES           = libs/eglibc/2.18.1-x86_32


version            = 2.1.0
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/expat/expat-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
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
EXPAT32_PKG_NAME                = expat-x32
EXPAT32_PKG_VERSION             = 2.1.0
EXPAT32_PKG_ARCH                = $(TOOLCHAIN)
EXPAT32_PKG_DISTRO_NAME         = kxLab
EXPAT32_PKG_DISTRO_VERSION      = 1.0
EXPAT32_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
EXPAT32_PKG_SHORT_DESCRIPTION   = expat-x32 $(version)
EXPAT32_PKG_URL                 = http://www.kxLab.com
EXPAT32_PKG_LICENSE             = GPLv2
EXPAT32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(EXPAT32_PKG_NAME)-pkg-description
EXPAT32_PKG_DESCRIPTION_FILE_IN = $(EXPAT32_PKG_NAME)-pkg-description.in
EXPAT32_PKG_INSTALL_SCRIPT      = $(EXPAT32_PKG_NAME)-pkg-install.sh

EXPAT32_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(EXPAT32_PKG_NAME)-package

pkg_basename     = $(EXPAT32_PKG_NAME)-$(EXPAT32_PKG_VERSION)-$(EXPAT32_PKG_ARCH)-$(EXPAT32_PKG_DISTRO_NAME)-$(EXPAT32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(EXPAT32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


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
	@mkdir -p $(EXPAT32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@( cd $(EXPAT32_PKG)/usr/bin ; \
	   mkdir 32 ; \
	   mv xmlwf 32 \
	 )
	@rm -rf $(EXPAT32_PKG)/usr/include
	@rm -rf $(EXPAT32_PKG)/usr/share
	# remove toolchain path from target libtool *.la files and
	@( cd $(EXPAT32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	  sed -i "s,$(TARGET_DEST_DIR),,g" libexpat.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(EXPAT32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# tune libtool *.la search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libexpat.la ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libexpat.la \
	 )
	# tune pkg-config *.pc search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" expat.pc \
	 )
	@(cd $(EXPAT32_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(EXPAT32_PKG_DESCRIPTION_FILE): $(EXPAT32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(EXPAT32_PKG_DESCRIPTION_FILE) $(EXPAT32_PKG_INSTALL_SCRIPT)
	@cp $(EXPAT32_PKG_DESCRIPTION_FILE) $(EXPAT32_PKG)/.DESCRIPTION
	@cp $(EXPAT32_PKG_INSTALL_SCRIPT) $(EXPAT32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(EXPAT32_PKG)/.REQUIRES
	@echo "pkgname=$(EXPAT32_PKG_NAME)"                            >  $(EXPAT32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(EXPAT32_PKG_VERSION)"                          >> $(EXPAT32_PKG)/.PKGINFO ; \
	 echo "arch=$(EXPAT32_PKG_ARCH)"                               >> $(EXPAT32_PKG)/.PKGINFO ; \
	 echo "distroname=$(EXPAT32_PKG_DISTRO_NAME)"                  >> $(EXPAT32_PKG)/.PKGINFO ; \
	 echo "distrover=$(EXPAT32_PKG_DISTRO_VERSION)"                >> $(EXPAT32_PKG)/.PKGINFO ; \
	 echo "group=$(EXPAT32_PKG_GROUP)"                             >> $(EXPAT32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(EXPAT32_PKG_SHORT_DESCRIPTION)\"" >> $(EXPAT32_PKG)/.PKGINFO ; \
	 echo "url=$(EXPAT32_PKG_URL)"                                 >> $(EXPAT32_PKG)/.PKGINFO ; \
	 echo "license=$(EXPAT32_PKG_LICENSE)"                         >> $(EXPAT32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(EXPAT32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
