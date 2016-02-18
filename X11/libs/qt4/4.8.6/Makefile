
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_DM64X)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)
COMPONENT_TARGETS += $(HARDWARE_CI20)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/x/qt4

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/4.9.2
endif
REQUIRES          += net/ca-certificates/40.0.2
REQUIRES          += X11/app/desktop-file-utils/0.22
REQUIRES          += X11/libs/hicolor-icon-theme/0.14
REQUIRES          += X11/app/xdg-utils/1.1.0

REQUIRES          += libs/alsa-lib/1.0.28
REQUIRES          += X11/app/dbus-x11-launch/1.8.10

REQUIRES          += libs/libmng/2.0.2
REQUIRES          += libs/icu4c/54.1
REQUIRES          += app/cups/2.0.1

REQUIRES          += X11/libs/fontconfig/2.11.1

REQUIRES          += X11/X.org/lib/libXaw/1.0.12
REQUIRES          += X11/X.org/lib/libXcursor/1.1.14
REQUIRES          += X11/X.org/lib/libXi/1.7.4
REQUIRES          += X11/X.org/lib/libXinerama/1.1.3
REQUIRES          += X11/X.org/lib/libXrandr/1.4.2
REQUIRES          += X11/X.org/lib/libXv/1.0.10
REQUIRES          += X11/X.org/lib/libxkbfile/1.0.8

REQUIRES          += libs/gstreamer0/0.10.36
REQUIRES          += libs/gst-plugins-base0/0.10.36

REQUIRES          += app/sqlite/3.8.7.1
REQUIRES          += app/mariadb/5.5.41
REQUIRES          += libs/libiodbc/3.52.9

REQUIRES          += X11/libs/opengl-collection

# ======= __END_OF_REQUIRES__ =======


version            = 4.8.6
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/x/qt4/qt-everywhere-opensource-src-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/qt-everywhere-opensource-src-$(version)
src_dir_name       = qt-everywhere-opensource-src-$(version)
doc_dir_name       = qt4-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

pkgconfig_in       = $(CURDIR)/pkgconfig/Qt.pc.in
profile_dir        = $(CURDIR)/profile.d
applications_dir   = $(CURDIR)/applications


ifneq ($(filter $(HARDWARE),$(HARDWARE_OMAP5UEVM)),)
PATCHES = PATCHES.omap543x
else
PATCHES = PATCHES
endif

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = xlibs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
QT4_PKG_NAME                = qt4
QT4_PKG_VERSION             = 4.8.6
QT4_PKG_ARCH                = $(TOOLCHAIN)
QT4_PKG_DISTRO_NAME         = $(DISTRO_NAME)
QT4_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
QT4_PKG_GROUP               = $(PKG_GROUP)
###                          |---handy-ruler-------------------------------|
QT4_PKG_SHORT_DESCRIPTION   = graphical user interface toolkit
QT4_PKG_URL                 = $(BUG_URL)
QT4_PKG_LICENSE             = GPLv3
QT4_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(QT4_PKG_NAME)-pkg-description
QT4_PKG_DESCRIPTION_FILE_IN = $(QT4_PKG_NAME)-pkg-description.in
QT4_PKG_INSTALL_SCRIPT      = $(QT4_PKG_NAME)-pkg-install.sh

QT4_PKG          = $(CURDIR)/$(TARGET_BUILD_DIR)/$(QT4_PKG_NAME)-package

pkg_basename     = $(QT4_PKG_NAME)-$(QT4_PKG_VERSION)-$(QT4_PKG_ARCH)-$(QT4_PKG_DISTRO_NAME)-$(QT4_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../build-system/core.mk


env_sysroot = INSTALL_ROOT=$(QT4_PKG)


ifneq ($(filter $(HARDWARE),$(HARDWARE_CB1X) $(HARDWARE_CB3X) $(HARDWARE_FFRK3288) $(HARDWARE_BEAGLE) $(HARDWARE_OMAP5UEVM)),)
ARCH   = arm
ABI    = gnueabihf
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_DM64X)),)
ARCH   = arm
ABI    = gnueabi
endif

