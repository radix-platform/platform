
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_ORANGE_PP2E)
COMPONENT_TARGETS += $(HARDWARE_NANOPI_NEO)
COMPONENT_TARGETS += $(HARDWARE_ORANGE_PP)
COMPONENT_TARGETS += $(HARDWARE_ORANGE_PL2)
COMPONENT_TARGETS += $(HARDWARE_WECHIP_TX6)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_POIN2)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXV)
COMPONENT_TARGETS += $(HARDWARE_P201)
COMPONENT_TARGETS += $(HARDWARE_NEXBOX_A95X)
COMPONENT_TARGETS += $(HARDWARE_ODROID_C2)
COMPONENT_TARGETS += $(HARDWARE_P212)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_VIM)
COMPONENT_TARGETS += $(HARDWARE_Q201)
COMPONENT_TARGETS += $(HARDWARE_ENYBOX_X2)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_VIM2)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BAIKAL_T1)
COMPONENT_TARGETS += $(HARDWARE_MBC4_PC)
COMPONENT_TARGETS += $(HARDWARE_S824L)
COMPONENT_TARGETS += $(HARDWARE_VESNIN)
COMPONENT_TARGETS += $(HARDWARE_S824L_LSB)
COMPONENT_TARGETS += $(HARDWARE_VESNIN_LSB)
COMPONENT_TARGETS += $(HARDWARE_TL2WK2)
COMPONENT_TARGETS += $(HARDWARE_TL2SV2)
COMPONENT_TARGETS += $(HARDWARE_TL2WK2_LSB)
COMPONENT_TARGETS += $(HARDWARE_TL2SV2_LSB)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/d/python3
SOURCE_REQUIRES   += sources/packages/d/python3-doc

REQUIRES           = libs/zlib/1.2.8
REQUIRES          += app/xz/5.2.2
REQUIRES          += libs/libffi/3.2.1
REQUIRES          += libs/readline/6.3
REQUIRES          += libs/expat/2.1.1
REQUIRES          += net/openssl/1.0.2f

# ======= __END_OF_REQUIRES__ =======


version            = 3.5.1
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/d/python3/Python-$(version).tar.xz
doc_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/d/python3-doc/python-$(version)-docs-text.tar.bz2
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
cross_patch        = $(SRC_PACKAGE_PATH_ABS)/packages/d/python3/patches/Python-$(version)-cross.patch

####### Targets

PKG_GROUP = dev
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
PYTHON_PKG_NAME                = python3
PYTHON_PKG_VERSION             = 3.5.1
PYTHON_PKG_ARCH                = $(TOOLCHAIN)
PYTHON_PKG_DISTRO_NAME         = $(DISTRO_NAME)
PYTHON_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
PYTHON_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
PYTHON_PKG_SHORT_DESCRIPTION   = interpreted programming language
PYTHON_PKG_URL                 = $(BUG_URL)
PYTHON_PKG_LICENSE             = GPLv2
PYTHON_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(PYTHON_PKG_NAME)-pkg-description
PYTHON_PKG_DESCRIPTION_FILE_IN = $(PYTHON_PKG_NAME)-pkg-description.in
PYTHON_PKG_INSTALL_SCRIPT      = $(PYTHON_PKG_NAME)-pkg-install.sh

PYTHON_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(PYTHON_PKG_NAME)-package

