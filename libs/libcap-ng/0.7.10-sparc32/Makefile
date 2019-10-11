
COMPONENT_TARGETS  = $(HARDWARE_MBC4_PC)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_SPARC32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/libcap-ng

REQUIRES           = libs/libcap-ng/0.7.10
REQUIRES          += dev/python2/2.7.16-sparc32
REQUIRES          += dev/python3/3.7.4-sparc32

# ======= __END_OF_REQUIRES__ =======


version            = 0.7.10
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/l/libcap-ng/libcap-ng-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libcap-ng-$(version)
src_dir_name       = libcap-ng-$(version)
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
LIBCAPNG32_PKG_NAME                = libcap-ng-x32
LIBCAPNG32_PKG_VERSION             = 0.7.10
LIBCAPNG32_PKG_ARCH                = $(TOOLCHAIN)
LIBCAPNG32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBCAPNG32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBCAPNG32_PKG_GROUP               = $(PKG_GROUP)
###                                 |---handy-ruler-------------------------------|
LIBCAPNG32_PKG_SHORT_DESCRIPTION   = capabilities library and utilities
LIBCAPNG32_PKG_URL                 = $(BUG_URL)
LIBCAPNG32_PKG_LICENSE             = GPLv2
LIBCAPNG32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBCAPNG32_PKG_NAME)-pkg-description
LIBCAPNG32_PKG_DESCRIPTION_FILE_IN = $(LIBCAPNG32_PKG_NAME)-pkg-description.in
LIBCAPNG32_PKG_INSTALL_SCRIPT      = $(LIBCAPNG32_PKG_NAME)-pkg-install.sh

LIBCAPNG32_PKG   = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBCAPNG32_PKG_NAME)-package

pkg_basename     = $(LIBCAPNG32_PKG_NAME)-$(LIBCAPNG32_PKG_VERSION)-$(LIBCAPNG32_PKG_ARCH)-$(LIBCAPNG32_PKG_DISTRO_NAME)-$(LIBCAPNG32_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(LIBCAPNG32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_SPARC32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc

extra_configure_switches += --bindir=/usr/bin/32

extra_configure_switches += --with-python=yes
extra_configure_switches += --with-python3=yes
ifeq ($(__ENABLE_STATIC__),yes)
extra_configure_switches += --enable-static=yes
else
extra_configure_switches += --enable-static=no
endif
extra_configure_switches += --enable-shared=yes


PYTHON_VERSION = 2.7

python_config  = PYTHON=$(PYTHON2)
python_config += am_cv_python_version=$(PYTHON_VERSION)
python_config += am_cv_python_platform=linux2
python_config += am_cv_python_pythondir=/usr/lib$(MULTILIB_SPARC32_SUFFIX)/python$(PYTHON_VERSION)/site-packages
python_config += am_cv_python_pyexecdir=/usr/lib$(MULTILIB_SPARC32_SUFFIX)/python$(PYTHON_VERSION)/site-packages
python_config += PYINCLUDEDIR=$(TARGET_DEST_DIR)/usr/include/python$(PYTHON_VERSION)

#
# PYTHON3 configuring by python3-config script:
#
PYTHON3_VERSION = 3.7

python_config  += PYTHON3=$(PYTHON3)
python_config  += PATH=$(TARGET_DEST_DIR)/usr/bin/32:$(PATH)
python_config  += PYTHON3_DIR=/usr/lib$(MULTILIB_SPARC32_SUFFIX)/python$(PYTHON3_VERSION)/site-packages
python_config  += PYTHON3_EXECDIR=/usr/lib$(MULTILIB_SPARC32_SUFFIX)/python$(PYTHON3_VERSION)/site-packages


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@( cd $(SRC_DIR) ; \
	   find . -exec touch -t 201903190437.43 {} \; \
	 )
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(python_config) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LIBCAPNG32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@mkdir -p $(LIBCAPNG32_PKG)/lib$(MULTILIB_SPARC32_SUFFIX)
	@( cd $(LIBCAPNG32_PKG)/usr/lib$(MULTILIB_SPARC32_SUFFIX) ; \
	   cp -a libcap-ng.so.0  $(LIBCAPNG32_PKG)/lib$(MULTILIB_SPARC32_SUFFIX) ; \
	   mv libcap-ng.so.0.?.? $(LIBCAPNG32_PKG)/lib$(MULTILIB_SPARC32_SUFFIX) ; \
	   ln -sf ../../lib$(MULTILIB_SPARC32_SUFFIX)/libcap-ng.so.0.?.? . ; \
	   ln -sf libcap-ng.so.0.?.? libcap-ng.so ; \
	 )
	@rm -rf $(LIBCAPNG32_PKG)/usr/include
	@rm -rf $(LIBCAPNG32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBCAPNG32_PKG)/usr/lib$(MULTILIB_SPARC32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libcap-ng.la ; \
	 )
	@( cd $(LIBCAPNG32_PKG)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/python$(PYTHON_VERSION)/site-packages ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" _capng.la ; \
	 )
	@( cd $(LIBCAPNG32_PKG)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/python$(PYTHON3_VERSION)/site-packages ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" _capng.la ; \
	 )
	# ======= remove TARGET_DEST_DIR from pkg-config *.pc files =======
	@( cd $(LIBCAPNG32_PKG)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/pkgconfig ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libcap-ng.pc ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBCAPNG32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_SPARC32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libcap-ng.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libcap-ng.la ; \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/python$(PYTHON_VERSION)/site-packages ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" _capng.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" _capng.la ; \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/python$(PYTHON3_VERSION)/site-packages ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" _capng.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" _capng.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/pkgconfig ; \
	   sed -i "s,=/usr,=$(TARGET_DEST_DIR)/usr,g" readline.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBCAPNG32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifeq ($(__ENABLE_STATIC__),yes)
	@( cd $(LIBCAPNG32_PKG) ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null ; \
	 )
endif
	@touch $@

$(LIBCAPNG32_PKG_DESCRIPTION_FILE): $(LIBCAPNG32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBCAPNG32_PKG_DESCRIPTION_FILE) $(LIBCAPNG32_PKG_INSTALL_SCRIPT)
	@cp $(LIBCAPNG32_PKG_DESCRIPTION_FILE) $(LIBCAPNG32_PKG)/.DESCRIPTION
	@cp $(LIBCAPNG32_PKG_INSTALL_SCRIPT) $(LIBCAPNG32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBCAPNG32_PKG)/.REQUIRES
	@echo "pkgname=$(LIBCAPNG32_PKG_NAME)"                            >  $(LIBCAPNG32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBCAPNG32_PKG_VERSION)"                          >> $(LIBCAPNG32_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBCAPNG32_PKG_ARCH)"                               >> $(LIBCAPNG32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBCAPNG32_PKG_DISTRO_NAME)"                  >> $(LIBCAPNG32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBCAPNG32_PKG_DISTRO_VERSION)"                >> $(LIBCAPNG32_PKG)/.PKGINFO ; \
	 echo "group=$(LIBCAPNG32_PKG_GROUP)"                             >> $(LIBCAPNG32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBCAPNG32_PKG_SHORT_DESCRIPTION)\"" >> $(LIBCAPNG32_PKG)/.PKGINFO ; \
	 echo "url=$(LIBCAPNG32_PKG_URL)"                                 >> $(LIBCAPNG32_PKG)/.PKGINFO ; \
	 echo "license=$(LIBCAPNG32_PKG_LICENSE)"                         >> $(LIBCAPNG32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LIBCAPNG32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
