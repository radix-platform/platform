
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/vaapi/libva

REQUIRES           = X11/libs/libva/1.7.2
REQUIRES          += X11/libs/libdrm/2.4.68-x86_32
REQUIRES          += X11/X.org/lib/libXext/1.3.3-x86_32
REQUIRES          += X11/X.org/lib/libXfixes/5.0.1-x86_32
REQUIRES          += Wayland/wayland/1.11.0-x86_32

REQUIRES          += X11/libs/opengl-collection

# ======= __END_OF_REQUIRES__ =======


version            = 1.7.2
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/m/vaapi/libva/libva-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libva-$(version)
src_dir_name       = libva-$(version)
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
LIBVA_32_PKG_NAME                = libva-x32
LIBVA_32_PKG_VERSION             = 1.7.2
LIBVA_32_PKG_ARCH                = $(TOOLCHAIN)
LIBVA_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBVA_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBVA_32_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
LIBVA_32_PKG_SHORT_DESCRIPTION   = Video Acceleration API
LIBVA_32_PKG_URL                 = $(BUG_URL)
LIBVA_32_PKG_LICENSE             = MIT
LIBVA_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBVA_32_PKG_NAME)-pkg-description
LIBVA_32_PKG_DESCRIPTION_FILE_IN = $(LIBVA_32_PKG_NAME)-pkg-description.in
LIBVA_32_PKG_INSTALL_SCRIPT      = $(LIBVA_32_PKG_NAME)-pkg-install.sh

LIBVA_32_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBVA_32_PKG_NAME)-package

pkg_basename     = $(LIBVA_32_PKG_NAME)-$(LIBVA_32_PKG_VERSION)-$(LIBVA_32_PKG_ARCH)-$(LIBVA_32_PKG_DISTRO_NAME)-$(LIBVA_32_PKG_DISTRO_VERSION)

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


env_sysroot  = DESTDIR=$(LIBVA_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var

extra_configure_switches += --bindir=/usr/bin/32

extra_configure_switches += --enable-dummy-driver

extra_configure_switches += --enable-docs=no
extra_configure_switches += --enable-drm=yes
extra_configure_switches += --enable-x11=yes
extra_configure_switches += --enable-wayland=yes

extra_configure_switches += --enable-glx=yes
extra_configure_switches += --enable-egl=yes

extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=no


CFLAGS += -Wno-deprecated-declarations


TARGET_BIN_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX)
TARGET_LIB_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib/../lib$(MULTILIB_X86_32_SUFFIX)


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
	@mkdir -p $(LIBVA_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(LIBVA_32_PKG)/usr/include
	@rm -rf $(LIBVA_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBVA_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libva-drm.la     libva-egl.la \
	                                    libva-glx.la     libva-tpi.la \
	                                    libva-wayland.la libva-x11.la \
	                                    libva.la ; \
	 )
	@( cd $(LIBVA_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/dri ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" dummy_drv_video.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBVA_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libva-drm.la     libva-egl.la \
	                                            libva-glx.la     libva-tpi.la \
	                                            libva-wayland.la libva-x11.la \
	                                            libva.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libva-drm.la     libva-egl.la \
	                                              libva-glx.la     libva-tpi.la \
	                                              libva-wayland.la libva-x11.la \
	                                              libva.la ; \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/dri ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g"   dummy_drv_video.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" dummy_drv_video.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libva-drm.pc     libva-egl.pc   \
	                                            libva-glx.pc     libva-tpi.pc   \
	                                            libva-wayland.pc libva-x11.pc ; \
	 )
	# ======= do not touch driverdir variable in libva.pc file =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,prefix=/usr,prefix=$(TARGET_DEST_DIR)/usr,g" libva.pc ; \
	   sed -i "s,libdir=/usr,libdir=$(TARGET_DEST_DIR)/usr,g" libva.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBVA_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(LIBVA_32_PKG)/usr/bin/32 ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(LIBVA_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(LIBVA_32_PKG_DESCRIPTION_FILE): $(LIBVA_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBVA_32_PKG_DESCRIPTION_FILE) $(LIBVA_32_PKG_INSTALL_SCRIPT)
	@cp $(LIBVA_32_PKG_DESCRIPTION_FILE) $(LIBVA_32_PKG)/.DESCRIPTION
	@cp $(LIBVA_32_PKG_INSTALL_SCRIPT) $(LIBVA_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBVA_32_PKG)/.REQUIRES
	@echo "pkgname=$(LIBVA_32_PKG_NAME)"                            >  $(LIBVA_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBVA_32_PKG_VERSION)"                          >> $(LIBVA_32_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBVA_32_PKG_ARCH)"                               >> $(LIBVA_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBVA_32_PKG_DISTRO_NAME)"                  >> $(LIBVA_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBVA_32_PKG_DISTRO_VERSION)"                >> $(LIBVA_32_PKG)/.PKGINFO ; \
	 echo "group=$(LIBVA_32_PKG_GROUP)"                             >> $(LIBVA_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBVA_32_PKG_SHORT_DESCRIPTION)\"" >> $(LIBVA_32_PKG)/.PKGINFO ; \
	 echo "url=$(LIBVA_32_PKG_URL)"                                 >> $(LIBVA_32_PKG)/.PKGINFO ; \
	 echo "license=$(LIBVA_32_PKG_LICENSE)"                         >> $(LIBVA_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LIBVA_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
