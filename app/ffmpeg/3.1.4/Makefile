
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXV)
COMPONENT_TARGETS += $(HARDWARE_P201)
COMPONENT_TARGETS += $(HARDWARE_NEXBOX_A95X)
COMPONENT_TARGETS += $(HARDWARE_ODROID_C2)
COMPONENT_TARGETS += $(HARDWARE_P212)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_VIM)
COMPONENT_TARGETS += $(HARDWARE_Q201)
COMPONENT_TARGETS += $(HARDWARE_ENYBOX_X2)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/ffmpeg

REQUIRES           = libs/alsa-lib/1.1.1
REQUIRES          += X11/libs/sdl/sdl/1.2.15
REQUIRES          += X11/libs/libva/1.7.2
REQUIRES          += X11/libs/libvdpau/1.1.1
REQUIRES          += app/jack/0.125.0

REQUIRES          += libs/gmp/6.1.2
REQUIRES          += net/gnutls/3.4.8
REQUIRES          += libs/libtasn1/4.7
REQUIRES          += libs/ladspa/1.13
REQUIRES          += libs/libass/0.13.3
REQUIRES          += libs/libbluray/0.9.3
REQUIRES          += libs/libcaca/0.99.19
REQUIRES          += app/celt/0.11.3
REQUIRES          += app/faac/1.28
REQUIRES          += libs/fdk-aac/0.1.4
REQUIRES          += X11/libs/fontconfig/2.12.4
REQUIRES          += libs/freetype/2.6.3
REQUIRES          += libs/fribidi/0.19.7
REQUIRES          += libs/gsm/1.0.13
REQUIRES          += libs/libiec61883/1.2.0
REQUIRES          += libs/libmodplug/0.8.8.5
REQUIRES          += libs/lame/3.99.5
REQUIRES          += libs/opencore-amr/0.1.3
REQUIRES          += libs/openh264/1.6.0
REQUIRES          += app/openjpeg/1.5.2
REQUIRES          += libs/opus/1.1.2
REQUIRES          += libs/pulseaudio/9.0
REQUIRES          += app/rtmpdump/2.4
REQUIRES          += libs/schroedinger/1.0.11
REQUIRES          += libs/libsoxr/0.1.2
REQUIRES          += libs/speex/1.2rc2
REQUIRES          += libs/libssh/0.7.3
REQUIRES          += libs/libtheora/1.1.1
REQUIRES          += app/twolame/0.3.13
REQUIRES          += libs/v4l-utils/1.10.1
REQUIRES          += libs/libvidstab/1.1
REQUIRES          += libs/vo-amrwbenc/0.1.3
REQUIRES          += libs/libvorbis/1.3.5
REQUIRES          += libs/libvpx/1.5.0
REQUIRES          += libs/wavpack/4.75.2
REQUIRES          += libs/libwebp/0.5.0
REQUIRES          += libs/libx264/0.148.20160920
REQUIRES          += libs/x265/2.1
REQUIRES          += libs/xvidcore/1.3.4
REQUIRES          += libs/zeromq/4.1.4
REQUIRES          += libs/zvbi/0.2.35
REQUIRES          += libs/netcdf/4.4.1
REQUIRES          += X11/X.org/xcb/libxcb/1.11.1

# ======= __END_OF_REQUIRES__ =======


version            = 3.1.4
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/m/ffmpeg/ffmpeg-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/ffmpeg-$(version)
src_dir_name       = ffmpeg-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
FFMPEG_PKG_NAME                = ffmpeg
FFMPEG_PKG_VERSION             = 3.1.4
FFMPEG_PKG_ARCH                = $(TOOLCHAIN)
FFMPEG_PKG_DISTRO_NAME         = $(DISTRO_NAME)
FFMPEG_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
FFMPEG_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
FFMPEG_PKG_SHORT_DESCRIPTION   = FFmpeg collection
FFMPEG_PKG_URL                 = $(BUG_URL)
FFMPEG_PKG_LICENSE             = LGPLv2.1
FFMPEG_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(FFMPEG_PKG_NAME)-pkg-description
FFMPEG_PKG_DESCRIPTION_FILE_IN = $(FFMPEG_PKG_NAME)-pkg-description.in
FFMPEG_PKG_INSTALL_SCRIPT      = $(FFMPEG_PKG_NAME)-pkg-install.sh