ifneq ($(filter $(HARDWARE),$(HARDWARE_PC32)),)
ARCH   = i386
ABI    = gnu
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC64)),)
ARCH   = x86_64
ABI    = gnu
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_B74) $(HARDWARE_CI20)),)
ARCH   = mips
ABI    = gnu
endif

TARGET_SPEC_DIR = linux-$(ARCH)-$(ABI)-g++


configure_switches  = -confirm-license
configure_switches += -opensource
configure_switches += -arch $(ARCH)
configure_switches += -platform linux-g++
configure_switches += -xplatform $(TARGET_SPEC_DIR)
configure_switches += -release
configure_switches += -shared
configure_switches += -force-pkg-config
configure_switches += -no-gtkstyle

configure_switches += -sysconfdir     /etc/xdg
configure_switches += -prefix         /usr/lib$(LIBSUFFIX)/qt4
configure_switches += -bindir         /usr/lib$(LIBSUFFIX)/qt4/bin
configure_switches += -libdir         /usr/lib$(LIBSUFFIX)/qt4/lib
configure_switches += -docdir         /usr/lib$(LIBSUFFIX)/qt4/doc
configure_switches += -headerdir      /usr/lib$(LIBSUFFIX)/qt4/include
configure_switches += -plugindir      /usr/lib$(LIBSUFFIX)/qt4/plugins
configure_switches += -importdir      /usr/lib$(LIBSUFFIX)/qt4/imports
configure_switches += -datadir        /usr/lib$(LIBSUFFIX)/qt4
configure_switches += -translationdir /usr/lib$(LIBSUFFIX)/qt4/translations
configure_switches += -examplesdir    /usr/lib$(LIBSUFFIX)/qt4/examples
configure_switches += -demosdir       /usr/lib$(LIBSUFFIX)/qt4/demos

configure_switches += -graphicssystem raster

