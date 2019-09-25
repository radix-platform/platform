
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/d/python2

REQUIRES           = dev/python2/2.7.11
REQUIRES          += libs/zlib/1.2.8-x86_32
REQUIRES          += app/xz/5.2.2-x86_32
REQUIRES          += libs/libffi/3.2.1-x86_32
REQUIRES          += libs/readline/6.3-x86_32
REQUIRES          += libs/expat/2.1.1-x86_32
REQUIRES          += net/openssl/1.0.2f-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 2.7.11
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/d/python2/Python-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/Python-$(version)
src_dir_name       = Python-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done

hw_cache_in        = $(CURDIR)/cross/hw.cache
hw_cache           = $(CURDIR)/$(SRC_DIR)/hw.cache
cross_patch        = $(SRC_PACKAGE_PATH_ABS)/packages/d/python2/patches/Python-$(version)-cross32.patch

####### Targets

PKG_GROUP = dev
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
PYTHON32_PKG_NAME                = python2-x32
PYTHON32_PKG_VERSION             = 2.7.11
PYTHON32_PKG_ARCH                = $(TOOLCHAIN)
PYTHON32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
PYTHON32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
PYTHON32_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
PYTHON32_PKG_SHORT_DESCRIPTION   = interpreted programming language
PYTHON32_PKG_URL                 = $(BUG_URL)
PYTHON32_PKG_LICENSE             = GPLv2
PYTHON32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(PYTHON32_PKG_NAME)-pkg-description
PYTHON32_PKG_DESCRIPTION_FILE_IN = $(PYTHON32_PKG_NAME)-pkg-description.in
PYTHON32_PKG_INSTALL_SCRIPT      = $(PYTHON32_PKG_NAME)-pkg-install.sh

PYTHON32_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(PYTHON32_PKG_NAME)-package

pkg_basename     = $(PYTHON32_PKG_NAME)-$(PYTHON32_PKG_VERSION)-$(PYTHON32_PKG_ARCH)-$(PYTHON32_PKG_DISTRO_NAME)-$(PYTHON32_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(PYTHON32_PKG)

LDFLAGS    += -L.

extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man

extra_configure_switches += --bindir=/usr/bin/32

extra_configure_switches += --with-system-expat
extra_configure_switches += --with-system-ffi
extra_configure_switches += --with-threads
extra_configure_switches += --enable-ipv6
extra_configure_switches += --enable-shared

extra_configure_switches += --cache-file=$(hw_cache)

python_environment  = RFS=$(TARGET_DEST_DIR)
python_environment += HOSTARCH=$(TARGET32)
python_environment += BUILDARCH=$(BUILD)
python_environment += PYTHONHOME=$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/python2.7
python_environment += LDFLAGS=-Wl,-rpath,/lib32:/usr/lib32


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@( cd $(SRC_DIR) ; \
	   ./configure ; \
	   make python Parser/pgen ; \
	   mv python python_for_build ; \
	   mv Parser/pgen Parser/pgen_for_build ; \
	   make distclean ; \
	 )
	@( cd $(TARGET_BUILD_DIR) ; patch -p0 < $(cross_patch) )
	@cp -a $(hw_cache_in) $(hw_cache)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(python_environment) ./configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(python_environment) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(PYTHON32_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(python_environment) $(MAKE) -j1 install $(env_sysroot)
	@( cd $(PYTHON32_PKG)/usr/include ; \
	   mv python2.7/pyconfig.h . ; \
	   rm -f python2.7/* ; \
	   mv pyconfig.h python2.7/pyconfig-32.h ; \
	 )
	@rm -rf $(PYTHON32_PKG)/usr/share
	@mkdir -p $(PYTHON32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/python2.7/site-packages
	@( cd $(SRC_DIR) ; \
	   mv Tools/README Tools/README.python-tools ; \
	   cp -a Tools/* \
	         $(PYTHON32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/python2.7/site-packages \
	 )
	@mkdir -p $(PYTHON32_PKG)/usr/bin/32
	@( cd $(PYTHON32_PKG)/usr/bin/32 ; \
	   mv 2to3 2to3-2.7 ; ln -sf 2to3-2.7 2to3 ; \
	   mv idle idle2.7 ; ln -sf idle2.7 idle2 ; ln -sf idle2 idle ;\
	   mv pydoc pydoc2.7 ; ln -sf pydoc2.7 pydoc2 ; ln -sf pydoc2 pydoc ;\
	   ln -sf ../../lib$(MULTILIB_X86_32_SUFFIX)/python2.7/site-packages/pynche/pynche pynche2 ; \
	   ln -sf pynche2 pynche ; \
	   ln -sf ../../lib$(MULTILIB_X86_32_SUFFIX)/python2.7/site-packages/i18n/msgfmt.py msgfmt-2.7.py ; \
	   ln -sf msgfmt-2.7.py msgfmt.py ; \
	   ln -sf ../../lib$(MULTILIB_X86_32_SUFFIX)/python2.7/site-packages/i18n/pygettext.py pygettext-2.7.py ; \
	   ln -sf pygettext-2.7.py pygettext.py ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(PYTHON32_PKG))
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" python-2.7.pc ; \
	 )
	@chmod +w $(PYTHON32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/libpython*.so.*
	# ======= Strip binaries =======
	@( cd $(PYTHON32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(PYTHON32_PKG_DESCRIPTION_FILE): $(PYTHON32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(PYTHON32_PKG_DESCRIPTION_FILE) $(PYTHON32_PKG_INSTALL_SCRIPT)
	@cp $(PYTHON32_PKG_DESCRIPTION_FILE) $(PYTHON32_PKG)/.DESCRIPTION
	@cp $(PYTHON32_PKG_INSTALL_SCRIPT) $(PYTHON32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(PYTHON32_PKG)/.REQUIRES
	@echo "pkgname=$(PYTHON32_PKG_NAME)"                            >  $(PYTHON32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(PYTHON32_PKG_VERSION)"                          >> $(PYTHON32_PKG)/.PKGINFO ; \
	 echo "arch=$(PYTHON32_PKG_ARCH)"                               >> $(PYTHON32_PKG)/.PKGINFO ; \
	 echo "distroname=$(PYTHON32_PKG_DISTRO_NAME)"                  >> $(PYTHON32_PKG)/.PKGINFO ; \
	 echo "distrover=$(PYTHON32_PKG_DISTRO_VERSION)"                >> $(PYTHON32_PKG)/.PKGINFO ; \
	 echo "group=$(PYTHON32_PKG_GROUP)"                             >> $(PYTHON32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(PYTHON32_PKG_SHORT_DESCRIPTION)\"" >> $(PYTHON32_PKG)/.PKGINFO ; \
	 echo "url=$(PYTHON32_PKG_URL)"                                 >> $(PYTHON32_PKG)/.PKGINFO ; \
	 echo "license=$(PYTHON32_PKG_LICENSE)"                         >> $(PYTHON32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(PYTHON32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
