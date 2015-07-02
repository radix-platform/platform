
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_VIP1830)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)
COMPONENT_TARGETS += $(HARDWARE_CI20)

#
# The rest targets links staticaly with newlib or uclibc and not requires glibc libraties
#
# COMPONENT_TARGETS += $(HARDWARE_CB1N)
# COMPONENT_TARGETS += $(HARDWARE_AT91S)
# COMPONENT_TARGETS += $(HARDWARE_VIP1830N)
# COMPONENT_TARGETS += $(HARDWARE_L17UC)
#

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk



SOURCE_REQUIRES   = sources/GNU/glibc/2.21

REQUIRES          = libs/glibc/2.21

# ======= __END_OF_REQUIRES__ =======


version           = 2.21
tar_xz_archive    = $(SRC_PACKAGE_PATH)/GNU/glibc/$(version)/glibc-$(version).tar.xz

SRC_ARCHIVE       = $(tar_xz_archive)
SRC_DIR           = $(TARGET_BUILD_DIR)/glibc-$(version)
src_dir_name      = glibc-$(version)
src_done          = $(TARGET_BUILD_DIR)/.source-done

PATCHES           = PATCHES

build_dir         = $(TARGET_BUILD_DIR)/build
build_target      = $(TARGET_BUILD_DIR)/.built
install_target    = $(TARGET_BUILD_DIR)/.installed


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
GLIBC_I18N_PKG_NAME                = glibc-i18n
GLIBC_I18N_PKG_VERSION             = 2.21
GLIBC_I18N_PKG_ARCH                = $(TOOLCHAIN)
GLIBC_I18N_PKG_DISTRO_NAME         = $(DISTRO_NAME)
GLIBC_I18N_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
GLIBC_I18N_PKG_GROUP               = $(PKG_GROUP)
###                                 |---handy-ruler-------------------------------|
GLIBC_I18N_PKG_SHORT_DESCRIPTION   = locale files
GLIBC_I18N_PKG_URL                 = $(BUG_URL)
GLIBC_I18N_PKG_LICENSE             = GPLv2
GLIBC_I18N_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GLIBC_I18N_PKG_NAME)-pkg-description
GLIBC_I18N_PKG_DESCRIPTION_FILE_IN = $(GLIBC_I18N_PKG_NAME)-pkg-description.in
GLIBC_I18N_PKG_INSTALL_SCRIPT      = $(GLIBC_I18N_PKG_NAME)-pkg-install.sh

GLIBC_I18N_PKG   = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GLIBC_I18N_PKG_NAME)-package

pkg_basename     = $(GLIBC_I18N_PKG_NAME)-$(GLIBC_I18N_PKG_VERSION)-$(GLIBC_I18N_PKG_ARCH)-$(GLIBC_I18N_PKG_DISTRO_NAME)-$(GLIBC_I18N_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = install_root=$(GLIBC_I18N_PKG)


OPTIMIZATION_FLAGS  = -O3
ifeq ($(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC))
OPTIMIZATION_FLAGS += -fPIC
endif


INSTALL_NOT_ARCHIVED_LOCALES = no

ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC)),)
INSTALL_ALL_LOCALES = yes
else
INSTALL_ALL_LOCALES = no
endif

# ==================================================================
LOCALES  = fa_IR/UTF-8
# ==================================================================
LOCALES += de_DE.UTF-8/UTF-8 de_DE/ISO-8859-1 de_DE@euro/ISO-8859-15
# ==================================================================
LOCALES += en_HK.UTF-8/UTF-8 en_HK/ISO-8859-1
LOCALES += en_PH.UTF-8/UTF-8 en_PH/ISO-8859-1
LOCALES += en_US.UTF-8/UTF-8 en_US/ISO-8859-1
LOCALES += es_MX.UTF-8/UTF-8 es_MX/ISO-8859-1
# ==================================================================
LOCALES += fr_FR.UTF-8/UTF-8 fr_FR/ISO-8859-1 fr_FR@euro/ISO-8859-15
LOCALES += it_IT.UTF-8/UTF-8 it_IT/ISO-8859-1 it_IT@euro/ISO-8859-15
# ==================================================================
LOCALES += ja_JP.EUC-JP/EUC-JP ja_JP.UTF-8/UTF-8
LOCALES += en_RU.KOI8-R/KOI8-R en_RU.UTF-8/UTF-8 en_RU.CP1251/CP1251
LOCALES += en_RU.ISO-8859-5/ISO-8859-5 en_RU/ISO-8859-5
# ==================================================================
LOCALES += ru_RU.KOI8-R/KOI8-R ru_RU.UTF-8/UTF-8 ru_RU.CP1251/CP1251
LOCALES += ru_RU.ISO-8859-5/ISO-8859-5 ru_RU/ISO-8859-5
# ==================================================================