FFMPEG_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(FFMPEG_PKG_NAME)-package

pkg_basename     = $(FFMPEG_PKG_NAME)-$(FFMPEG_PKG_VERSION)-$(FFMPEG_PKG_ARCH)-$(FFMPEG_PKG_DISTRO_NAME)-$(FFMPEG_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(FFMPEG_PKG)


ENABLE_X86_YASM = no


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)
TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


#
# NOTE: use generic CPU to avoid FFmpeg's desisions about CPU
#
ifneq ($(filter $(HARDWARE),$(HARDWARE_CB1X)      \
                            $(HARDWARE_CB2X)      \
                            $(HARDWARE_CB3X)      \
                            $(HARDWARE_FFRK3288)  \
                            $(HARDWARE_M201) $(HARDWARE_MXV) \
                            $(HARDWARE_NIT6Q)     \
                            $(HARDWARE_OMAP5UEVM) \
                            $(HARDWARE_DRA7XXEVM)),)
ARCH = arm
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_P201) $(HARDWARE_NEXBOX_A95X) \
                                             $(HARDWARE_ODROID_C2)   \
                            $(HARDWARE_P212) $(HARDWARE_KHADAS_VIM)  \
                            $(HARDWARE_Q201) $(HARDWARE_ENYBOX_X2)),)
ARCH = aarch64
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC32)),)
ARCH = i686
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC64)),)
ARCH = x86_64
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_CI20) $(HARDWARE_BT1)),)
ARCH = mips
endif



extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man

extra_configure_switches += --bindir=/usr/bin

extra_configure_switches += --arch=$(ARCH)
extra_configure_switches += --enable-cross-compile

ifneq ($(filter $(HARDWARE),$(HARDWARE_PC32) $(HARDWARE_PC64)),)
ifneq ($(ENABLE_X86_YASM),yes)
extra_configure_switches += --disable-yasm
endif
endif

ifneq ($(filter $(HARDWARE),$(HARDWARE_CI20) $(HARDWARE_BT1)),)
extra_configure_switches += --disable-mipsdsp
extra_configure_switches += --disable-mipsdspr2
endif

extra_configure_switches += --target-os=linux
extra_configure_switches += --nm='$(CROSS_PREFIX)nm -g'
extra_configure_switches += --ar='$(CROSS_PREFIX)ar'
extra_configure_switches += --as='$(CROSS_PREFIX)gcc'
extra_configure_switches += --ranlib='$(CROSS_PREFIX)ranlib'
extra_configure_switches += --strip='$(CROSS_PREFIX)strip'
extra_configure_switches += --yasmexe=/usr/bin/yasm

extra_configure_switches += --cc='$(CROSS_PREFIX)gcc'
extra_configure_switches += --cxx='$(CROSS_PREFIX)g++'
extra_configure_switches += --objcc='$(CROSS_PREFIX)gcc'
extra_configure_switches += --dep-cc='$(CROSS_PREFIX)gcc'
extra_configure_switches += --ld='$(CROSS_PREFIX)gcc'


