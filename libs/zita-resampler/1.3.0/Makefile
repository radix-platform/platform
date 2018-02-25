
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


SOURCE_REQUIRES    = sources/packages/m/linuxaudio/kokkinizita/zita-resampler

REQUIRES           = libs/libsndfile/1.0.26

# ======= __END_OF_REQUIRES__ =======


version            = 1.3.0
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/m/linuxaudio/kokkinizita/zita-resampler/zita-resampler-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/zita-resampler-$(version)
src_dir_name       = zita-resampler-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
Z_RESAMPLE_PKG_NAME                = zita-resampler
Z_RESAMPLE_PKG_VERSION             = 1.3.0
Z_RESAMPLE_PKG_ARCH                = $(TOOLCHAIN)
Z_RESAMPLE_PKG_DISTRO_NAME         = $(DISTRO_NAME)
Z_RESAMPLE_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
Z_RESAMPLE_PKG_GROUP               = $(PKG_GROUP)
###                                 |---handy-ruler-------------------------------|
Z_RESAMPLE_PKG_SHORT_DESCRIPTION   = sample rate conversion library
Z_RESAMPLE_PKG_URL                 = $(BUG_URL)
Z_RESAMPLE_PKG_LICENSE             = GPLv3
Z_RESAMPLE_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(Z_RESAMPLE_PKG_NAME)-pkg-description
Z_RESAMPLE_PKG_DESCRIPTION_FILE_IN = $(Z_RESAMPLE_PKG_NAME)-pkg-description.in
Z_RESAMPLE_PKG_INSTALL_SCRIPT      = $(Z_RESAMPLE_PKG_NAME)-pkg-install.sh

Z_RESAMPLE_PKG   = $(CURDIR)/$(TARGET_BUILD_DIR)/$(Z_RESAMPLE_PKG_NAME)-package

pkg_basename     = $(Z_RESAMPLE_PKG_NAME)-$(Z_RESAMPLE_PKG_VERSION)-$(Z_RESAMPLE_PKG_ARCH)-$(Z_RESAMPLE_PKG_DISTRO_NAME)-$(Z_RESAMPLE_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


CXXFLAGS += -I../libs


TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)

LDFLAGS += -L../libs -Wl,-rpath,$(TARGET_LIB_RPATH)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@( cd $(SRC_DIR)/libs ; \
	   $(BUILD_ENVIRONMENT) \
	      $(MAKE) PREFIX=/usr LIBDIR=$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   ln -sf libzita-resampler.so.$(version) libzita-resampler.so   ; \
	 )
	@( cd $(SRC_DIR)/apps ; \
	   $(BUILD_ENVIRONMENT)  \
	      $(MAKE) PREFIX=/usr LIBDIR=$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	 )
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(Z_RESAMPLE_PKG)
	@( cd $(SRC_DIR) ; \
	   $(MAKE) -j1 -C libs DESTDIR="$(Z_RESAMPLE_PKG)" PREFIX=/usr LIBDIR=lib$(LIBSUFFIX) install ; \
	   $(MAKE) -j1 -C apps DESTDIR="$(Z_RESAMPLE_PKG)" PREFIX=/usr BINDIR=bin LIBDIR=lib$(LIBSUFFIX) install ; \
	 )
	# ======= Install Documentation =======
	@mkdir -p $(Z_RESAMPLE_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(Z_RESAMPLE_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(Z_RESAMPLE_PKG)/usr/share/doc/$(src_dir_name)/html
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING INSTALL README \
	         $(Z_RESAMPLE_PKG)/usr/share/doc/$(src_dir_name) ; \
	   cp -a docs/* $(Z_RESAMPLE_PKG)/usr/share/doc/$(src_dir_name)/html ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(Z_RESAMPLE_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(Z_RESAMPLE_PKG))
	# ======= Strip binaries =======
	@( cd $(Z_RESAMPLE_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(Z_RESAMPLE_PKG_DESCRIPTION_FILE): $(Z_RESAMPLE_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(Z_RESAMPLE_PKG_DESCRIPTION_FILE) $(Z_RESAMPLE_PKG_INSTALL_SCRIPT)
	@cp $(Z_RESAMPLE_PKG_DESCRIPTION_FILE) $(Z_RESAMPLE_PKG)/.DESCRIPTION
	@cp $(Z_RESAMPLE_PKG_INSTALL_SCRIPT) $(Z_RESAMPLE_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(Z_RESAMPLE_PKG)/.REQUIRES
	@echo "pkgname=$(Z_RESAMPLE_PKG_NAME)"                            >  $(Z_RESAMPLE_PKG)/.PKGINFO ; \
	 echo "pkgver=$(Z_RESAMPLE_PKG_VERSION)"                          >> $(Z_RESAMPLE_PKG)/.PKGINFO ; \
	 echo "arch=$(Z_RESAMPLE_PKG_ARCH)"                               >> $(Z_RESAMPLE_PKG)/.PKGINFO ; \
	 echo "distroname=$(Z_RESAMPLE_PKG_DISTRO_NAME)"                  >> $(Z_RESAMPLE_PKG)/.PKGINFO ; \
	 echo "distrover=$(Z_RESAMPLE_PKG_DISTRO_VERSION)"                >> $(Z_RESAMPLE_PKG)/.PKGINFO ; \
	 echo "group=$(Z_RESAMPLE_PKG_GROUP)"                             >> $(Z_RESAMPLE_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(Z_RESAMPLE_PKG_SHORT_DESCRIPTION)\"" >> $(Z_RESAMPLE_PKG)/.PKGINFO ; \
	 echo "url=$(Z_RESAMPLE_PKG_URL)"                                 >> $(Z_RESAMPLE_PKG)/.PKGINFO ; \
	 echo "license=$(Z_RESAMPLE_PKG_LICENSE)"                         >> $(Z_RESAMPLE_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(Z_RESAMPLE_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
