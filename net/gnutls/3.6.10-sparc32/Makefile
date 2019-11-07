
COMPONENT_TARGETS  = $(HARDWARE_MBC4_PC)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_SPARC32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/n/gnutls

REQUIRES           = net/gnutls/3.6.10
REQUIRES          += libs/libidn/1.35-sparc32
REQUIRES          += net/p11-kit/0.23.18.1-sparc32
REQUIRES          += net/nettle/3.5.1-sparc32
REQUIRES          += dev/guile/2.2.6-sparc32

# ======= __END_OF_REQUIRES__ =======


version            = 3.6.10
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/n/gnutls/gnutls-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/gnutls-$(version)
src_dir_name       = gnutls-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
GNUTLS_32_PKG_NAME                = gnutls-x32
GNUTLS_32_PKG_VERSION             = 3.6.10
GNUTLS_32_PKG_ARCH                = $(TOOLCHAIN)
GNUTLS_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
GNUTLS_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
GNUTLS_32_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
GNUTLS_32_PKG_SHORT_DESCRIPTION   = GNU TLS library
GNUTLS_32_PKG_URL                 = $(BUG_URL)
GNUTLS_32_PKG_LICENSE             = GPLv2
GNUTLS_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GNUTLS_32_PKG_NAME)-pkg-description
GNUTLS_32_PKG_DESCRIPTION_FILE_IN = $(GNUTLS_32_PKG_NAME)-pkg-description.in
GNUTLS_32_PKG_INSTALL_SCRIPT      = $(GNUTLS_32_PKG_NAME)-pkg-install.sh

GNUTLS_32_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GNUTLS_32_PKG_NAME)-package

pkg_basename     = $(GNUTLS_32_PKG_NAME)-$(GNUTLS_32_PKG_VERSION)-$(GNUTLS_32_PKG_ARCH)-$(GNUTLS_32_PKG_DISTRO_NAME)-$(GNUTLS_32_PKG_DISTRO_VERSION)

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


env_sysroot  = DESTDIR=$(GNUTLS_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_SPARC32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --enable-openssl-compatibility
extra_configure_switches += --disable-rpath

extra_configure_switches += --bindir=/usr/bin/32

extra_configure_switches += --enable-static=no
extra_configure_switches += --enable-shared=yes

# Тhе road to hellis paved with good intentions:
extra_configure_switches += --without-libnettle-prefix


GUILE_EFFECTIVE_VERSION = 2.2

#
# Enable Guile extension if Guile 2.2 is installed on a build machile:
# -------------------------------------------------------------------
# NOTE:
#   that gnutls with Guile extension also should be installed
#   on build machine.
#
ifneq ($(wildcard /usr/lib$(BUILD_MULTILIB_SUFFIX)/guile/$(GUILE_EFFECTIVE_VERSION)),)
extra_configure_switches += --enable-guile
extra_configure_switches += --with-guile-site-dir=/usr/share/guile/site/$(GUILE_EFFECTIVE_VERSION)
extra_configure_switches += --with-guile-site-ccache-dir=/usr/lib$(MULTILIB_SPARC32_SUFFIX)/guile/$(GUILE_EFFECTIVE_VERSION)/site-ccache
extra_configure_switches += --with-guile-extension-dir=/usr/lib$(MULTILIB_SPARC32_SUFFIX)/guile/$(GUILE_EFFECTIVE_VERSION)/extensions

guile_environment  = guile_snarf=$(TARGET_DEST_DIR)/usr/bin/32/guile-snarf
guile_environment += GUILE_EXTENSION_DIR_FOR_BUILD=/usr/lib$(BUILD_MULTILIB_SUFFIX)/guile/$(GUILE_EFFECTIVE_VERSION)
#
# Especially for SPARC32:
#
guile_environment += LIBPTHREAD='-lpthread' LIBATOMIC_LIBS='-latomic' LIBS='-lpthread -latomic'
else
extra_configure_switches += --enable-guile=no
endif


LDFLAGS += -m32 -Wl,-rpath,/lib$(MULTILIB_SPARC32_SUFFIX):/usr/lib$(MULTILIB_SPARC32_SUFFIX)


TARGET_BIN_RPATH = /lib$(MULTILIB_SPARC32_SUFFIX):/usr/lib$(MULTILIB_SPARC32_SUFFIX)
TARGET_LIB_RPATH = /lib$(MULTILIB_SPARC32_SUFFIX):/usr/lib$(MULTILIB_SPARC32_SUFFIX):/usr/lib/../lib$(MULTILIB_SPARC32_SUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(guile_environment) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) $(guile_environment) -j1
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(GNUTLS_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) $(guile_environment) -j1 install $(env_sysroot)
	@rm -rf $(GNUTLS_32_PKG)/usr/include
	@rm -rf $(GNUTLS_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(GNUTLS_32_PKG)/usr/lib$(MULTILIB_SPARC32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libgnutls-openssl.la libgnutls.la libgnutlsxx.la ; \
	 )
	@( cd $(GNUTLS_32_PKG)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/guile/$(GUILE_EFFECTIVE_VERSION)/extensions ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" guile-gnutls-v-?.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(GNUTLS_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_SPARC32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g"   libgnutls-openssl.la libgnutls.la libgnutlsxx.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libgnutls-openssl.la libgnutls.la libgnutlsxx.la ; \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/guile/$(GUILE_EFFECTIVE_VERSION)/extensions ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g"   guile-gnutls-v-?.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" guile-gnutls-v-?.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" gnutls.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(GNUTLS_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep -v "no machine" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(GNUTLS_32_PKG)/usr/bin/32 ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(GNUTLS_32_PKG)/usr/lib$(MULTILIB_SPARC32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep -v "no machine" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(GNUTLS_32_PKG_DESCRIPTION_FILE): $(GNUTLS_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(GNUTLS_32_PKG_DESCRIPTION_FILE) $(GNUTLS_32_PKG_INSTALL_SCRIPT)
	@cp $(GNUTLS_32_PKG_DESCRIPTION_FILE) $(GNUTLS_32_PKG)/.DESCRIPTION
	@cp $(GNUTLS_32_PKG_INSTALL_SCRIPT) $(GNUTLS_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GNUTLS_32_PKG)/.REQUIRES
	@echo "pkgname=$(GNUTLS_32_PKG_NAME)"                            >  $(GNUTLS_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GNUTLS_32_PKG_VERSION)"                          >> $(GNUTLS_32_PKG)/.PKGINFO ; \
	 echo "arch=$(GNUTLS_32_PKG_ARCH)"                               >> $(GNUTLS_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(GNUTLS_32_PKG_DISTRO_NAME)"                  >> $(GNUTLS_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(GNUTLS_32_PKG_DISTRO_VERSION)"                >> $(GNUTLS_32_PKG)/.PKGINFO ; \
	 echo "group=$(GNUTLS_32_PKG_GROUP)"                             >> $(GNUTLS_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GNUTLS_32_PKG_SHORT_DESCRIPTION)\"" >> $(GNUTLS_32_PKG)/.PKGINFO ; \
	 echo "url=$(GNUTLS_32_PKG_URL)"                                 >> $(GNUTLS_32_PKG)/.PKGINFO ; \
	 echo "license=$(GNUTLS_32_PKG_LICENSE)"                         >> $(GNUTLS_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(GNUTLS_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