extra_configure_switches += --extra-cflags='--sysroot=$(TARGET_DEST_DIR) $(CFLAGS) $(ARCH_FLAGS) $(ARCH_DEFS) $(HW_FLAGS) $(WARN_FLAGS)'
extra_configure_switches += --extra-cxxflags='--sysroot=$(TARGET_DEST_DIR) $(CFLAGS) $(ARCH_FLAGS) $(ARCH_DEFS) $(HW_FLAGS) $(WARN_FLAGS)'
extra_configure_switches += --extra-objcflags='--sysroot=$(TARGET_DEST_DIR) $(CFLAGS) $(ARCH_FLAGS) $(ARCH_DEFS) $(HW_FLAGS) $(WARN_FLAGS)'
extra_configure_switches += --extra-ldflags='--sysroot=$(TARGET_DEST_DIR) -L$(TARGET_DEST_DIR)/lib$(LIBSUFFIX) -L$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)'
extra_configure_switches += --extra-ldexeflags='--sysroot=$(TARGET_DEST_DIR) -L$(TARGET_DEST_DIR)/lib$(LIBSUFFIX) -L$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) -Wl,-rpath,$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)'
extra_configure_switches += --extra-ldlibflags='--sysroot=$(TARGET_DEST_DIR) -L$(TARGET_DEST_DIR)/lib$(LIBSUFFIX) -L$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) -Wl,-rpath,$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)'
extra_configure_switches += --disable-rpath


extra_configure_switches += --host-cc=gcc
extra_configure_switches += --host-cflags='-I/usr/include'
extra_configure_switches += --host-cppflags='-I/usr/include'
extra_configure_switches += --host-ld=gcc
extra_configure_switches += --host-ldflags='-L/usr/lib$(BUILD_MULTILIB_SUFFIX)'
extra_configure_switches += --host-os=linux

extra_configure_switches += --enable-pic

extra_configure_switches += --enable-shared


#
# Configure options:
#
extra_configure_switches += --enable-gpl
extra_configure_switches += --enable-nonfree
extra_configure_switches += --enable-version3
extra_configure_switches += --disable-debug
extra_configure_switches += --disable-stripping
#
# Component options:
#
extra_configure_switches += --enable-avresample
#
# External library support:
#
extra_configure_switches += --enable-gmp
extra_configure_switches += --enable-gnutls
extra_configure_switches += --enable-ladspa
extra_configure_switches += --enable-libass
extra_configure_switches += --enable-libbluray
extra_configure_switches += --enable-libcaca
extra_configure_switches += --enable-libcelt
extra_configure_switches += --enable-libfaac
extra_configure_switches += --enable-libfdk-aac
extra_configure_switches += --enable-libfontconfig
extra_configure_switches += --enable-libfreetype
extra_configure_switches += --enable-libfribidi
extra_configure_switches += --enable-libgsm
extra_configure_switches += --enable-libiec61883
extra_configure_switches += --enable-libmodplug
extra_configure_switches += --enable-libmp3lame
extra_configure_switches += --enable-libopencore-amrnb
extra_configure_switches += --enable-libopencore-amrwb
extra_configure_switches += --enable-libopenh264
extra_configure_switches += --enable-libopenjpeg
extra_configure_switches += --enable-libopus
extra_configure_switches += --enable-libpulse
extra_configure_switches += --enable-librtmp
extra_configure_switches += --enable-libschroedinger
extra_configure_switches += --enable-libsoxr
extra_configure_switches += --enable-libspeex
extra_configure_switches += --enable-libssh
extra_configure_switches += --enable-libtheora
extra_configure_switches += --enable-libtwolame
extra_configure_switches += --enable-libv4l2
extra_configure_switches += --enable-libvidstab
extra_configure_switches += --enable-libvo-amrwbenc
extra_configure_switches += --enable-libvorbis
extra_configure_switches += --enable-libvpx
extra_configure_switches += --enable-libwavpack
extra_configure_switches += --enable-libwebp
extra_configure_switches += --enable-libx264
extra_configure_switches += --enable-libx265
extra_configure_switches += --enable-libxcb
extra_configure_switches += --enable-libxcb-shm
extra_configure_switches += --enable-libxcb-xfixes
extra_configure_switches += --enable-libxcb-shape
extra_configure_switches += --enable-libxvid
extra_configure_switches += --enable-libzmq
extra_configure_switches += --enable-libzvbi
extra_configure_switches += --enable-netcdf
extra_configure_switches += --enable-opengl
extra_configure_switches += --enable-x11grab


