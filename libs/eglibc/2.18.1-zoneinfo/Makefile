
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


version    = 2.18.1
tz_version = 2013i

SOURCE_REQUIRES   = $(SRC_PACKAGE_DIR)/iana/tz


REQUIRES          = libs/eglibc/2.18.1-i18n


tar_gz_code_archive       = $(SRC_PACKAGE_PATH)/iana/tz/tzcode$(tz_version).tar.gz
tar_gz_data_archive       = $(SRC_PACKAGE_PATH)/iana/tz/tzdata$(tz_version).tar.gz


SRC_DIR           = $(TARGET_BUILD_DIR)/timezone
src_done          = $(TARGET_BUILD_DIR)/.source-done

install_target    = $(TARGET_BUILD_DIR)/.installed

build_tzinfo_pkg  = $(TARGET_BUILD_DIR)/.eglibc_zoneinfo_pkg_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
EGLIBC_TZ_PKG_NAME                = eglibc-zoneinfo
EGLIBC_TZ_PKG_VERSION             = 2.18.1
ifeq ($(HARDWARE),$(TARGET_HOST))
EGLIBC_TZ_PKG_ARCH                = $(shell uname -m)
else
EGLIBC_TZ_PKG_ARCH                = $(TOOLCHAIN)
endif
EGLIBC_TZ_PKG_DISTRO_NAME         = kxLab
EGLIBC_TZ_PKG_DISTRO_VERSION      = 1.0
EGLIBC_TZ_PKG_GROUP               = $(PKG_GROUP)
###                                   |---handy-ruler-------------------------------|
EGLIBC_TZ_PKG_SHORT_DESCRIPTION   = eglibc-zoneinfo $(version) timezone db
EGLIBC_TZ_PKG_URL                 = http://www.kxLab.com
EGLIBC_TZ_PKG_LICENSE             = GPLv2
EGLIBC_TZ_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(EGLIBC_TZ_PKG_NAME)-pkg-description
EGLIBC_TZ_PKG_DESCRIPTION_FILE_IN = $(EGLIBC_TZ_PKG_NAME)-pkg-description.in
EGLIBC_TZ_PKG_INSTALL_SCRIPT      = $(EGLIBC_TZ_PKG_NAME)-pkg-install.sh

EGLIBC_TZ_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(EGLIBC_TZ_PKG_NAME)-package

pkg_basename     = $(EGLIBC_TZ_PKG_NAME)-$(EGLIBC_TZ_PKG_VERSION)-$(EGLIBC_TZ_PKG_ARCH)-$(EGLIBC_TZ_PKG_DISTRO_NAME)-$(EGLIBC_TZ_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(EGLIBC_TZ_PKG_GROUP)/$(pkg_basename).tgz


BUILD_TARGETS    = $(build_tzinfo_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../build-system/core.mk


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
	# Remove $PKG/usr/share/zoneinfo/localtime -- the install script will create it as a link to /etc/localtime.
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
	@touch $@


$(EGLIBC_TZ_PKG_DESCRIPTION_FILE): $(EGLIBC_TZ_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@


$(build_tzinfo_pkg): $(install_target) $(EGLIBC_TZ_PKG_DESCRIPTION_FILE)
	# Install the same to $(TARGET_DEST_DIR)
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(EGLIBC_TZ_PKG) && cp -rf * $(TARGET_DEST_DIR)
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
	@touch $@
