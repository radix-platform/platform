
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


SOURCE_REQUIRES    = sources/GNU/m4

REQUIRES           = libs/glibc/2.27

# ======= __END_OF_REQUIRES__ =======


version            = 1.4.17
tar_xz_archive     = $(SRC_PACKAGE_PATH)/GNU/m4/m4-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/m4-$(version)
src_dir_name       = m4-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = dev

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
M4_PKG_NAME                = m4
M4_PKG_VERSION             = 1.4.17
M4_PKG_ARCH                = $(TOOLCHAIN)
M4_PKG_DISTRO_NAME         = $(DISTRO_NAME)
M4_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
M4_PKG_GROUP               = $(PKG_GROUP)
###                         |---handy-ruler-------------------------------|
M4_PKG_SHORT_DESCRIPTION   = UNIX macro processor
M4_PKG_URL                 = $(BUG_URL)
M4_PKG_LICENSE             = GPLv3
M4_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(M4_PKG_NAME)-pkg-description
M4_PKG_DESCRIPTION_FILE_IN = $(M4_PKG_NAME)-pkg-description.in
M4_PKG_INSTALL_SCRIPT      = $(M4_PKG_NAME)-pkg-install.sh

M4_PKG           = $(CURDIR)/$(TARGET_BUILD_DIR)/$(M4_PKG_NAME)-package

pkg_basename     = $(M4_PKG_NAME)-$(M4_PKG_VERSION)-$(M4_PKG_ARCH)-$(M4_PKG_DISTRO_NAME)-$(M4_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(M4_PKG)


extra_configure_switches  = --libdir=/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man


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
	@mkdir -p $(M4_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@rm -f $(M4_PKG)/usr/share/info/dir
	@gzip -9 $(M4_PKG)/usr/share/info/*
	@if [ -d $(M4_PKG)/usr/share/man ]; then \
	  ( cd $(M4_PKG)/usr/share/man ; \
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
	@mkdir -p $(M4_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(M4_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(M4_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS BACKLOG COPYING INSTALL NEWS README THANKS TODO \
	         $(M4_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(M4_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(M4_PKG))
	# ======= Strip binaries =======
	@( cd $(M4_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null \
	 )
	@touch $@

$(M4_PKG_DESCRIPTION_FILE): $(M4_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(M4_PKG_DESCRIPTION_FILE) $(M4_PKG_INSTALL_SCRIPT)
	@cp $(M4_PKG_DESCRIPTION_FILE) $(M4_PKG)/.DESCRIPTION
	@cp $(M4_PKG_INSTALL_SCRIPT) $(M4_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(M4_PKG)/.REQUIRES
	@echo "pkgname=$(M4_PKG_NAME)"                            >  $(M4_PKG)/.PKGINFO ; \
	 echo "pkgver=$(M4_PKG_VERSION)"                          >> $(M4_PKG)/.PKGINFO ; \
	 echo "arch=$(M4_PKG_ARCH)"                               >> $(M4_PKG)/.PKGINFO ; \
	 echo "distroname=$(M4_PKG_DISTRO_NAME)"                  >> $(M4_PKG)/.PKGINFO ; \
	 echo "distrover=$(M4_PKG_DISTRO_VERSION)"                >> $(M4_PKG)/.PKGINFO ; \
	 echo "group=$(M4_PKG_GROUP)"                             >> $(M4_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(M4_PKG_SHORT_DESCRIPTION)\"" >> $(M4_PKG)/.PKGINFO ; \
	 echo "url=$(M4_PKG_URL)"                                 >> $(M4_PKG)/.PKGINFO ; \
	 echo "license=$(M4_PKG_LICENSE)"                         >> $(M4_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(M4_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
