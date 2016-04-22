
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/x/mesa

REQUIRES           = X11/libs/mesa/10.3.4
REQUIRES          += libs/expat/2.1.1-x86_32
REQUIRES          += libs/libxml2/2.9.1-x86_32
REQUIRES          += libs/eudev/3.1.5-x86_32
REQUIRES          += libs/libomxil-bellagio/0.9.3-x86_32
REQUIRES          += dev/llvm/3.7.1-x86_32
REQUIRES          += X11/libs/libdrm/2.4.64-x86_32
REQUIRES          += X11/X.org/proto/glproto/1.4.17-x86_32
REQUIRES          += X11/X.org/proto/dri2proto/2.8-x86_32
REQUIRES          += X11/X.org/proto/dri3proto/1.0-x86_32
REQUIRES          += X11/X.org/proto/presentproto/1.0-x86_32
REQUIRES          += X11/X.org/lib/libxshmfence/1.1-x86_32
REQUIRES          += X11/X.org/lib/libpciaccess/0.13.2-x86_32
REQUIRES          += X11/X.org/lib/libXxf86vm/1.1.3-x86_32
REQUIRES          += X11/X.org/lib/libXdamage/1.1.4-x86_32
REQUIRES          += Wayland/wayland/1.6.0-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 10.3.4
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/x/mesa/MesaLib-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/Mesa-$(version)
src_dir_name       = Mesa-$(version)
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
MESA_32_PKG_NAME                = mesa-x32
MESA_32_PKG_VERSION             = 10.3.4
MESA_32_PKG_ARCH                = $(TOOLCHAIN)
MESA_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
MESA_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
MESA_32_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
MESA_32_PKG_SHORT_DESCRIPTION   = 3D graphics library
MESA_32_PKG_URL                 = $(BUG_URL)
MESA_32_PKG_LICENSE             = GPLv2
MESA_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(MESA_32_PKG_NAME)-pkg-description
MESA_32_PKG_DESCRIPTION_FILE_IN = $(MESA_32_PKG_NAME)-pkg-description.in
MESA_32_PKG_INSTALL_SCRIPT      = $(MESA_32_PKG_NAME)-pkg-install.sh

MESA_32_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(MESA_32_PKG_NAME)-package

pkg_basename     = $(MESA_32_PKG_NAME)-$(MESA_32_PKG_VERSION)-$(MESA_32_PKG_ARCH)-$(MESA_32_PKG_DISTRO_NAME)-$(MESA_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../build-system/core.mk


env_sysroot  = DESTDIR=$(MESA_32_PKG)


DRI_DRIVERS = i915,i965,nouveau,r200,swrast


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --with-llvm-prefix=$(TARGET_DEST_DIR)/usr
extra_configure_switches += --with-dri-driverdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)/xorg/modules/dri
extra_configure_switches += --with-dri-drivers="$(DRI_DRIVERS)"

#
# 'radeonsi' driver requires elfutils
#
extra_configure_switches += --with-gallium-drivers=nouveau,r300,r600,svga,swrast

extra_configure_switches += --enable-egl
extra_configure_switches += --enable-gles1
extra_configure_switches += --enable-gles2
extra_configure_switches += --with-egl-platforms=x11,drm,wayland

extra_configure_switches += --enable-llvm-shared-libs
extra_configure_switches += --disable-gallium-egl
extra_configure_switches += --disable-gallium-gbm
extra_configure_switches += --enable-gbm

extra_configure_switches += --enable-gallium-llvm
extra_configure_switches += --enable-shared-glapi

extra_configure_switches += --enable-glx
extra_configure_switches += --enable-glx-tls
extra_configure_switches += --enable-dri
extra_configure_switches += --enable-osmesa
extra_configure_switches += --enable-texture-float

extra_configure_switches += --enable-xa
# NVIDIA extra_configure_switches += --enable-vdpau
extra_configure_switches += --enable-omx
extra_configure_switches += --with-omx-libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)