pkg_basename     = $(PYTHON_PKG_NAME)-$(PYTHON_PKG_VERSION)-$(PYTHON_PKG_ARCH)-$(PYTHON_PKG_DISTRO_NAME)-$(PYTHON_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(PYTHON_PKG)

LDFLAGS    += -L.

extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --with-system-expat
extra_configure_switches += --with-system-ffi
extra_configure_switches += --with-threads
extra_configure_switches += --enable-ipv6
extra_configure_switches += --enable-shared

extra_configure_switches += --cache-file=$(hw_cache)

python_environment  = RFS=$(TARGET_DEST_DIR)
python_environment += HOSTARCH=$(TARGET)
python_environment += BUILDARCH=$(BUILD)
python_environment += PYTHONHOME=$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/python3.5


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@( cd $(SRC_DIR) ; \
	   ./configure ; \
	   make python ; \
	   mv python python_for_build ; \
	   mv Parser/pgen Parser/pgen_for_build ; \
	   mv Programs/_freeze_importlib Programs/_freeze_importlib_for_build ; \
	   make distclean ; \
	 )
	@( cd $(TARGET_BUILD_DIR) ; patch -p0 < $(cross_patch) )
	@cp -a $(hw_cache_in) $(hw_cache)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(python_environment) ./configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(python_environment) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(PYTHON_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(python_environment) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install 2to3/3to2 scripts =======
	@mkdir -p $(PYTHON_PKG)/usr/bin
	@cat $(scripts_dir)/python-2to3 > $(PYTHON_PKG)/usr/bin/python-2to3
	@cat $(scripts_dir)/python-3to2 > $(PYTHON_PKG)/usr/bin/python-3to2
	@chmod 0755 $(PYTHON_PKG)/usr/bin/python-2to3
	@chmod 0755 $(PYTHON_PKG)/usr/bin/python-3to2
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC)),)
	# ======= copy pyconfig.h for x86_64 =======
	@( cd $(PYTHON_PKG)/usr/include/python3.5m ; \
	   mv pyconfig.h pyconfig-64.h ; \
	   echo ''                                       > pyconfig.h ; \
	   echo '/******************************'       >> pyconfig.h ; \
	   echo '  pyconfig.h - Multilib Header'        >> pyconfig.h ; \
	   echo ' ******************************/'      >> pyconfig.h ; \
	   echo ''                                      >> pyconfig.h ; \
	   echo '#ifndef __MULTILIB__PYCONFIG_H__'      >> pyconfig.h ; \
	   echo '#define __MULTILIB__PYCONFIG_H__'      >> pyconfig.h ; \
	   echo ''                                      >> pyconfig.h ; \
	   echo '#if defined(__x86_64__)    || \'       >> pyconfig.h ; \
	   echo '    defined(__sparc64__)   || \'       >> pyconfig.h ; \
	   echo '    defined(__arch64__)    || \'       >> pyconfig.h ; \
	   echo '    defined(__powerpc64__) || \'       >> pyconfig.h ; \
	   echo '    defined (__s390x__)'               >> pyconfig.h ; \
	   echo '#include "pyconfig-64.h"'              >> pyconfig.h ; \
	   echo '#else'                                 >> pyconfig.h ; \
	   echo '#include "pyconfig-32.h"'              >> pyconfig.h ; \
	   echo '#endif'                                >> pyconfig.h ; \
	   echo ''                                      >> pyconfig.h ; \
	   echo '#endif /* __MULTILIB__PYCONFIG_H__ */' >> pyconfig.h ; \
	 )
