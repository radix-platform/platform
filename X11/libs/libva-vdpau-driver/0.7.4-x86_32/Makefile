
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/vaapi/libva-vdpau-driver

REQUIRES           = X11/libs/libva-vdpau-driver/0.7.4
REQUIRES          += X11/libs/libva/1.7.2-x86_32
REQUIRES          += X11/libs/libvdpau/1.1.1-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 0.7.4
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/m/vaapi/libva-vdpau-driver/libva-vdpau-driver-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libva-vdpau-driver-$(version)
src_dir_name       = libva-vdpau-driver-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = xlibs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
VDPAU_DRV_32_PKG_NAME                = libva-vdpau-driver-x32
VDPAU_DRV_32_PKG_VERSION             = 0.7.4
VDPAU_DRV_32_PKG_ARCH                = $(TOOLCHAIN)
VDPAU_DRV_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
VDPAU_DRV_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
VDPAU_DRV_32_PKG_GROUP               = $(PKG_GROUP)
###                                   |---handy-ruler-------------------------------|
VDPAU_DRV_32_PKG_SHORT_DESCRIPTION   = VDPAU backend for VA API
VDPAU_DRV_32_PKG_URL                 = $(BUG_URL)
VDPAU_DRV_32_PKG_LICENSE             = GPLv2
VDPAU_DRV_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(VDPAU_DRV_32_PKG_NAME)-pkg-description
VDPAU_DRV_32_PKG_DESCRIPTION_FILE_IN = $(VDPAU_DRV_32_PKG_NAME)-pkg-description.in
VDPAU_DRV_32_PKG_INSTALL_SCRIPT      = $(VDPAU_DRV_32_PKG_NAME)-pkg-install.sh

VDPAU_DRV_32_PKG = $(CURDIR)/$(TARGET_BUILD_DIR)/$(VDPAU_DRV_32_PKG_NAME)-package

pkg_basename     = $(VDPAU_DRV_32_PKG_NAME)-$(VDPAU_DRV_32_PKG_VERSION)-$(VDPAU_DRV_32_PKG_ARCH)-$(VDPAU_DRV_32_PKG_DISTRO_NAME)-$(VDPAU_DRV_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_certificate  = $(call cert-name,$(pkg_archive))
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../build-system/core.mk


env_sysroot  = DESTDIR=$(VDPAU_DRV_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var

extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=no


TARGET_LIB_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib/../lib$(MULTILIB_X86_32_SUFFIX)

LDFLAGS += -Wl,-rpath,$(TARGET_LIB_RPATH)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(VDPAU_DRV_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(VDPAU_DRV_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/dri ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" vdpau_drv_video.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(VDPAU_DRV_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/dri ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g"   vdpau_drv_video.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" vdpau_drv_video.la ; \
	 )
	# ======= Strip binaries =======
	@( cd $(VDPAU_DRV_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(VDPAU_DRV_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(VDPAU_DRV_32_PKG_DESCRIPTION_FILE): $(VDPAU_DRV_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(VDPAU_DRV_32_PKG_DESCRIPTION_FILE) $(VDPAU_DRV_32_PKG_INSTALL_SCRIPT)
	@cp $(VDPAU_DRV_32_PKG_DESCRIPTION_FILE) $(VDPAU_DRV_32_PKG)/.DESCRIPTION
	@cp $(VDPAU_DRV_32_PKG_INSTALL_SCRIPT) $(VDPAU_DRV_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(VDPAU_DRV_32_PKG)/.REQUIRES
	@echo "pkgname=$(VDPAU_DRV_32_PKG_NAME)"                            >  $(VDPAU_DRV_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(VDPAU_DRV_32_PKG_VERSION)"                          >> $(VDPAU_DRV_32_PKG)/.PKGINFO ; \
	 echo "arch=$(VDPAU_DRV_32_PKG_ARCH)"                               >> $(VDPAU_DRV_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(VDPAU_DRV_32_PKG_DISTRO_NAME)"                  >> $(VDPAU_DRV_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(VDPAU_DRV_32_PKG_DISTRO_VERSION)"                >> $(VDPAU_DRV_32_PKG)/.PKGINFO ; \
	 echo "group=$(VDPAU_DRV_32_PKG_GROUP)"                             >> $(VDPAU_DRV_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(VDPAU_DRV_32_PKG_SHORT_DESCRIPTION)\"" >> $(VDPAU_DRV_32_PKG)/.PKGINFO ; \
	 echo "url=$(VDPAU_DRV_32_PKG_URL)"                                 >> $(VDPAU_DRV_32_PKG)/.PKGINFO ; \
	 echo "license=$(VDPAU_DRV_32_PKG_LICENSE)"                         >> $(VDPAU_DRV_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(VDPAU_DRV_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
