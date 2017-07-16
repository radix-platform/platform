
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/x/gst-plugins-base

REQUIRES           = libs/gst-plugins-base0/0.10.36
REQUIRES          += libs/gstreamer0/0.10.36-x86_32
REQUIRES          += libs/alsa-lib/1.1.1-x86_32
REQUIRES          += libs/libvorbis/1.3.5-x86_32
REQUIRES          += libs/libtheora/1.1.1-x86_32
REQUIRES          += app/cdparanoia/10.2-x86_32
REQUIRES          += libs/libvisual/0.4.0-x86_32
REQUIRES          += libs/pango/1.40.1-x86_32
REQUIRES          += X11/X.org/lib/libXv/1.0.10-x86_32
REQUIRES          += X11/X.org/lib/libSM/1.2.2-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 0.10.36
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/x/gst-plugins-base/gst-plugins-base-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/gst-plugins-base-$(version)
src_dir_name       = gst-plugins-base-$(version)
doc_dir_name       = gst-plugins-base0-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
GSTP_BASE_32_PKG_NAME                = gst-plugins-base0-x32
GSTP_BASE_32_PKG_VERSION             = 0.10.36
GSTP_BASE_32_PKG_ARCH                = $(TOOLCHAIN)
GSTP_BASE_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
GSTP_BASE_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
GSTP_BASE_32_PKG_GROUP               = $(PKG_GROUP)
###                                   |---handy-ruler-------------------------------|
GSTP_BASE_32_PKG_SHORT_DESCRIPTION   = base set of GStreamer plugins
GSTP_BASE_32_PKG_URL                 = $(BUG_URL)
GSTP_BASE_32_PKG_LICENSE             = GPLv2
GSTP_BASE_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GSTP_BASE_32_PKG_NAME)-pkg-description
GSTP_BASE_32_PKG_DESCRIPTION_FILE_IN = $(GSTP_BASE_32_PKG_NAME)-pkg-description.in
GSTP_BASE_32_PKG_INSTALL_SCRIPT      = $(GSTP_BASE_32_PKG_NAME)-pkg-install.sh

GSTP_BASE_32_PKG = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GSTP_BASE_32_PKG_NAME)-package

pkg_basename     = $(GSTP_BASE_32_PKG_NAME)-$(GSTP_BASE_32_PKG_VERSION)-$(GSTP_BASE_32_PKG_ARCH)-$(GSTP_BASE_32_PKG_DISTRO_NAME)-$(GSTP_BASE_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(GSTP_BASE_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(doc_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --bindir=/usr/bin/32
extra_configure_switches += --libexecdir=/usr/libexec/32

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
	@mkdir -p $(GSTP_BASE_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(GSTP_BASE_32_PKG)/usr/include
	@rm -rf $(GSTP_BASE_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(GSTP_BASE_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libgstapp-?.??.la libgstaudio-?.??.la             \
	                                    libgstcdda-?.??.la libgstfft-?.??.la              \
	                                    libgstinterfaces-?.??.la libgstnetbuffer-?.??.la  \
	                                    libgstpbutils-?.??.la libgstriff-?.??.la          \
	                                    libgstrtp-?.??.la libgstrtsp-?.??.la              \
	                                    libgstsdp-?.??.la libgsttag-?.??.la               \
	                                    libgstvideo-?.??.la                             ; \
	 )
	@( cd $(GSTP_BASE_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/gstreamer-?.?? ; \
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
	$(call install-into-devenv, $(GSTP_BASE_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
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
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/gstreamer-?.?? ; \
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
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
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
	@( cd $(GSTP_BASE_32_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(GSTP_BASE_32_PKG)/usr/bin/32 ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(GSTP_BASE_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(GSTP_BASE_32_PKG_DESCRIPTION_FILE): $(GSTP_BASE_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(GSTP_BASE_32_PKG_DESCRIPTION_FILE) $(GSTP_BASE_32_PKG_INSTALL_SCRIPT)
	@cp $(GSTP_BASE_32_PKG_DESCRIPTION_FILE) $(GSTP_BASE_32_PKG)/.DESCRIPTION
	@cp $(GSTP_BASE_32_PKG_INSTALL_SCRIPT) $(GSTP_BASE_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GSTP_BASE_32_PKG)/.REQUIRES
	@echo "pkgname=$(GSTP_BASE_32_PKG_NAME)"                            >  $(GSTP_BASE_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GSTP_BASE_32_PKG_VERSION)"                          >> $(GSTP_BASE_32_PKG)/.PKGINFO ; \
	 echo "arch=$(GSTP_BASE_32_PKG_ARCH)"                               >> $(GSTP_BASE_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(GSTP_BASE_32_PKG_DISTRO_NAME)"                  >> $(GSTP_BASE_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(GSTP_BASE_32_PKG_DISTRO_VERSION)"                >> $(GSTP_BASE_32_PKG)/.PKGINFO ; \
	 echo "group=$(GSTP_BASE_32_PKG_GROUP)"                             >> $(GSTP_BASE_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GSTP_BASE_32_PKG_SHORT_DESCRIPTION)\"" >> $(GSTP_BASE_32_PKG)/.PKGINFO ; \
	 echo "url=$(GSTP_BASE_32_PKG_URL)"                                 >> $(GSTP_BASE_32_PKG)/.PKGINFO ; \
	 echo "license=$(GSTP_BASE_32_PKG_LICENSE)"                         >> $(GSTP_BASE_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(GSTP_BASE_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