$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
ifeq ($(INSTALL_NOT_ARCHIVED_LOCALES),yes)
	@cd $(SRC_DIR)/localedata && sed -i 's,$\(LOCALEDEF),\$\(LOCALEDEF\) --no-archive,' Makefile
endif
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@mkdir -p $(GLIBC_I18N_PKG)
	@echo "slibdir=/lib$(LIBSUFFIX)" >> $(build_dir)/configparms
	@cd $(build_dir) && CC=$(BUILD_CC) ../$(src_dir_name)/configure \
	  --prefix=/usr                  \
	  --build=$(BUILD)               \
	  --libdir=/usr/lib$(LIBSUFFIX)
	@cd $(build_dir) && $(MAKE)
ifneq ($(INSTALL_ALL_LOCALES),yes)
	@cd $(build_dir) && $(MAKE) -j1 SUPPORTED-LOCALES="$(LOCALES)" localedata/install-locales $(env_sysroot)
else
	@cd $(build_dir) && $(MAKE) -j1 localedata/install-locales $(env_sysroot)
endif
	@touch $@

$(install_target): $(build_target)
ifeq ($(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC))
	# ======= Install the same locales into /usr/lib32 (x86_32 compat) directory =======
	@mkdir -p $(GLIBC_I18N_PKG)/usr/lib32 && cp -rf $(GLIBC_I18N_PKG)/usr/lib/locale $(GLIBC_I18N_PKG)/usr/lib32
endif
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(GLIBC_I18N_PKG))
	@touch $@

$(GLIBC_I18N_PKG_DESCRIPTION_FILE): $(GLIBC_I18N_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(GLIBC_I18N_PKG_DESCRIPTION_FILE) $(GLIBC_I18N_PKG_INSTALL_SCRIPT)
	@cp $(GLIBC_I18N_PKG_DESCRIPTION_FILE) $(GLIBC_I18N_PKG)/.DESCRIPTION
	@cp $(GLIBC_I18N_PKG_INSTALL_SCRIPT) $(GLIBC_I18N_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GLIBC_I18N_PKG)/.REQUIRES
	@echo "pkgname=$(GLIBC_I18N_PKG_NAME)"                            >  $(GLIBC_I18N_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GLIBC_I18N_PKG_VERSION)"                          >> $(GLIBC_I18N_PKG)/.PKGINFO ; \
	 echo "arch=$(GLIBC_I18N_PKG_ARCH)"                               >> $(GLIBC_I18N_PKG)/.PKGINFO ; \
	 echo "distroname=$(GLIBC_I18N_PKG_DISTRO_NAME)"                  >> $(GLIBC_I18N_PKG)/.PKGINFO ; \
	 echo "distrover=$(GLIBC_I18N_PKG_DISTRO_VERSION)"                >> $(GLIBC_I18N_PKG)/.PKGINFO ; \
	 echo "group=$(GLIBC_I18N_PKG_GROUP)"                             >> $(GLIBC_I18N_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GLIBC_I18N_PKG_SHORT_DESCRIPTION)\"" >> $(GLIBC_I18N_PKG)/.PKGINFO ; \
	 echo "url=$(GLIBC_I18N_PKG_URL)"                                 >> $(GLIBC_I18N_PKG)/.PKGINFO ; \
	 echo "license=$(GLIBC_I18N_PKG_LICENSE)"                         >> $(GLIBC_I18N_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(GLIBC_I18N_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
