
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


SOURCE_REQUIRES    = sources/packages/a/logrotate

ifneq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES           = libs/popt/1.16
else
REQUIRES           = libs/popt/1.16-x86_32
endif
REQUIRES          += app/dcron/4.5

# ======= __END_OF_REQUIRES__ =======


version             = 3.8.7
tar_gz_archive      = $(SRC_PACKAGE_PATH)/packages/a/logrotate/logrotate-$(version).tar.gz
SRC_ARCHIVE         = $(tar_gz_archive)
SRC_DIR             = $(TARGET_BUILD_DIR)/logrotate-$(version)
src_dir_name        = logrotate-$(version)
src_done            = $(TARGET_BUILD_DIR)/.source_done

logrotate_conf      = $(CURDIR)/conf/logrotate.conf
logrotate_cron      = $(CURDIR)/scripts/logrotate-cron

PATCHES = PATCHES

build_target        = $(TARGET_BUILD_DIR)/.build_done
install_target      = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LOGROTATE_PKG_NAME                = logrotate
LOGROTATE_PKG_VERSION             = 3.8.7
LOGROTATE_PKG_ARCH                = $(TOOLCHAIN)
LOGROTATE_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LOGROTATE_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LOGROTATE_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
LOGROTATE_PKG_SHORT_DESCRIPTION   = system log rotation tool
LOGROTATE_PKG_URL                 = $(BUG_URL)
LOGROTATE_PKG_LICENSE             = GPLv2
LOGROTATE_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LOGROTATE_PKG_NAME)-pkg-description
LOGROTATE_PKG_DESCRIPTION_FILE_IN = $(LOGROTATE_PKG_NAME)-pkg-description.in
LOGROTATE_PKG_INSTALL_SCRIPT      = $(LOGROTATE_PKG_NAME)-pkg-install.sh

LOGROTATE_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LOGROTATE_PKG_NAME)-package

pkg_basename     = $(LOGROTATE_PKG_NAME)-$(LOGROTATE_PKG_VERSION)-$(LOGROTATE_PKG_ARCH)-$(LOGROTATE_PKG_DISTRO_NAME)-$(LOGROTATE_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) RPM_OPT_FLAGS="$(CFLAGS)"
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LOGROTATE_PKG)/usr/sbin
	@( cd $(SRC_DIR) ; \
	   cat logrotate > $(LOGROTATE_PKG)/usr/sbin/logrotate ; \
	   chmod 0755 $(LOGROTATE_PKG)/usr/sbin/logrotate ; \
	 )
	# ======= man pages =======
	@mkdir -p $(LOGROTATE_PKG)/usr/share/man/man8
	@( cd $(SRC_DIR) ; \
	   cat logrotate.8 | gzip -9c > $(LOGROTATE_PKG)/usr/share/man/man8/logrotate.8.gz ; \
	 )
	# ======= create logrotate.d and install config file =======
	@mkdir -p $(LOGROTATE_PKG)/etc/logrotate.d
	@cat $(logrotate_conf) > $(LOGROTATE_PKG)/etc/logrotate.conf.new
	# ======= make logrotate run from cron every day =======
	@mkdir -p $(LOGROTATE_PKG)/etc/cron.daily
	@cat $(logrotate_cron) > $(LOGROTATE_PKG)/etc/cron.daily/logrotate
	@chmod 0755 $(LOGROTATE_PKG)/etc/cron.daily/logrotate
	# ======= documentation =======
	@mkdir -p $(LOGROTATE_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING $(LOGROTATE_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(LOGROTATE_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a CHANGES COPYING INSTALL README* examples \
	         $(LOGROTATE_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LOGROTATE_PKG))
	# ======= Strip binaries =======
	@( cd $(LOGROTATE_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null \
	 )
	@touch $@

$(LOGROTATE_PKG_DESCRIPTION_FILE): $(LOGROTATE_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LOGROTATE_PKG_DESCRIPTION_FILE) $(LOGROTATE_PKG_INSTALL_SCRIPT)
	@cp $(LOGROTATE_PKG_DESCRIPTION_FILE) $(LOGROTATE_PKG)/.DESCRIPTION
	@cp $(LOGROTATE_PKG_INSTALL_SCRIPT) $(LOGROTATE_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LOGROTATE_PKG)/.REQUIRES
	@echo "pkgname=$(LOGROTATE_PKG_NAME)"                            >  $(LOGROTATE_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LOGROTATE_PKG_VERSION)"                          >> $(LOGROTATE_PKG)/.PKGINFO ; \
	 echo "arch=$(LOGROTATE_PKG_ARCH)"                               >> $(LOGROTATE_PKG)/.PKGINFO ; \
	 echo "distroname=$(LOGROTATE_PKG_DISTRO_NAME)"                  >> $(LOGROTATE_PKG)/.PKGINFO ; \
	 echo "distrover=$(LOGROTATE_PKG_DISTRO_VERSION)"                >> $(LOGROTATE_PKG)/.PKGINFO ; \
	 echo "group=$(LOGROTATE_PKG_GROUP)"                             >> $(LOGROTATE_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LOGROTATE_PKG_SHORT_DESCRIPTION)\"" >> $(LOGROTATE_PKG)/.PKGINFO ; \
	 echo "url=$(LOGROTATE_PKG_URL)"                                 >> $(LOGROTATE_PKG)/.PKGINFO ; \
	 echo "license=$(LOGROTATE_PKG_LICENSE)"                         >> $(LOGROTATE_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LOGROTATE_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