endif
	@if [ -d $(PYTHON_PKG)/usr/share/man ]; then \
	  ( cd $(PYTHON_PKG)/usr/share/man ; \
	    for manpagedir in `find . -type d -name "man*"` ; do \
	      ( cd $$manpagedir ; \
	        for eachpage in `find . -type l -maxdepth 1` ; do \
	          ln -s `readlink $$eachpage`.gz $$eachpage.gz ; \
	          rm $$eachpage ; \
	        done ; \
	        gzip -9 *.?  ; \
	      ) \
	    done \
	  ) \
	 fi
	@mkdir -p $(PYTHON_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/LICENSE $(SRC_DIR)/README \
	       $(PYTHON_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(PYTHON_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a LICENSE README \
	         $(PYTHON_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@mkdir -p $(PYTHON_PKG)/usr/lib$(LIBSUFFIX)/python3.5/site-packages
	@( cd $(SRC_DIR) ; \
	   mv Tools/README Tools/README.python-tools ; \
	   cp -a Tools/* \
	         $(PYTHON_PKG)/usr/lib$(LIBSUFFIX)/python3.5/site-packages \
	 )
	@cp -a $(PYTHON_PKG)/usr/lib$(LIBSUFFIX)/python3.5/site-packages/README.python-tools \
	       $(PYTHON_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(PYTHON_PKG)/usr/share/doc/$(src_dir_name) ; \
	   ln -sf ../../../lib$(LIBSUFFIX)/python3.5/site-packages Tools \
	 )
	@mkdir -p $(PYTHON_PKG)/usr/bin
	@( cd $(PYTHON_PKG)/usr/bin ; \
	   rm -f 2to3 ; \
	   ln -sf ../lib$(LIBSUFFIX)/python3.5/site-packages/pynche/pynche pynche3 ; \
	   ln -sf ../lib$(LIBSUFFIX)/python3.5/site-packages/i18n/msgfmt.py msgfmt-3.5.py ; \
	   ln -sf ../lib$(LIBSUFFIX)/python3.5/site-packages/i18n/pygettext.py pygettext-3.5.py ; \
	 )
	# ======= Install Documentation ======
	@mkdir -p $(PYTHON_PKG)/usr/share/doc/$(src_dir_name)/Documentation
	@tar xjf $(doc_bz2_archive) -C $(TARGET_BUILD_DIR)
	@mv $(TARGET_BUILD_DIR)/python-$(version)-docs-text/* $(PYTHON_PKG)/usr/share/doc/$(src_dir_name)/Documentation
	@rm -rf $(TARGET_BUILD_DIR)/python-$(version)-docs-text
	@( cd $(PYTHON_PKG) ; \
	   find . -type d -exec chmod 755 "{}" \;    ; \
	   find . -perm 640 -exec chmod 644 "{}" \;  ; \
	   find . -perm 750 -exec chmod 755 "{}" \;  ; \
	 )
	# ======= tune python3.5m-config CFLAGS for target machine =======
	@( cd $(PYTHON_PKG)/usr/bin ; \
	   sed -i 's,includedir=$$(echo "$${prefix},includedir=$$(echo "/usr,g' python3.5m-config ; \
	   sed -i 's,LIBPL=$$(echo "$${prefix},LIBPL=$$(echo "/usr,g' python3.5m-config ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" python3.5m-config ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(PYTHON_PKG))
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" python-3.5.pc ; \
	 )
	@chmod +w $(PYTHON_PKG)/usr/lib$(LIBSUFFIX)/libpython*.so*
	# ======= Strip binaries =======
	@( cd $(PYTHON_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(PYTHON_PKG_DESCRIPTION_FILE): $(PYTHON_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(PYTHON_PKG_DESCRIPTION_FILE) $(PYTHON_PKG_INSTALL_SCRIPT)
	@cp $(PYTHON_PKG_DESCRIPTION_FILE) $(PYTHON_PKG)/.DESCRIPTION
	@cp $(PYTHON_PKG_INSTALL_SCRIPT) $(PYTHON_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(PYTHON_PKG)/.REQUIRES
	@echo "pkgname=$(PYTHON_PKG_NAME)"                            >  $(PYTHON_PKG)/.PKGINFO ; \
	 echo "pkgver=$(PYTHON_PKG_VERSION)"                          >> $(PYTHON_PKG)/.PKGINFO ; \
	 echo "arch=$(PYTHON_PKG_ARCH)"                               >> $(PYTHON_PKG)/.PKGINFO ; \
	 echo "distroname=$(PYTHON_PKG_DISTRO_NAME)"                  >> $(PYTHON_PKG)/.PKGINFO ; \
	 echo "distrover=$(PYTHON_PKG_DISTRO_VERSION)"                >> $(PYTHON_PKG)/.PKGINFO ; \
	 echo "group=$(PYTHON_PKG_GROUP)"                             >> $(PYTHON_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(PYTHON_PKG_SHORT_DESCRIPTION)\"" >> $(PYTHON_PKG)/.PKGINFO ; \
	 echo "url=$(PYTHON_PKG_URL)"                                 >> $(PYTHON_PKG)/.PKGINFO ; \
	 echo "license=$(PYTHON_PKG_LICENSE)"                         >> $(PYTHON_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(PYTHON_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
