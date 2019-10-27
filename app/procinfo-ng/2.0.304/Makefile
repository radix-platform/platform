
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


SOURCE_REQUIRES    = sources/packages/a/procinfo-ng
SOURCE_REQUIRES   += sources/packages/a/procinfo

REQUIRES           = libs/ncurses/6.1

# ======= __END_OF_REQUIRES__ =======


version            = 2.0.304
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/a/procinfo-ng/procinfo-ng-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/procinfo-ng-$(version)
src_dir_name       = procinfo-ng-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

procinfo_version   = 18
procinfo_archive   = $(SRC_PACKAGE_PATH)/packages/a/procinfo/procinfo-$(procinfo_version).tar.gz
PROCINFO_SRC_DIR   = $(TARGET_BUILD_DIR)/procinfo-$(procinfo_version)
procinfo_src_done  = $(TARGET_BUILD_DIR)/.procinfo-source-done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
PROCINFO_PKG_NAME                = procinfo-ng
PROCINFO_PKG_VERSION             = 2.0.304
PROCINFO_PKG_ARCH                = $(TOOLCHAIN)
PROCINFO_PKG_DISTRO_NAME         = $(DISTRO_NAME)
PROCINFO_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
PROCINFO_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
PROCINFO_PKG_SHORT_DESCRIPTION   = utilities for displaying process information
PROCINFO_PKG_URL                 = $(BUG_URL)
PROCINFO_PKG_LICENSE             = GPLv2
PROCINFO_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(PROCINFO_PKG_NAME)-pkg-description
PROCINFO_PKG_DESCRIPTION_FILE_IN = $(PROCINFO_PKG_NAME)-pkg-description.in
PROCINFO_PKG_INSTALL_SCRIPT      = $(PROCINFO_PKG_NAME)-pkg-install.sh

PROCINFO_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(PROCINFO_PKG_NAME)-package

pkg_basename     = $(PROCINFO_PKG_NAME)-$(PROCINFO_PKG_VERSION)-$(PROCINFO_PKG_ARCH)-$(PROCINFO_PKG_DISTRO_NAME)-$(PROCINFO_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(PROCINFO_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --enable-maintainer-mode

CFLAGS += -Wno-deprecated-declarations -Wno-narrowing


####### Dependencies

$(procinfo_src_done): $(procinfo_archive)
	@echo "Expanding $(procinfo_archive)"
	@tar xzf $(procinfo_archive) -C $(TARGET_BUILD_DIR)
	@touch $@

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP) $(procinfo_src_done)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && \
	  $(BUILD_ENVIRONMENT) ./configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(PROCINFO_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install a couple of scripts from the original procinfo package: =======
	@mkdir -p $(PROCINFO_PKG)/usr/bin
	@mkdir -p $(PROCINFO_PKG)/usr/share/man/man8
	@install -m 0755 $(PROCINFO_SRC_DIR)/lsdev.pl     $(PROCINFO_PKG)/usr/bin/lsdev
	@install -m 0755 $(PROCINFO_SRC_DIR)/socklist.pl  $(PROCINFO_PKG)/usr/bin/socklist
	@install -m 0644 $(PROCINFO_SRC_DIR)/lsdev.8 $(PROCINFO_SRC_DIR)/socklist.8 $(PROCINFO_PKG)/usr/share/man/man8
	# ======= Install Documentation =======
	@if [ -d $(PROCINFO_PKG)/usr/share/man ]; then \
	  ( cd $(PROCINFO_PKG)/usr/share/man ; \
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
	@mkdir -p $(PROCINFO_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/{GPL,LGPL,LICENSE}* \
	       $(PROCINFO_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(PROCINFO_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a GPL* LGPL* LICENSE* \
	         $(PROCINFO_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(PROCINFO_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(PROCINFO_PKG))
	# ======= Strip Binaries =======
	@( cd $(PROCINFO_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(PROCINFO_PKG_DESCRIPTION_FILE): $(PROCINFO_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(PROCINFO_PKG_DESCRIPTION_FILE) $(PROCINFO_PKG_INSTALL_SCRIPT)
	@cp $(PROCINFO_PKG_DESCRIPTION_FILE) $(PROCINFO_PKG)/.DESCRIPTION
	@cp $(PROCINFO_PKG_INSTALL_SCRIPT) $(PROCINFO_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(PROCINFO_PKG)/.REQUIRES
	@echo "pkgname=$(PROCINFO_PKG_NAME)"                            >  $(PROCINFO_PKG)/.PKGINFO ; \
	 echo "pkgver=$(PROCINFO_PKG_VERSION)"                          >> $(PROCINFO_PKG)/.PKGINFO ; \
	 echo "arch=$(PROCINFO_PKG_ARCH)"                               >> $(PROCINFO_PKG)/.PKGINFO ; \
	 echo "distroname=$(PROCINFO_PKG_DISTRO_NAME)"                  >> $(PROCINFO_PKG)/.PKGINFO ; \
	 echo "distrover=$(PROCINFO_PKG_DISTRO_VERSION)"                >> $(PROCINFO_PKG)/.PKGINFO ; \
	 echo "group=$(PROCINFO_PKG_GROUP)"                             >> $(PROCINFO_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(PROCINFO_PKG_SHORT_DESCRIPTION)\"" >> $(PROCINFO_PKG)/.PKGINFO ; \
	 echo "url=$(PROCINFO_PKG_URL)"                                 >> $(PROCINFO_PKG)/.PKGINFO ; \
	 echo "license=$(PROCINFO_PKG_LICENSE)"                         >> $(PROCINFO_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(PROCINFO_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