#
# OpenCL requires libclc (http://libclc.llvm.org)
#
#extra_configure_switches += --enable-opencl
#extra_configure_switches += --enable-opencl-icd

extra_configure_switches += --with-clang-libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)


environment  = LLVM_CONFIG=$(TARGET_DEST_DIR)/usr/bin/32/llvm-config-host
environment += WAYLAND_SCANNER=$(TARGET_DEST_DIR)/usr/bin/$(TARGET)-wayland-scanner


TARGET_LIB_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib/../lib$(MULTILIB_X86_32_SUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@( cd $(SRC_DIR) ; \
	   autoreconf -fi ; \
	 )
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure $(environment) \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(MESA_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(MESA_32_PKG)/etc
	@rm -rf $(MESA_32_PKG)/usr/include
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(MESA_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libEGL.la          \
	                                    libGL.la           \
	                                    libGLESv1_CM.la    \
	                                    libGLESv2.la       \
	                                    libOSMesa.la       \
	                                    libgbm.la          \
	                                    libglapi.la        \
	                                    libomx_mesa.la     \
	                                    libwayland-egl.la  \
	                                    libxatracker.la  ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(MESA_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libEGL.la          \
	                                            libGL.la           \
	                                            libGLESv1_CM.la    \
	                                            libGLESv2.la       \
	                                            libOSMesa.la       \
	                                            libgbm.la          \
	                                            libglapi.la        \
	                                            libomx_mesa.la     \
	                                            libwayland-egl.la  \
	                                            libxatracker.la  ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libEGL.la          \
	                                              libGL.la           \
	                                              libGLESv1_CM.la    \
	                                              libGLESv2.la       \
	                                              libOSMesa.la       \
	                                              libgbm.la          \
	                                              libglapi.la        \
	                                              libomx_mesa.la     \
	                                              libwayland-egl.la  \
	                                              libxatracker.la  ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" egl.pc          \
	                                            gbm.pc          \
	                                            gl.pc           \
	                                            glesv1_cm.pc    \
	                                            glesv2.pc       \
	                                            osmesa.pc       \
	                                            wayland-egl.pc  \
	                                            xatracker.pc  ; \
	 )
	# ======= do not touch dridriverdir variable in dri.pc file =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,prefix=/usr,prefix=$(TARGET_DEST_DIR)/usr,g" dri.pc ; \
	   sed -i "s,libdir=/usr,libdir=$(TARGET_DEST_DIR)/usr,g" dri.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(MESA_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(MESA_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(MESA_32_PKG_DESCRIPTION_FILE): $(MESA_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(MESA_32_PKG_DESCRIPTION_FILE) $(MESA_32_PKG_INSTALL_SCRIPT)
	@cp $(MESA_32_PKG_DESCRIPTION_FILE) $(MESA_32_PKG)/.DESCRIPTION
	@cp $(MESA_32_PKG_INSTALL_SCRIPT) $(MESA_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(MESA_32_PKG)/.REQUIRES
	@echo "pkgname=$(MESA_32_PKG_NAME)"                            >  $(MESA_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(MESA_32_PKG_VERSION)"                          >> $(MESA_32_PKG)/.PKGINFO ; \
	 echo "arch=$(MESA_32_PKG_ARCH)"                               >> $(MESA_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(MESA_32_PKG_DISTRO_NAME)"                  >> $(MESA_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(MESA_32_PKG_DISTRO_VERSION)"                >> $(MESA_32_PKG)/.PKGINFO ; \
	 echo "group=$(MESA_32_PKG_GROUP)"                             >> $(MESA_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(MESA_32_PKG_SHORT_DESCRIPTION)\"" >> $(MESA_32_PKG)/.PKGINFO ; \
	 echo "url=$(MESA_32_PKG_URL)"                                 >> $(MESA_32_PKG)/.PKGINFO ; \
	 echo "license=$(MESA_32_PKG_LICENSE)"                         >> $(MESA_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(MESA_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
