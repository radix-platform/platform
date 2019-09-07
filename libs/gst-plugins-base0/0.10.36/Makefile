
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


SOURCE_REQUIRES    = sources/packages/x/gst-plugins-base
SOURCE_REQUIRES   += sources/hal/omap543x/glsdk/gst-plugins-base0.10

REQUIRES           = libs/gstreamer0/0.10.36
REQUIRES          += libs/alsa-lib/1.1.1
REQUIRES          += libs/libvorbis/1.3.5
REQUIRES          += libs/libtheora/1.1.1
REQUIRES          += app/cdparanoia/10.2
REQUIRES          += libs/libvisual/0.4.0
REQUIRES          += libs/pango/1.40.1
REQUIRES          += X11/X.org/lib/libXv/1.0.10
REQUIRES          += X11/X.org/lib/libSM/1.2.2

# ======= __END_OF_REQUIRES__ =======


version            = 0.10.36
ifneq ($(filter $(HARDWARE),$(HARDWARE_OMAP5UEVM) $(HARDWARE_DRA7XXEVM)),)
tar_xz_archive     = $(SRC_PACKAGE_PATH)/hal/omap543x/glsdk/gst-plugins-base0.10/gst-plugins-base-ti-$(version).tar.xz
else
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/x/gst-plugins-base/gst-plugins-base-$(version).tar.xz
endif
SRC_ARCHIVE        = $(tar_xz_archive)

ifneq ($(filter $(HARDWARE),$(HARDWARE_OMAP5UEVM) $(HARDWARE_DRA7XXEVM)),)
src_dir_name       = gst-plugins-base-ti-$(version)
else
src_dir_name       = gst-plugins-base-$(version)
endif
SRC_DIR            = $(TARGET_BUILD_DIR)/$(src_dir_name)

doc_dir_name       = gst-plugins-base0-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

ifneq ($(filter $(HARDWARE),$(HARDWARE_OMAP5UEVM) $(HARDWARE_DRA7XXEVM)),)
PATCHES = PATCHES.omap543x
else
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC32)),)
PATCHES = PATCHES.x86_32
else
PATCHES = PATCHES
endif
endif

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
GSTP_BASE_PKG_NAME                = gst-plugins-base0
GSTP_BASE_PKG_VERSION             = 0.10.36
GSTP_BASE_PKG_ARCH                = $(TOOLCHAIN)
GSTP_BASE_PKG_DISTRO_NAME         = $(DISTRO_NAME)
GSTP_BASE_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
GSTP_BASE_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
GSTP_BASE_PKG_SHORT_DESCRIPTION   = base set of GStreamer plugins
GSTP_BASE_PKG_URL                 = $(BUG_URL)
GSTP_BASE_PKG_LICENSE             = GPLv2
GSTP_BASE_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GSTP_BASE_PKG_NAME)-pkg-description
GSTP_BASE_PKG_DESCRIPTION_FILE_IN = $(GSTP_BASE_PKG_NAME)-pkg-description.in
GSTP_BASE_PKG_INSTALL_SCRIPT      = $(GSTP_BASE_PKG_NAME)-pkg-install.sh

GSTP_BASE_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GSTP_BASE_PKG_NAME)-package

