
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXV)
COMPONENT_TARGETS += $(HARDWARE_P201)
COMPONENT_TARGETS += $(HARDWARE_NEXBOX_A95X)
COMPONENT_TARGETS += $(HARDWARE_ODROID_C2)
COMPONENT_TARGETS += $(HARDWARE_P212)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_VIM)
COMPONENT_TARGETS += $(HARDWARE_Q201)
COMPONENT_TARGETS += $(HARDWARE_ENYBOX_X2)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES   = sources/GNU/glibc/2.24
SOURCE_REQUIRES  += sources/iana/tz


REQUIRES          = dev/kernel-headers
REQUIRES         += dev/gcc-runtime/5.3.0
REQUIRES         += base/pkgtool

# ======= __END_OF_REQUIRES__ =======


version               = 2.24
tar_xz_archive        = $(SRC_PACKAGE_PATH)/GNU/glibc/$(version)/glibc-$(version).tar.xz

tz_version            = 2016i
tar_gz_code_archive   = $(SRC_PACKAGE_PATH)/iana/tz/tzcode$(tz_version).tar.gz
tar_gz_data_archive   = $(SRC_PACKAGE_PATH)/iana/tz/tzdata$(tz_version).tar.gz
exclude_list          = $(CURDIR)/tz-exclude.list

SRC_ARCHIVE       = $(tar_xz_archive)
SRC_DIR           = $(TARGET_BUILD_DIR)/glibc-$(version)
src_dir_name      = glibc-$(version)
src_done          = $(TARGET_BUILD_DIR)/.source-done

PATCHES           = PATCHES

build_dir         = $(CURDIR)/$(TARGET_BUILD_DIR)/build
build_target      = $(CURDIR)/$(TARGET_BUILD_DIR)/.built
install_target    = $(CURDIR)/$(TARGET_BUILD_DIR)/.installed


build_glibc_pkg   = $(CURDIR)/$(TARGET_BUILD_DIR)/.glibc_pkg_done


OPTIMIZATION_FLAGS  = -O3


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
GLIBC_PKG_NAME                = glibc
GLIBC_PKG_VERSION             = 2.24
GLIBC_PKG_ARCH                = $(TOOLCHAIN)
GLIBC_PKG_DISTRO_NAME         = $(DISTRO_NAME)
GLIBC_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
GLIBC_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
GLIBC_PKG_SHORT_DESCRIPTION   = GNU C libraries
GLIBC_PKG_URL                 = $(BUG_URL)
GLIBC_PKG_LICENSE             = GPLv2
GLIBC_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GLIBC_PKG_NAME)-pkg-description
GLIBC_PKG_DESCRIPTION_FILE_IN = $(GLIBC_PKG_NAME)-pkg-description.in
GLIBC_PKG_INSTALL_SCRIPT      = $(GLIBC_PKG_NAME)-pkg-install.sh

GLIBC_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GLIBC_PKG_NAME)-package

pkg_basename     = $(GLIBC_PKG_NAME)-$(GLIBC_PKG_VERSION)-$(GLIBC_PKG_ARCH)-$(GLIBC_PKG_DISTRO_NAME)-$(GLIBC_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_certificate  = $(call cert-name,$(pkg_archive))
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)
BUILD_TARGETS   += $(build_glibc_pkg)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = install_root=$(GLIBC_PKG)


extra_configure_switches  += --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches  += --with-headers=$(TARGET_DEST_DIR)/usr/include
extra_configure_switches  += --with-binutils=$(TOOLCHAIN_PATH)/bin
extra_configure_switches  += --enable-kernel=2.6.36
extra_configure_switches  += --enable-obsolete-rpc
extra_configure_switches  += --disable-profile
extra_configure_switches  += --disable-rpath
extra_configure_switches  += --without-gd
extra_configure_switches  += --without-cvs
extra_configure_switches  += --with-tls
extra_configure_switches  += --with-__thread


#
# Time Zone config:
#
CFLAGS += -DHAVE_LOCALTIME_RZ=0 -DNETBSD_INSPIRED=0


