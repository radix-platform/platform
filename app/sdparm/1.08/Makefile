
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


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/sdparm

ifeq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC)),)
REQUIRES           = libs/sg3_utils/1.41
else
REQUIRES           = libs/sg3_utils/1.41-x86_32
endif

# ======= __END_OF_REQUIRES__ =======


version            = 1.08
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/a/sdparm/sdparm-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/sdparm-$(version)
src_dir_name       = sdparm-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
SDPARM_PKG_NAME                = sdparm
SDPARM_PKG_VERSION             = 1.08
SDPARM_PKG_ARCH                = $(TOOLCHAIN)
SDPARM_PKG_DISTRO_NAME         = $(DISTRO_NAME)
SDPARM_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
SDPARM_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
SDPARM_PKG_SHORT_DESCRIPTION   = fetch and change SCSI attributes
SDPARM_PKG_URL                 = $(BUG_URL)
SDPARM_PKG_LICENSE             = BSD
SDPARM_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(SDPARM_PKG_NAME)-pkg-description
SDPARM_PKG_DESCRIPTION_FILE_IN = $(SDPARM_PKG_NAME)-pkg-description.in
SDPARM_PKG_INSTALL_SCRIPT      = $(SDPARM_PKG_NAME)-pkg-install.sh

SDPARM_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(SDPARM_PKG_NAME)-package

pkg_basename     = $(SDPARM_PKG_NAME)-$(SDPARM_PKG_VERSION)-$(SDPARM_PKG_ARCH)-$(SDPARM_PKG_DISTRO_NAME)-$(SDPARM_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(SDPARM_PKG)

extra_configure_switches  = --libdir=/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --bindir=/usr/sbin
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --program-prefix=
extra_configure_switches += --program-suffix=


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) $(environment) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(environment) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(SDPARM_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(environment) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(SDPARM_PKG)/usr/share/man ]; then \
	  ( cd $(SDPARM_PKG)/usr/share/man ; \
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
	@mkdir -p $(SDPARM_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING $(SRC_DIR)/CREDITS \
	       $(SDPARM_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(SDPARM_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING CREDITS INSTALL NEWS README notes.txt \
	         $(SDPARM_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(SDPARM_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(SDPARM_PKG))
	# ======= Strip binaries =======
	@( cd $(SDPARM_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null \
	 )
	@touch $@

$(SDPARM_PKG_DESCRIPTION_FILE): $(SDPARM_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(SDPARM_PKG_DESCRIPTION_FILE) $(SDPARM_PKG_INSTALL_SCRIPT)
	@cp $(SDPARM_PKG_DESCRIPTION_FILE) $(SDPARM_PKG)/.DESCRIPTION
	@cp $(SDPARM_PKG_INSTALL_SCRIPT) $(SDPARM_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(SDPARM_PKG)/.REQUIRES
	@echo "pkgname=$(SDPARM_PKG_NAME)"                            >  $(SDPARM_PKG)/.PKGINFO ; \
	 echo "pkgver=$(SDPARM_PKG_VERSION)"                          >> $(SDPARM_PKG)/.PKGINFO ; \
	 echo "arch=$(SDPARM_PKG_ARCH)"                               >> $(SDPARM_PKG)/.PKGINFO ; \
	 echo "distroname=$(SDPARM_PKG_DISTRO_NAME)"                  >> $(SDPARM_PKG)/.PKGINFO ; \
	 echo "distrover=$(SDPARM_PKG_DISTRO_VERSION)"                >> $(SDPARM_PKG)/.PKGINFO ; \
	 echo "group=$(SDPARM_PKG_GROUP)"                             >> $(SDPARM_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(SDPARM_PKG_SHORT_DESCRIPTION)\"" >> $(SDPARM_PKG)/.PKGINFO ; \
	 echo "url=$(SDPARM_PKG_URL)"                                 >> $(SDPARM_PKG)/.PKGINFO ; \
	 echo "license=$(SDPARM_PKG_LICENSE)"                         >> $(SDPARM_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(SDPARM_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
