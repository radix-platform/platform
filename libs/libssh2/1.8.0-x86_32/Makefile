
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/libssh2

REQUIRES           = libs/libssh2/1.8.0
REQUIRES          += net/openssl/1.1.1d-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 1.8.0
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/libssh2/libssh2-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libssh2-$(version)
src_dir_name       = libssh2-$(version)
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
LIBSSH2_32_PKG_NAME                = libssh2-x32
LIBSSH2_32_PKG_VERSION             = 1.8.0
LIBSSH2_32_PKG_ARCH                = $(TOOLCHAIN)
LIBSSH2_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBSSH2_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBSSH2_32_PKG_GROUP               = $(PKG_GROUP)
###                                 |---handy-ruler-------------------------------|
LIBSSH2_32_PKG_SHORT_DESCRIPTION   = SSH2 library
LIBSSH2_32_PKG_URL                 = $(BUG_URL)
LIBSSH2_32_PKG_LICENSE             = BSD
LIBSSH2_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBSSH2_32_PKG_NAME)-pkg-description
LIBSSH2_32_PKG_DESCRIPTION_FILE_IN = $(LIBSSH2_32_PKG_NAME)-pkg-description.in
LIBSSH2_32_PKG_INSTALL_SCRIPT      = $(LIBSSH2_32_PKG_NAME)-pkg-install.sh

LIBSSH2_32_PKG   = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBSSH2_32_PKG_NAME)-package

pkg_basename     = $(LIBSSH2_32_PKG_NAME)-$(LIBSSH2_32_PKG_VERSION)-$(LIBSSH2_32_PKG_ARCH)-$(LIBSSH2_32_PKG_DISTRO_NAME)-$(LIBSSH2_32_PKG_DISTRO_VERSION)

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


env_sysroot  = DESTDIR=$(LIBSSH2_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man

extra_configure_switches += --bindir=/usr/bin/32

# trick the configure script:
# ==========================
extra_configure_switches += ac_cv_libssl=yes

extra_configure_switches += --with-openssl
extra_configure_switches += --with-libssl-prefix=$(TARGET_DEST_DIR)/usr

extra_configure_switches += --with-libz
extra_configure_switches += --with-libz-prefix=$(TARGET_DEST_DIR)/usr

extra_configure_switches += --disable-rpath

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
	@mkdir -p $(LIBSSH2_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(LIBSSH2_32_PKG)/usr/include
	@rm -rf $(LIBSSH2_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBSSH2_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libssh2.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBSSH2_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libssh2.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libssh2.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libssh2.pc ; \
	 )
	# =======Strip binaries =======
	@( cd $(LIBSSH2_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBSSH2_32_PKG_DESCRIPTION_FILE): $(LIBSSH2_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBSSH2_32_PKG_DESCRIPTION_FILE) $(LIBSSH2_32_PKG_INSTALL_SCRIPT)
	@cp $(LIBSSH2_32_PKG_DESCRIPTION_FILE) $(LIBSSH2_32_PKG)/.DESCRIPTION
	@cp $(LIBSSH2_32_PKG_INSTALL_SCRIPT) $(LIBSSH2_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBSSH2_32_PKG)/.REQUIRES
	@echo "pkgname=$(LIBSSH2_32_PKG_NAME)"                            >  $(LIBSSH2_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBSSH2_32_PKG_VERSION)"                          >> $(LIBSSH2_32_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBSSH2_32_PKG_ARCH)"                               >> $(LIBSSH2_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBSSH2_32_PKG_DISTRO_NAME)"                  >> $(LIBSSH2_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBSSH2_32_PKG_DISTRO_VERSION)"                >> $(LIBSSH2_32_PKG)/.PKGINFO ; \
	 echo "group=$(LIBSSH2_32_PKG_GROUP)"                             >> $(LIBSSH2_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBSSH2_32_PKG_SHORT_DESCRIPTION)\"" >> $(LIBSSH2_32_PKG)/.PKGINFO ; \
	 echo "url=$(LIBSSH2_32_PKG_URL)"                                 >> $(LIBSSH2_32_PKG)/.PKGINFO ; \
	 echo "license=$(LIBSSH2_32_PKG_LICENSE)"                         >> $(LIBSSH2_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LIBSSH2_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
