
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


NEED_ABS_PATH     = true
COMPONENT_IS_3PP  = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES   = sources/packages/a/procps
SOURCE_REQUIRES  += sources/packages/a/procinfo
SOURCE_REQUIRES  += sources/packages/a/psmisc

REQUIRES          = libs/libtermcap/1.2.3

# ======= __END_OF_REQUIRES__ =======


version           = 3.2.8
tar_gz_archive    = $(SRC_PACKAGE_PATH)/packages/a/procps/procps-$(version).tar.gz
SRC_ARCHIVE       = $(tar_gz_archive)
SRC_DIR           = $(TARGET_BUILD_DIR)/procps-$(version)
src_dir_name      = procps-$(version)
src_done          = $(TARGET_BUILD_DIR)/.source-done

procinfo_version  = 18
procinfo_archive  = $(SRC_PACKAGE_PATH)/packages/a/procinfo/procinfo-$(procinfo_version).tar.gz
PROCINFO_SRC_DIR  = $(TARGET_BUILD_DIR)/procinfo-$(procinfo_version)
procinfo_src_done = $(TARGET_BUILD_DIR)/.procinfo-source-done

psmisc_version    = 22.21
psmisc_archive    = $(SRC_PACKAGE_PATH)/packages/a/psmisc/psmisc-$(psmisc_version).tar.gz
PSMISC_SRC_DIR    = $(TARGET_BUILD_DIR)/psmisc-$(psmisc_version)
psmisc_src_done   = $(TARGET_BUILD_DIR)/.psmisc-source-done

ifneq ($(filter $(HARDWARE),$(HARDWARE_PC64)),)
PATCHES = PATCHES.x86_64
else
PATCHES = PATCHES
endif

build_target      = $(TARGET_BUILD_DIR)/.build_done
install_target    = $(TARGET_BUILD_DIR)/.install_done

cache_file_in     = $(CURDIR)/fix-malloc.cache
cache_file        = $(CURDIR)/$(SRC_DIR)/fix-malloc.cache


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
PROCPS_PKG_NAME                = procps
PROCPS_PKG_VERSION             = 3.2.8
PROCPS_PKG_ARCH                = $(TOOLCHAIN)
PROCPS_PKG_DISTRO_NAME         = $(DISTRO_NAME)
PROCPS_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
PROCPS_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
PROCPS_PKG_SHORT_DESCRIPTION   = process information utilities
PROCPS_PKG_URL                 = $(BUG_URL)
PROCPS_PKG_LICENSE             = GPLv2
PROCPS_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(PROCPS_PKG_NAME)-pkg-description
PROCPS_PKG_DESCRIPTION_FILE_IN = $(PROCPS_PKG_NAME)-pkg-description.in
PROCPS_PKG_INSTALL_SCRIPT      = $(PROCPS_PKG_NAME)-pkg-install.sh

PROCPS_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(PROCPS_PKG_NAME)-package

pkg_basename     = $(PROCPS_PKG_NAME)-$(PROCPS_PKG_VERSION)-$(PROCPS_PKG_ARCH)-$(PROCPS_PKG_DISTRO_NAME)-$(PROCPS_PKG_DISTRO_VERSION)

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

$(procinfo_src_done): $(procinfo_archive)
	@echo "Expanding $(procinfo_archive)"
	@tar xzf $(procinfo_archive) -C $(TARGET_BUILD_DIR)
	@touch $@

