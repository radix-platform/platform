
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/b/sqlite/2016

REQUIRES           = app/sqlite/3.12.2.0
REQUIRES          += libs/readline/8.0-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 3.12.2.0
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/b/sqlite/2016/sqlite-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/sqlite-$(version)
src_dir_name       = sqlite-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
SQLITE_32_PKG_NAME                = sqlite-x32
SQLITE_32_PKG_VERSION             = 3.12.2.0
SQLITE_32_PKG_ARCH                = $(TOOLCHAIN)
SQLITE_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
SQLITE_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
SQLITE_32_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
SQLITE_32_PKG_SHORT_DESCRIPTION   = self contained database engine
SQLITE_32_PKG_URL                 = $(BUG_URL)
SQLITE_32_PKG_LICENSE             = public
SQLITE_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(SQLITE_32_PKG_NAME)-pkg-description
SQLITE_32_PKG_DESCRIPTION_FILE_IN = $(SQLITE_32_PKG_NAME)-pkg-description.in
SQLITE_32_PKG_INSTALL_SCRIPT      = $(SQLITE_32_PKG_NAME)-pkg-install.sh

SQLITE_32_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(SQLITE_32_PKG_NAME)-package

pkg_basename     = $(SQLITE_32_PKG_NAME)-$(SQLITE_32_PKG_VERSION)-$(SQLITE_32_PKG_ARCH)-$(SQLITE_32_PKG_DISTRO_NAME)-$(SQLITE_32_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(SQLITE_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var

extra_configure_switches += --bindir=/usr/bin/32

extra_configure_switches += --enable-readline=yes
extra_configure_switches += --enable-threadsafe=yes
extra_configure_switches += --enable-dynamic-extensions=yes

extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


configure_environment  = LDFLAGS=-Wl,-rpath,/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) $(configure_environment) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(SQLITE_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(SQLITE_32_PKG)/usr/include
	@rm -rf $(SQLITE_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(SQLITE_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libsqlite?.la  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(SQLITE_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libsqlite?.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libsqlite?.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" sqlite?.pc \
	 )
	# ======= Strip Binaries =======
	@( cd $(SQLITE_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(SQLITE_32_PKG_DESCRIPTION_FILE): $(SQLITE_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(SQLITE_32_PKG_DESCRIPTION_FILE) $(SQLITE_32_PKG_INSTALL_SCRIPT)
	@cp $(SQLITE_32_PKG_DESCRIPTION_FILE) $(SQLITE_32_PKG)/.DESCRIPTION
	@cp $(SQLITE_32_PKG_INSTALL_SCRIPT) $(SQLITE_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(SQLITE_32_PKG)/.REQUIRES
	@echo "pkgname=$(SQLITE_32_PKG_NAME)"                            >  $(SQLITE_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(SQLITE_32_PKG_VERSION)"                          >> $(SQLITE_32_PKG)/.PKGINFO ; \
	 echo "arch=$(SQLITE_32_PKG_ARCH)"                               >> $(SQLITE_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(SQLITE_32_PKG_DISTRO_NAME)"                  >> $(SQLITE_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(SQLITE_32_PKG_DISTRO_VERSION)"                >> $(SQLITE_32_PKG)/.PKGINFO ; \
	 echo "group=$(SQLITE_32_PKG_GROUP)"                             >> $(SQLITE_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(SQLITE_32_PKG_SHORT_DESCRIPTION)\"" >> $(SQLITE_32_PKG)/.PKGINFO ; \
	 echo "url=$(SQLITE_32_PKG_URL)"                                 >> $(SQLITE_32_PKG)/.PKGINFO ; \
	 echo "license=$(SQLITE_32_PKG_LICENSE)"                         >> $(SQLITE_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(SQLITE_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
