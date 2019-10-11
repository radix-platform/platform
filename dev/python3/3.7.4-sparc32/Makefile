
COMPONENT_TARGETS  = $(HARDWARE_MBC4_PC)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_SPARC32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/d/python3

REQUIRES           = dev/python3/3.7.4
REQUIRES          += env/libuuid/2.34-sparc32
REQUIRES          += app/xz/5.2.3-sparc32
REQUIRES          += app/bzip2/1.0.6-sparc32
REQUIRES          += app/sqlite/3.26.0.0-sparc32
REQUIRES          += libs/libffi/3.2.1-sparc32
REQUIRES          += libs/expat/2.2.9-sparc32
REQUIRES          += libs/gdbm/1.11-sparc32
REQUIRES          += net/openssl/1.1.1d-sparc32

# ======= __END_OF_REQUIRES__ =======


version            = 3.7.4
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/d/python3/Python-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/Python-$(version)
src_dir_name       = Python-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

scripts_dir        = $(CURDIR)/scripts

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done

hw_cache_in        = $(CURDIR)/cross/hw.cache
hw_cache           = $(CURDIR)/$(SRC_DIR)/hw.cache

####### Targets

PKG_GROUP = dev
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
PYTHON32_PKG_NAME                = python3-x32
PYTHON32_PKG_VERSION             = 3.7.4
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

extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_SPARC32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man

extra_configure_switches += --bindir=/usr/bin/32

extra_configure_switches += --with-system-expat
extra_configure_switches += --with-system-ffi
extra_configure_switches += --with-threads
extra_configure_switches += --enable-ipv6
extra_configure_switches += --enable-optimizations
extra_configure_switches += --enable-shared

extra_configure_switches += --cache-file=$(hw_cache)

python_environment  = RFS=$(TARGET_DEST_DIR)
python_environment += HOSTARCH=$(TARGET32)
python_environment += BUILDARCH=$(BUILD)
python_environment += PYTHONHOME=$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/python3.7
python_environment += ac_cv_prog_READELF=$(TOOLCHAIN_PATH)/bin/$(TARGET)-readelf
python_environment += LDFLAGS=-Wl,-rpath,/lib32:/usr/lib32
python_environment += PYTHON3=$(PYTHON3)
python_environment += PGEN3=$(PGEN3)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@( cd $(SRC_DIR) ; \
	   sed -i 's,^SSL=/usr,SSL=$(TARGET_DEST_DIR)/usr,'   Modules/Setup.dist ; \
	   sed -i 's,^ZLIB=/usr,ZLIB=$(TARGET_DEST_DIR)/usr,' Modules/Setup.dist ; \
	 )
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
	# ======= Install 2to3/3to2 scripts =======
	@mkdir -p $(PYTHON32_PKG)/usr/bin/32
	@cat $(scripts_dir)/python-2to3 > $(PYTHON32_PKG)/usr/bin/32/python-2to3
	@cat $(scripts_dir)/python-3to2 > $(PYTHON32_PKG)/usr/bin/32/python-3to2
	@chmod 0755 $(PYTHON32_PKG)/usr/bin/32/python-2to3
	@chmod 0755 $(PYTHON32_PKG)/usr/bin/32/python-3to2
	# ======= copy pyconfig.h for sparc32 =======
	@rm -rf $(PYTHON32_PKG)/usr/include/python3.7m/internal
	@( cd $(PYTHON32_PKG)/usr/include ; \
	   mv python3.7m/pyconfig.h . ; \
	   rm -f python3.7m/* ; \
	   mv pyconfig.h python3.7m/pyconfig-32.h ; \
	 )
	@rm -rf $(PYTHON32_PKG)/usr/share
	@mkdir -p $(PYTHON32_PKG)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/python3.7/site-packages
	@( cd $(SRC_DIR) ; \
	   mv Tools/README Tools/README.python-tools ; \
	   cp -a Tools/* \
	         $(PYTHON32_PKG)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/python3.7/site-packages \
	 )
	@mkdir -p $(PYTHON32_PKG)/usr/bin/32
	@( cd $(PYTHON32_PKG)/usr/bin/32 ; \
	   rm -f 2to3 ; \
	   ln -sf ../../lib$(MULTILIB_SPARC32_SUFFIX)/python3.7/site-packages/pynche/pynche pynche3 ; \
	   ln -sf ../../lib$(MULTILIB_SPARC32_SUFFIX)/python3.7/site-packages/i18n/msgfmt.py msgfmt-3.7.py ; \
	   ln -sf ../../lib$(MULTILIB_SPARC32_SUFFIX)/python3.7/site-packages/i18n/pygettext.py pygettext-3.7.py ; \
	 )
	# ======= tune python3.7m-config CFLAGS for target machine =======
	@( cd $(PYTHON32_PKG)/usr/bin/32 ; \
	   sed -i 's,RESULT=\(\$$(dirname .*\)$$,RESULT=\$$(dirname \1),' python3.7m-config ; \
	   sed -i 's,includedir=$$(echo "$${prefix},includedir=$$(echo "/usr,g' python3.7m-config ; \
	   sed -i 's,LIBPL=$$(echo "$${prefix},LIBPL=$$(echo "/usr,g' python3.7m-config ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" python3.7m-config ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(PYTHON32_PKG))
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" python-3.7.pc ; \
	 )
	@chmod +w $(PYTHON32_PKG)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/libpython*.so*
	# ======= tune LIBPL config-3.7m*/Makefile for target machine =======
	@( cd $(PYTHON32_PKG)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/python3.7 ; \
	   sed -i 's,$(CURDIR)/$(TARGET_BUILD_DIR),/usr/src,g' config-3.7m*/Makefile ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g"                    config-3.7m*/Makefile ; \
	   sed -i 's,$(TOOLCHAIN_PATH),/usr,g'                 config-3.7m*/Makefile ; \
	   sed -i 's,$(TARGET)-,,g'                            config-3.7m*/Makefile ; \
	   sed -i 's, --sysroot=,,g'                           config-3.7m*/Makefile ; \
	   sed -i "s, '--build=[^\']*',,g"                     config-3.7m*/Makefile ; \
	   sed -i "s, '--host=[^\']*',,g"                      config-3.7m*/Makefile ; \
	   sed -i "s, 'build_alias=[^\']*',,g"                 config-3.7m*/Makefile ; \
	   sed -i "s, 'host_alias=[^\']*',,g"                  config-3.7m*/Makefile ; \
	   host=`cat config-3.7m*/Makefile | grep '^HOST_GNU_TYPE' | sed 's,HOST_GNU_TYPE=[ \t]*\(.*\)$$,\1,'` ; \
	   sed -i "s,\(^BUILD_GNU_TYPE=[ \t]*\).*,\1$$host,"   config-3.7m*/Makefile ; \
	 )
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