$(psmisc_src_done): $(psmisc_archive)
	@echo "Expanding $(psmisc_archive)"
	@tar xzf $(psmisc_archive) -C $(TARGET_BUILD_DIR)
	@touch $@

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP) $(procinfo_src_done) $(psmisc_src_done)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@cp -a $(cache_file_in) $(cache_file)
	@cd $(PSMISC_SRC_DIR) && \
	    $(BUILD_ENVIRONMENT) ./configure \
	      --prefix=/usr \
	      --libdir=/usr/lib$(LIBSUFFIX) \
	      --disable-rpath \
	      --cache-file=$(cache_file) \
	      --build=$(BUILD) \
	      --host=$(TARGET)
	@cd $(PSMISC_SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@cd $(PROCINFO_SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(PROCPS_PKG)/lib$(LIBSUFFIX) \
	          $(PROCPS_PKG)/bin \
	          $(PROCPS_PKG)/sbin \
	          $(PROCPS_PKG)/usr/bin \
	          $(PROCPS_PKG)/usr/include/proc
	# ======= Install procps-$(version) =======
	@( cd $(SRC_DIR) ; \
	   cat free    > $(PROCPS_PKG)/bin/free ; \
	   cat ps/ps   > $(PROCPS_PKG)/bin/ps ; \
	   cat proc/libproc-$(version).so > $(PROCPS_PKG)/lib$(LIBSUFFIX)/libproc-$(version).so ; \
	   cat pkill   > $(PROCPS_PKG)/usr/bin/pkill ; \
	   cat skill   > $(PROCPS_PKG)/usr/bin/skill ; \
	   cat pmap    > $(PROCPS_PKG)/usr/bin/pmap ; \
	   cat slabtop > $(PROCPS_PKG)/usr/bin/slabtop ; \
	   cat sysctl  > $(PROCPS_PKG)/sbin/sysctl ; \
	   cat tload   > $(PROCPS_PKG)/usr/bin/tload ; \
	   cat top     > $(PROCPS_PKG)/usr/bin/top ; \
	   cat uptime  > $(PROCPS_PKG)/usr/bin/uptime ; \
	   cat vmstat  > $(PROCPS_PKG)/usr/bin/vmstat ; \
	   cat w       > $(PROCPS_PKG)/usr/bin/w ; \
	   cat watch   > $(PROCPS_PKG)/usr/bin/watch ; \
	   chmod a+x $(PROCPS_PKG)/bin/* ; \
	   chmod a+x $(PROCPS_PKG)/usr/bin/* ; \
	   chmod a+x $(PROCPS_PKG)/sbin/* ; \
	   chmod a+x $(PROCPS_PKG)/lib$(LIBSUFFIX)/libproc-$(version).so ; \
	   cp -a proc/*.h $(PROCPS_PKG)/usr/include/proc ; \
	   chmod 644 $(PROCPS_PKG)/usr/include/proc/* ; \
	 )
	@( cd $(PROCPS_PKG)/usr/bin ; \
	   ln -sf pkill pgrep ; \
	   ln -sf skill snice ; \
	   ln -sf ../../bin/free . ; \
	   ln -sf ../../bin/ps . ; \
	 )
	@( cd $(SRC_DIR) ; \
	   cp -a ps/ps.1 . ; \
	   mkdir -p $(PROCPS_PKG)/usr/share/man/man1 ; \
	   for page in free.1 pgrep.1 ps.1 slabtop.1 skill.1 tload.1 top.1 uptime.1 w.1 watch.1 ; do \
	     cat $$page | gzip -9c > $(PROCPS_PKG)/usr/share/man/man1/$$page.gz ; \
	   done ; \
	   ( cd $(PROCPS_PKG)/usr/share/man/man1 ; ln -sf pgrep.1.gz pkill.1.gz ) ; \
	   ( cd $(PROCPS_PKG)/usr/share/man/man1 ; ln -sf skill.1.gz snice.1.gz ) ; \
	   mkdir -p $(PROCPS_PKG)/usr/share/man/man5 ; \
	   cat sysctl.conf.5 | gzip -9c > $(PROCPS_PKG)/usr/share/man/man5/sysctl.conf.5.gz ; \
	   mkdir -p $(PROCPS_PKG)/usr/share/man/man8 ; \
	   for page in vmstat.8 sysctl.8 ; do \
	     cat $$page | gzip -9c > $(PROCPS_PKG)/usr/share/man/man8/$$page.gz ; \
	   done \
	 )
	@mkdir -p $(PROCPS_PKG)/usr/doc/procps-$(version)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING* $(PROCPS_PKG)/usr/doc/procps-$(version) ; \
	   chmod 644 $(PROCPS_PKG)/usr/doc/procps-$(version)/* \
	 )
	@mkdir -p $(PROCPS_PKG)/usr/share/doc/procps-$(version)
	@( cd $(SRC_DIR) ; \
	   cp -a BUGS COPYING* NEWS TODO $(PROCPS_PKG)/usr/share/doc/procps-$(version) ; \
	   chmod 644 $(PROCPS_PKG)/usr/share/doc/procps-$(version)/* \
	 )
	# ======= Install psmisc-$(psmisc_version) =======
	@mkdir -p $(PROCPS_PKG)/bin $(PROCPS_PKG)/usr/bin
	@( cd $(PSMISC_SRC_DIR)/src ; \
	   cat fuser   > $(PROCPS_PKG)/usr/bin/fuser  ; \
	   cat pstree  > $(PROCPS_PKG)/usr/bin/pstree ; \
	   cat killall > $(PROCPS_PKG)/bin/killall    ; \
	   chmod 0755 $(PROCPS_PKG)/usr/bin/fuser  ; \
	   chmod 0755 $(PROCPS_PKG)/usr/bin/pstree ; \
	   chmod 0755 $(PROCPS_PKG)/bin/killall    ; \
	 )
	@( cd $(PSMISC_SRC_DIR)/doc ; \
	   mkdir -p $(PROCPS_PKG)/usr/share/man/man1 ; \
	   for page in fuser.1 killall.1 pstree.1 ; do \
	     cat $$page | gzip -9c > $(PROCPS_PKG)/usr/share/man/man1/$$page.gz ; \
	   done \
	 )
	@mkdir -p $(PROCPS_PKG)/usr/doc/psmisc-$(psmisc_version)
	@( cd $(PSMISC_SRC_DIR) ; \
	   cp -a COPYING $(PROCPS_PKG)/usr/doc/psmisc-$(psmisc_version) ; \
	   chmod 644 $(PROCPS_PKG)/usr/doc/psmisc-$(psmisc_version)/* \
	 )
	@mkdir -p $(PROCPS_PKG)/usr/share/doc/psmisc-$(psmisc_version)
	@( cd $(PSMISC_SRC_DIR) ; \
	   cp -a AUTHORS COPYING ChangeLog INSTALL NEWS README \
	         $(PROCPS_PKG)/usr/share/doc/psmisc-$(psmisc_version) ; \
	   chmod 644 $(PROCPS_PKG)/usr/share/doc/psmisc-$(psmisc_version)/* \
	 )
	# ======= Install procinfo-$(procinfo_version) =======
	@mkdir -p $(PROCPS_PKG)/usr/bin
	@( cd $(PROCINFO_SRC_DIR) ; \
	   cat procinfo    > $(PROCPS_PKG)/usr/bin/procinfo ; \
	   cat lsdev.pl    > $(PROCPS_PKG)/usr/bin/lsdev    ; \
	   cat socklist.pl > $(PROCPS_PKG)/usr/bin/socklist ; \
	   chmod 0755 $(PROCPS_PKG)/usr/bin/procinfo ; \
	   chmod 0755 $(PROCPS_PKG)/usr/bin/lsdev    ; \
	   chmod 0755 $(PROCPS_PKG)/usr/bin/socklist ; \
	 )
	@( cd $(PROCINFO_SRC_DIR) ; \
	   mkdir -p $(PROCPS_PKG)/usr/share/man/man8 ; \
	   for page in procinfo.8 lsdev.8 socklist.8 ; do \
	     cat $$page | gzip -9c > $(PROCPS_PKG)/usr/share/man/man8/$$page.gz ; \
	   done \
	 )
	@mkdir -p $(PROCPS_PKG)/usr/share/doc/procinfo-$(procinfo_version)
	@( cd $(PROCINFO_SRC_DIR) ; \
	   cp -a CHANGES README \
	         $(PROCPS_PKG)/usr/share/doc/procinfo-$(procinfo_version) ; \
	   chmod 644 $(PROCPS_PKG)/usr/share/doc/procinfo-$(procinfo_version)/* \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(PROCPS_PKG))
	# ======= Strip binaries =======
	@( cd $(PROCPS_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(PROCPS_PKG_DESCRIPTION_FILE): $(PROCPS_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(PROCPS_PKG_DESCRIPTION_FILE) $(PROCPS_PKG_INSTALL_SCRIPT)
	@cp $(PROCPS_PKG_DESCRIPTION_FILE) $(PROCPS_PKG)/.DESCRIPTION
	@cp $(PROCPS_PKG_INSTALL_SCRIPT) $(PROCPS_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(PROCPS_PKG)/.REQUIRES
	@echo "pkgname=$(PROCPS_PKG_NAME)"                            >  $(PROCPS_PKG)/.PKGINFO ; \
	 echo "pkgver=$(PROCPS_PKG_VERSION)"                          >> $(PROCPS_PKG)/.PKGINFO ; \
	 echo "arch=$(PROCPS_PKG_ARCH)"                               >> $(PROCPS_PKG)/.PKGINFO ; \
	 echo "distroname=$(PROCPS_PKG_DISTRO_NAME)"                  >> $(PROCPS_PKG)/.PKGINFO ; \
	 echo "distrover=$(PROCPS_PKG_DISTRO_VERSION)"                >> $(PROCPS_PKG)/.PKGINFO ; \
	 echo "group=$(PROCPS_PKG_GROUP)"                             >> $(PROCPS_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(PROCPS_PKG_SHORT_DESCRIPTION)\"" >> $(PROCPS_PKG)/.PKGINFO ; \
	 echo "url=$(PROCPS_PKG_URL)"                                 >> $(PROCPS_PKG)/.PKGINFO ; \
	 echo "license=$(PROCPS_PKG_LICENSE)"                         >> $(PROCPS_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(PROCPS_PKG)  && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
