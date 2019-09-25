
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
COMPONENT_TARGETS += $(HARDWARE_KHADAS_VIM2)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OKMX6DL_C)
COMPONENT_TARGETS += $(HARDWARE_OKMX6Q_C)
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


include ../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/x/MesaLib/10.x

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.3.0
endif
REQUIRES          += libs/expat/2.1.1
REQUIRES          += libs/libxml2/2.9.3
REQUIRES          += libs/eudev/3.1.5
REQUIRES          += libs/libomxil-bellagio/0.9.3
REQUIRES          += dev/llvm/3.7.1
REQUIRES          += X11/libs/libdrm/2.4.68
REQUIRES          += X11/X.org/proto/glproto/1.4.17
REQUIRES          += X11/X.org/proto/dri2proto/2.8
REQUIRES          += X11/X.org/proto/dri3proto/1.0
REQUIRES          += X11/X.org/proto/presentproto/1.0
REQUIRES          += X11/X.org/lib/libxshmfence/1.2
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC64) $(HARDWARE_PC32)),)
REQUIRES          += X11/X.org/lib/libpciaccess/0.13.4
endif
REQUIRES          += X11/X.org/lib/libXxf86vm/1.1.4
REQUIRES          += X11/X.org/lib/libXdamage/1.1.4
REQUIRES          += Wayland/wayland/1.11.0

# ======= __END_OF_REQUIRES__ =======


version            = 10.3.4
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/x/MesaLib/10.x/MesaLib-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/Mesa-$(version)
src_dir_name       = Mesa-$(version)
doc_dir_name       = mesa-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

licenses           = $(CURDIR)/license/LICENSES

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = xlibs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
MESA_PKG_NAME                = mesa
MESA_PKG_VERSION             = 10.3.4
MESA_PKG_ARCH                = $(TOOLCHAIN)
MESA_PKG_DISTRO_NAME         = $(DISTRO_NAME)
MESA_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
MESA_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
MESA_PKG_SHORT_DESCRIPTION   = 3D graphics library
MESA_PKG_URL                 = $(BUG_URL)
MESA_PKG_LICENSE             = GPLv2
MESA_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(MESA_PKG_NAME)-pkg-description
MESA_PKG_DESCRIPTION_FILE_IN = $(MESA_PKG_NAME)-pkg-description.in
MESA_PKG_INSTALL_SCRIPT      = $(MESA_PKG_NAME)-pkg-install.sh

MESA_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(MESA_PKG_NAME)-package

pkg_basename     = $(MESA_PKG_NAME)-$(MESA_PKG_VERSION)-$(MESA_PKG_ARCH)-$(MESA_PKG_DISTRO_NAME)-$(MESA_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(MESA_PKG)

#
# 'radeon' driver requires elfutils
#
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC64) $(HARDWARE_PC32)),)
DRI_DRIVERS = i915,i965,nouveau,r200,swrast
else
DRI_DRIVERS = nouveau,r200,swrast
endif

extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(doc_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --sysconfdir=/etc

extra_configure_switches += --with-llvm-prefix=$(TARGET_DEST_DIR)/usr
extra_configure_switches += --with-dri-driverdir=/usr/lib$(LIBSUFFIX)/xorg/modules/dri
extra_configure_switches += --with-dri-drivers="$(DRI_DRIVERS)"

#
# 'radeonsi' driver requires elfutils
#
extra_configure_switches += --with-gallium-drivers=nouveau,r300,r600,svga,swrast

ifneq ($(filter $(HARDWARE),$(HARDWARE_CB1X) $(HARDWARE_CI20) $(HARDWARE_M201) $(HARDWARE_MXV)),)
extra_configure_switches += --disable-egl
extra_configure_switches += --disable-gles1
extra_configure_switches += --disable-gles2
extra_configure_switches += --disable-gbm
else
extra_configure_switches += --enable-egl
extra_configure_switches += --enable-gles1
extra_configure_switches += --enable-gles2
extra_configure_switches += --with-egl-platforms=x11,drm,wayland
extra_configure_switches += --enable-gbm
endif

extra_configure_switches += --disable-gallium-egl
extra_configure_switches += --disable-gallium-gbm

extra_configure_switches += --enable-gallium-llvm
extra_configure_switches += --enable-shared-glapi

extra_configure_switches += --enable-dri
extra_configure_switches += --enable-glx
extra_configure_switches += --enable-glx-tls
extra_configure_switches += --enable-osmesa
extra_configure_switches += --enable-texture-float

extra_configure_switches += --enable-llvm-shared-libs
extra_configure_switches += --enable-xa
# NVIDIA extra_configure_switches += --enable-vdpau
extra_configure_switches += --enable-omx
extra_configure_switches += --with-omx-libdir=/usr/lib$(LIBSUFFIX)

#
# OpenCL requires libclc (http://libclc.llvm.org)
#
#extra_configure_switches += --enable-opencl
#extra_configure_switches += --enable-opencl-icd

extra_configure_switches += --with-clang-libdir=/usr/lib$(LIBSUFFIX)


environment  = LLVM_CONFIG=$(TARGET_DEST_DIR)/usr/bin/llvm-config-host
environment += WAYLAND_SCANNER=$(TARGET_DEST_DIR)/usr/bin/$(TARGET)-wayland-scanner


TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


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
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(MESA_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(MESA_PKG)/usr/share/man ]; then \
	  ( cd $(MESA_PKG)/usr/share/man ; \
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
	@mkdir -p $(MESA_PKG)/usr/doc/$(doc_dir_name)
	@cp -a $(licenses) $(SRC_DIR)/docs/COPYING \
	       $(MESA_PKG)/usr/doc/$(doc_dir_name)
	@mkdir -p $(MESA_PKG)/usr/share/doc/$(doc_dir_name)/html
	@( cd $(SRC_DIR) ; \
	   cp -a $(licenses) docs/COPYING docs/*.txt docs/README* \
	         $(MESA_PKG)/usr/share/doc/$(doc_dir_name) ; \
	   cp -a docs/*.{html,png} \
	         $(MESA_PKG)/usr/share/doc/$(doc_dir_name)/html ; \
	   rm -f $(MESA_PKG)/usr/share/doc/$(doc_dir_name)/html/relnotes.html ; \
	   cp -a docs/relnotes/$(version).html \
	         $(MESA_PKG)/usr/share/doc/$(doc_dir_name)/html/relnotes-$(version).html ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(MESA_PKG)/usr/share/doc/$(doc_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
ifneq ($(filter $(HARDWARE),$(HARDWARE_CB1X) $(HARDWARE_CI20) $(HARDWARE_M201) $(HARDWARE_MXV)),)
	@( cd $(MESA_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libGL.la           \
	                                    libOSMesa.la       \
	                                    libglapi.la        \
	                                    libomx_mesa.la     \
	                                    libxatracker.la  ; \
	 )
else
	@( cd $(MESA_PKG)/usr/lib$(LIBSUFFIX) ; \
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
endif
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(MESA_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
ifneq ($(filter $(HARDWARE),$(HARDWARE_CB1X) $(HARDWARE_CI20) $(HARDWARE_M201) $(HARDWARE_MXV)),)
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libGL.la           \
	                                            libOSMesa.la       \
	                                            libglapi.la        \
	                                            libomx_mesa.la     \
	                                            libxatracker.la  ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libGL.la           \
	                                              libOSMesa.la       \
	                                              libglapi.la        \
	                                              libomx_mesa.la     \
	                                              libxatracker.la  ; \
	 )
else
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
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
endif
	# ======= tune pkg-config *.pc search path to the target destination for development =======
ifneq ($(filter $(HARDWARE),$(HARDWARE_CB1X) $(HARDWARE_CI20) $(HARDWARE_M201) $(HARDWARE_MXV)),)
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" gl.pc           \
	                                            osmesa.pc       \
	                                            xatracker.pc  ; \
	 )
else
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" egl.pc          \
	                                            gbm.pc          \
	                                            gl.pc           \
	                                            glesv1_cm.pc    \
	                                            glesv2.pc       \
	                                            osmesa.pc       \
	                                            wayland-egl.pc  \
	                                            xatracker.pc  ; \
	 )
endif
	# ======= do not touch dridriverdir variable in dri.pc file =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,prefix=/usr,prefix=$(TARGET_DEST_DIR)/usr,g" dri.pc ; \
	   sed -i "s,libdir=/usr,libdir=$(TARGET_DEST_DIR)/usr,g" dri.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(MESA_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(MESA_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(MESA_PKG_DESCRIPTION_FILE): $(MESA_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(MESA_PKG_DESCRIPTION_FILE) $(MESA_PKG_INSTALL_SCRIPT)
	@cp $(MESA_PKG_DESCRIPTION_FILE) $(MESA_PKG)/.DESCRIPTION
	@cp $(MESA_PKG_INSTALL_SCRIPT) $(MESA_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(MESA_PKG)/.REQUIRES
	@echo "pkgname=$(MESA_PKG_NAME)"                            >  $(MESA_PKG)/.PKGINFO ; \
	 echo "pkgver=$(MESA_PKG_VERSION)"                          >> $(MESA_PKG)/.PKGINFO ; \
	 echo "arch=$(MESA_PKG_ARCH)"                               >> $(MESA_PKG)/.PKGINFO ; \
	 echo "distroname=$(MESA_PKG_DISTRO_NAME)"                  >> $(MESA_PKG)/.PKGINFO ; \
	 echo "distrover=$(MESA_PKG_DISTRO_VERSION)"                >> $(MESA_PKG)/.PKGINFO ; \
	 echo "group=$(MESA_PKG_GROUP)"                             >> $(MESA_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(MESA_PKG_SHORT_DESCRIPTION)\"" >> $(MESA_PKG)/.PKGINFO ; \
	 echo "url=$(MESA_PKG_URL)"                                 >> $(MESA_PKG)/.PKGINFO ; \
	 echo "license=$(MESA_PKG_LICENSE)"                         >> $(MESA_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(MESA_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
