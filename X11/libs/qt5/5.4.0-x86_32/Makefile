
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/x/qt5

REQUIRES           = X11/libs/qt5/5.4.0

REQUIRES          += libs/alsa-lib/1.0.28-x86_32
REQUIRES          += X11/app/dbus-x11-launch/1.8.10-x86_32

REQUIRES          += libs/libmng/2.0.2-x86_32
REQUIRES          += libs/icu4c/54.1-x86_32
REQUIRES          += app/cups/2.0.1-x86_32

REQUIRES          += X11/libs/fontconfig/2.11.1-x86_32

REQUIRES          += X11/X.org/lib/libXaw/1.0.12-x86_32
REQUIRES          += X11/X.org/lib/libXcursor/1.1.14-x86_32
REQUIRES          += X11/X.org/lib/libXi/1.7.4-x86_32
REQUIRES          += X11/X.org/lib/libXinerama/1.1.3-x86_32
REQUIRES          += X11/X.org/lib/libXrandr/1.4.2-x86_32
REQUIRES          += X11/X.org/lib/libXv/1.0.10-x86_32
REQUIRES          += X11/X.org/lib/libxkbfile/1.0.8-x86_32

REQUIRES          += X11/X.org/xcb/xcb-util-cursor/0.1.1-x86_32
REQUIRES          += X11/X.org/xcb/xcb-util-keysyms/0.4.0-x86_32
REQUIRES          += X11/X.org/xcb/xcb-util-wm/0.4.1-x86_32

REQUIRES          += libs/gstreamer/1.4.5-x86_32
REQUIRES          += libs/gst-plugins-base/1.4.5-x86_32

REQUIRES          += app/sqlite/3.8.7.1-x86_32
REQUIRES          += app/mariadb/5.5.41-x86_32
REQUIRES          += libs/libiodbc/3.52.9-x86_32

REQUIRES          += X11/libs/opengl-collection

# ======= __END_OF_REQUIRES__ =======


version            = 5.4.0
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/x/qt5/qt-everywhere-opensource-src-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/qt-everywhere-opensource-src-$(version)
src_dir_name       = qt-everywhere-opensource-src-$(version)
doc_dir_name       = qt5-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

pkgconfig_in       = $(CURDIR)/pkgconfig/Qt5.pc.in
profile_dir        = $(CURDIR)/profile.d


PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = xlibs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
QT5_32_PKG_NAME                = qt5-x32
QT5_32_PKG_VERSION             = 5.4.0
QT5_32_PKG_ARCH                = $(TOOLCHAIN)
QT5_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
QT5_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
QT5_32_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
QT5_32_PKG_SHORT_DESCRIPTION   = graphical user interface toolkit
QT5_32_PKG_URL                 = $(BUG_URL)
QT5_32_PKG_LICENSE             = GPLv3
QT5_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(QT5_32_PKG_NAME)-pkg-description
QT5_32_PKG_DESCRIPTION_FILE_IN = $(QT5_32_PKG_NAME)-pkg-description.in
QT5_32_PKG_INSTALL_SCRIPT      = $(QT5_32_PKG_NAME)-pkg-install.sh

QT5_32_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(QT5_32_PKG_NAME)-package

