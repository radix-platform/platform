
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
COMPONENT_TARGETS += $(HARDWARE_OKMX6DL_C)
COMPONENT_TARGETS += $(HARDWARE_OKMX6Q_C)
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


SOURCE_REQUIRES    = sources/packages/a/logrotate

REQUIRES           = libs/popt/1.16
REQUIRES          += app/dcron/4.5

# ======= __END_OF_REQUIRES__ =======


version            = 3.15.1
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/a/logrotate/logrotate-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/logrotate-$(version)
src_dir_name       = logrotate-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

logrotate_conf     = $(CURDIR)/conf/logrotate.conf
logrotate_cron     = $(CURDIR)/scripts/logrotate-cron

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LOGROTATE_PKG_NAME                = logrotate
LOGROTATE_PKG_VERSION             = 3.15.1
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
pkg_certificate  = $(call cert-name,$(pkg_archive))
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(LOGROTATE_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@( cd $(SRC_DIR) ; ./autogen.sh )
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) $(environment) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(environment) $(MAKE) RPM_OPT_FLAGS="$(CFLAGS)"
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LOGROTATE_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(environment) $(MAKE) -j1 install $(env_sysroot)
	# ======= create logrotate.d and install config file =======
	@mkdir -p $(LOGROTATE_PKG)/etc/logrotate.d
	@cat $(logrotate_conf) > $(LOGROTATE_PKG)/etc/logrotate.conf.new
	# ======= make logrotate run from cron every day =======
	@mkdir -p $(LOGROTATE_PKG)/etc/cron.daily
	@cat $(logrotate_cron) > $(LOGROTATE_PKG)/etc/cron.daily/logrotate
	@chmod 0755 $(LOGROTATE_PKG)/etc/cron.daily/logrotate
	@if [ -d $(LOGROTATE_PKG)/usr/share/man ]; then \
	  ( cd $(LOGROTATE_PKG)/usr/share/man ; \
	    for manpagedir in `find . -type d -name "man*"` ; do \
	      ( cd $$manpagedir ; \
	        for eachpage in `find . -type l -maxdepth 1` ; do \
	          ln -s `readlink $$eachpage`.gz $$eachpage.gz ; \
	          rm $$eachpage ; \
	        done ; \
	        gzip -9 *.?  ; \
	      ) \
	    done \
	  ) \
	 fi
	# ======= Install Documentation =======
	@mkdir -p $(LOGROTATE_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING $(LOGROTATE_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(LOGROTATE_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING INSTALL README* examples \
	         $(LOGROTATE_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog.md ]; then \
	     DOCSDIR=`echo $(LOGROTATE_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog.md | head -n 1000 > $$DOCSDIR/ChangeLog.md ; \
	     touch -r ChangeLog.md $$DOCSDIR/ChangeLog.md ; \
	   fi \
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

$(pkg_certificate) : $(pkg_archive) ;
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
	@$(PSEUDO) sh -c "cd $(LOGROTATE_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
