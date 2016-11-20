
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXV)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/vaapi/libva

REQUIRES           = X11/libs/libdrm/2.4.68
REQUIRES          += X11/X.org/lib/libXext/1.3.3
REQUIRES          += X11/X.org/lib/libXfixes/5.0.1
REQUIRES          += Wayland/wayland/1.11.0

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

LIBVA_PKG          = $(CURDIR)/$(TARGET_BUILD_DIR)/libva-package

BUILD_TARGETS      = $(build_target)
BUILD_TARGETS     += $(install_target)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(LIBVA_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var

extra_configure_switches += --enable-dummy-driver

extra_configure_switches += --enable-docs=no
extra_configure_switches += --enable-drm=yes
extra_configure_switches += --enable-x11=yes
extra_configure_switches += --enable-wayland=yes

extra_configure_switches += --enable-glx=no
extra_configure_switches += --enable-egl=no

extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


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
	@mkdir -p $(LIBVA_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(LIBVA_PKG)/usr/share/man ]; then \
	  ( cd $(LIBVA_PKG)/usr/share/man ; \
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
	@mkdir -p $(LIBVA_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(LIBVA_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(LIBVA_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING NEWS \
	         $(LIBVA_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(LIBVA_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBVA_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libva-drm.la     libva-tpi.la \
	                                    libva-wayland.la libva-x11.la \
	                                    libva.la ; \
	 )
	@( cd $(LIBVA_PKG)/usr/lib$(LIBSUFFIX)/dri ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" dummy_drv_video.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBVA_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libva-drm.la     libva-tpi.la \
	                                            libva-wayland.la libva-x11.la \
	                                            libva.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libva-drm.la     libva-tpi.la \
	                                              libva-wayland.la libva-x11.la \
	                                              libva.la ; \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/dri ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g"   dummy_drv_video.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" dummy_drv_video.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libva-drm.pc     libva-tpi.pc   \
	                                            libva-wayland.pc libva-x11.pc ; \
	 )
	# ======= do not touch driverdir variable in libva.pc file =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,prefix=/usr,prefix=$(TARGET_DEST_DIR)/usr,g" libva.pc ; \
	   sed -i "s,libdir=/usr,libdir=$(TARGET_DEST_DIR)/usr,g" libva.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBVA_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@
