
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXQ)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

ENABLE_DYNAMIC_PUBKEYS = yes


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/n/crda
SOURCE_REQUIRES   += sources/packages/n/wireless-regdb

REQUIRES           = net/iw/3.17
ifeq ($(ENABLE_DYNAMIC_PUBKEYS),yes)
REQUIRES          += net/openssl/1.0.2f
else
REQUIRES          += net/libgcrypt/1.6.2
endif

# ======= __END_OF_REQUIRES__ =======


version            = 3.13
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/n/crda/crda-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/crda-$(version)
src_dir_name       = crda-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

wireless_regdb_version = 2014.11.07
wireless_regdb_tarball = $(SRC_PACKAGE_PATH)/packages/n/wireless-regdb/wireless-regdb-$(wireless_regdb_version).tar.xz

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
CRDA_PKG_NAME                = crda
CRDA_PKG_VERSION             = 3.13
CRDA_PKG_ARCH                = $(TOOLCHAIN)
CRDA_PKG_DISTRO_NAME         = $(DISTRO_NAME)
CRDA_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
CRDA_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
CRDA_PKG_SHORT_DESCRIPTION   = Central Regulatory Domain Agent
CRDA_PKG_URL                 = $(BUG_URL)
CRDA_PKG_LICENSE             = copyleft-next-0.3.0
CRDA_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(CRDA_PKG_NAME)-pkg-description
CRDA_PKG_DESCRIPTION_FILE_IN = $(CRDA_PKG_NAME)-pkg-description.in
CRDA_PKG_INSTALL_SCRIPT      = $(CRDA_PKG_NAME)-pkg-install.sh

CRDA_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(CRDA_PKG_NAME)-package

pkg_basename     = $(CRDA_PKG_NAME)-$(CRDA_PKG_VERSION)-$(CRDA_PKG_ARCH)-$(CRDA_PKG_DISTRO_NAME)-$(CRDA_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(CRDA_PKG)

DYNAMIC_PUBKEY_DIR  = etc/wireless-regdb/pubkeys

#
# NOTE: the default format is 'le32' and we can check only x86_64 HARDWARE.
#
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC64)),)
DATA_FORMAT = le64
else
DATA_FORMAT = le32
endif


configure_switches  = PREFIX=/usr
configure_switches += LIBDIR=/usr/lib$(LIBSUFFIX)
ifeq ($(ENABLE_DYNAMIC_PUBKEYS),yes)
configure_switches += USE_OPENSSL=1
configure_switches += RUNTIME_PUBKEY_DIR=/$(DYNAMIC_PUBKEY_DIR)
configure_switches += DATA_FORMAT=$(DATA_FORMAT)
endif
configure_switches += UDEV_RULE_DIR=/lib/udev/rules.d
configure_switches += MANDIR=/usr/share/man

configure_switches += REG_BIN=$(CRDA_PKG)/usr/lib$(LIBSUFFIX)/crda/regulatory.bin

#
# Build machine 'regdbdump' to verify regulatory.bin DB
#
configure_switches += BUILD_REG_DB_DUMP=/sbin/regdbdump


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@echo "Expanding `basename $(wireless_regdb_tarball)`"
	@tar xJf $(wireless_regdb_tarball) -C $(TARGET_BUILD_DIR)
	@touch $@

$(build_target): $(src_done)
	# ======= Install wireless-regdb-$(wireless_regdb_version) =======
	@( cd $(TARGET_BUILD_DIR)/wireless-regdb-$(wireless_regdb_version) ; \
	   mkdir -p $(CRDA_PKG)/usr/lib$(LIBSUFFIX)/crda ; \
	   cat regulatory.bin > $(CRDA_PKG)/usr/lib$(LIBSUFFIX)/crda/regulatory.bin ; \
	   mkdir -p $(CRDA_PKG)/usr/share/man/man5 ; \
	   gzip -9c regulatory.bin.5 > $(CRDA_PKG)/usr/share/man/man5/regulatory.bin.5.gz ; \
	   mkdir -p $(CRDA_PKG)/usr/share/doc/$(src_dir_name)/regdb ; \
	   cp -a CONTRIBUTING LICENSE README db.txt \
	         $(CRDA_PKG)/usr/share/doc/$(src_dir_name)/regdb ; \
	 )
	# ======= Build CRDA-$(version) =======
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) $(configure_switches)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(CRDA_PKG)/usr/lib$(LIBSUFFIX)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(configure_switches) $(env_sysroot)
ifeq ($(ENABLE_DYNAMIC_PUBKEYS),yes)
	@mkdir -p $(CRDA_PKG)/$(DYNAMIC_PUBKEY_DIR)
endif
	# ======= Install Documentation =======
	@mkdir -p $(CRDA_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/LICENSE $(SRC_DIR)/copyleft-next-0.3.0 \
	       $(CRDA_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(CRDA_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a LICENSE README copyleft-next-0.3.0 \
	         $(CRDA_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(CRDA_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(CRDA_PKG))
	# ======= Strip binaries =======
	@( cd $(CRDA_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(CRDA_PKG_DESCRIPTION_FILE): $(CRDA_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(CRDA_PKG_DESCRIPTION_FILE) $(CRDA_PKG_INSTALL_SCRIPT)
	@cp $(CRDA_PKG_DESCRIPTION_FILE) $(CRDA_PKG)/.DESCRIPTION
	@cp $(CRDA_PKG_INSTALL_SCRIPT) $(CRDA_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(CRDA_PKG)/.REQUIRES
	@echo "pkgname=$(CRDA_PKG_NAME)"                            >  $(CRDA_PKG)/.PKGINFO ; \
	 echo "pkgver=$(CRDA_PKG_VERSION)"                          >> $(CRDA_PKG)/.PKGINFO ; \
	 echo "arch=$(CRDA_PKG_ARCH)"                               >> $(CRDA_PKG)/.PKGINFO ; \
	 echo "distroname=$(CRDA_PKG_DISTRO_NAME)"                  >> $(CRDA_PKG)/.PKGINFO ; \
	 echo "distrover=$(CRDA_PKG_DISTRO_VERSION)"                >> $(CRDA_PKG)/.PKGINFO ; \
	 echo "group=$(CRDA_PKG_GROUP)"                             >> $(CRDA_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(CRDA_PKG_SHORT_DESCRIPTION)\"" >> $(CRDA_PKG)/.PKGINFO ; \
	 echo "url=$(CRDA_PKG_URL)"                                 >> $(CRDA_PKG)/.PKGINFO ; \
	 echo "license=$(CRDA_PKG_LICENSE)"                         >> $(CRDA_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(CRDA_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