ifneq ($(filter $(HARDWARE),$(HARDWARE_CB1X) $(HARDWARE_CI20)),)
configure_switches += -opengl es2
else
configure_switches += -opengl
endif
configure_switches += -system-libpng
configure_switches += -system-libmng
configure_switches += -system-libjpeg
configure_switches += -system-libtiff
configure_switches += -system-zlib
configure_switches += -system-sqlite
configure_switches += -plugin-sql-sqlite
configure_switches += -plugin-sql-mysql
configure_switches += -plugin-sql-odbc
configure_switches += -openssl-linked
configure_switches += -dbus
configure_switches += -accessibility
configure_switches += -glib
configure_switches += -gstreamer
configure_switches += -multimedia
configure_switches += -fontconfig
configure_switches += -webkit
configure_switches += -no-qt3support
configure_switches += -make libs
configure_switches += -make tools
configure_switches += -make examples
configure_switches += -make demos
configure_switches += -nomake docs
configure_switches += -no-separate-debug-info
configure_switches += -no-pch
configure_switches += -no-rpath
configure_switches += -optimized-qmake
configure_switches += -reduce-relocations
configure_switches += -no-openvg
configure_switches += -verbose


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)/qt4/lib


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@( cd $(SRC_DIR) ; sed -i "s,^\(QMAKE_INCDIR_X11 *=\).*,\1," mkspecs/common/linux.conf )
	@( cd $(SRC_DIR) ; sed -i "s,^\(QMAKE_INCDIR_OPENGL *=\).*,\1," mkspecs/common/linux.conf )
	@( cd $(SRC_DIR) ; sed -i "s,^\(QMAKE_LIBDIR_X11 *=\).*,\1," mkspecs/common/linux.conf )
	@( cd $(SRC_DIR) ; sed -i "s,^\(QMAKE_LIBDIR_OPENGL *=\).*,\1," mkspecs/common/linux.conf )
	@( cd $(SRC_DIR)/mkspecs ; rm -rf $(TARGET_SPEC_DIR) )
	@cp -a $(CURDIR)/mkspecs/$(TARGET_SPEC_DIR) $(SRC_DIR)/mkspecs
	@( cd $(SRC_DIR)/mkspecs/$(TARGET_SPEC_DIR) ; \
	   cat qmake.conf.in | \
	     sed 's,@CCACHE@,$(CCACHE),g'              | \
	     sed 's,@LIBDIRSUFFIX@,$(LIBSUFFIX),g'     | \
	     sed 's,@CROSS_COMPILE@,$(CROSS_PREFIX),g' | \
	     sed 's,@SYSROOT@,$(TARGET_DEST_DIR),g'    | \
	     sed 's,@ARCH_FLAGS@,$(ARCH_FLAGS),g'      | \
	     sed 's,@ARCH_DEFS@,$(ARCH_DEFS),g'        | \
	     sed 's,@HW_FLAGS@,$(HW_FLAGS),g'          > qmake.conf ; \
	 )
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && \
	  export PKG_CONFIG_SYSROOT=$(TARGET_DEST_DIR) ; \
	  export PKG_CONFIG_PATH=$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig:$(TARGET_DEST_DIR)/share/pkgconfig ; \
	  ./configure $(configure_switches)
	@cd $(SRC_DIR) && $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(QT4_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Rename build-machine tools =======
	@( cd $(QT4_PKG)/usr/lib$(LIBSUFFIX)/qt4/bin ; \
	   for file in lrelease moc qmake rcc uic ; do \
	     mv $$file $(TARGET)-$$file ; \
	   done ; \
	 )
	@mkdir -p $(QT4_PKG)/usr/bin
	@( cd $(QT4_PKG)/usr/lib$(LIBSUFFIX)/qt4/bin ; \
	   for file in lrelease moc qmake rcc uic ; do \
	     ( cd $(QT4_PKG)/usr/bin ; ln -sf ../../usr/lib$(LIBSUFFIX)/qt4/bin/$(TARGET)-$$file . ) ; \
	   done ; \
	 )
	# ======= Install Qmake =======
	@( cd $(SRC_DIR)/src/tools ; $(MAKE) clean )
	@for dir in bootstrap moc rcc uic ; do \
	  ( cd $(SRC_DIR)/src/tools/$$dir ; \
	    CC="$(CROSS_PREFIX)gcc --sysroot=$(TARGET_DEST_DIR)" \
	    CXX="$(CROSS_PREFIX)g++ --sysroot=$(TARGET_DEST_DIR)" \
	    LINK="$(CROSS_PREFIX)g++ --sysroot=$(TARGET_DEST_DIR) -L$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)" \
	    ../../../bin/qmake -makefile -spec ../../../mkspecs/$(TARGET_SPEC_DIR) ; \
	  ) ; \
	 done
	@( cd $(SRC_DIR)/src/tools ; \
	   $(MAKE) && $(MAKE) -j1 install $(env_sysroot) ; \
	 )
	@( cd $(SRC_DIR)/tools/linguist/lrelease ; \
	   $(MAKE) clean ; \
	    CC="$(CROSS_PREFIX)gcc --sysroot=$(TARGET_DEST_DIR)" \
	    CXX="$(CROSS_PREFIX)g++ --sysroot=$(TARGET_DEST_DIR)" \
	    LINK="$(CROSS_PREFIX)g++ --sysroot=$(TARGET_DEST_DIR) -L$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)" \
	    ../../../bin/qmake -makefile -spec ../../../mkspecs/$(TARGET_SPEC_DIR) ; \
	   $(MAKE) ; \
	   $(MAKE) -j1 install $(env_sysroot) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   $(MAKE) distclean ; \
	   ( cd qmake ; $(MAKE) clean ) ; \
	   export PKG_CONFIG_SYSROOT=$(TARGET_DEST_DIR) ; \
	   export PKG_CONFIG_PATH=$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig:$(TARGET_DEST_DIR)/share/pkgconfig ; \
	   ./configure -confirm-license -opensource -prefix /usr/lib$(LIBSUFFIX)/qt4 \
	               -arch $(ARCH) -platform $(TARGET_SPEC_DIR) \
	               -force-pkg-config \
	               -release \
	               -shared \
	               -little-endian \
	               -host-little-endian \
	               -optimized-qmake \
	               -v ; \
	  cp -a bin/qmake $(QT4_PKG)/usr/lib$(LIBSUFFIX)/qt4/bin ; \
	 )
	# ======= Remove target mkspecs/$(TARGET_SPEC_DIR) =======
	@( cd $(QT4_PKG)/usr/lib$(LIBSUFFIX)/qt4/mkspecs ; \
	   rm -rf $(TARGET_SPEC_DIR) ; \
	   rm -f default ; \
	 )
	# ======= Install Qt.pc file =======
	@( cd $(QT4_PKG)/usr/lib$(LIBSUFFIX) ; ln -sf qt4 qt-$(version) )
	@cat $(pkgconfig_in) | \
	     sed "s,@PREFIX@,/usr/lib$(LIBSUFFIX)/qt4,g" | \
	     sed "s,@VERSION@,$(version),g" > $(QT4_PKG)/usr/lib$(LIBSUFFIX)/qt4/lib/pkgconfig/Qt.pc
	# ======= Remove internal used dependencies of libjscore, libwebcore ======
	sed -i "s, -ljscore,,g" $(QT4_PKG)/usr/lib$(LIBSUFFIX)/qt4/lib/libQtWebKit.la \
	                        $(QT4_PKG)/usr/lib$(LIBSUFFIX)/qt4/lib/pkgconfig/QtWebKit.pc
	sed -i "s,  -lwebcore,,g" $(QT4_PKG)/usr/lib$(LIBSUFFIX)/qt4/lib/libQtWebKit.la \
	                          $(QT4_PKG)/usr/lib$(LIBSUFFIX)/qt4/lib/pkgconfig/QtWebKit.pc
	sed -i "s, -L../../JavaScriptCore/release,,g" $(QT4_PKG)/usr/lib$(LIBSUFFIX)/qt4/lib/libQtWebKit.la \
	                                              $(QT4_PKG)/usr/lib$(LIBSUFFIX)/qt4/lib/pkgconfig/QtWebKit.pc
	sed -i "s, -L../../WebCore/release,,g" $(QT4_PKG)/usr/lib$(LIBSUFFIX)/qt4/lib/libQtWebKit.la \
	                                       $(QT4_PKG)/usr/lib$(LIBSUFFIX)/qt4/lib/pkgconfig/QtWebKit.pc
	# ======= Link shared libraries into /usr/lib$(LIBSUFFIX) =======
	@( cd $(QT4_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in qt4/lib/*.so* ; do \
	     ln -sf $$file . ; \
	   done ; \
	 )
	# ======= Add Profile scripts =======
	@mkdir -p $(QT4_PKG)/etc/profile.d
	@cat $(profile_dir)/qt4.csh.in | sed "s,@LIBDIR@,/usr/lib$(LIBSUFFIX),g" > $(QT4_PKG)/etc/profile.d/qt4.csh
	@cat $(profile_dir)/qt4.sh.in  | sed "s,@LIBDIR@,/usr/lib$(LIBSUFFIX),g" > $(QT4_PKG)/etc/profile.d/qt4.sh
	@chmod 0755 $(QT4_PKG)/etc/profile.d/*
	# ======= Link pkgconfig files to 'normal' place =======
	@mkdir -p $(QT4_PKG)/usr/lib$(LIBSUFFIX)/pkgconfig
	@( cd $(QT4_PKG)/usr/lib$(LIBSUFFIX)/qt4/lib/pkgconfig ; \
	   for file in *.pc ; do \
	     ( cd $(QT4_PKG)/usr/lib$(LIBSUFFIX)/pkgconfig ; ln -sf ../../lib$(LIBSUFFIX)/qt4/lib/pkgconfig/$$file . ) ; \
	   done ; \
	 )
	# ======= Install Qt private headers =======
	@( cd $(SRC_DIR) ; \
	   rsync -aR \
	         include/Qt{Core,Declarative,Gui,Script}/private \
	         src/{corelib,declarative,gui,script}/*/*_p.h \
	         $(QT4_PKG)/usr/lib$(LIBSUFFIX)/qt4/ ; \
	 )
	# ======= Add menu entries for Qt applications =======
	@mkdir -p $(QT4_PKG)/usr/share/icons/hicolor/{16x16,32x32,48x48,64x64,128x128}/apps
	@( cd $(SRC_DIR) ; \
	   convert doc/src/images/qt-logo.png -resize 32x32 $(QT4_PKG)/usr/share/icons/hicolor/32x32/apps/qt-logo.png ; \
	   convert doc/src/images/qt-logo.png -resize 48x48 $(QT4_PKG)/usr/share/icons/hicolor/48x48/apps/qt-logo.png ; \
	   install -p -m644 -D tools/assistant/tools/assistant/images/assistant.png $(QT4_PKG)/usr/share/icons/hicolor/32x32/apps/assistant.png ; \
	   install -p -m644 -D tools/assistant/tools/assistant/images/assistant-128.png $(QT4_PKG)/usr/share/icons/hicolor/128x128/apps/assistant.png ; \
	   install -p -m644 -D tools/designer/src/designer/images/designer.png $(QT4_PKG)/usr/share/icons/hicolor/128x128/apps/designer.png ; \
	   for icon in tools/linguist/linguist/images/icons/linguist-*-32.png ; do \
	     file=`basename $${icon}` ; \
	     size=`echo $${file} | cut -d- -f2` ; \
	     install -p -m644 -D $${icon} $(QT4_PKG)/usr/share/icons/hicolor/$${size}x$${size}/apps/linguist.png ; \
	   done ; \
	 )
	@mkdir -p $(QT4_PKG)/usr/share/applications
	@( cd $(applications_dir) ; \
	   for file in assistant designer linguist qtconfig ; do \
	     cat $$file.desktop.in | \
	       sed "s,@QT4LINK@,/usr/lib$(LIBSUFFIX)/qt4,g" > $(QT4_PKG)/usr/share/applications/$$file.desktop ; \
	   done ; \
	 )
	# ======= Install Documentation =======
	@mkdir -p $(QT4_PKG)/usr/doc/$(doc_dir_name)
	@cp -a $(SRC_DIR)/*GPL_EXCEPTION* $(SRC_DIR)/LICENSE* \
	       $(QT4_PKG)/usr/doc/$(doc_dir_name)
	@mkdir -p $(QT4_PKG)/usr/share/doc/$(doc_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a INSTALL *GPL_EXCEPTION* LICENSE* README changes-* doc/html \
	         $(QT4_PKG)/usr/share/doc/$(doc_dir_name) ; \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(QT4_PKG)/usr/lib$(LIBSUFFIX)/qt4/lib ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libQtCLucene.la     libQtCore.la        \
	                                    libQtDBus.la        libQtDeclarative.la \
	                                    libQtGui.la         libQtHelp.la        \
	                                    libQtMultimedia.la  libQtNetwork.la     \
	                                    libQtOpenGL.la      libQtScript.la      \
	                                    libQtScriptTools.la libQtSql.la         \
	                                    libQtSvg.la         libQtTest.la        \
	                                    libQtWebKit.la      libQtXml.la         \
	                                    libQtXmlPatterns.la libphonon.la      ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libQtCLucene.prl     libQtCore.prl               \
	                                    libQtDBus.prl        libQtDeclarative.prl        \
	                                    libQtDesigner.prl    libQtDesignerComponents.prl \
	                                    libQtGui.prl         libQtHelp.prl               \
	                                    libQtMultimedia.prl  libQtNetwork.prl            \
	                                    libQtOpenGL.prl      libQtScript.prl             \
	                                    libQtScriptTools.prl libQtSql.prl                \
	                                    libQtSvg.prl         libQtTest.prl               \
	                                    libQtUiTools.prl     libQtWebKit.prl             \
	                                    libQtXml.prl         libQtXmlPatterns.prl        \
	                                    libphonon.prl                                  ; \
	 )
ifneq ($(filter $(HARDWARE),$(HARDWARE_CB1X) $(HARDWARE_CI20)),)
	@( cd $(QT4_PKG)/usr/lib$(LIBSUFFIX)/qt4/lib ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libQtMeeGoGraphicsSystemHelper.la  ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libQtMeeGoGraphicsSystemHelper.prl ; \
	 )
endif
	# ======= Change source directory to more 'normal' place =======
	@( cd $(QT4_PKG)/usr/lib$(LIBSUFFIX)/qt4/lib ; \
	   sed -i "s,$(CURDIR)/$(SRC_DIR),/usr/src/qt-$(version),g" \
	           libQtCLucene.prl     libQtCore.prl               \
	           libQtDBus.prl        libQtDeclarative.prl        \
	           libQtDesigner.prl    libQtDesignerComponents.prl \
	           libQtGui.prl         libQtHelp.prl               \
	           libQtMultimedia.prl  libQtNetwork.prl            \
	           libQtOpenGL.prl      libQtScript.prl             \
	           libQtScriptTools.prl libQtSql.prl                \
	           libQtSvg.prl         libQtTest.prl               \
	           libQtUiTools.prl     libQtWebKit.prl             \
	           libQtXml.prl         libQtXmlPatterns.prl        \
	           libphonon.prl                                  ; \
	 )
ifneq ($(filter $(HARDWARE),$(HARDWARE_CB1X) $(HARDWARE_CI20)),)
	@( cd $(QT4_PKG)/usr/lib$(LIBSUFFIX)/qt4/lib ; \
	   sed -i "s,$(CURDIR)/$(SRC_DIR),/usr/src/qt-$(version),g" \
	           libQtMeeGoGraphicsSystemHelper.prl             ; \
	 )
endif
	# ======= remove toolchain path from target pkgconfig *.pc files =======
	@( cd $(QT4_PKG)/usr/lib$(LIBSUFFIX)/qt4/lib/pkgconfig ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" QtCLucene.pc     QtCore.pc               \
	                                    QtDBus.pc        QtDeclarative.pc        \
	                                    QtDesigner.pc    QtDesignerComponents.pc \
	                                    QtGui.pc         QtHelp.pc               \
	                                    QtMultimedia.pc  QtNetwork.pc            \
	                                    QtOpenGL.pc      QtScript.pc             \
	                                    QtScriptTools.pc QtSql.pc                \
	                                    QtSvg.pc         QtTest.pc               \
	                                    QtUiTools.pc     QtWebKit.pc             \
	                                    QtXml.pc         QtXmlPatterns.pc        \
	                                    phonon.pc                              ; \
	 )
ifneq ($(filter $(HARDWARE),$(HARDWARE_CB1X) $(HARDWARE_CI20)),)
	@( cd $(QT4_PKG)/usr/lib$(LIBSUFFIX)/qt4/lib/pkgconfig ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" QtMeeGoGraphicsSystemHelper.pc ; \
	 )
endif
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(QT4_PKG))
	# ======= Remove build-machine tools from target package =======
	@( cd $(QT4_PKG)/usr/lib$(LIBSUFFIX)/qt4/bin ; \
	   for file in lrelease moc qmake rcc uic ; do \
	     rm -f $(TARGET)-$$file ; \
	   done ; \
	 )
	@rm -rf $(QT4_PKG)/usr/bin
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/qt4/lib ; \
	   sed -i "s,/usr/lib,$(TARGET_DEST_DIR)/usr/lib,g" libQtCLucene.la     libQtCore.la        \
	                                                    libQtDBus.la        libQtDeclarative.la \
	                                                    libQtGui.la         libQtHelp.la        \
	                                                    libQtMultimedia.la  libQtNetwork.la     \
	                                                    libQtOpenGL.la      libQtScript.la      \
	                                                    libQtScriptTools.la libQtSql.la         \
	                                                    libQtSvg.la         libQtTest.la        \
	                                                    libQtWebKit.la      libQtXml.la         \
	                                                    libQtXmlPatterns.la libphonon.la      ; \
	   sed -i "s,/usr/lib,$(TARGET_DEST_DIR)/usr/lib,g" libQtCLucene.prl     libQtCore.prl               \
	                                                    libQtDBus.prl        libQtDeclarative.prl        \
	                                                    libQtDesigner.prl    libQtDesignerComponents.prl \
	                                                    libQtGui.prl         libQtHelp.prl               \
	                                                    libQtMultimedia.prl  libQtNetwork.prl            \
	                                                    libQtOpenGL.prl      libQtScript.prl             \
	                                                    libQtScriptTools.prl libQtSql.prl                \
	                                                    libQtSvg.prl         libQtTest.prl               \
	                                                    libQtUiTools.prl     libQtWebKit.prl             \
	                                                    libQtXml.prl         libQtXmlPatterns.prl        \
	                                                    libphonon.prl                                  ; \
	 )
ifneq ($(filter $(HARDWARE),$(HARDWARE_CB1X) $(HARDWARE_CI20)),)
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/qt4/lib ; \
	   sed -i "s,/usr/lib,$(TARGET_DEST_DIR)/usr/lib,g" libQtMeeGoGraphicsSystemHelper.la  ; \
	   sed -i "s,/usr/lib,$(TARGET_DEST_DIR)/usr/lib,g" libQtMeeGoGraphicsSystemHelper.prl ; \
	 )
endif
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/qt4/lib/pkgconfig ; \
	   sed -i "s,/usr/lib,$(TARGET_DEST_DIR)/usr/lib,g" QtCLucene.pc     QtCore.pc               \
	                                                    QtDBus.pc        QtDeclarative.pc        \
	                                                    QtDesigner.pc    QtDesignerComponents.pc \
	                                                    QtGui.pc         QtHelp.pc               \
	                                                    QtMultimedia.pc  QtNetwork.pc            \
	                                                    QtOpenGL.pc      QtScript.pc             \
	                                                    QtScriptTools.pc QtSql.pc                \
	                                                    QtSvg.pc         QtTest.pc               \
	                                                    QtUiTools.pc     QtWebKit.pc             \
	                                                    QtXml.pc         QtXmlPatterns.pc        \
	                                                    phonon.pc                              ; \
	 )
ifneq ($(filter $(HARDWARE),$(HARDWARE_CB1X) $(HARDWARE_CI20)),)
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/qt4/lib/pkgconfig ; \
	   sed -i "s,/usr/lib,$(TARGET_DEST_DIR)/usr/lib,g" QtMeeGoGraphicsSystemHelper.pc ; \
	 )
endif
	# ======= Strip binaries =======
	@( cd $(QT4_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(QT4_PKG)/usr/lib$(LIBSUFFIX)/qt4/tests/qt4 ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if [ -n "$$rpath" ] ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(QT4_PKG_DESCRIPTION_FILE): $(QT4_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(QT4_PKG_DESCRIPTION_FILE) $(QT4_PKG_INSTALL_SCRIPT)
	@cp $(QT4_PKG_DESCRIPTION_FILE) $(QT4_PKG)/.DESCRIPTION
	@cp $(QT4_PKG_INSTALL_SCRIPT) $(QT4_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(QT4_PKG)/.REQUIRES
	@echo "pkgname=$(QT4_PKG_NAME)"                            >  $(QT4_PKG)/.PKGINFO ; \
	 echo "pkgver=$(QT4_PKG_VERSION)"                          >> $(QT4_PKG)/.PKGINFO ; \
	 echo "arch=$(QT4_PKG_ARCH)"                               >> $(QT4_PKG)/.PKGINFO ; \
	 echo "distroname=$(QT4_PKG_DISTRO_NAME)"                  >> $(QT4_PKG)/.PKGINFO ; \
	 echo "distrover=$(QT4_PKG_DISTRO_VERSION)"                >> $(QT4_PKG)/.PKGINFO ; \
	 echo "group=$(QT4_PKG_GROUP)"                             >> $(QT4_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(QT4_PKG_SHORT_DESCRIPTION)\"" >> $(QT4_PKG)/.PKGINFO ; \
	 echo "url=$(QT4_PKG_URL)"                                 >> $(QT4_PKG)/.PKGINFO ; \
	 echo "license=$(QT4_PKG_LICENSE)"                         >> $(QT4_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(QT4_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
