
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/X.org/xcb/libxcb

REQUIRES           = X11/X.org/xcb/libxcb/1.11.1
REQUIRES          += X11/X.org/xcb/xcb-proto/1.11-x86_32
REQUIRES          += X11/X.org/lib/libXau/1.0.8-x86_32
REQUIRES          += X11/X.org/lib/libXdmcp/1.1.2-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 1.11.1
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/X.org/xcb/libxcb/libxcb-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libxcb-$(version)
src_dir_name       = libxcb-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = xorg

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
XORG_32_PKG_NAME                = libxcb-x32
XORG_32_PKG_VERSION             = 1.11.1
XORG_32_PKG_ARCH                = $(TOOLCHAIN)
XORG_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
XORG_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
XORG_32_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
XORG_32_PKG_SHORT_DESCRIPTION   = X protocol C-language Binding
XORG_32_PKG_URL                 = $(BUG_URL)
XORG_32_PKG_LICENSE             = custom
XORG_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(XORG_32_PKG_NAME)-pkg-description
XORG_32_PKG_DESCRIPTION_FILE_IN = $(XORG_32_PKG_NAME)-pkg-description.in
XORG_32_PKG_INSTALL_SCRIPT      = $(XORG_32_PKG_NAME)-pkg-install.sh

XORG_32_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(XORG_32_PKG_NAME)-package

pkg_basename     = $(XORG_32_PKG_NAME)-$(XORG_32_PKG_VERSION)-$(XORG_32_PKG_ARCH)-$(XORG_32_PKG_DISTRO_NAME)-$(XORG_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../../build-system/core.mk


env_sysroot  = DESTDIR=$(XORG_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


pkg_environment = PKG_CONFIG_PATH=$(PKG_CONFIG_PATH)

PYTHON_VERSION  = 2.7
python_config  += am_cv_python_pythondir=/usr/lib$(MULTILIB_X86_32_SUFFIX)/python$(PYTHON_VERSION)/site-packages


TARGET_LIB_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib/../lib$(MULTILIB_X86_32_SUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) $(python_config) ../$(src_dir_name)/configure $(pkg_environment) \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(XORG_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(XORG_32_PKG)/usr/include
	@rm -rf $(XORG_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(XORG_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libxcb.la libxcb-composite.la libxcb-damage.la      \
	                                    libxcb-dpms.la libxcb-dri2.la libxcb-dri3.la        \
	                                    libxcb-glx.la libxcb-present.la libxcb-randr.la     \
	                                    libxcb-record.la libxcb-render.la libxcb-res.la     \
	                                    libxcb-screensaver.la libxcb-shape.la libxcb-shm.la \
	                                    libxcb-sync.la libxcb-xevie.la libxcb-xf86dri.la    \
	                                    libxcb-xfixes.la libxcb-xinerama.la libxcb-xkb.la   \
	                                    libxcb-xprint.la libxcb-xtest.la libxcb-xv.la       \
	                                    libxcb-xvmc.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(XORG_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libxcb.la libxcb-composite.la libxcb-damage.la      \
	                                            libxcb-dpms.la libxcb-dri2.la libxcb-dri3.la        \
	                                            libxcb-glx.la libxcb-present.la libxcb-randr.la     \
	                                            libxcb-record.la libxcb-render.la libxcb-res.la     \
	                                            libxcb-screensaver.la libxcb-shape.la libxcb-shm.la \
	                                            libxcb-sync.la libxcb-xevie.la libxcb-xf86dri.la    \
	                                            libxcb-xfixes.la libxcb-xinerama.la libxcb-xkb.la   \
	                                            libxcb-xprint.la libxcb-xtest.la libxcb-xv.la       \
	                                            libxcb-xvmc.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libxcb.la libxcb-composite.la libxcb-damage.la      \
	                                              libxcb-dpms.la libxcb-dri2.la libxcb-dri3.la        \
	                                              libxcb-glx.la libxcb-present.la libxcb-randr.la     \
	                                              libxcb-record.la libxcb-render.la libxcb-res.la     \
	                                              libxcb-screensaver.la libxcb-shape.la libxcb-shm.la \
	                                              libxcb-sync.la libxcb-xevie.la libxcb-xf86dri.la    \
	                                              libxcb-xfixes.la libxcb-xinerama.la libxcb-xkb.la   \
	                                              libxcb-xprint.la libxcb-xtest.la libxcb-xv.la       \
	                                              libxcb-xvmc.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" xcb.pc xcb-composite.pc xcb-damage.pc xcb-dpms.pc         \
	                                            xcb-dri2.pc xcb-dri3.pc xcb-glx.pc xcb-present.pc         \
	                                            xcb-randr.pc xcb-record.pc xcb-render.pc xcb-res.pc       \
	                                            xcb-screensaver.pc xcb-shape.pc xcb-shm.pc xcb-sync.pc    \
	                                            xcb-xevie.pc xcb-xf86dri.pc xcb-xfixes.pc xcb-xinerama.pc \
	                                            xcb-xkb.pc xcb-xprint.pc xcb-xtest.pc xcb-xv.pc xcb-xvmc.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(XORG_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(XORG_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(XORG_32_PKG_DESCRIPTION_FILE): $(XORG_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(XORG_32_PKG_DESCRIPTION_FILE) $(XORG_32_PKG_INSTALL_SCRIPT)
	@cp $(XORG_32_PKG_DESCRIPTION_FILE) $(XORG_32_PKG)/.DESCRIPTION
	@cp $(XORG_32_PKG_INSTALL_SCRIPT) $(XORG_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(XORG_32_PKG)/.REQUIRES
	@echo "pkgname=$(XORG_32_PKG_NAME)"                            >  $(XORG_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(XORG_32_PKG_VERSION)"                          >> $(XORG_32_PKG)/.PKGINFO ; \
	 echo "arch=$(XORG_32_PKG_ARCH)"                               >> $(XORG_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(XORG_32_PKG_DISTRO_NAME)"                  >> $(XORG_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(XORG_32_PKG_DISTRO_VERSION)"                >> $(XORG_32_PKG)/.PKGINFO ; \
	 echo "group=$(XORG_32_PKG_GROUP)"                             >> $(XORG_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(XORG_32_PKG_SHORT_DESCRIPTION)\"" >> $(XORG_32_PKG)/.PKGINFO ; \
	 echo "url=$(XORG_32_PKG_URL)"                                 >> $(XORG_32_PKG)/.PKGINFO ; \
	 echo "license=$(XORG_32_PKG_LICENSE)"                         >> $(XORG_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(XORG_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
