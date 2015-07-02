
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
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


include ../../../../build-system/constants.mk


SOURCE_REQUIRES   = sources/iana/tz

REQUIRES          = libs/eglibc/2.19.1-i18n

# ======= __END_OF_REQUIRES__ =======


version    = 2.19.1
tz_version = 2013i

tar_gz_code_archive       = $(SRC_PACKAGE_PATH)/iana/tz/tzcode$(tz_version).tar.gz
tar_gz_data_archive       = $(SRC_PACKAGE_PATH)/iana/tz/tzdata$(tz_version).tar.gz


SRC_DIR           = $(TARGET_BUILD_DIR)/timezone
src_done          = $(TARGET_BUILD_DIR)/.source-done
install_target    = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
EGLIBC_TZ_PKG_NAME                = eglibc-zoneinfo
EGLIBC_TZ_PKG_VERSION             = 2.19.1
EGLIBC_TZ_PKG_ARCH                = $(TOOLCHAIN)
EGLIBC_TZ_PKG_DISTRO_NAME         = $(DISTRO_NAME)
EGLIBC_TZ_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
EGLIBC_TZ_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
EGLIBC_TZ_PKG_SHORT_DESCRIPTION   = timezone database
EGLIBC_TZ_PKG_URL                 = $(BUG_URL)
EGLIBC_TZ_PKG_LICENSE             = GPLv2
EGLIBC_TZ_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(EGLIBC_TZ_PKG_NAME)-pkg-description
EGLIBC_TZ_PKG_DESCRIPTION_FILE_IN = $(EGLIBC_TZ_PKG_NAME)-pkg-description.in
EGLIBC_TZ_PKG_INSTALL_SCRIPT      = $(EGLIBC_TZ_PKG_NAME)-pkg-install.sh

EGLIBC_TZ_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(EGLIBC_TZ_PKG_NAME)-package

pkg_basename     = $(EGLIBC_TZ_PKG_NAME)-$(EGLIBC_TZ_PKG_VERSION)-$(EGLIBC_TZ_PKG_ARCH)-$(EGLIBC_TZ_PKG_DISTRO_NAME)-$(EGLIBC_TZ_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../build-system/core.mk


OPTIMIZATION_FLAGS  = -O3

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC))
OPTIMIZATION_FLAGS += -fPIC
endif


$(src_done): $(tar_gz_code_archive) $(tar_gz_data_archive)
	@mkdir -p $(SRC_DIR)
	@tar xzf $(tar_gz_code_archive) -C $(SRC_DIR)
	@tar xzf $(tar_gz_data_archive) -C $(SRC_DIR)
	@cd $(SRC_DIR) && CWD=`pwd` sed -i "s,/usr/local,.,g" Makefile
	@cd $(SRC_DIR) && sed -i "s,/etc/$(TZDIR_BASENAME),/$(TZDIR_BASENAME),g" Makefile
	@touch $@

$(install_target): $(src_done)
	@mkdir -p $(EGLIBC_TZ_PKG)
	@cd $(SRC_DIR) && $(MAKE)
	@cd $(SRC_DIR) && $(MAKE) install
	@mkdir -p $(EGLIBC_TZ_PKG)/usr/share/zoneinfo/{posix,right}
	@cp -a $(SRC_DIR)/zoneinfo/* $(EGLIBC_TZ_PKG)/usr/share/zoneinfo
	@cp -a $(SRC_DIR)/zoneinfo-posix/* $(EGLIBC_TZ_PKG)/usr/share/zoneinfo/posix
	@cp -a $(SRC_DIR)/zoneinfo-leaps/* $(EGLIBC_TZ_PKG)/usr/share/zoneinfo/right
	# ======= Remove PACKAGE/usr/share/zoneinfo/localtime --                =======
	# ======= the install script will create it as a link to /etc/localtime =======
	@rm -f $(EGLIBC_TZ_PKG)/usr/share/zoneinfo/localtime
	@cp -rf $(SRC_DIR)/man $(EGLIBC_TZ_PKG)/usr/share
	@( cd $(EGLIBC_TZ_PKG)/usr/share/man/man3 ; \
	   for file in *.3 ; do \
	     gzip -9 --force $$file; \
	   done )
	@( cd $(EGLIBC_TZ_PKG)/usr/share/man/man5 ; \
	   for file in *.5 ; do \
	     gzip -9 --force $$file; \
	   done )
	@( cd $(EGLIBC_TZ_PKG)/usr/share/man/man8 ; \
	   for file in *.8 ; do \
	     gzip -9 --force $$file; \
	   done )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(EGLIBC_TZ_PKG))
	@touch $@

$(EGLIBC_TZ_PKG_DESCRIPTION_FILE): $(EGLIBC_TZ_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(EGLIBC_TZ_PKG_DESCRIPTION_FILE) $(EGLIBC_TZ_PKG_INSTALL_SCRIPT)
	@cp $(EGLIBC_TZ_PKG_DESCRIPTION_FILE) $(EGLIBC_TZ_PKG)/.DESCRIPTION
	@cp $(EGLIBC_TZ_PKG_INSTALL_SCRIPT) $(EGLIBC_TZ_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(EGLIBC_TZ_PKG)/.REQUIRES
	@echo "pkgname=$(EGLIBC_TZ_PKG_NAME)"                            >  $(EGLIBC_TZ_PKG)/.PKGINFO ; \
	 echo "pkgver=$(EGLIBC_TZ_PKG_VERSION)"                          >> $(EGLIBC_TZ_PKG)/.PKGINFO ; \
	 echo "arch=$(EGLIBC_TZ_PKG_ARCH)"                               >> $(EGLIBC_TZ_PKG)/.PKGINFO ; \
	 echo "distroname=$(EGLIBC_TZ_PKG_DISTRO_NAME)"                  >> $(EGLIBC_TZ_PKG)/.PKGINFO ; \
	 echo "distrover=$(EGLIBC_TZ_PKG_DISTRO_VERSION)"                >> $(EGLIBC_TZ_PKG)/.PKGINFO ; \
	 echo "group=$(EGLIBC_TZ_PKG_GROUP)"                             >> $(EGLIBC_TZ_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(EGLIBC_TZ_PKG_SHORT_DESCRIPTION)\"" >> $(EGLIBC_TZ_PKG)/.PKGINFO ; \
	 echo "url=$(EGLIBC_TZ_PKG_URL)"                                 >> $(EGLIBC_TZ_PKG)/.PKGINFO ; \
	 echo "license=$(EGLIBC_TZ_PKG_LICENSE)"                         >> $(EGLIBC_TZ_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(EGLIBC_TZ_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
