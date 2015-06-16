
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/GNU/libiconv

REQUIRES           = libs/libiconv/1.14
REQUIRES          += app/gettext/0.18.3.2-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 1.14
tar_gz_archive     = $(SRC_PACKAGE_PATH)/GNU/libiconv/libiconv-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libiconv-$(version)
src_dir_name       = libiconv-$(version)
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
ICONV32_PKG_NAME                = libiconv-x32
ICONV32_PKG_VERSION             = 1.14
ICONV32_PKG_ARCH                = $(TOOLCHAIN)
ICONV32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
ICONV32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
ICONV32_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
ICONV32_PKG_SHORT_DESCRIPTION   = character set conversion library
ICONV32_PKG_URL                 = $(BUG_URL)
ICONV32_PKG_LICENSE             = GPLv2
ICONV32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(ICONV32_PKG_NAME)-pkg-description
ICONV32_PKG_DESCRIPTION_FILE_IN = $(ICONV32_PKG_NAME)-pkg-description.in
ICONV32_PKG_INSTALL_SCRIPT      = $(ICONV32_PKG_NAME)-pkg-install.sh

ICONV32_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(ICONV32_PKG_NAME)-package

pkg_basename     = $(ICONV32_PKG_NAME)-$(ICONV32_PKG_VERSION)-$(ICONV32_PKG_ARCH)-$(ICONV32_PKG_DISTRO_NAME)-$(ICONV32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(ICONV32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-rpath
extra_configure_switches += --enable-nls
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
	@mkdir -p $(ICONV32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@chmod a+x $(ICONV32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/libcharset.la
	@chmod a+x $(ICONV32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/libcharset.so.?.?.?
	@chmod a+x $(ICONV32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/libiconv.la
	@chmod a+x $(ICONV32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/libiconv.so.?.?.?
	@chmod a+x $(ICONV32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/preloadable_libiconv.so
	@( cd $(ICONV32_PKG)/usr/bin ; \
	   mkdir 32 ; \
	   mv iconv 32 \
	 )
	@rm -rf $(ICONV32_PKG)/usr/include
	@rm -rf $(ICONV32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(ICONV32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libcharset.la libiconv.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
#	@mkdir -p $(TARGET_DEST_DIR)
#	@cd $(ICONV32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= tune libtool *.la search path to the target destination for development =======
#	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
#	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libcharset.la libiconv.la ; \
#	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libcharset.la libiconv.la \
#	 )
	# ======= Strip binaries =======
	@( cd $(ICONV32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@
	exit 1

$(ICONV32_PKG_DESCRIPTION_FILE): $(ICONV32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(ICONV32_PKG_DESCRIPTION_FILE) $(ICONV32_PKG_INSTALL_SCRIPT)
	@cp $(ICONV32_PKG_DESCRIPTION_FILE) $(ICONV32_PKG)/.DESCRIPTION
	@cp $(ICONV32_PKG_INSTALL_SCRIPT) $(ICONV32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(ICONV32_PKG)/.REQUIRES
	@echo "pkgname=$(ICONV32_PKG_NAME)"                            >  $(ICONV32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(ICONV32_PKG_VERSION)"                          >> $(ICONV32_PKG)/.PKGINFO ; \
	 echo "arch=$(ICONV32_PKG_ARCH)"                               >> $(ICONV32_PKG)/.PKGINFO ; \
	 echo "distroname=$(ICONV32_PKG_DISTRO_NAME)"                  >> $(ICONV32_PKG)/.PKGINFO ; \
	 echo "distrover=$(ICONV32_PKG_DISTRO_VERSION)"                >> $(ICONV32_PKG)/.PKGINFO ; \
	 echo "group=$(ICONV32_PKG_GROUP)"                             >> $(ICONV32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(ICONV32_PKG_SHORT_DESCRIPTION)\"" >> $(ICONV32_PKG)/.PKGINFO ; \
	 echo "url=$(ICONV32_PKG_URL)"                                 >> $(ICONV32_PKG)/.PKGINFO ; \
	 echo "license=$(ICONV32_PKG_LICENSE)"                         >> $(ICONV32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(ICONV32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