$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	@tar --exclude-from=$(exclude_list) -xzf $(tar_gz_code_archive) -C $(SRC_DIR)/timezone
	@tar --exclude-from=$(exclude_list) -xzf $(tar_gz_data_archive) -C $(SRC_DIR)/timezone
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@echo "slibdir=/lib$(LIBSUFFIX)" >> $(build_dir)/configparms
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(env_sysroot) ../$(src_dir_name)/configure \
	  --prefix=/usr                \
	  --build=$(BUILD)             \
	  --host=$(TARGET)             \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(GLIBC_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= fake LOCALES installation to allow implementation of iconv and intl into GLIBC =======
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 SUPPORTED-LOCALES="" \
	                                                     localedata/install-locales $(env_sysroot)
	@touch $@

$(build_glibc_pkg): $(install_target)
	@rm -f $(GLIBC_PKG)/usr/share/info/dir
	@gzip -9 $(GLIBC_PKG)/usr/share/info/*
	# ======= Install Documentation =======
	@mkdir -p $(GLIBC_PKG)/usr/doc/glibc-$(version)
	@cp -a  $(SRC_DIR)/COPYING* $(SRC_DIR)/LICENSES \
	        $(GLIBC_PKG)/usr/doc/glibc-$(version)
	@mkdir -p $(GLIBC_PKG)/usr/share/doc/glibc-$(version)
	@( cd $(SRC_DIR) ; \
	   cp -a BUGS CONFORMANCE COPYING* INSTALL LICENSES NAMESPACE NEWS README \
	         $(GLIBC_PKG)/usr/share/doc/glibc-$(version) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(GLIBC_PKG)/usr/share/doc/glibc-$(version)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
ifeq ($(TOOLCHAIN),$(TOOLCHAIN_S9XX_GLIBC))
	@mkdir -p $(GLIBC_PKG)/lib64
	@( cd $(GLIBC_PKG)/lib64 ; \
	   ln -sf ../lib$(LIBSUFFIX)/ld-$(version).so ld-linux-aarch64.so.1 ; \
	 )
endif
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(GLIBC_PKG))
	# ======= Strip binaries =======
	@( cd $(GLIBC_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null ; \
	   find . | xargs file | grep "relocatable" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null ; \
	 )
	@touch $@

$(GLIBC_PKG_DESCRIPTION_FILE): $(GLIBC_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(build_glibc_pkg) $(GLIBC_PKG_DESCRIPTION_FILE) $(GLIBC_PKG_INSTALL_SCRIPT)
	@cp $(GLIBC_PKG_DESCRIPTION_FILE) $(GLIBC_PKG)/.DESCRIPTION
	@cp $(GLIBC_PKG_INSTALL_SCRIPT) $(GLIBC_PKG)/.INSTALL
	@$(BUILD_BIN_PKG_REQUIRES) $(GLIBC_PKG)/.REQUIRES
	@echo "pkgname=$(GLIBC_PKG_NAME)"                            >  $(GLIBC_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GLIBC_PKG_VERSION)"                          >> $(GLIBC_PKG)/.PKGINFO ; \
	 echo "arch=$(GLIBC_PKG_ARCH)"                               >> $(GLIBC_PKG)/.PKGINFO ; \
	 echo "distroname=$(GLIBC_PKG_DISTRO_NAME)"                  >> $(GLIBC_PKG)/.PKGINFO ; \
	 echo "distrover=$(GLIBC_PKG_DISTRO_VERSION)"                >> $(GLIBC_PKG)/.PKGINFO ; \
	 echo "group=$(GLIBC_PKG_GROUP)"                             >> $(GLIBC_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GLIBC_PKG_SHORT_DESCRIPTION)\"" >> $(GLIBC_PKG)/.PKGINFO ; \
	 echo "url=$(GLIBC_PKG_URL)"                                 >> $(GLIBC_PKG)/.PKGINFO ; \
	 echo "license=$(GLIBC_PKG_LICENSE)"                         >> $(GLIBC_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(GLIBC_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
