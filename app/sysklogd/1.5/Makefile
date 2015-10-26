
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


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES     = sources/packages/a/sysklogd

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/4.9.2
else
REQUIRES           = libs/glibc/2.21
endif

# ======= __END_OF_REQUIRES__ =======


version             = 1.5
tar_gz_archive      = $(SRC_PACKAGE_PATH)/packages/a/sysklogd/sysklogd-$(version).tar.gz
SRC_ARCHIVE         = $(tar_gz_archive)
SRC_DIR             = $(TARGET_BUILD_DIR)/sysklogd-$(version)
src_dir_name        = sysklogd-$(version)
src_done            = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target        = $(TARGET_BUILD_DIR)/.build_done
install_target      = $(TARGET_BUILD_DIR)/.install_done

scripts_dir         = $(CURDIR)/scripts


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
SYSKLOGD_PKG_NAME                = sysklogd
SYSKLOGD_PKG_VERSION             = 1.5
SYSKLOGD_PKG_ARCH                = $(TOOLCHAIN)
SYSKLOGD_PKG_DISTRO_NAME         = $(DISTRO_NAME)
SYSKLOGD_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
SYSKLOGD_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
SYSKLOGD_PKG_SHORT_DESCRIPTION   = Linux system logging utilities
SYSKLOGD_PKG_URL                 = $(BUG_URL)
SYSKLOGD_PKG_LICENSE             = GPLv2
SYSKLOGD_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(SYSKLOGD_PKG_NAME)-pkg-description
SYSKLOGD_PKG_DESCRIPTION_FILE_IN = $(SYSKLOGD_PKG_NAME)-pkg-description.in
SYSKLOGD_PKG_INSTALL_SCRIPT      = $(SYSKLOGD_PKG_NAME)-pkg-install.sh

SYSKLOGD_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(SYSKLOGD_PKG_NAME)-package

pkg_basename     = $(SYSKLOGD_PKG_NAME)-$(SYSKLOGD_PKG_VERSION)-$(SYSKLOGD_PKG_ARCH)-$(SYSKLOGD_PKG_DISTRO_NAME)-$(SYSKLOGD_PKG_DISTRO_VERSION)

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
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) all
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(SYSKLOGD_PKG)/usr/sbin
	@( cd $(SRC_DIR) ; \
	   cat klogd > $(SYSKLOGD_PKG)/usr/sbin/klogd ; \
	   cat syslogd > $(SYSKLOGD_PKG)/usr/sbin/syslogd ; \
	   chmod 0755 $(SYSKLOGD_PKG)/usr/sbin/* \
	 )
	# ======= man pages =======
	@mkdir -p $(SYSKLOGD_PKG)/usr/share/man/man{5,8}
	@( cd $(SRC_DIR) ; \
	   cat syslog.conf.5 | gzip -9c > $(SYSKLOGD_PKG)/usr/share/man/man5/syslog.conf.5.gz ; \
	   cat klogd.8 | gzip -9c > $(SYSKLOGD_PKG)/usr/share/man/man8/klogd.8.gz ; \
	   cat sysklogd.8 | gzip -9c > $(SYSKLOGD_PKG)/usr/share/man/man8/sysklogd.8.gz ; \
	 )
	@( cd $(SYSKLOGD_PKG)/usr/share/man/man8 ; ln -s sysklogd.8.gz syslogd.8.gz )
	# ======= start/stop daemon; config scripts =======
	@mkdir -p $(SYSKLOGD_PKG)/etc
	@cat $(scripts_dir)/syslog.conf.new > $(SYSKLOGD_PKG)/etc/syslog.conf.new
	@mkdir -p $(SYSKLOGD_PKG)/etc/logrotate.d
	@cat $(scripts_dir)/syslog.logrotate > $(SYSKLOGD_PKG)/etc/logrotate.d/syslog.new
	@mkdir -p $(SYSKLOGD_PKG)/etc/rc.d
	@cat $(scripts_dir)/rc.syslog.new > $(SYSKLOGD_PKG)/etc/rc.d/rc.syslog.new
	@chmod 0755 $(SYSKLOGD_PKG)/etc/rc.d/rc.syslog.new
	# ======= system log files =======
	@mkdir -p $(SYSKLOGD_PKG)/var/log
	@for i in cron debug maillog messages secure spooler syslog ; do \
	   touch $(SYSKLOGD_PKG)/var/log/$$i.new ; \
	   chmod 640 $(SYSKLOGD_PKG)/var/log/$$i.new ; \
	 done
	# ======= Install Documentation =======
	@mkdir -p $(SYSKLOGD_PKG)/usr/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING \
	         $(SYSKLOGD_PKG)/usr/doc/$(src_dir_name) \
	 )
	@mkdir -p $(SYSKLOGD_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a ANNOUNCE CHANGES COPYING INSTALL MANIFEST NEWS README.1st README.linux syslog.conf \
	         $(SYSKLOGD_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(SYSKLOGD_PKG))
	# ======= Strip binaries =======
	@( cd $(SYSKLOGD_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null \
	 )
	@touch $@

$(SYSKLOGD_PKG_DESCRIPTION_FILE): $(SYSKLOGD_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(SYSKLOGD_PKG_DESCRIPTION_FILE) $(SYSKLOGD_PKG_INSTALL_SCRIPT)
	@cp $(SYSKLOGD_PKG_DESCRIPTION_FILE) $(SYSKLOGD_PKG)/.DESCRIPTION
	@cp $(SYSKLOGD_PKG_INSTALL_SCRIPT) $(SYSKLOGD_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(SYSKLOGD_PKG)/.REQUIRES
	@echo "pkgname=$(SYSKLOGD_PKG_NAME)"                            >  $(SYSKLOGD_PKG)/.PKGINFO ; \
	 echo "pkgver=$(SYSKLOGD_PKG_VERSION)"                          >> $(SYSKLOGD_PKG)/.PKGINFO ; \
	 echo "arch=$(SYSKLOGD_PKG_ARCH)"                               >> $(SYSKLOGD_PKG)/.PKGINFO ; \
	 echo "distroname=$(SYSKLOGD_PKG_DISTRO_NAME)"                  >> $(SYSKLOGD_PKG)/.PKGINFO ; \
	 echo "distrover=$(SYSKLOGD_PKG_DISTRO_VERSION)"                >> $(SYSKLOGD_PKG)/.PKGINFO ; \
	 echo "group=$(SYSKLOGD_PKG_GROUP)"                             >> $(SYSKLOGD_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(SYSKLOGD_PKG_SHORT_DESCRIPTION)\"" >> $(SYSKLOGD_PKG)/.PKGINFO ; \
	 echo "url=$(SYSKLOGD_PKG_URL)"                                 >> $(SYSKLOGD_PKG)/.PKGINFO ; \
	 echo "license=$(SYSKLOGD_PKG_LICENSE)"                         >> $(SYSKLOGD_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(SYSKLOGD_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
