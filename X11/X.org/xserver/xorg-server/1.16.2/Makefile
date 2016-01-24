
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_VIP1830)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/X.org/xserver/xorg-server

REQUIRES           = libs/eudev/1.9
REQUIRES          += net/nettle/2.7.1
REQUIRES          += X11/app/dbus-x11-launch/1.8.10

REQUIRES          += X11/X.org/proto/xproto/7.0.26
REQUIRES          += X11/X.org/proto/dri2proto/2.8
REQUIRES          += X11/X.org/proto/dri3proto/1.0
REQUIRES          += X11/X.org/proto/xf86driproto/2.1.1
REQUIRES          += X11/X.org/proto/randrproto/1.4.0
REQUIRES          += X11/X.org/proto/renderproto/0.11.1
REQUIRES          += X11/X.org/proto/videoproto/2.3.2
REQUIRES          += X11/X.org/proto/xineramaproto/1.2.1
REQUIRES          += X11/X.org/proto/presentproto/1.0
REQUIRES          += X11/X.org/proto/inputproto/2.3.1
REQUIRES          += X11/X.org/proto/kbproto/1.0.6
REQUIRES          += X11/X.org/proto/scrnsaverproto/1.2.2
REQUIRES          += X11/X.org/proto/xextproto/7.3.0
REQUIRES          += X11/X.org/proto/fontsproto/2.1.3
REQUIRES          += X11/X.org/proto/glproto/1.4.17
REQUIRES          += X11/X.org/proto/resourceproto/1.2.0

REQUIRES          += X11/X.org/lib/libXaw/1.0.12
REQUIRES          += X11/X.org/lib/libXft/2.3.2
REQUIRES          += X11/X.org/lib/libXfont/1.5.0
REQUIRES          += X11/X.org/lib/libXi/1.7.4
REQUIRES          += X11/X.org/lib/libXdamage/1.1.4
REQUIRES          += X11/X.org/lib/libXxf86vm/1.1.3
REQUIRES          += X11/X.org/lib/pixman/0.32.6
REQUIRES          += X11/X.org/lib/libxshmfence/1.1

REQUIRES          += X11/X.org/xcb/xcb-util-cursor/0.1.1
REQUIRES          += X11/X.org/xcb/xcb-util-keysyms/0.4.0
REQUIRES          += X11/X.org/xcb/xcb-util-wm/0.4.1

REQUIRES          += X11/libs/libdrm/2.4.64
REQUIRES          += X11/libs/libepoxy/1.2
REQUIRES          += Wayland/wayland/1.6.0

ifneq ($(filter $(HARDWARE),$(HARDWARE_PC64) $(HARDWARE_PC32)),)
REQUIRES          += X11/X.org/lib/libpciaccess/0.13.2
endif

REQUIRES          += X11/libs/opengl-collection

# ======= __END_OF_REQUIRES__ =======


version            = 1.16.2
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/X.org/xserver/xorg-server/xorg-server-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/xorg-server-$(version)
src_dir_name       = xorg-server-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

kbd_layout         = $(CURDIR)/kbd-layout/90-keyboard-layout.conf

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = xorg

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
XORG_PKG_NAME                = xorg-server
XORG_PKG_VERSION             = 1.16.2
XORG_PKG_ARCH                = $(TOOLCHAIN)
XORG_PKG_DISTRO_NAME         = $(DISTRO_NAME)
XORG_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
XORG_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
XORG_PKG_SHORT_DESCRIPTION   = The Xorg server
XORG_PKG_URL                 = $(BUG_URL)
XORG_PKG_LICENSE             = custom
XORG_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(XORG_PKG_NAME)-pkg-description
XORG_PKG_DESCRIPTION_FILE_IN = $(XORG_PKG_NAME)-pkg-description.in
XORG_PKG_INSTALL_SCRIPT      = $(XORG_PKG_NAME)-pkg-install.sh

XORG_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(XORG_PKG_NAME)-package

pkg_basename     = $(XORG_PKG_NAME)-$(XORG_PKG_VERSION)-$(XORG_PKG_ARCH)-$(XORG_PKG_DISTRO_NAME)-$(XORG_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../../build-system/core.mk


env_sysroot = DESTDIR=$(XORG_PKG)

#
# Servers to build:
#
BUILD_SERVERS  = --enable-xorg
BUILD_SERVERS += --enable-dmx
BUILD_SERVERS += --enable-xvfb
BUILD_SERVERS += --enable-xnest
BUILD_SERVERS += --enable-xwayland
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC64) $(HARDWARE_PC32)),)
BUILD_SERVERS += --enable-kdrive
BUILD_SERVERS += --enable-xephyr
BUILD_SERVERS += --enable-xfbdev
endif
BUILD_SERVERS += --enable-config-udev
BUILD_SERVERS += --disable-config-hal

#
# Default font paths to be used by the X server:
#
DEF_FONTPATH = "/usr/share/fonts/local,/usr/share/fonts/TTF,/usr/share/fonts/OTF,/usr/share/fonts/Type1,/usr/share/fonts/misc,/usr/share/fonts/CID,/usr/share/fonts/75dpi/:unscaled,/usr/share/fonts/100dpi/:unscaled,/usr/share/fonts/75dpi,/usr/share/fonts/100dpi,/usr/share/fonts/cyrillic"

extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=no

extra_configure_switches += --enable-ipv6
extra_configure_switches += --enable-dri
extra_configure_switches += --enable-dri2
extra_configure_switches += --enable-dri3

