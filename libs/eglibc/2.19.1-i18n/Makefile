
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_VIP1830)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)

#
# The rest targets links staticaly with newlib or uclibc and not requires eglibc libraties
#
# COMPONENT_TARGETS += $(HARDWARE_CB1N)
# COMPONENT_TARGETS += $(HARDWARE_AT91S)
# COMPONENT_TARGETS += $(HARDWARE_VIP1830N)
# COMPONENT_TARGETS += $(HARDWARE_L17UC)
#

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk



SOURCE_REQUIRES   = sources/GNU/EGLIBC/2.19.1

REQUIRES          = libs/eglibc/2.19.1


version                   = 2.19.1
tar_bz2_archive           = $(SRC_PACKAGE_PATH)/GNU/EGLIBC/$(version)/eglibc-$(version).tar.bz2
tar_bz2_archive_ports     = $(SRC_PACKAGE_PATH)/GNU/EGLIBC/$(version)/eglibc-ports-$(version).tar.bz2
tar_bz2_archive_localedef = $(SRC_PACKAGE_PATH)/GNU/EGLIBC/$(version)/eglibc-localedef-$(version).tar.bz2


SRC_ARCHIVE       = $(tar_bz2_archive)
SRC_DIR           = $(TARGET_BUILD_DIR)/eglibc-$(version)
src_dir_name      = eglibc-$(version)
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
EGLIBC_I18N_PKG_NAME                = eglibc-i18n
EGLIBC_I18N_PKG_VERSION             = 2.19.1
EGLIBC_I18N_PKG_ARCH                = $(TOOLCHAIN)
EGLIBC_I18N_PKG_DISTRO_NAME         = $(DISTRO_NAME)
EGLIBC_I18N_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
EGLIBC_I18N_PKG_GROUP               = $(PKG_GROUP)
###                                  |---handy-ruler-------------------------------|
EGLIBC_I18N_PKG_SHORT_DESCRIPTION   = locale files
EGLIBC_I18N_PKG_URL                 = $(BUG_URL)
EGLIBC_I18N_PKG_LICENSE             = GPLv2
EGLIBC_I18N_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(EGLIBC_I18N_PKG_NAME)-pkg-description
EGLIBC_I18N_PKG_DESCRIPTION_FILE_IN = $(EGLIBC_I18N_PKG_NAME)-pkg-description.in
EGLIBC_I18N_PKG_INSTALL_SCRIPT      = $(EGLIBC_I18N_PKG_NAME)-pkg-install.sh

EGLIBC_I18N_PKG  = $(CURDIR)/$(TARGET_BUILD_DIR)/$(EGLIBC_I18N_PKG_NAME)-package

pkg_basename     = $(EGLIBC_I18N_PKG_NAME)-$(EGLIBC_I18N_PKG_VERSION)-$(EGLIBC_I18N_PKG_ARCH)-$(EGLIBC_I18N_PKG_DISTRO_NAME)-$(EGLIBC_I18N_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = install_root=$(EGLIBC_I18N_PKG)


OPTIMIZATION_FLAGS  = -O3
ifeq ($(TOOLCHAIN),$(TOOLCHAIN_X86_64_EGLIBC))
OPTIMIZATION_FLAGS += -fPIC
endif


INSTALL_NOT_ARCHIVED_LOCALES = no

ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_X86_64_EGLIBC)),)
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
	@tar xjf $(tar_bz2_archive_ports) -C $(SRC_DIR)
	@mv $(SRC_DIR)/eglibc-ports-$(version) $(SRC_DIR)/ports
	@tar xjf $(tar_bz2_archive_localedef) -C $(SRC_DIR)
	@mv $(SRC_DIR)/eglibc-localedef-$(version) $(SRC_DIR)/localedef
ifneq ($(INSTALL_NOT_ARCHIVED_LOCALES),yes)
	@cd $(SRC_DIR)/localedef && sed -i "s,--no-archive,,g" Makefile.in
endif
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@mkdir -p $(EGLIBC_I18N_PKG)
	@echo "slibdir=/lib$(LIBSUFFIX)" >> $(build_dir)/configparms
	@cd $(build_dir) && CC=$(BUILD_CC) ../$(src_dir_name)/localedef/configure \
	  --prefix=/usr                  \
	  --build=$(BUILD)               \
	  --libdir=/usr/lib$(LIBSUFFIX)  \
	  --with-glibc=../$(src_dir_name)
	@cd $(build_dir) && $(MAKE)
ifneq ($(INSTALL_ALL_LOCALES),yes)
	@cd $(build_dir) && $(MAKE) SUPPORTED-LOCALES="$(LOCALES)" install-locales $(env_sysroot)
else
	@cd $(build_dir) && $(MAKE) install-locales $(env_sysroot)
endif
	@touch $@

$(install_target): $(build_target)
ifeq ($(TOOLCHAIN),$(TOOLCHAIN_X86_64_EGLIBC))
	# Install the same locales into /usr/lib32 (x86_32 compat) directory
	@mkdir -p $(EGLIBC_I18N_PKG)/usr/lib32 && cp -rf $(EGLIBC_I18N_PKG)/usr/lib/locale $(EGLIBC_I18N_PKG)/usr/lib32
endif
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(EGLIBC_I18N_PKG) && cp -rf * $(TARGET_DEST_DIR)
	@touch $@

$(EGLIBC_I18N_PKG_DESCRIPTION_FILE): $(EGLIBC_I18N_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(EGLIBC_I18N_PKG_DESCRIPTION_FILE) $(EGLIBC_I18N_PKG_INSTALL_SCRIPT)
	@cp $(EGLIBC_I18N_PKG_DESCRIPTION_FILE) $(EGLIBC_I18N_PKG)/.DESCRIPTION
	@cp $(EGLIBC_I18N_PKG_INSTALL_SCRIPT) $(EGLIBC_I18N_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(EGLIBC_I18N_PKG)/.REQUIRES
	@echo "pkgname=$(EGLIBC_I18N_PKG_NAME)"                            >  $(EGLIBC_I18N_PKG)/.PKGINFO ; \
	 echo "pkgver=$(EGLIBC_I18N_PKG_VERSION)"                          >> $(EGLIBC_I18N_PKG)/.PKGINFO ; \
	 echo "arch=$(EGLIBC_I18N_PKG_ARCH)"                               >> $(EGLIBC_I18N_PKG)/.PKGINFO ; \
	 echo "distroname=$(EGLIBC_I18N_PKG_DISTRO_NAME)"                  >> $(EGLIBC_I18N_PKG)/.PKGINFO ; \
	 echo "distrover=$(EGLIBC_I18N_PKG_DISTRO_VERSION)"                >> $(EGLIBC_I18N_PKG)/.PKGINFO ; \
	 echo "group=$(EGLIBC_I18N_PKG_GROUP)"                             >> $(EGLIBC_I18N_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(EGLIBC_I18N_PKG_SHORT_DESCRIPTION)\"" >> $(EGLIBC_I18N_PKG)/.PKGINFO ; \
	 echo "url=$(EGLIBC_I18N_PKG_URL)"                                 >> $(EGLIBC_I18N_PKG)/.PKGINFO ; \
	 echo "license=$(EGLIBC_I18N_PKG_LICENSE)"                         >> $(EGLIBC_I18N_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(EGLIBC_I18N_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