CPPFLAGS += -Wno-deprecated-declarations -Wno-unused-but-set-variable
CPPFLAGS += -Wno-unused-result -Wno-strict-overflow -Wno-discarded-qualifiers
CPPFLAGS += -Wno-array-bounds -Wno-unused-function -Wno-undef


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && \
	  $(BUILD_ENVIRONMENT) ./configure \
	  --prefix=/usr               \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(FFMPEG_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(FFMPEG_PKG)/usr/share/man ]; then \
	  ( cd $(FFMPEG_PKG)/usr/share/man ; \
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
	@mkdir -p $(FFMPEG_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING* $(SRC_DIR)/LICENSE.md \
	       $(FFMPEG_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(FFMPEG_PKG)/usr/share/doc/$(src_dir_name)/html
	@( cd $(FFMPEG_PKG)/usr/share/doc/$(src_dir_name) ; \
	   mv *.html html ; \
	 )
	@( cd $(SRC_DIR)/doc ; \
	   cp -a bootstrap.min.css style.min.css default.css \
	         $(FFMPEG_PKG)/usr/share/doc/$(src_dir_name)/html ; \
	 )
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING* CREDITS INSTALL.md LICENSE.md MAINTAINERS README.md RELEASE* VERSION \
	         $(FFMPEG_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog -a -s ChangeLog ]; then \
	     DOCSDIR=`echo $(FFMPEG_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove target path from target pkg-config *.pc files =======
	@( cd $(FFMPEG_PKG)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libavcodec.pc libavdevice.pc libavfilter.pc     \
	                                    libavformat.pc libavresample.pc libavutil.pc    \
	                                    libpostproc.pc libswresample.pc libswscale.pc ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(FFMPEG_PKG))
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libavcodec.pc libavdevice.pc libavfilter.pc     \
	                                            libavformat.pc libavresample.pc libavutil.pc    \
	                                            libpostproc.pc libswresample.pc libswscale.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(FFMPEG_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(FFMPEG_PKG)/usr/bin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH" | cut -f2 -d'='` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       rpath=`echo $$rpath | sed "s,$(TARGET_DEST_DIR),,g"` ; \
	       $(CHRPATH) -r $$rpath $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(FFMPEG_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH" | cut -f2 -d'='` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       rpath=`echo $$rpath | sed "s,$(TARGET_DEST_DIR),,g"` ; \
	       $(CHRPATH) -r $$rpath $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(FFMPEG_PKG_DESCRIPTION_FILE): $(FFMPEG_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(FFMPEG_PKG_DESCRIPTION_FILE) $(FFMPEG_PKG_INSTALL_SCRIPT)
	@cp $(FFMPEG_PKG_DESCRIPTION_FILE) $(FFMPEG_PKG)/.DESCRIPTION
	@cp $(FFMPEG_PKG_INSTALL_SCRIPT) $(FFMPEG_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(FFMPEG_PKG)/.REQUIRES
	@echo "pkgname=$(FFMPEG_PKG_NAME)"                            >  $(FFMPEG_PKG)/.PKGINFO ; \
	 echo "pkgver=$(FFMPEG_PKG_VERSION)"                          >> $(FFMPEG_PKG)/.PKGINFO ; \
	 echo "arch=$(FFMPEG_PKG_ARCH)"                               >> $(FFMPEG_PKG)/.PKGINFO ; \
	 echo "distroname=$(FFMPEG_PKG_DISTRO_NAME)"                  >> $(FFMPEG_PKG)/.PKGINFO ; \
	 echo "distrover=$(FFMPEG_PKG_DISTRO_VERSION)"                >> $(FFMPEG_PKG)/.PKGINFO ; \
	 echo "group=$(FFMPEG_PKG_GROUP)"                             >> $(FFMPEG_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(FFMPEG_PKG_SHORT_DESCRIPTION)\"" >> $(FFMPEG_PKG)/.PKGINFO ; \
	 echo "url=$(FFMPEG_PKG_URL)"                                 >> $(FFMPEG_PKG)/.PKGINFO ; \
	 echo "license=$(FFMPEG_PKG_LICENSE)"                         >> $(FFMPEG_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(FFMPEG_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
