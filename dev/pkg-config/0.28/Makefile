
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
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


SOURCE_REQUIRES    = sources/packages/d/pkg-config

REQUIRES           = libs/glib2/2.48.0

# ======= __END_OF_REQUIRES__ =======


version            = 0.28
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/d/pkg-config/pkg-config-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/pkg-config-$(version)
src_dir_name       = pkg-config-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

profile_dir        = $(CURDIR)/profile.d

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = dev

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
PCONFIG_PKG_NAME                = pkg-config
PCONFIG_PKG_VERSION             = 0.28
PCONFIG_PKG_ARCH                = $(TOOLCHAIN)
PCONFIG_PKG_DISTRO_NAME         = $(DISTRO_NAME)
PCONFIG_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
PCONFIG_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
PCONFIG_PKG_SHORT_DESCRIPTION   = managing library compile/link flags utility
PCONFIG_PKG_URL                 = $(BUG_URL)
PCONFIG_PKG_LICENSE             = GPLv2
PCONFIG_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(PCONFIG_PKG_NAME)-pkg-description
PCONFIG_PKG_DESCRIPTION_FILE_IN = $(PCONFIG_PKG_NAME)-pkg-description.in
PCONFIG_PKG_INSTALL_SCRIPT      = $(PCONFIG_PKG_NAME)-pkg-install.sh

PCONFIG_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(PCONFIG_PKG_NAME)-package

pkg_basename     = $(PCONFIG_PKG_NAME)-$(PCONFIG_PKG_VERSION)-$(PCONFIG_PKG_ARCH)-$(PCONFIG_PKG_DISTRO_NAME)-$(PCONFIG_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(PCONFIG_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

# disable the creation of an undesired hard link to the pkg-config program:
extra_configure_switches += --disable-host-tool


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(PCONFIG_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Add Profile scripts =======
	@mkdir -p $(PCONFIG_PKG)/etc/profile.d
	@cat $(profile_dir)/pkgconfig.csh.in | sed "s,@LIBDIRSUFFIX@,$(LIBSUFFIX),g" > $(PCONFIG_PKG)/etc/profile.d/pkgconfig.csh
	@cat $(profile_dir)/pkgconfig.sh.in  | sed "s,@LIBDIRSUFFIX@,$(LIBSUFFIX),g" > $(PCONFIG_PKG)/etc/profile.d/pkgconfig.sh
	@chmod 0755 $(PCONFIG_PKG)/etc/profile.d/*
	# ======= Install Documentation =======
	@if [ -d $(PCONFIG_PKG)/usr/share/man ]; then \
	  ( cd $(PCONFIG_PKG)/usr/share/man ; \
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
	@mkdir -p $(PCONFIG_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(PCONFIG_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(PCONFIG_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING INSTALL NEWS README \
	         $(PCONFIG_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(PCONFIG_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(PCONFIG_PKG))
	# ======= Strip binaries =======
	@( cd $(PCONFIG_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(XORG_PKG)/usr/bin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(PCONFIG_PKG_DESCRIPTION_FILE): $(PCONFIG_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(PCONFIG_PKG_DESCRIPTION_FILE) $(PCONFIG_PKG_INSTALL_SCRIPT)
	@cp $(PCONFIG_PKG_DESCRIPTION_FILE) $(PCONFIG_PKG)/.DESCRIPTION
	@cp $(PCONFIG_PKG_INSTALL_SCRIPT) $(PCONFIG_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(PCONFIG_PKG)/.REQUIRES
	@echo "pkgname=$(PCONFIG_PKG_NAME)"                            >  $(PCONFIG_PKG)/.PKGINFO ; \
	 echo "pkgver=$(PCONFIG_PKG_VERSION)"                          >> $(PCONFIG_PKG)/.PKGINFO ; \
	 echo "arch=$(PCONFIG_PKG_ARCH)"                               >> $(PCONFIG_PKG)/.PKGINFO ; \
	 echo "distroname=$(PCONFIG_PKG_DISTRO_NAME)"                  >> $(PCONFIG_PKG)/.PKGINFO ; \
	 echo "distrover=$(PCONFIG_PKG_DISTRO_VERSION)"                >> $(PCONFIG_PKG)/.PKGINFO ; \
	 echo "group=$(PCONFIG_PKG_GROUP)"                             >> $(PCONFIG_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(PCONFIG_PKG_SHORT_DESCRIPTION)\"" >> $(PCONFIG_PKG)/.PKGINFO ; \
	 echo "url=$(PCONFIG_PKG_URL)"                                 >> $(PCONFIG_PKG)/.PKGINFO ; \
	 echo "license=$(PCONFIG_PKG_LICENSE)"                         >> $(PCONFIG_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(PCONFIG_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
