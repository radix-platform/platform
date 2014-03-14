
COMPONENT_TARGETS  = $(TARGET_HOST)
COMPONENT_TARGETS += $(TARGET_PC32)
COMPONENT_TARGETS += $(TARGET_PC64)
COMPONENT_TARGETS += $(TARGET_CB1X)
COMPONENT_TARGETS += $(TARGET_VIP1830)
COMPONENT_TARGETS += $(TARGET_BEAGLE)
COMPONENT_TARGETS += $(TARGET_OMAP5UEVM)
COMPONENT_TARGETS += $(TARGET_B74)

#
# The rest targets links staticaly with newlib or uclibc and not requires eglibc libraties
#
# COMPONENT_TARGETS += $(TARGET_CB1N)
# COMPONENT_TARGETS += $(TARGET_GUARD)
# COMPONENT_TARGETS += $(TARGET_VIP1830N)
# COMPONENT_TARGETS += $(TARGET_L17UC)
#

NEED_ABS_PATH      = true

COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


version = 2.18.1

SOURCE_REQUIRES   = $(SRC_PACKAGE_DIR)/GNU/EGLIBC/$(version)


REQUIRES          = libs/eglibc/2.18.1


tar_bz2_archive           = $(SRC_PACKAGE_PATH)/GNU/EGLIBC/$(version)/eglibc-$(version).tar.bz2
tar_bz2_archive_ports     = $(SRC_PACKAGE_PATH)/GNU/EGLIBC/$(version)/eglibc-ports-$(version).tar.bz2
tar_bz2_archive_localedef = $(SRC_PACKAGE_PATH)/GNU/EGLIBC/$(version)/eglibc-localedef-$(version).tar.bz2


SRC_ARCHIVE       = $(tar_bz2_archive)
SRC_DIR           = $(TARGET_BUILD_DIR)/eglibc-$(version)
src_dir_name      = eglibc-$(version)
src_done          = $(TARGET_BUILD_DIR)/.source-done

PATCHES           = PATCHES

build_dir         = $(TARGET_BUILD_DIR)/build
install_target    = $(TARGET_BUILD_DIR)/.installed


build_i18n_pkg    = $(TARGET_BUILD_DIR)/.eglibc_i18n_pkg_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
EGLIBC_I18N_PKG_NAME                = eglibc-i18n
EGLIBC_I18N_PKG_VERSION             = 2.18.1
ifeq ($(HARDWARE),$(TARGET_HOST))
EGLIBC_I18N_PKG_ARCH                = $(shell uname -m)
else
EGLIBC_I18N_PKG_ARCH                = $(TOOLCHAIN)
endif
EGLIBC_I18N_PKG_DISTRO_NAME         = kxLab
EGLIBC_I18N_PKG_DISTRO_VERSION      = 1.0
EGLIBC_I18N_PKG_GROUP               = $(PKG_GROUP)
###                                   |---handy-ruler-------------------------------|
EGLIBC_I18N_PKG_SHORT_DESCRIPTION   = eglibc-i18n $(version) locales
EGLIBC_I18N_PKG_URL                 = http://www.kxLab.com
EGLIBC_I18N_PKG_LICENSE             = GPLv2
EGLIBC_I18N_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(EGLIBC_I18N_PKG_NAME)-pkg-description
EGLIBC_I18N_PKG_DESCRIPTION_FILE_IN = $(EGLIBC_I18N_PKG_NAME)-pkg-description.in
EGLIBC_I18N_PKG_INSTALL_SCRIPT      = $(EGLIBC_I18N_PKG_NAME)-pkg-install.sh

EGLIBC_I18N_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(EGLIBC_I18N_PKG_NAME)-package

pkg_basename     = $(EGLIBC_I18N_PKG_NAME)-$(EGLIBC_I18N_PKG_VERSION)-$(EGLIBC_I18N_PKG_ARCH)-$(EGLIBC_I18N_PKG_DISTRO_NAME)-$(EGLIBC_I18N_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(EGLIBC_I18N_PKG_GROUP)/$(pkg_basename).tgz


BUILD_TARGETS    = $(build_i18n_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../build-system/core.mk


env_sysroot  = install_root=$(EGLIBC_I18N_PKG)


OPTIMIZATION_FLAGS = -O3

CFLAGS      += -g


INSTALL_NOT_ARCHIVED_LOCALES = no

ifneq ($(filter $(TOOLCHAIN),$(X86_64_EGLIBC_TOOLCHAIN_NAME) $(BUILD_TOOLCHAIN_NAME)),)
INSTALL_ALL_LOCALES = yes
else
INSTALL_ALL_LOCALES = no
endif


LOCALES  = fa_IR/UTF-8

LOCALES += de_DE.UTF-8/UTF-8 de_DE/ISO-8859-1 de_DE@euro/ISO-8859-15

LOCALES += en_HK.UTF-8/UTF-8 en_HK/ISO-8859-1
LOCALES += en_PH.UTF-8/UTF-8 en_PH/ISO-8859-1
LOCALES += en_US.UTF-8/UTF-8 en_US/ISO-8859-1
LOCALES += es_MX.UTF-8/UTF-8 es_MX/ISO-8859-1

LOCALES += fr_FR.UTF-8/UTF-8 fr_FR/ISO-8859-1 fr_FR@euro/ISO-8859-15
LOCALES += it_IT.UTF-8/UTF-8 it_IT/ISO-8859-1 it_IT@euro/ISO-8859-15

LOCALES += ja_JP.EUC-JP/EUC-JP ja_JP.UTF-8/UTF-8

LOCALES += en_RU.KOI8-R/KOI8-R en_RU.UTF-8/UTF-8 en_RU.CP1251/CP1251
LOCALES += en_RU.ISO-8859-5/ISO-8859-5 en_RU/ISO-8859-5

LOCALES += ru_RU.KOI8-R/KOI8-R ru_RU.UTF-8/UTF-8 ru_RU.CP1251/CP1251
LOCALES += ru_RU.ISO-8859-5/ISO-8859-5 ru_RU/ISO-8859-5



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

$(install_target): $(src_done)
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


$(EGLIBC_I18N_PKG_DESCRIPTION_FILE): $(EGLIBC_I18N_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@


$(build_i18n_pkg): $(install_target) $(EGLIBC_I18N_PKG_DESCRIPTION_FILE)
ifeq ($(TOOLCHAIN),$(BUILD_TOOLCHAIN_NAME))
	# Install the same locales into /usr/lib (x86_32 compat) directory
	@mkdir -p $(EGLIBC_I18N_PKG)/usr/lib && cp -rf $(EGLIBC_I18N_PKG)/usr/lib64/locale $(EGLIBC_I18N_PKG)/usr/lib
endif
ifeq ($(TOOLCHAIN),$(X86_64_EGLIBC_TOOLCHAIN_NAME))
	# Install the same locales into /usr/lib32 (x86_32 compat) directory
	@mkdir -p $(EGLIBC_I18N_PKG)/usr/lib32 && cp -rf $(EGLIBC_I18N_PKG)/usr/lib/locale $(EGLIBC_I18N_PKG)/usr/lib32
endif
	# Install the same to $(TARGET_DEST_DIR)
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(EGLIBC_I18N_PKG) && cp -rf * $(TARGET_DEST_DIR)
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
	@touch $@
