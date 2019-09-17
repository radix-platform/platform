
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


SOURCE_REQUIRES    = sources/packages/a/xfsprogs

REQUIRES           = app/util-linux/2.27.1

# ======= __END_OF_REQUIRES__ =======


version            = 4.3.0
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/a/xfsprogs/xfsprogs-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/xfsprogs-$(version)
src_dir_name       = xfsprogs-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
XFSPROGS_PKG_NAME                = xfsprogs
XFSPROGS_PKG_VERSION             = 4.3.0
XFSPROGS_PKG_ARCH                = $(TOOLCHAIN)
XFSPROGS_PKG_DISTRO_NAME         = $(DISTRO_NAME)
XFSPROGS_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
XFSPROGS_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
XFSPROGS_PKG_SHORT_DESCRIPTION   = XFS filesystem tools
XFSPROGS_PKG_URL                 = $(BUG_URL)
XFSPROGS_PKG_LICENSE             = GPLv2
XFSPROGS_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(XFSPROGS_PKG_NAME)-pkg-description
XFSPROGS_PKG_DESCRIPTION_FILE_IN = $(XFSPROGS_PKG_NAME)-pkg-description.in
XFSPROGS_PKG_INSTALL_SCRIPT      = $(XFSPROGS_PKG_NAME)-pkg-install.sh

XFSPROGS_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(XFSPROGS_PKG_NAME)-package

pkg_basename     = $(XFSPROGS_PKG_NAME)-$(XFSPROGS_PKG_VERSION)-$(XFSPROGS_PKG_ARCH)-$(XFSPROGS_PKG_DISTRO_NAME)-$(XFSPROGS_PKG_DISTRO_VERSION)

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


env_sysroot = DIST_ROOT=$(XFSPROGS_PKG)

extra_configure_switches  = --libdir=/lib$(LIBSUFFIX)
extra_configure_switches += --libexecdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --sbindir=/sbin
extra_configure_switches += --bindir=/usr/bin
extra_configure_switches += --includedir=/usr/include
extra_configure_switches += --datadir=/usr/share
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --enable-shared

environment  = BUILD_CC=gcc
environment += BUILD_CFLAGS='-I../include'

CFLAGS += -D_DEFAULT_SOURCE

TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && \
	  $(BUILD_ENVIRONMENT) $(environment) ./configure \
	  --prefix=/usr               \
	  --exec-prefix=/usr          \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) $(environment)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(XFSPROGS_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install-dev $(env_sysroot)
	@mkdir -p $(XFSPROGS_PKG)/usr/lib$(LIBSUFFIX)
	@( cd $(XFSPROGS_PKG)/lib$(LIBSUFFIX) ; \
	   chmod 755 *.la ; \
	   cp -a libhandle.so.? $(XFSPROGS_PKG)/usr/lib$(LIBSUFFIX) ; \
	   mv *.a *.la *.so $(XFSPROGS_PKG)/usr/lib$(LIBSUFFIX) ; \
	 )
	@( cd $(XFSPROGS_PKG)/usr/lib$(LIBSUFFIX) ; \
	   ln -sf ../../lib$(LIBSUFFIX)/libhandle.so.?.?.? . \
	 )
	@mkdir -p $(XFSPROGS_PKG)/usr/sbin
	@mv $(XFSPROGS_PKG)/sbin/xfs_* $(XFSPROGS_PKG)/usr/sbin
	@mv $(XFSPROGS_PKG)/usr/sbin/xfs_repair $(XFSPROGS_PKG)/sbin
	# ======= Install Documentation =======
	@mkdir -p $(XFSPROGS_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/doc/COPYING* \
	       $(XFSPROGS_PKG)/usr/doc/$(src_dir_name)
	@mv $(XFSPROGS_PKG)/usr/share/doc/xfsprogs $(XFSPROGS_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a doc/INSTALL doc/sparse.txt \
	         $(XFSPROGS_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	# ======= remove target path from target libtool *.la files =======
	@( cd $(XFSPROGS_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libhandle.la ; \
	   sed -i "s,'/lib,'/usr/lib,g"     libhandle.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(XFSPROGS_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libhandle.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libhandle.la \
	 )
	# ======= Strip binaries =======
	@( cd $(XFSPROGS_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(XFSPROGS_PKG) ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(XFSPROGS_PKG_DESCRIPTION_FILE): $(XFSPROGS_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(XFSPROGS_PKG_DESCRIPTION_FILE) $(XFSPROGS_PKG_INSTALL_SCRIPT)
	@cp $(XFSPROGS_PKG_DESCRIPTION_FILE) $(XFSPROGS_PKG)/.DESCRIPTION
	@cp $(XFSPROGS_PKG_INSTALL_SCRIPT) $(XFSPROGS_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(XFSPROGS_PKG)/.REQUIRES
	@echo "pkgname=$(XFSPROGS_PKG_NAME)"                            >  $(XFSPROGS_PKG)/.PKGINFO ; \
	 echo "pkgver=$(XFSPROGS_PKG_VERSION)"                          >> $(XFSPROGS_PKG)/.PKGINFO ; \
	 echo "arch=$(XFSPROGS_PKG_ARCH)"                               >> $(XFSPROGS_PKG)/.PKGINFO ; \
	 echo "distroname=$(XFSPROGS_PKG_DISTRO_NAME)"                  >> $(XFSPROGS_PKG)/.PKGINFO ; \
	 echo "distrover=$(XFSPROGS_PKG_DISTRO_VERSION)"                >> $(XFSPROGS_PKG)/.PKGINFO ; \
	 echo "group=$(XFSPROGS_PKG_GROUP)"                             >> $(XFSPROGS_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(XFSPROGS_PKG_SHORT_DESCRIPTION)\"" >> $(XFSPROGS_PKG)/.PKGINFO ; \
	 echo "url=$(XFSPROGS_PKG_URL)"                                 >> $(XFSPROGS_PKG)/.PKGINFO ; \
	 echo "license=$(XFSPROGS_PKG_LICENSE)"                         >> $(XFSPROGS_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(XFSPROGS_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