pkg_basename     = $(GSTP_BASE_PKG_NAME)-$(GSTP_BASE_PKG_VERSION)-$(GSTP_BASE_PKG_ARCH)-$(GSTP_BASE_PKG_DISTRO_NAME)-$(GSTP_BASE_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(GSTP_BASE_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(doc_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --disable-debug

extra_configure_switches += --disable-gnome_vfs
extra_configure_switches += --disable-oggtest
extra_configure_switches += --disable-vorbistest
extra_configure_switches += --disable-freetypetest
extra_configure_switches += --disable-examples

extra_configure_switches += --with-package-name="GStreamer Base Plugins ($(DISTRO_CAPTION) Linux)"
extra_configure_switches += --with-package-origin="$(BUG_URL)"

extra_configure_switches += --enable-introspection=no
extra_configure_switches += --enable-gtk-doc=no

extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)
TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
ifneq ($(filter $(HARDWARE),$(HARDWARE_OMAP5UEVM) $(HARDWARE_DRA7XXEVM)),)
	@( cd $(SRC_DIR) ; ./autogen.sh ; make distclean )
endif
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
	@mkdir -p $(GSTP_BASE_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(GSTP_BASE_PKG)/usr/share/man ]; then \
	  ( cd $(GSTP_BASE_PKG)/usr/share/man ; \
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
ifneq ($(filter $(HARDWARE),$(HARDWARE_OMAP5UEVM) $(HARDWARE_DRA7XXEVM)),)
	# ======= TI GLSDK gst-plugins-base doesn't have HTML Documentation =======
else
	@mkdir -p $(GSTP_BASE_PKG)/usr/share/gtk-doc/html/gst-plugins-base{-libs,-plugins}-0.10
	@( cd $(SRC_DIR)/docs/libs/html ; \
	   cp -a *.html *.css *.png \
	         $(GSTP_BASE_PKG)/usr/share/gtk-doc/html/gst-plugins-base-libs-0.10 ; \
	 )
	@( cd $(SRC_DIR)/docs/plugins/html ; \
	   cp -a *.html *.css *.png \
	         $(GSTP_BASE_PKG)/usr/share/gtk-doc/html/gst-plugins-base-plugins-0.10 ; \
	 )
endif
	@mkdir -p $(GSTP_BASE_PKG)/usr/doc/$(doc_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING* \
	       $(GSTP_BASE_PKG)/usr/doc/$(doc_dir_name)
	@mkdir -p $(GSTP_BASE_PKG)/usr/share/doc/$(doc_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING* INSTALL NEWS README RELEASE REQUIREMENTS \
	         $(GSTP_BASE_PKG)/usr/share/doc/$(doc_dir_name) ; \
	 )
ifeq ($(filter $(HARDWARE),$(HARDWARE_OMAP5UEVM) $(HARDWARE_DRA7XXEVM)),)
	@mkdir -p $(GSTP_BASE_PKG)/usr/share/doc/$(doc_dir_name)/html
	@ln -sf ../../../gtk-doc/html/gst-plugins-base-libs-0.10 $(GSTP_BASE_PKG)/usr/share/doc/$(doc_dir_name)/html/gst-plugins-base-libs-0.10
	@ln -sf ../../../gtk-doc/html/gst-plugins-base-plugins-0.10 $(GSTP_BASE_PKG)/usr/share/doc/$(doc_dir_name)/html/gst-plugins-base-plugins-0.10
endif
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(GSTP_BASE_PKG)/usr/share/doc/$(doc_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(GSTP_BASE_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libgstapp-?.??.la libgstaudio-?.??.la             \
	                                    libgstcdda-?.??.la libgstfft-?.??.la              \
	                                    libgstinterfaces-?.??.la libgstnetbuffer-?.??.la  \
	                                    libgstpbutils-?.??.la libgstriff-?.??.la          \
	                                    libgstrtp-?.??.la libgstrtsp-?.??.la              \
	                                    libgstsdp-?.??.la libgsttag-?.??.la               \
	                                    libgstvideo-?.??.la                             ; \
	 )
	@( cd $(GSTP_BASE_PKG)/usr/lib$(LIBSUFFIX)/gstreamer-?.?? ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libgstadder.la libgstalsa.la                    \
	                                    libgstapp.la libgstaudioconvert.la              \
	                                    libgstaudiorate.la libgstaudioresample.la       \
	                                    libgstaudiotestsrc.la libgstcdparanoia.la       \
	                                    libgstdecodebin.la libgstdecodebin2.la          \
	                                    libgstencodebin.la libgstffmpegcolorspace.la    \
	                                    libgstgdp.la libgstgio.la libgstlibvisual.la    \
	                                    libgstogg.la libgstpango.la libgstplaybin.la    \
	                                    libgstsubparse.la libgsttcp.la libgsttheora.la  \
	                                    libgsttypefindfunctions.la libgstvideorate.la   \
	                                    libgstvideoscale.la libgstvideotestsrc.la       \
	                                    libgstvolume.la libgstvorbis.la                 \
	                                    libgstximagesink.la libgstxvimagesink.la      ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(GSTP_BASE_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libgstapp-?.??.la libgstaudio-?.??.la             \
	                                            libgstcdda-?.??.la libgstfft-?.??.la              \
	                                            libgstinterfaces-?.??.la libgstnetbuffer-?.??.la  \
	                                            libgstpbutils-?.??.la libgstriff-?.??.la          \
	                                            libgstrtp-?.??.la libgstrtsp-?.??.la              \
	                                            libgstsdp-?.??.la libgsttag-?.??.la               \
	                                            libgstvideo-?.??.la                             ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libgstapp-?.??.la libgstaudio-?.??.la             \
	                                              libgstcdda-?.??.la libgstfft-?.??.la              \
	                                              libgstinterfaces-?.??.la libgstnetbuffer-?.??.la  \
	                                              libgstpbutils-?.??.la libgstriff-?.??.la          \
	                                              libgstrtp-?.??.la libgstrtsp-?.??.la              \
	                                              libgstsdp-?.??.la libgsttag-?.??.la               \
	                                              libgstvideo-?.??.la                             ; \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/gstreamer-?.?? ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libgstadder.la libgstalsa.la                    \
	                                            libgstapp.la libgstaudioconvert.la              \
	                                            libgstaudiorate.la libgstaudioresample.la       \
	                                            libgstaudiotestsrc.la libgstcdparanoia.la       \
	                                            libgstdecodebin.la libgstdecodebin2.la          \
	                                            libgstencodebin.la libgstffmpegcolorspace.la    \
	                                            libgstgdp.la libgstgio.la libgstlibvisual.la    \
	                                            libgstogg.la libgstpango.la libgstplaybin.la    \
	                                            libgstsubparse.la libgsttcp.la libgsttheora.la  \
	                                            libgsttypefindfunctions.la libgstvideorate.la   \
	                                            libgstvideoscale.la libgstvideotestsrc.la       \
	                                            libgstvolume.la libgstvorbis.la                 \
	                                            libgstximagesink.la libgstxvimagesink.la      ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libgstadder.la libgstalsa.la                    \
	                                              libgstapp.la libgstaudioconvert.la              \
	                                              libgstaudiorate.la libgstaudioresample.la       \
	                                              libgstaudiotestsrc.la libgstcdparanoia.la       \
	                                              libgstdecodebin.la libgstdecodebin2.la          \
	                                              libgstencodebin.la libgstffmpegcolorspace.la    \
	                                              libgstgdp.la libgstgio.la libgstlibvisual.la    \
	                                              libgstogg.la libgstpango.la libgstplaybin.la    \
	                                              libgstsubparse.la libgsttcp.la libgsttheora.la  \
	                                              libgsttypefindfunctions.la libgstvideorate.la   \
	                                              libgstvideoscale.la libgstvideotestsrc.la       \
	                                              libgstvolume.la libgstvorbis.la                 \
	                                              libgstximagesink.la libgstxvimagesink.la      ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" gstreamer-app-?.??.pc gstreamer-audio-?.??.pc             \
	                                            gstreamer-cdda-?.??.pc gstreamer-fft-?.??.pc              \
	                                            gstreamer-floatcast-?.??.pc gstreamer-interfaces-?.??.pc  \
	                                            gstreamer-netbuffer-?.??.pc gstreamer-pbutils-?.??.pc     \
	                                            gstreamer-plugins-base-?.??.pc gstreamer-riff-?.??.pc     \
	                                            gstreamer-rtp-?.??.pc gstreamer-rtsp-?.??.pc              \
	                                            gstreamer-sdp-?.??.pc gstreamer-tag-?.??.pc               \
	                                            gstreamer-video-?.??.pc                                 ; \
	 )
	# ======= Strip binaries =======
	@( cd $(GSTP_BASE_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(GSTP_BASE_PKG)/usr/bin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(GSTP_BASE_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(GSTP_BASE_PKG_DESCRIPTION_FILE): $(GSTP_BASE_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(GSTP_BASE_PKG_DESCRIPTION_FILE) $(GSTP_BASE_PKG_INSTALL_SCRIPT)
	@cp $(GSTP_BASE_PKG_DESCRIPTION_FILE) $(GSTP_BASE_PKG)/.DESCRIPTION
	@cp $(GSTP_BASE_PKG_INSTALL_SCRIPT) $(GSTP_BASE_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GSTP_BASE_PKG)/.REQUIRES
	@echo "pkgname=$(GSTP_BASE_PKG_NAME)"                            >  $(GSTP_BASE_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GSTP_BASE_PKG_VERSION)"                          >> $(GSTP_BASE_PKG)/.PKGINFO ; \
	 echo "arch=$(GSTP_BASE_PKG_ARCH)"                               >> $(GSTP_BASE_PKG)/.PKGINFO ; \
	 echo "distroname=$(GSTP_BASE_PKG_DISTRO_NAME)"                  >> $(GSTP_BASE_PKG)/.PKGINFO ; \
	 echo "distrover=$(GSTP_BASE_PKG_DISTRO_VERSION)"                >> $(GSTP_BASE_PKG)/.PKGINFO ; \
	 echo "group=$(GSTP_BASE_PKG_GROUP)"                             >> $(GSTP_BASE_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GSTP_BASE_PKG_SHORT_DESCRIPTION)\"" >> $(GSTP_BASE_PKG)/.PKGINFO ; \
	 echo "url=$(GSTP_BASE_PKG_URL)"                                 >> $(GSTP_BASE_PKG)/.PKGINFO ; \
	 echo "license=$(GSTP_BASE_PKG_LICENSE)"                         >> $(GSTP_BASE_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(GSTP_BASE_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