pkg_basename     = $(QT5_32_PKG_NAME)-$(QT5_32_PKG_VERSION)-$(QT5_32_PKG_ARCH)-$(QT5_32_PKG_DISTRO_NAME)-$(QT5_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../build-system/core.mk


env_sysroot = INSTALL_ROOT=$(QT5_32_PKG)


ARCH   = i386
ABI    = gnu


TARGET_SPEC_DIR = linux-$(ARCH)-$(ABI)-g++
DEVICE_SPEC_DIR = linux-$(HARDWARE)-g++

QT_BUILD_ENVIRONMENT  = export PKG_CONFIG=/usr/bin/pkg-config ;
QT_BUILD_ENVIRONMENT += export PKG_CONFIG_SYSROOT_DIR=$(TARGET_DEST_DIR) ;
QT_BUILD_ENVIRONMENT += export PKG_CONFIG_PATH=$(ROOTFS_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig:$(ROOTFS_DEST_DIR)/usr/share/pkgconfig ;
QT_BUILD_ENVIRONMENT += export PKG_CONFIG_LIBDIR=$(ROOTFS_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig:$(ROOTFS_DEST_DIR)/usr/share/pkgconfig ;


configure_switches  = -confirm-license
configure_switches += -opensource
configure_switches += -device $(HARDWARE)
configure_switches += -device-option CCACHE=$(CCACHE)
configure_switches += -device-option CROSS_COMPILE=$(CROSS_PREFIX)

configure_switches += -sysroot $(TARGET_DEST_DIR)
configure_switches += -extprefix /usr/lib$(MULTILIB_X86_32_SUFFIX)/qt5

configure_switches += -sysconfdir     /etc/xdg
configure_switches += -bindir         /usr/lib$(MULTILIB_X86_32_SUFFIX)/qt5/bin
configure_switches += -headerdir      /usr/lib$(MULTILIB_X86_32_SUFFIX)/qt5/include
configure_switches += -libdir         /usr/lib$(MULTILIB_X86_32_SUFFIX)/qt5/lib
configure_switches += -archdatadir    /usr/lib$(MULTILIB_X86_32_SUFFIX)/qt5
configure_switches += -plugindir      /usr/lib$(MULTILIB_X86_32_SUFFIX)/qt5/plugins
configure_switches += -libexecdir     /usr/lib$(MULTILIB_X86_32_SUFFIX)/qt5/libexec
configure_switches += -importdir      /usr/lib$(MULTILIB_X86_32_SUFFIX)/qt5/imports
configure_switches += -qmldir         /usr/lib$(MULTILIB_X86_32_SUFFIX)/qt5/qml
configure_switches += -datadir        /usr/lib$(MULTILIB_X86_32_SUFFIX)/qt5
configure_switches += -docdir         /usr/lib$(MULTILIB_X86_32_SUFFIX)/qt5/doc
configure_switches += -translationdir /usr/lib$(MULTILIB_X86_32_SUFFIX)/qt5/translations
configure_switches += -examplesdir    /usr/lib$(MULTILIB_X86_32_SUFFIX)/qt5/examples
configure_switches += -testsdir       /usr/lib$(MULTILIB_X86_32_SUFFIX)/qt5/tests

configure_switches += -release
configure_switches += -shared
configure_switches += -force-pkg-config
configure_switches += -c++11

configure_switches += -no-largefile
configure_switches += -no-gtkstyle
configure_switches += -opengl

configure_switches += -accessibility
configure_switches += -system-sqlite
configure_switches += -plugin-sql-sqlite
configure_switches += -plugin-sql-mysql
configure_switches += -plugin-sql-odbc
configure_switches += -system-zlib
configure_switches += -mtdev
configure_switches += -system-libpng
configure_switches += -system-libjpeg
configure_switches += -system-freetype
configure_switches += -system-harfbuzz
configure_switches += -openssl
configure_switches += -system-pcre
configure_switches += -system-xcb
configure_switches += -xinput2
configure_switches += -xcb-xlib
configure_switches += -glib
configure_switches += -no-pulseaudio
configure_switches += -alsa
configure_switches += -gui
configure_switches += -widgets
configure_switches += -nis
configure_switches += -cups
configure_switches += -evdev
configure_switches += -icu
configure_switches += -dbus
configure_switches += -no-use-gold-linker

configure_switches += -xcb
configure_switches += -eglfs
configure_switches += -no-directfb
configure_switches += -linuxfb
configure_switches += -kms
configure_switches += -qpa xcb

configure_switches += -qreal double
configure_switches += -no-warnings-are-errors
configure_switches += -make libs
configure_switches += -make tools
configure_switches += -nomake examples
configure_switches += -nomake tests
configure_switches += -no-strip
configure_switches += -no-pch
configure_switches += -no-rpath
configure_switches += -optimized-qmake
configure_switches += -verbose


TARGET_BIN_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX)/qt5/lib


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@cp -a $(CURDIR)/mkspecs/devices/$(DEVICE_SPEC_DIR) $(SRC_DIR)/qtbase/mkspecs/devices
	@cp -a $(CURDIR)/mkspecs/$(TARGET_SPEC_DIR) $(SRC_DIR)/qtbase/mkspecs
	@( cd $(SRC_DIR)/qtbase/mkspecs/devices/$(DEVICE_SPEC_DIR) ; \
	   cat qmake.conf.in | \
	     sed 's,@LIBDIRSUFFIX@,$(MULTILIB_X86_32_SUFFIX),g' | \
	     sed 's,@ARCH_FLAGS@,$(ARCH_FLAGS),g'               | \
	     sed 's,@ARCH_DEFS@,$(ARCH_DEFS),g'                 | \
	     sed 's,@HW_FLAGS@,$(HW_FLAGS),g'                   > qmake.conf ; \
	 )
	@( cd $(SRC_DIR)/qtbase/mkspecs/$(TARGET_SPEC_DIR) ; \
	   cat qmake.conf.in | \
	     sed 's,@CCACHE@,$(CCACHE),g'                       | \
	     sed 's,@LIBDIRSUFFIX@,$(MULTILIB_X86_32_SUFFIX),g' | \
	     sed 's,@CROSS_COMPILE@,$(CROSS_PREFIX),g'          | \
	     sed 's,@SYSROOT@,$(TARGET_DEST_DIR),g'             | \
	     sed 's,@ARCH_FLAGS@,$(ARCH_FLAGS),g'               | \
	     sed 's,@ARCH_DEFS@,$(ARCH_DEFS),g'                 | \
	     sed 's,@HW_FLAGS@,$(HW_FLAGS),g'                   > qmake.conf ; \
	 )
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && \
	  $(QT_BUILD_ENVIRONMENT) CFG_ARCH="$(ARCH)" ./configure $(configure_switches)
	@cd $(SRC_DIR) && $(QT_BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(QT5_32_PKG)
	@cd $(SRC_DIR) && $(QT_BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	# ======= Rename build-machine tools =======
	@( cd $(QT5_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/qt5/bin ; \
	   for file in lconvert lrelease lupdate moc qdbuscpp2xml qdbusxml2cpp  \
	               qdoc qlalr qmake qmlimportscanner qmllint qmlmin rcc uic ; do \
	     mv $$file $(TARGET32)-$${file}-qt5 ; \
	   done ; \
	 )
	@mkdir -p $(QT5_32_PKG)/usr/bin/32
	@( cd $(QT5_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/qt5/bin ; \
	   for file in lconvert lrelease lupdate moc qdbuscpp2xml qdbusxml2cpp  \
	               qdoc qlalr qmake qmlimportscanner qmllint qmlmin rcc uic ; do \
	     ( cd $(QT5_32_PKG)/usr/bin/32 ; ln -sf ../../../usr/lib$(MULTILIB_X86_32_SUFFIX)/qt5/bin/$(TARGET32)-$${file}-qt5 . ) ; \
	   done ; \
	 )
	# ======= Install Qmake =======
	@( cd $(SRC_DIR) ; \
	   for dir in qtbase/src/tools/bootstrap qtbase/src/tools/bootstrap-dbus \
	              qtdeclarative/src/qmldevtools qtdeclarative/tools/qmlimportscanner \
	              qtdeclarative/tools/qmllint qtdeclarative/tools/qmlmin \
	              qttools/src/linguist/lconvert qttools/src/linguist/lrelease \
	              qttools/src/linguist/lupdate \
	              qtbase/src/tools/qdbuscpp2xml qtbase/src/tools/qdbusxml2cpp \
	              qtbase/src/tools/qdoc qtbase/src/tools/qlalr \
	              qtbase/src/tools/rcc qtbase/src/tools/uic \
	              qtbase/src/tools/moc ; do \
	     back=`echo $$dir | sed 's,[a-z2-]*,\.\.,g'` ; \
	     bname=`basename $$dir` ; \
	     ( cd $$dir ; \
	       $(MAKE) clean ; \
	       $$back/qtbase/bin/qmake -makefile -spec $$back/qtbase/mkspecs/$(TARGET_SPEC_DIR) -o Makefile $$bname.pro ; \
	       $(MAKE) ; \
	     ) ; \
	   done ; \
	 )
	@( cd $(SRC_DIR) ; \
	   for dir in qtdeclarative/tools/qmlimportscanner qtdeclarative/tools/qmllint \
	              qtdeclarative/tools/qmlmin qttools/src/linguist/lconvert \
	              qttools/src/linguist/lrelease qttools/src/linguist/lupdate \
	              qtbase/src/tools/qdbuscpp2xml qtbase/src/tools/qdbusxml2cpp \
	              qtbase/src/tools/qdoc qtbase/src/tools/qlalr \
	              qtbase/src/tools/rcc qtbase/src/tools/uic \
	              qtbase/src/tools/moc ; do \
	     back=`echo $$dir | sed 's,[a-z2-]*,\.\.,g'` ; \
	     bname=`basename $$dir` ; \
	     ( cd $$dir ; \
	       $(MAKE) install $(env_sysroot) ; \
	     ) ; \
	   done ; \
	 )
	@( cd $(SRC_DIR)/qtbase/qmake ; \
	   $(MAKE) clean ; \
	 )
	@( cd $(SRC_DIR)/qtbase ; \
	   sed -i "/^# Verify makespec/ a\exit 0" configure ; \
	   $(QT_BUILD_ENVIRONMENT) ./configure \
	      -confirm-license -opensource -prefix /usr/lib$(MULTILIB_X86_32_SUFFIX)/qt5 \
	      -arch $(ARCH) -platform $(TARGET_SPEC_DIR) \
	      -force-pkg-config -release -shared -make tools -make libs \
	      -nomake examples -nomake tests -optimized-qmake \
	      -sysroot $(TARGET_DEST_DIR) -extprefix /usr/lib$(MULTILIB_X86_32_SUFFIX)/qt5 \
	      -verbose ; \
	   cp -a bin/qmake $(QT5_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/qt5/bin ; \
	 )
	# ======= Remove target mkspecs/$(TARGET_SPEC_DIR) =======
	@( cd $(QT5_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/qt5/mkspecs ; \
	   rm -rf $(TARGET_SPEC_DIR) ; \
	   rm -rf devices/$(DEVICE_SPEC_DIR) ; \
	   cat $(CURDIR)/mkspecs/qconfig.pri.in      | \
	       sed "s,@ARCH@,$(ARCH),g"              | \
	       sed "s,@LIBDIRSUFFIX@,$(MULTILIB_X86_32_SUFFIX),g"   \
	            > $(QT5_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/qt5/mkspecs/qconfig.pri ; \
	   echo -n "" > qdevice.pri ; \
	   echo -n "" > qmodule.pri ; \
	 )
	# ======= Install Qt.pc file =======
	@( cd $(QT5_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; ln -sf qt5 qt-$(version) )
	@cat $(pkgconfig_in) | \
	     sed "s,@PREFIX@,/usr/lib$(MULTILIB_X86_32_SUFFIX)/qt5,g" | \
	     sed "s,@VERSION@,$(version),g" > $(QT5_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/qt5/lib/pkgconfig/Qt5.pc
	# ======= Remove internal used dependencies of libjscore, libwebcore ======
	sed -i "s# -Wl,-whole-archive -lWebKit1 -Wl,-no-whole-archive -L$(CURDIR)/$(SRC_DIR)/qtwebkit/Source/WebKit/##g" \
	       $(QT5_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/qt5/lib/pkgconfig/Qt5WebKit.pc
	sed -i "s# -Wl,-whole-archive -lWebKit2 -Wl,-no-whole-archive -L$(CURDIR)/$(SRC_DIR)/qtwebkit/Source/WebKit2/##g" \
	       $(QT5_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/qt5/lib/pkgconfig/Qt5WebKit.pc
	sed -i "s# -Wl,-whole-archive -lWebCore -Wl,-no-whole-archive -L$(CURDIR)/$(SRC_DIR)/qtwebkit/Source/WebCore/##g" \
	       $(QT5_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/qt5/lib/pkgconfig/Qt5WebKit.pc
	sed -i "s# -Wl,-whole-archive -lANGLE -Wl,-no-whole-archive -L$(CURDIR)/$(SRC_DIR)/qtwebkit/Source/ThirdParty/ANGLE/##g" \
	       $(QT5_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/qt5/lib/pkgconfig/Qt5WebKit.pc
	sed -i "s# -Wl,-whole-archive -lleveldb -Wl,-no-whole-archive -L$(CURDIR)/$(SRC_DIR)/qtwebkit/Source/ThirdParty/leveldb/##g" \
	       $(QT5_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/qt5/lib/pkgconfig/Qt5WebKit.pc
	sed -i "s# -Wl,-whole-archive -lJavaScriptCore -Wl,-no-whole-archive -L$(CURDIR)/$(SRC_DIR)/qtwebkit/Source/JavaScriptCore/##g" \
	       $(QT5_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/qt5/lib/pkgconfig/Qt5WebKit.pc
	sed -i "s# -Wl,-whole-archive -lWTF -Wl,-no-whole-archive -L$(CURDIR)/$(SRC_DIR)/qtwebkit/Source/WTF/##g" \
	       $(QT5_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/qt5/lib/pkgconfig/Qt5WebKit.pc
	# ======= Link shared libraries into /usr/lib$(MULTILIB_X86_32_SUFFIX) =======
	@( cd $(QT5_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in qt5/lib/*.so* ; do \
	     ln -sf $$file . ; \
	   done ; \
	 )
	# ======= Add Profile scripts =======
	@mkdir -p $(QT5_32_PKG)/etc/profile.d/32
	@cat $(profile_dir)/qt5.csh.in | sed "s,@LIBDIR@,/usr/lib$(MULTILIB_X86_32_SUFFIX),g" > $(QT5_32_PKG)/etc/profile.d/32/qt5.csh
	@cat $(profile_dir)/qt5.sh.in  | sed "s,@LIBDIR@,/usr/lib$(MULTILIB_X86_32_SUFFIX),g" > $(QT5_32_PKG)/etc/profile.d/32/qt5.sh
	@chmod 0644 $(QT5_32_PKG)/etc/profile.d/32/*
	# ======= Link pkgconfig files to 'normal' place =======
	@mkdir -p $(QT5_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig
	@( cd $(QT5_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/qt5/lib/pkgconfig ; \
	   for file in *.pc ; do \
	     ( cd $(QT5_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; ln -sf ../../lib$(MULTILIB_X86_32_SUFFIX)/qt5/lib/pkgconfig/$$file . ) ; \
	   done ; \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(QT5_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/qt5/lib ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libEnginio.la              libQt5Bluetooth.la           \
	                                    libQt5Bootstrap.la         libQt5CLucene.la             \
	                                    libQt5Concurrent.la        libQt5Core.la                \
	                                    libQt5DBus.la              libQt5Declarative.la         \
	                                    libQt5Designer.la          libQt5DesignerComponents.la  \
	                                    libQt5Gui.la               libQt5Help.la                \
	                                    libQt5Location.la          libQt5Multimedia.la          \
	                                    libQt5MultimediaQuick_p.la libQt5MultimediaWidgets.la   \
	                                    libQt5Network.la           libQt5Nfc.la                 \
	                                    libQt5OpenGL.la            libQt5OpenGLExtensions.la    \
	                                    libQt5PlatformSupport.la   libQt5Positioning.la         \
	                                    libQt5PrintSupport.la      libQt5Qml.la                 \
	                                    libQt5QmlDevTools.la       libQt5Quick.la               \
	                                    libQt5QuickParticles.la    libQt5QuickTest.la           \
	                                    libQt5QuickWidgets.la      libQt5Script.la              \
	                                    libQt5ScriptTools.la       libQt5Sensors.la             \
	                                    libQt5SerialPort.la        libQt5Sql.la                 \
	                                    libQt5Svg.la               libQt5Test.la                \
	                                    libQt5UiTools.la           libQt5WebChannel.la          \
	                                    libQt5WebKit.la            libQt5WebKitWidgets.la       \
	                                    libQt5WebSockets.la        libQt5Widgets.la             \
	                                    libQt5X11Extras.la         libQt5Xml.la                 \
	                                    libQt5XmlPatterns.la                                  ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libEnginio.prl              libQt5Bluetooth.prl           \
	                                    libQt5Bootstrap.prl         libQt5CLucene.prl             \
	                                    libQt5Concurrent.prl        libQt5Core.prl                \
	                                    libQt5DBus.prl              libQt5Declarative.prl         \
	                                    libQt5Designer.prl          libQt5DesignerComponents.prl  \
	                                    libQt5Gui.prl               libQt5Help.prl                \
	                                    libQt5Location.prl          libQt5Multimedia.prl          \
	                                    libQt5MultimediaQuick_p.prl libQt5MultimediaWidgets.prl   \
	                                    libQt5Network.prl           libQt5Nfc.prl                 \
	                                    libQt5OpenGL.prl            libQt5OpenGLExtensions.prl    \
	                                    libQt5PlatformSupport.prl   libQt5Positioning.prl         \
	                                    libQt5PrintSupport.prl      libQt5Qml.prl                 \
	                                    libQt5QmlDevTools.prl       libQt5Quick.prl               \
	                                    libQt5QuickParticles.prl    libQt5QuickTest.prl           \
	                                    libQt5QuickWidgets.prl      libQt5Script.prl              \
	                                    libQt5ScriptTools.prl       libQt5Sensors.prl             \
	                                    libQt5SerialPort.prl        libQt5Sql.prl                 \
	                                    libQt5Svg.prl               libQt5Test.prl                \
	                                    libQt5UiTools.prl           libQt5WebChannel.prl          \
	                                    libQt5WebKit.prl            libQt5WebKitWidgets.prl       \
	                                    libQt5WebSockets.prl        libQt5Widgets.prl             \
	                                    libQt5X11Extras.prl         libQt5Xml.prl                 \
	                                    libQt5XmlPatterns.prl       libqgsttools_p.prl          ; \
	 )
	# ======= Change source directory to more 'normal' place =======
	@( cd $(QT5_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/qt5/lib ; \
	   sed -i "s,$(CURDIR)/$(SRC_DIR),/usr/src/qt-$(version),g" \
	           libEnginio.prl              libQt5Bluetooth.prl           \
	           libQt5Bootstrap.prl         libQt5CLucene.prl             \
	           libQt5Concurrent.prl        libQt5Core.prl                \
	           libQt5DBus.prl              libQt5Declarative.prl         \
	           libQt5Designer.prl          libQt5DesignerComponents.prl  \
	           libQt5Gui.prl               libQt5Help.prl                \
	           libQt5Location.prl          libQt5Multimedia.prl          \
	           libQt5MultimediaQuick_p.prl libQt5MultimediaWidgets.prl   \
	           libQt5Network.prl           libQt5Nfc.prl                 \
	           libQt5OpenGL.prl            libQt5OpenGLExtensions.prl    \
	           libQt5PlatformSupport.prl   libQt5Positioning.prl         \
	           libQt5PrintSupport.prl      libQt5Qml.prl                 \
	           libQt5QmlDevTools.prl       libQt5Quick.prl               \
	           libQt5QuickParticles.prl    libQt5QuickTest.prl           \
	           libQt5QuickWidgets.prl      libQt5Script.prl              \
	           libQt5ScriptTools.prl       libQt5Sensors.prl             \
	           libQt5SerialPort.prl        libQt5Sql.prl                 \
	           libQt5Svg.prl               libQt5Test.prl                \
	           libQt5UiTools.prl           libQt5WebChannel.prl          \
	           libQt5WebKit.prl            libQt5WebKitWidgets.prl       \
	           libQt5WebSockets.prl        libQt5Widgets.prl             \
	           libQt5X11Extras.prl         libQt5Xml.prl                 \
	           libQt5XmlPatterns.prl       libqgsttools_p.prl          ; \
	 )
	# ======= remove toolchain path from target pkgconfig *.pc files =======
	@( cd $(QT5_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/qt5/lib/pkgconfig ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" Enginio.pc              Qt5Bluetooth.pc           \
	                                    Qt5Bootstrap.pc         Qt5CLucene.pc             \
	                                    Qt5Concurrent.pc        Qt5Core.pc                \
	                                    Qt5DBus.pc              Qt5Declarative.pc         \
	                                    Qt5Designer.pc          Qt5DesignerComponents.pc  \
	                                    Qt5Gui.pc               Qt5Help.pc                \
	                                    Qt5Location.pc          Qt5Multimedia.pc          \
	                                    Qt5MultimediaQuick_p.pc Qt5MultimediaWidgets.pc   \
	                                    Qt5Network.pc           Qt5Nfc.pc                 \
	                                    Qt5OpenGL.pc            Qt5OpenGLExtensions.pc    \
	                                    Qt5PlatformSupport.pc   Qt5Positioning.pc         \
	                                    Qt5PrintSupport.pc      Qt5Qml.pc                 \
	                                    Qt5QmlDevTools.pc       Qt5Quick.pc               \
	                                    Qt5QuickParticles.pc    Qt5QuickTest.pc           \
	                                    Qt5QuickWidgets.pc      Qt5Script.pc              \
	                                    Qt5ScriptTools.pc       Qt5Sensors.pc             \
	                                    Qt5SerialPort.pc        Qt5Sql.pc                 \
	                                    Qt5Svg.pc               Qt5Test.pc                \
	                                    Qt5UiTools.pc           Qt5WebChannel.pc          \
	                                    Qt5WebKit.pc            Qt5WebKitWidgets.pc       \
	                                    Qt5WebSockets.pc        Qt5Widgets.pc             \
	                                    Qt5X11Extras.pc         Qt5Xml.pc                 \
	                                    Qt5XmlPatterns.pc                               ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(QT5_32_PKG))
	# ======= Remove build-machine tools from target package =======
	@( cd $(QT5_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/qt5/bin ; \
	   for file in lconvert lrelease lupdate moc qdbuscpp2xml qdbusxml2cpp  \
	               qdoc qlalr qmake qmlimportscanner qmllint qmlmin rcc uic ; do \
	     rm -f $(TARGET32)-$${file}-qt5 ; \
	   done ; \
	 )
	@rm -rf $(QT5_32_PKG)/usr/bin
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/qt5/lib ; \
	   sed -i "s,/usr/lib,$(TARGET_DEST_DIR)/usr/lib,g" libEnginio.la              libQt5Bluetooth.la           \
	                                                    libQt5Bootstrap.la         libQt5CLucene.la             \
	                                                    libQt5Concurrent.la        libQt5Core.la                \
	                                                    libQt5DBus.la              libQt5Declarative.la         \
	                                                    libQt5Designer.la          libQt5DesignerComponents.la  \
	                                                    libQt5Gui.la               libQt5Help.la                \
	                                                    libQt5Location.la          libQt5Multimedia.la          \
	                                                    libQt5MultimediaQuick_p.la libQt5MultimediaWidgets.la   \
	                                                    libQt5Network.la           libQt5Nfc.la                 \
	                                                    libQt5OpenGL.la            libQt5OpenGLExtensions.la    \
	                                                    libQt5PlatformSupport.la   libQt5Positioning.la         \
	                                                    libQt5PrintSupport.la      libQt5Qml.la                 \
	                                                    libQt5QmlDevTools.la       libQt5Quick.la               \
	                                                    libQt5QuickParticles.la    libQt5QuickTest.la           \
	                                                    libQt5QuickWidgets.la      libQt5Script.la              \
	                                                    libQt5ScriptTools.la       libQt5Sensors.la             \
	                                                    libQt5SerialPort.la        libQt5Sql.la                 \
	                                                    libQt5Svg.la               libQt5Test.la                \
	                                                    libQt5UiTools.la           libQt5WebChannel.la          \
	                                                    libQt5WebKit.la            libQt5WebKitWidgets.la       \
	                                                    libQt5WebSockets.la        libQt5Widgets.la             \
	                                                    libQt5X11Extras.la         libQt5Xml.la                 \
	                                                    libQt5XmlPatterns.la                                  ; \
	   sed -i "s,/usr/lib,$(TARGET_DEST_DIR)/usr/lib,g" libEnginio.prl              libQt5Bluetooth.prl           \
	                                                    libQt5Bootstrap.prl         libQt5CLucene.prl             \
	                                                    libQt5Concurrent.prl        libQt5Core.prl                \
	                                                    libQt5DBus.prl              libQt5Declarative.prl         \
	                                                    libQt5Designer.prl          libQt5DesignerComponents.prl  \
	                                                    libQt5Gui.prl               libQt5Help.prl                \
	                                                    libQt5Location.prl          libQt5Multimedia.prl          \
	                                                    libQt5MultimediaQuick_p.prl libQt5MultimediaWidgets.prl   \
	                                                    libQt5Network.prl           libQt5Nfc.prl                 \
	                                                    libQt5OpenGL.prl            libQt5OpenGLExtensions.prl    \
	                                                    libQt5PlatformSupport.prl   libQt5Positioning.prl         \
	                                                    libQt5PrintSupport.prl      libQt5Qml.prl                 \
	                                                    libQt5QmlDevTools.prl       libQt5Quick.prl               \
	                                                    libQt5QuickParticles.prl    libQt5QuickTest.prl           \
	                                                    libQt5QuickWidgets.prl      libQt5Script.prl              \
	                                                    libQt5ScriptTools.prl       libQt5Sensors.prl             \
	                                                    libQt5SerialPort.prl        libQt5Sql.prl                 \
	                                                    libQt5Svg.prl               libQt5Test.prl                \
	                                                    libQt5UiTools.prl           libQt5WebChannel.prl          \
	                                                    libQt5WebKit.prl            libQt5WebKitWidgets.prl       \
	                                                    libQt5WebSockets.prl        libQt5Widgets.prl             \
	                                                    libQt5X11Extras.prl         libQt5Xml.prl                 \
	                                                    libQt5XmlPatterns.prl       libqgsttools_p.prl          ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/qt5/lib/pkgconfig ; \
	   sed -i "s,/usr/lib,$(TARGET_DEST_DIR)/usr/lib,g" Enginio.pc              Qt5Bluetooth.pc           \
	                                                    Qt5Bootstrap.pc         Qt5CLucene.pc             \
	                                                    Qt5Concurrent.pc        Qt5Core.pc                \
	                                                    Qt5DBus.pc              Qt5Declarative.pc         \
	                                                    Qt5Designer.pc          Qt5DesignerComponents.pc  \
	                                                    Qt5Gui.pc               Qt5Help.pc                \
	                                                    Qt5Location.pc          Qt5Multimedia.pc          \
	                                                    Qt5MultimediaQuick_p.pc Qt5MultimediaWidgets.pc   \
	                                                    Qt5Network.pc           Qt5Nfc.pc                 \
	                                                    Qt5OpenGL.pc            Qt5OpenGLExtensions.pc    \
	                                                    Qt5PlatformSupport.pc   Qt5Positioning.pc         \
	                                                    Qt5PrintSupport.pc      Qt5Qml.pc                 \
	                                                    Qt5QmlDevTools.pc       Qt5Quick.pc               \
	                                                    Qt5QuickParticles.pc    Qt5QuickTest.pc           \
	                                                    Qt5QuickWidgets.pc      Qt5Script.pc              \
	                                                    Qt5ScriptTools.pc       Qt5Sensors.pc             \
	                                                    Qt5SerialPort.pc        Qt5Sql.pc                 \
	                                                    Qt5Svg.pc               Qt5Test.pc                \
	                                                    Qt5UiTools.pc           Qt5WebChannel.pc          \
	                                                    Qt5WebKit.pc            Qt5WebKitWidgets.pc       \
	                                                    Qt5WebSockets.pc        Qt5Widgets.pc             \
	                                                    Qt5X11Extras.pc         Qt5Xml.pc                 \
	                                                    Qt5XmlPatterns.pc                               ; \
	 )
	# ======= Strip binaries =======
	@( cd $(QT5_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(QT5_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/qt5/libexec ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if [ -n "$$rpath" ] ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(QT5_32_PKG_DESCRIPTION_FILE): $(QT5_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(QT5_32_PKG_DESCRIPTION_FILE) $(QT5_32_PKG_INSTALL_SCRIPT)
	@cp $(QT5_32_PKG_DESCRIPTION_FILE) $(QT5_32_PKG)/.DESCRIPTION
	@cp $(QT5_32_PKG_INSTALL_SCRIPT) $(QT5_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(QT5_32_PKG)/.REQUIRES
	@echo "pkgname=$(QT5_32_PKG_NAME)"                            >  $(QT5_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(QT5_32_PKG_VERSION)"                          >> $(QT5_32_PKG)/.PKGINFO ; \
	 echo "arch=$(QT5_32_PKG_ARCH)"                               >> $(QT5_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(QT5_32_PKG_DISTRO_NAME)"                  >> $(QT5_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(QT5_32_PKG_DISTRO_VERSION)"                >> $(QT5_32_PKG)/.PKGINFO ; \
	 echo "group=$(QT5_32_PKG_GROUP)"                             >> $(QT5_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(QT5_32_PKG_SHORT_DESCRIPTION)\"" >> $(QT5_32_PKG)/.PKGINFO ; \
	 echo "url=$(QT5_32_PKG_URL)"                                 >> $(QT5_32_PKG)/.PKGINFO ; \
	 echo "license=$(QT5_32_PKG_LICENSE)"                         >> $(QT5_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(QT5_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