extra_configure_switches += --with-pic
extra_configure_switches += --with-int10=x86emu
extra_configure_switches += --with-default-font-path="$(DEF_FONTPATH)"
extra_configure_switches += --with-module-dir=/usr/lib$(LIBSUFFIX)/xorg/modules
extra_configure_switches += --with-xkb-path=/etc/X11/xkb
extra_configure_switches += --with-xkb-output=/var/lib/xkb
extra_configure_switches += --with-fontrootdir=/usr/share/fonts

extra_configure_switches += --with-os-name="$(DISTRO_CAPTION) $(DISTRO_VERSION)"
extra_configure_switches += --with-os-vendor="$(DISTRO_CAPTION) Linux Project"
extra_configure_switches += --with-vendor-web="$(BUG_URL)"

extra_configure_switches += --enable-systemd-logind=no


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)
TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


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
	  $(extra_configure_switches) \
	  $(BUILD_SERVERS)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(XORG_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(XORG_PKG)/var/log
	@( cd $(XORG_PKG)/usr/lib$(LIBSUFFIX) ; \
	   rm -rf modules ; \
	   ln -sf xorg/modules . ; \
	 )
	@mkdir -p $(XORG_PKG)/etc/X11/xorg.conf.d $(XORG_PKG)/usr/share/X11/xorg.conf.d
	@cp -a $(kbd_layout) $(XORG_PKG)/usr/share/X11/xorg.conf.d
	@chmod u+s $(XORG_PKG)/usr/bin/Xorg
	# ======= Install Documentation =======
	@( cd $(XORG_PKG)/usr/share/man/man5 ; \
	   for file in *.5 ; do                                \
	     ln=`head -n 1 $$file` ;                           \
	     if [ "`echo $$ln | grep '^\.so '`" != "" ] ; then \
	       origin=`echo $$ln | cut -f 2 -d ' '` ;          \
	       origin=`basename $$origin` ;                    \
	       rm -f $$file ;                                  \
	       ln -sf $$origin $$file ;                        \
	     fi ;                                              \
	   done ;                                              \
	 )
	@if [ -d $(XORG_PKG)/usr/share/man ]; then \
	  ( cd $(XORG_PKG)/usr/share/man ; \
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
	@mkdir -p $(XORG_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(XORG_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(XORG_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING INSTALL README \
	         $(XORG_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(XORG_PKG)/usr/share/doc ; \
	   ln -sf $(src_dir_name) $(XORG_PKG_NAME) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(XORG_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(XORG_PKG)/usr/lib$(LIBSUFFIX)/xorg/modules ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libexa.la libfb.la libfbdevhw.la        \
	                                    libint10.la libshadow.la libshadowfb.la \
	                                    libvbe.la libvgahw.la libwfb.la ; \
	 )
	@( cd $(XORG_PKG)/usr/lib$(LIBSUFFIX)/xorg/modules/multimedia ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" bt829_drv.la fi1236_drv.la msp3430_drv.la \
	                                    tda8425_drv.la tda9850_drv.la tda9885_drv.la \
	                                    uda1380_drv.la ; \
	 )
	@( cd $(XORG_PKG)/usr/lib$(LIBSUFFIX)/xorg/modules/extensions ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libglx.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(XORG_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/xorg/modules ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libexa.la libfb.la libfbdevhw.la        \
	                                            libint10.la libshadow.la libshadowfb.la \
	                                            libvbe.la libvgahw.la libwfb.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libexa.la libfb.la libfbdevhw.la        \
	                                              libint10.la libshadow.la libshadowfb.la \
	                                              libvbe.la libvgahw.la libwfb.la ; \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/xorg/modules/multimedia ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" bt829_drv.la fi1236_drv.la msp3430_drv.la    \
	                                            tda8425_drv.la tda9850_drv.la tda9885_drv.la \
	                                            uda1380_drv.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" bt829_drv.la fi1236_drv.la msp3430_drv.la    \
	                                              tda8425_drv.la tda9850_drv.la tda9885_drv.la \
	                                              uda1380_drv.la ; \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/xorg/modules/extensions ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libglx.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libglx.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" xorg-server.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(XORG_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(XORG_PKG)/usr/bin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(XORG_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(XORG_PKG_DESCRIPTION_FILE): $(XORG_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(XORG_PKG_DESCRIPTION_FILE) $(XORG_PKG_INSTALL_SCRIPT)
	@cp $(XORG_PKG_DESCRIPTION_FILE) $(XORG_PKG)/.DESCRIPTION
	@cp $(XORG_PKG_INSTALL_SCRIPT) $(XORG_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(XORG_PKG)/.REQUIRES
	@echo "pkgname=$(XORG_PKG_NAME)"                            >  $(XORG_PKG)/.PKGINFO ; \
	 echo "pkgver=$(XORG_PKG_VERSION)"                          >> $(XORG_PKG)/.PKGINFO ; \
	 echo "arch=$(XORG_PKG_ARCH)"                               >> $(XORG_PKG)/.PKGINFO ; \
	 echo "distroname=$(XORG_PKG_DISTRO_NAME)"                  >> $(XORG_PKG)/.PKGINFO ; \
	 echo "distrover=$(XORG_PKG_DISTRO_VERSION)"                >> $(XORG_PKG)/.PKGINFO ; \
	 echo "group=$(XORG_PKG_GROUP)"                             >> $(XORG_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(XORG_PKG_SHORT_DESCRIPTION)\"" >> $(XORG_PKG)/.PKGINFO ; \
	 echo "url=$(XORG_PKG_URL)"                                 >> $(XORG_PKG)/.PKGINFO ; \
	 echo "license=$(XORG_PKG_LICENSE)"                         >> $(XORG_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(XORG_PKG) && \
	                    chown -R root:root     . && \
	                    chmod 04755 usr/bin/Xorg && \
	                    $(MAKE_PACKAGE) --linkadd yes .."
