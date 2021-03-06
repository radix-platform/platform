
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/vaapi/libva-vdpau-driver

REQUIRES           = X11/libs/libva/1.7.2
REQUIRES          += X11/libs/libvdpau/1.1.1

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
VDPAU_DRV_PKG_NAME                = libva-vdpau-driver
VDPAU_DRV_PKG_VERSION             = 0.7.4
VDPAU_DRV_PKG_ARCH                = $(TOOLCHAIN)
VDPAU_DRV_PKG_DISTRO_NAME         = $(DISTRO_NAME)
VDPAU_DRV_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
VDPAU_DRV_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
VDPAU_DRV_PKG_SHORT_DESCRIPTION   = VDPAU backend for VA API
VDPAU_DRV_PKG_URL                 = $(BUG_URL)
VDPAU_DRV_PKG_LICENSE             = GPLv2
VDPAU_DRV_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(VDPAU_DRV_PKG_NAME)-pkg-description
VDPAU_DRV_PKG_DESCRIPTION_FILE_IN = $(VDPAU_DRV_PKG_NAME)-pkg-description.in
VDPAU_DRV_PKG_INSTALL_SCRIPT      = $(VDPAU_DRV_PKG_NAME)-pkg-install.sh

VDPAU_DRV_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(VDPAU_DRV_PKG_NAME)-package

pkg_basename     = $(VDPAU_DRV_PKG_NAME)-$(VDPAU_DRV_PKG_VERSION)-$(VDPAU_DRV_PKG_ARCH)-$(VDPAU_DRV_PKG_DISTRO_NAME)-$(VDPAU_DRV_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../build-system/core.mk


env_sysroot = DESTDIR=$(VDPAU_DRV_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var

extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=no


TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)

LDFLAGS += -Wl,-rpath,$(TARGET_LIB_RPATH)


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
	@mkdir -p $(VDPAU_DRV_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(VDPAU_DRV_PKG)/usr/share/man ]; then \
	  ( cd $(VDPAU_DRV_PKG)/usr/share/man ; \
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
	@mkdir -p $(VDPAU_DRV_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(VDPAU_DRV_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(VDPAU_DRV_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING NEWS README \
	         $(VDPAU_DRV_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(VDPAU_DRV_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(VDPAU_DRV_PKG)/usr/lib$(LIBSUFFIX)/dri ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" vdpau_drv_video.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(VDPAU_DRV_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/dri ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" vdpau_drv_video.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" vdpau_drv_video.la ; \
	 )
	# ======= Strip binaries =======
	@( cd $(VDPAU_DRV_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(VDPAU_DRV_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(VDPAU_DRV_PKG_DESCRIPTION_FILE): $(VDPAU_DRV_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(VDPAU_DRV_PKG_DESCRIPTION_FILE) $(VDPAU_DRV_PKG_INSTALL_SCRIPT)
	@cp $(VDPAU_DRV_PKG_DESCRIPTION_FILE) $(VDPAU_DRV_PKG)/.DESCRIPTION
	@cp $(VDPAU_DRV_PKG_INSTALL_SCRIPT) $(VDPAU_DRV_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(VDPAU_DRV_PKG)/.REQUIRES
	@echo "pkgname=$(VDPAU_DRV_PKG_NAME)"                            >  $(VDPAU_DRV_PKG)/.PKGINFO ; \
	 echo "pkgver=$(VDPAU_DRV_PKG_VERSION)"                          >> $(VDPAU_DRV_PKG)/.PKGINFO ; \
	 echo "arch=$(VDPAU_DRV_PKG_ARCH)"                               >> $(VDPAU_DRV_PKG)/.PKGINFO ; \
	 echo "distroname=$(VDPAU_DRV_PKG_DISTRO_NAME)"                  >> $(VDPAU_DRV_PKG)/.PKGINFO ; \
	 echo "distrover=$(VDPAU_DRV_PKG_DISTRO_VERSION)"                >> $(VDPAU_DRV_PKG)/.PKGINFO ; \
	 echo "group=$(VDPAU_DRV_PKG_GROUP)"                             >> $(VDPAU_DRV_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(VDPAU_DRV_PKG_SHORT_DESCRIPTION)\"" >> $(VDPAU_DRV_PKG)/.PKGINFO ; \
	 echo "url=$(VDPAU_DRV_PKG_URL)"                                 >> $(VDPAU_DRV_PKG)/.PKGINFO ; \
	 echo "license=$(VDPAU_DRV_PKG_LICENSE)"                         >> $(VDPAU_DRV_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(VDPAU_DRV_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
