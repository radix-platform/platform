
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/libiodbc

REQUIRES           = libs/libiodbc/3.52.9
REQUIRES          += libs/glibc/2.21-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 3.52.9
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/libiodbc/libiodbc-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libiodbc-$(version)
src_dir_name       = libiodbc-$(version)
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
LIBIODBC_32_PKG_NAME                = libiodbc-x32
LIBIODBC_32_PKG_VERSION             = 3.52.9
LIBIODBC_32_PKG_ARCH                = $(TOOLCHAIN)
LIBIODBC_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBIODBC_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBIODBC_32_PKG_GROUP               = $(PKG_GROUP)
###                                  |---handy-ruler-------------------------------|
LIBIODBC_32_PKG_SHORT_DESCRIPTION   = Independent Open DataBase Connectivity
LIBIODBC_32_PKG_URL                 = $(BUG_URL)
LIBIODBC_32_PKG_LICENSE             = LGPLv2
LIBIODBC_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBIODBC_32_PKG_NAME)-pkg-description
LIBIODBC_32_PKG_DESCRIPTION_FILE_IN = $(LIBIODBC_32_PKG_NAME)-pkg-description.in
LIBIODBC_32_PKG_INSTALL_SCRIPT      = $(LIBIODBC_32_PKG_NAME)-pkg-install.sh

LIBIODBC_32_PKG  = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBIODBC_32_PKG_NAME)-package

pkg_basename     = $(LIBIODBC_32_PKG_NAME)-$(LIBIODBC_32_PKG_VERSION)-$(LIBIODBC_32_PKG_ARCH)-$(LIBIODBC_32_PKG_DISTRO_NAME)-$(LIBIODBC_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(LIBIODBC_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man

extra_configure_switches += --sysconfdir=/etc

extra_configure_switches += --bindir=/usr/bin/32

extra_configure_switches += --disable-gui
extra_configure_switches += --disable-gtktest

extra_configure_switches += --disable-libodbc
extra_configure_switches += --program-prefix=
extra_configure_switches += --program-suffix=

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
	@mkdir -p $(LIBIODBC_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@rm -rf $(LIBIODBC_32_PKG)/usr/include
	@rm -rf $(LIBIODBC_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBIODBC_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libiodbc.la libiodbcinst.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(LIBIODBC_32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libiodbc.la libiodbcinst.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libiodbc.la libiodbcinst.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libiodbc.pc ; \
	   sed -i "s,/etc,$(TARGET_DEST_DIR)/etc,g" libiodbc.pc ; \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/bin/32 ; \
	   sed -i "s,prefix=/usr,prefix=$(TARGET_DEST_DIR)/usr,g" iodbc-config ; \
	   sed -i "s,/usr/lib,$(TARGET_DEST_DIR)/usr/lib,g"       iodbc-config ; \
	   sed -i "s,/etc,$(TARGET_DEST_DIR)/etc,g"               iodbc-config ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBIODBC_32_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBIODBC_32_PKG_DESCRIPTION_FILE): $(LIBIODBC_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBIODBC_32_PKG_DESCRIPTION_FILE) $(LIBIODBC_32_PKG_INSTALL_SCRIPT)
	@cp $(LIBIODBC_32_PKG_DESCRIPTION_FILE) $(LIBIODBC_32_PKG)/.DESCRIPTION
	@cp $(LIBIODBC_32_PKG_INSTALL_SCRIPT) $(LIBIODBC_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBIODBC_32_PKG)/.REQUIRES
	@echo "pkgname=$(LIBIODBC_32_PKG_NAME)"                            >  $(LIBIODBC_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBIODBC_32_PKG_VERSION)"                          >> $(LIBIODBC_32_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBIODBC_32_PKG_ARCH)"                               >> $(LIBIODBC_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBIODBC_32_PKG_DISTRO_NAME)"                  >> $(LIBIODBC_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBIODBC_32_PKG_DISTRO_VERSION)"                >> $(LIBIODBC_32_PKG)/.PKGINFO ; \
	 echo "group=$(LIBIODBC_32_PKG_GROUP)"                             >> $(LIBIODBC_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBIODBC_32_PKG_SHORT_DESCRIPTION)\"" >> $(LIBIODBC_32_PKG)/.PKGINFO ; \
	 echo "url=$(LIBIODBC_32_PKG_URL)"                                 >> $(LIBIODBC_32_PKG)/.PKGINFO ; \
	 echo "license=$(LIBIODBC_32_PKG_LICENSE)"                         >> $(LIBIODBC_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBIODBC_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
