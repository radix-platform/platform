
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


SOURCE_REQUIRES    = sources/packages/l/shared-mime-info

REQUIRES           = libs/glib2/2.48.0
REQUIRES          += app/gettext/0.19.7
REQUIRES          += libs/libxml2/2.9.3

# ======= __END_OF_REQUIRES__ =======


version            = 1.6
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/l/shared-mime-info/shared-mime-info-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/shared-mime-info-$(version)
src_dir_name       = shared-mime-info-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
MIME_INFO_PKG_NAME                = shared-mime-info
MIME_INFO_PKG_VERSION             = 1.6
MIME_INFO_PKG_ARCH                = $(TOOLCHAIN)
MIME_INFO_PKG_DISTRO_NAME         = $(DISTRO_NAME)
MIME_INFO_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
MIME_INFO_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
MIME_INFO_PKG_SHORT_DESCRIPTION   = MIME database
MIME_INFO_PKG_URL                 = $(BUG_URL)
MIME_INFO_PKG_LICENSE             = GPLv2
MIME_INFO_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(MIME_INFO_PKG_NAME)-pkg-description
MIME_INFO_PKG_DESCRIPTION_FILE_IN = $(MIME_INFO_PKG_NAME)-pkg-description.in
MIME_INFO_PKG_INSTALL_SCRIPT      = $(MIME_INFO_PKG_NAME)-pkg-install.sh

MIME_INFO_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(MIME_INFO_PKG_NAME)-package

pkg_basename     = $(MIME_INFO_PKG_NAME)-$(MIME_INFO_PKG_VERSION)-$(MIME_INFO_PKG_ARCH)-$(MIME_INFO_PKG_DISTRO_NAME)-$(MIME_INFO_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(MIME_INFO_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --disable-update-mimedb


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
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(MIME_INFO_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(MIME_INFO_PKG)/usr/share/man ]; then \
	  ( cd $(MIME_INFO_PKG)/usr/share/man ; \
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
	@mkdir -p $(MIME_INFO_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(MIME_INFO_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(MIME_INFO_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING HACKING NEWS README \
	         $(MIME_INFO_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(MIME_INFO_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(MIME_INFO_PKG))
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/share/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" shared-mime-info.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(MIME_INFO_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(MIME_INFO_PKG_DESCRIPTION_FILE): $(MIME_INFO_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(MIME_INFO_PKG_DESCRIPTION_FILE) $(MIME_INFO_PKG_INSTALL_SCRIPT)
	@cp $(MIME_INFO_PKG_DESCRIPTION_FILE) $(MIME_INFO_PKG)/.DESCRIPTION
	@cp $(MIME_INFO_PKG_INSTALL_SCRIPT) $(MIME_INFO_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(MIME_INFO_PKG)/.REQUIRES
	@echo "pkgname=$(MIME_INFO_PKG_NAME)"                            >  $(MIME_INFO_PKG)/.PKGINFO ; \
	 echo "pkgver=$(MIME_INFO_PKG_VERSION)"                          >> $(MIME_INFO_PKG)/.PKGINFO ; \
	 echo "arch=$(MIME_INFO_PKG_ARCH)"                               >> $(MIME_INFO_PKG)/.PKGINFO ; \
	 echo "distroname=$(MIME_INFO_PKG_DISTRO_NAME)"                  >> $(MIME_INFO_PKG)/.PKGINFO ; \
	 echo "distrover=$(MIME_INFO_PKG_DISTRO_VERSION)"                >> $(MIME_INFO_PKG)/.PKGINFO ; \
	 echo "group=$(MIME_INFO_PKG_GROUP)"                             >> $(MIME_INFO_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(MIME_INFO_PKG_SHORT_DESCRIPTION)\"" >> $(MIME_INFO_PKG)/.PKGINFO ; \
	 echo "url=$(MIME_INFO_PKG_URL)"                                 >> $(MIME_INFO_PKG)/.PKGINFO ; \
	 echo "license=$(MIME_INFO_PKG_LICENSE)"                         >> $(MIME_INFO_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(MIME_INFO_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
