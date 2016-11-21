
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


SOURCE_REQUIRES    = sources/packages/n/nettle

REQUIRES           = libs/gmp/6.1.0

# ======= __END_OF_REQUIRES__ =======


version            = 3.2
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/n/nettle/nettle-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/nettle-$(version)
src_dir_name       = nettle-$(version)
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
NETTLE_PKG_NAME                = nettle
NETTLE_PKG_VERSION             = 3.2
NETTLE_PKG_ARCH                = $(TOOLCHAIN)
NETTLE_PKG_DISTRO_NAME         = $(DISTRO_NAME)
NETTLE_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
NETTLE_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
NETTLE_PKG_SHORT_DESCRIPTION   = small cryptographic library
NETTLE_PKG_URL                 = $(BUG_URL)
NETTLE_PKG_LICENSE             = GPLv2
NETTLE_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(NETTLE_PKG_NAME)-pkg-description
NETTLE_PKG_DESCRIPTION_FILE_IN = $(NETTLE_PKG_NAME)-pkg-description.in
NETTLE_PKG_INSTALL_SCRIPT      = $(NETTLE_PKG_NAME)-pkg-install.sh

NETTLE_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(NETTLE_PKG_NAME)-package

pkg_basename     = $(NETTLE_PKG_NAME)-$(NETTLE_PKG_VERSION)-$(NETTLE_PKG_ARCH)-$(NETTLE_PKG_DISTRO_NAME)-$(NETTLE_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(NETTLE_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


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
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(NETTLE_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@chmod a+x $(NETTLE_PKG)/usr/lib$(LIBSUFFIX)/lib*.so.?.?
	# ======= Install documentation =======
	@rm -f $(NETTLE_PKG)/usr/share/info/dir
	@gzip -9 $(NETTLE_PKG)/usr/share/info/*
	@mkdir -p $(NETTLE_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING* \
	       $(NETTLE_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(NETTLE_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING* INSTALL NEWS README TODO descore.README nettle.html nettle.pdf \
	         $(NETTLE_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(NETTLE_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(NETTLE_PKG))
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" hogweed.pc ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" nettle.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(NETTLE_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(NETTLE_PKG_DESCRIPTION_FILE): $(NETTLE_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(NETTLE_PKG_DESCRIPTION_FILE) $(NETTLE_PKG_INSTALL_SCRIPT)
	@cp $(NETTLE_PKG_DESCRIPTION_FILE) $(NETTLE_PKG)/.DESCRIPTION
	@cp $(NETTLE_PKG_INSTALL_SCRIPT) $(NETTLE_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(NETTLE_PKG)/.REQUIRES
	@echo "pkgname=$(NETTLE_PKG_NAME)"                            >  $(NETTLE_PKG)/.PKGINFO ; \
	 echo "pkgver=$(NETTLE_PKG_VERSION)"                          >> $(NETTLE_PKG)/.PKGINFO ; \
	 echo "arch=$(NETTLE_PKG_ARCH)"                               >> $(NETTLE_PKG)/.PKGINFO ; \
	 echo "distroname=$(NETTLE_PKG_DISTRO_NAME)"                  >> $(NETTLE_PKG)/.PKGINFO ; \
	 echo "distrover=$(NETTLE_PKG_DISTRO_VERSION)"                >> $(NETTLE_PKG)/.PKGINFO ; \
	 echo "group=$(NETTLE_PKG_GROUP)"                             >> $(NETTLE_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(NETTLE_PKG_SHORT_DESCRIPTION)\"" >> $(NETTLE_PKG)/.PKGINFO ; \
	 echo "url=$(NETTLE_PKG_URL)"                                 >> $(NETTLE_PKG)/.PKGINFO ; \
	 echo "license=$(NETTLE_PKG_LICENSE)"                         >> $(NETTLE_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(NETTLE_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
