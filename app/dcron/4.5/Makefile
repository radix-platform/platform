
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


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/dcron

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.4.0
else
REQUIRES           = libs/glibc/2.27
endif

# ======= __END_OF_REQUIRES__ =======


version             = 4.5
tar_gz_archive      = $(SRC_PACKAGE_PATH)/packages/a/dcron/dcron-$(version).tar.gz
SRC_ARCHIVE         = $(tar_gz_archive)
SRC_DIR             = $(TARGET_BUILD_DIR)/dcron-$(version)
src_dir_name        = dcron-$(version)
src_done            = $(TARGET_BUILD_DIR)/.source_done

crontab_root        = $(CURDIR)/scripts/crontab-root
run_parts           = $(CURDIR)/scripts/run-parts
run_parts_man       = $(CURDIR)/man/run-parts.8

PATCHES = PATCHES

build_target        = $(TARGET_BUILD_DIR)/.build_done
install_target      = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
DCRON_PKG_NAME                = dcron
DCRON_PKG_VERSION             = 4.5
DCRON_PKG_ARCH                = $(TOOLCHAIN)
DCRON_PKG_DISTRO_NAME         = $(DISTRO_NAME)
DCRON_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
DCRON_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
DCRON_PKG_SHORT_DESCRIPTION   = Lightweight Cron daemon
DCRON_PKG_URL                 = $(BUG_URL)
DCRON_PKG_LICENSE             = GPLv2
DCRON_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(DCRON_PKG_NAME)-pkg-description
DCRON_PKG_DESCRIPTION_FILE_IN = $(DCRON_PKG_NAME)-pkg-description.in
DCRON_PKG_INSTALL_SCRIPT      = $(DCRON_PKG_NAME)-pkg-install.sh

DCRON_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(DCRON_PKG_NAME)-package

pkg_basename     = $(DCRON_PKG_NAME)-$(DCRON_PKG_VERSION)-$(DCRON_PKG_ARCH)-$(DCRON_PKG_DISTRO_NAME)-$(DCRON_PKG_DISTRO_VERSION)

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


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(DCRON_PKG)/usr/{bin,sbin}
	@( cd $(SRC_DIR) ; \
	   cat crond > $(DCRON_PKG)/usr/sbin/crond ; \
	   cat crontab > $(DCRON_PKG)/usr/bin/crontab ; \
	   chmod 0755 $(DCRON_PKG)/usr/sbin/crond ; \
	   chmod 4711 $(DCRON_PKG)/usr/bin/crontab ; \
	 )
	@cp -a $(run_parts) $(DCRON_PKG)/usr/bin/run-parts
	@chmod 0755 $(DCRON_PKG)/usr/bin/run-parts
	# ======= man pages =======
	@mkdir -p $(DCRON_PKG)/usr/share/man/man{1,8}
	@( cd $(SRC_DIR) ; \
	   cat crontab.1 | gzip -9c > $(DCRON_PKG)/usr/share/man/man1/crontab.1.gz ; \
	   cat crond.8 | gzip -9c > $(DCRON_PKG)/usr/share/man/man8/crond.8.gz ; \
	 )
	@cat $(run_parts_man) | gzip -9c > $(DCRON_PKG)/usr/share/man/man8/run-parts.8.gz
	# ======= create some other stuff =======
	@mkdir -p $(DCRON_PKG)/etc/cron.{hourly,daily,weekly,monthly}
	@mkdir -p $(DCRON_PKG)/var/spool/cron/crontabs
	@mkdir -p $(DCRON_PKG)/var/spool/cron/cronstamps
	@chmod 0751 $(DCRON_PKG)/var/spool/cron
	@chmod 0750 $(DCRON_PKG)/var/spool/cron/crontabs $(DCRON_PKG)/var/spool/cron/cronstamps
	@cat $(crontab_root) > $(DCRON_PKG)/var/spool/cron/crontabs/root.new
	@chmod 0600 $(DCRON_PKG)/var/spool/cron/crontabs/root.new
	# ======= dcron will whine about "unable to scan" this directory, so we'll create it =======
	@mkdir -p $(DCRON_PKG)/etc/cron.d
	# ======= documentation =======
	@mkdir -p $(DCRON_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a CHANGELOG* README extra \
	         $(DCRON_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(DCRON_PKG))
	# ======= Strip binaries =======
	@( cd $(DCRON_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null \
	 )
	@touch $@

$(DCRON_PKG_DESCRIPTION_FILE): $(DCRON_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(DCRON_PKG_DESCRIPTION_FILE) $(DCRON_PKG_INSTALL_SCRIPT)
	@cp $(DCRON_PKG_DESCRIPTION_FILE) $(DCRON_PKG)/.DESCRIPTION
	@cp $(DCRON_PKG_INSTALL_SCRIPT) $(DCRON_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(DCRON_PKG)/.REQUIRES
	@echo "pkgname=$(DCRON_PKG_NAME)"                            >  $(DCRON_PKG)/.PKGINFO ; \
	 echo "pkgver=$(DCRON_PKG_VERSION)"                          >> $(DCRON_PKG)/.PKGINFO ; \
	 echo "arch=$(DCRON_PKG_ARCH)"                               >> $(DCRON_PKG)/.PKGINFO ; \
	 echo "distroname=$(DCRON_PKG_DISTRO_NAME)"                  >> $(DCRON_PKG)/.PKGINFO ; \
	 echo "distrover=$(DCRON_PKG_DISTRO_VERSION)"                >> $(DCRON_PKG)/.PKGINFO ; \
	 echo "group=$(DCRON_PKG_GROUP)"                             >> $(DCRON_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(DCRON_PKG_SHORT_DESCRIPTION)\"" >> $(DCRON_PKG)/.PKGINFO ; \
	 echo "url=$(DCRON_PKG_URL)"                                 >> $(DCRON_PKG)/.PKGINFO ; \
	 echo "license=$(DCRON_PKG_LICENSE)"                         >> $(DCRON_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(DCRON_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
