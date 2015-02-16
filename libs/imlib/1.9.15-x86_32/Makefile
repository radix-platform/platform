
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/imlib

REQUIRES           = libs/imlib/1.9.15
REQUIRES          += libs/libpng/libpng14/1.4.13-x86_32
REQUIRES          += libs/libtiff/4.0.3-x86_32
REQUIRES          += libs/giflib/5.1.0-x86_32
REQUIRES          += X11/X.org/lib/libXt/1.1.4-x86_32
REQUIRES          += X11/X.org/lib/libXext/1.3.3-x86_32


version            = 1.9.15
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/l/imlib/imlib-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/imlib-$(version)
src_dir_name       = imlib-$(version)
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
IMLIB_32_PKG_NAME                = imlib-x32
IMLIB_32_PKG_VERSION             = 1.9.15
IMLIB_32_PKG_ARCH                = $(TOOLCHAIN)
IMLIB_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
IMLIB_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
IMLIB_32_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
IMLIB_32_PKG_SHORT_DESCRIPTION   = image loading and rendering library
IMLIB_32_PKG_URL                 = $(BUG_URL)
IMLIB_32_PKG_LICENSE             = GPLv2
IMLIB_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(IMLIB_32_PKG_NAME)-pkg-description
IMLIB_32_PKG_DESCRIPTION_FILE_IN = $(IMLIB_32_PKG_NAME)-pkg-description.in
IMLIB_32_PKG_INSTALL_SCRIPT      = $(IMLIB_32_PKG_NAME)-pkg-install.sh

IMLIB_32_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(IMLIB_32_PKG_NAME)-package

pkg_basename      = $(IMLIB_32_PKG_NAME)-$(IMLIB_32_PKG_VERSION)-$(IMLIB_32_PKG_ARCH)-$(IMLIB_32_PKG_DISTRO_NAME)-$(IMLIB_32_PKG_DISTRO_VERSION)

pkg_archive       = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature     = $(call sign-name,$(pkg_archive))
pkg_description   = $(call desc-name,$(pkg_archive))
products          = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS     = $(build_target)
BUILD_TARGETS    += $(install_target)

PRODUCT_TARGETS   = $(products)

ROOTFS_TARGETS    = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(IMLIB_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --mandir=/usr/share/man

extra_configure_switches += --bindir=/usr/bin/32

extra_configure_switches += --sysconfdir=/etc

extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@( cd $(SRC_DIR) ; \
	   autoreconf -i ; \
	 )
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@( cd $(build_dir) ; \
	   sed -i "s,^\(CPPFLAGS =\).*,\1 -I$(TARGET_DEST_DIR)/usr/include," Makefile ; \
	   sed -i "s,^\(CPPFLAGS =\).*,\1 -I$(TARGET_DEST_DIR)/usr/include," Imlib/Makefile ; \
	   sed -i "s,^\(CPPFLAGS =\).*,\1 -I$(TARGET_DEST_DIR)/usr/include," utils/Makefile ; \
	 )
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(IMLIB_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@rm -f $(IMLIB_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig/imlibgdk.pc
	@rm -rf $(IMLIB_32_PKG)/etc
	@rm -rf $(IMLIB_32_PKG)/usr/include
	@rm -rf $(IMLIB_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(IMLIB_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libImlib.la \
	 )
	# ======= remove toolchain path from target imlib *.pc files =======
	@( cd $(IMLIB_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" imlib.pc \
	 )
	# ======= remove toolchain path from target imlib-config script =======
	@( cd $(IMLIB_32_PKG)/usr/bin/32 ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" imlib-config \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(IMLIB_32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libImlib.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libImlib.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,=/usr,=$(TARGET_DEST_DIR)/usr,g"   imlib.pc ; \
	   sed -i "s,-L/usr,-L$(TARGET_DEST_DIR)/usr,g" imlib.pc ; \
	 )
	# ======= tune imlib-config script to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/bin/32 ; \
	   sed -i "s,prefix=/usr,prefix=$(TARGET_DEST_DIR)/usr,g" imlib-config ; \
	   sed -i "s,-L/usr,-L$(TARGET_DEST_DIR)/usr,g"           imlib-config ; \
	 )
	# ======= Strip binaries =======
	@( cd $(IMLIB_32_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(IMLIB_32_PKG_DESCRIPTION_FILE): $(IMLIB_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(IMLIB_32_PKG_DESCRIPTION_FILE) $(IMLIB_32_PKG_INSTALL_SCRIPT)
	@cp $(IMLIB_32_PKG_DESCRIPTION_FILE) $(IMLIB_32_PKG)/.DESCRIPTION
	@cp $(IMLIB_32_PKG_INSTALL_SCRIPT) $(IMLIB_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(IMLIB_32_PKG)/.REQUIRES
	@echo "pkgname=$(IMLIB_32_PKG_NAME)"                            >  $(IMLIB_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(IMLIB_32_PKG_VERSION)"                          >> $(IMLIB_32_PKG)/.PKGINFO ; \
	 echo "arch=$(IMLIB_32_PKG_ARCH)"                               >> $(IMLIB_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(IMLIB_32_PKG_DISTRO_NAME)"                  >> $(IMLIB_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(IMLIB_32_PKG_DISTRO_VERSION)"                >> $(IMLIB_32_PKG)/.PKGINFO ; \
	 echo "group=$(IMLIB_32_PKG_GROUP)"                             >> $(IMLIB_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(IMLIB_32_PKG_SHORT_DESCRIPTION)\"" >> $(IMLIB_32_PKG)/.PKGINFO ; \
	 echo "url=$(IMLIB_32_PKG_URL)"                                 >> $(IMLIB_32_PKG)/.PKGINFO ; \
	 echo "license=$(IMLIB_32_PKG_LICENSE)"                         >> $(IMLIB_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(IMLIB_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
