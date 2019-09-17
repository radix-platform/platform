
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
COMPONENT_TARGETS += $(HARDWARE_RK3328_CC)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_EDGE)
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


NEED_ABS_PATH        = true
COMPONENT_IS_3PP     = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES      = sources/packages/a/sysfsutils

ifeq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC)),)
REQUIRES             = app/util-linux/2.27.1
else
REQUIRES             = app/util-linux/2.27.1-x86_32
endif

# ======= __END_OF_REQUIRES__ =======


version              = 2.1.0
tar_gz_archive       = $(SRC_PACKAGE_PATH)/packages/a/sysfsutils/sysfsutils-$(version).tar.gz
SRC_ARCHIVE          = $(tar_gz_archive)
SRC_DIR              = $(TARGET_BUILD_DIR)/sysfsutils-$(version)
src_dir_name         = sysfsutils-$(version)
src_done             = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target         = $(TARGET_BUILD_DIR)/.build_done
install_target       = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
SYSFSUTILS_PKG_NAME                = sysfsutils
SYSFSUTILS_PKG_VERSION             = 2.1.0
SYSFSUTILS_PKG_ARCH                = $(TOOLCHAIN)
SYSFSUTILS_PKG_DISTRO_NAME         = $(DISTRO_NAME)
SYSFSUTILS_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
SYSFSUTILS_PKG_GROUP               = $(PKG_GROUP)
###                                 |---handy-ruler-------------------------------|
SYSFSUTILS_PKG_SHORT_DESCRIPTION   = utilities for the sysfs filesystem
SYSFSUTILS_PKG_URL                 = $(BUG_URL)
SYSFSUTILS_PKG_LICENSE             = GPLv2
SYSFSUTILS_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(SYSFSUTILS_PKG_NAME)-pkg-description
SYSFSUTILS_PKG_DESCRIPTION_FILE_IN = $(SYSFSUTILS_PKG_NAME)-pkg-description.in
SYSFSUTILS_PKG_INSTALL_SCRIPT      = $(SYSFSUTILS_PKG_NAME)-pkg-install.sh

SYSFSUTILS_PKG   = $(CURDIR)/$(TARGET_BUILD_DIR)/$(SYSFSUTILS_PKG_NAME)-package

pkg_basename     = $(SYSFSUTILS_PKG_NAME)-$(SYSFSUTILS_PKG_VERSION)-$(SYSFSUTILS_PKG_ARCH)-$(SYSFSUTILS_PKG_DISTRO_NAME)-$(SYSFSUTILS_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(SYSFSUTILS_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && \
	  $(BUILD_ENVIRONMENT) ./configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(SYSFSUTILS_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@mkdir -p $(SYSFSUTILS_PKG)/lib$(LIBSUFFIX)
	@( cd $(SYSFSUTILS_PKG)/usr/lib$(LIBSUFFIX)   ; \
	   cp -a libsysfs.so.? ../../lib$(LIBSUFFIX)  ; \
	   mv libsysfs.so.?.?.? ../../lib$(LIBSUFFIX) ; \
	   ln -sf ../../lib$(LIBSUFFIX)/libsysfs.so.?.?.? . \
	 )
	# ======= Install Documentation =======
	@if [ -d $(SYSFSUTILS_PKG)/usr/share/man ]; then \
	  ( cd $(SYSFSUTILS_PKG)/usr/share/man ; \
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
	@mkdir -p $(SYSFSUTILS_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(SYSFSUTILS_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(SYSFSUTILS_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING CREDITS NEWS README TODO docs/libsysfs.txt \
	         $(SYSFSUTILS_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(SYSFSUTILS_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove target path from target libtool *.la files =======
	@( cd $(SYSFSUTILS_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libsysfs.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(SYSFSUTILS_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libsysfs.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libsysfs.la \
	 )
	# ======= Strip binaries =======
	@( cd $(SYSFSUTILS_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(SYSFSUTILS_PKG_DESCRIPTION_FILE): $(SYSFSUTILS_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(SYSFSUTILS_PKG_DESCRIPTION_FILE) $(SYSFSUTILS_PKG_INSTALL_SCRIPT)
	@cp $(SYSFSUTILS_PKG_DESCRIPTION_FILE) $(SYSFSUTILS_PKG)/.DESCRIPTION
	@cp $(SYSFSUTILS_PKG_INSTALL_SCRIPT) $(SYSFSUTILS_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(SYSFSUTILS_PKG)/.REQUIRES
	@echo "pkgname=$(SYSFSUTILS_PKG_NAME)"                            >  $(SYSFSUTILS_PKG)/.PKGINFO ; \
	 echo "pkgver=$(SYSFSUTILS_PKG_VERSION)"                          >> $(SYSFSUTILS_PKG)/.PKGINFO ; \
	 echo "arch=$(SYSFSUTILS_PKG_ARCH)"                               >> $(SYSFSUTILS_PKG)/.PKGINFO ; \
	 echo "distroname=$(SYSFSUTILS_PKG_DISTRO_NAME)"                  >> $(SYSFSUTILS_PKG)/.PKGINFO ; \
	 echo "distrover=$(SYSFSUTILS_PKG_DISTRO_VERSION)"                >> $(SYSFSUTILS_PKG)/.PKGINFO ; \
	 echo "group=$(SYSFSUTILS_PKG_GROUP)"                             >> $(SYSFSUTILS_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(SYSFSUTILS_PKG_SHORT_DESCRIPTION)\"" >> $(SYSFSUTILS_PKG)/.PKGINFO ; \
	 echo "url=$(SYSFSUTILS_PKG_URL)"                                 >> $(SYSFSUTILS_PKG)/.PKGINFO ; \
	 echo "license=$(SYSFSUTILS_PKG_LICENSE)"                         >> $(SYSFSUTILS_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(SYSFSUTILS_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
