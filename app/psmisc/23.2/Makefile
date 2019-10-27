
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


SOURCE_REQUIRES    = sources/packages/a/psmisc

REQUIRES           = libs/ncurses/6.1

# ======= __END_OF_REQUIRES__ =======


version            = 23.2
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/a/psmisc/psmisc-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/psmisc-$(version)
src_dir_name       = psmisc-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
PSMISC_PKG_NAME                = psmisc
PSMISC_PKG_VERSION             = 23.2
PSMISC_PKG_ARCH                = $(TOOLCHAIN)
PSMISC_PKG_DISTRO_NAME         = $(DISTRO_NAME)
PSMISC_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
PSMISC_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
PSMISC_PKG_SHORT_DESCRIPTION   = small utilities that use proc file-system
PSMISC_PKG_URL                 = $(BUG_URL)
PSMISC_PKG_LICENSE             = GPLv2
PSMISC_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(PSMISC_PKG_NAME)-pkg-description
PSMISC_PKG_DESCRIPTION_FILE_IN = $(PSMISC_PKG_NAME)-pkg-description.in
PSMISC_PKG_INSTALL_SCRIPT      = $(PSMISC_PKG_NAME)-pkg-install.sh

PSMISC_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(PSMISC_PKG_NAME)-package

pkg_basename     = $(PSMISC_PKG_NAME)-$(PSMISC_PKG_VERSION)-$(PSMISC_PKG_ARCH)-$(PSMISC_PKG_DISTRO_NAME)-$(PSMISC_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(PSMISC_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var

extra_configure_switches += --disable-silent-rules
extra_configure_switches += --disable-rpath


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
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
	@mkdir -p $(PSMISC_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Move "killall" to the traditional location: =======
	@mkdir -p $(PSMISC_PKG)/bin
	@mv $(PSMISC_PKG)/usr/bin/killall $(PSMISC_PKG)/bin
	@( cd $(PSMISC_PKG)/usr/bin ; \
	   ln -sf ../../bin/killall . ; \
	 )
	# ======= Install Documentation =======
	@if [ -d $(PSMISC_PKG)/usr/share/man ]; then \
	  ( cd $(PSMISC_PKG)/usr/share/man ; \
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
	@mkdir -p $(PSMISC_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(PSMISC_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(PSMISC_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING NEWS README* \
	         $(PSMISC_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(PSMISC_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(PSMISC_PKG))
	# ======= Strip Binaries =======
	@( cd $(PSMISC_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(PSMISC_PKG_DESCRIPTION_FILE): $(PSMISC_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(PSMISC_PKG_DESCRIPTION_FILE) $(PSMISC_PKG_INSTALL_SCRIPT)
	@cp $(PSMISC_PKG_DESCRIPTION_FILE) $(PSMISC_PKG)/.DESCRIPTION
	@cp $(PSMISC_PKG_INSTALL_SCRIPT) $(PSMISC_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(PSMISC_PKG)/.REQUIRES
	@echo "pkgname=$(PSMISC_PKG_NAME)"                            >  $(PSMISC_PKG)/.PKGINFO ; \
	 echo "pkgver=$(PSMISC_PKG_VERSION)"                          >> $(PSMISC_PKG)/.PKGINFO ; \
	 echo "arch=$(PSMISC_PKG_ARCH)"                               >> $(PSMISC_PKG)/.PKGINFO ; \
	 echo "distroname=$(PSMISC_PKG_DISTRO_NAME)"                  >> $(PSMISC_PKG)/.PKGINFO ; \
	 echo "distrover=$(PSMISC_PKG_DISTRO_VERSION)"                >> $(PSMISC_PKG)/.PKGINFO ; \
	 echo "group=$(PSMISC_PKG_GROUP)"                             >> $(PSMISC_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(PSMISC_PKG_SHORT_DESCRIPTION)\"" >> $(PSMISC_PKG)/.PKGINFO ; \
	 echo "url=$(PSMISC_PKG_URL)"                                 >> $(PSMISC_PKG)/.PKGINFO ; \
	 echo "license=$(PSMISC_PKG_LICENSE)"                         >> $(PSMISC_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(PSMISC_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
