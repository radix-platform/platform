
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
COMPONENT_TARGETS += $(HARDWARE_P201)
COMPONENT_TARGETS += $(HARDWARE_NEXBOX_A95X)
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


include ../../../../build-system/constants.mk

BUILD_QT_CREATOR = yes

SOURCE_REQUIRES    = sources/packages/x/qt5
ifeq ($(BUILD_QT_CREATOR),yes)
SOURCE_REQUIRES   += sources/packages/d/qt-creator
endif

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.3.0
endif
REQUIRES          += net/ca-certificates/52.0
REQUIRES          += X11/app/desktop-file-utils/0.22
REQUIRES          += X11/libs/hicolor-icon-theme/0.15
REQUIRES          += X11/app/xdg-utils/1.1.1

REQUIRES          += libs/alsa-lib/1.1.1
REQUIRES          += libs/pulseaudio/9.0
REQUIRES          += X11/app/dbus-x11-launch/1.11.2

REQUIRES          += libs/libmng/2.0.3
REQUIRES          += libs/icu4c/55.1
REQUIRES          += libs/libvpx/1.5.0
REQUIRES          += libs/assimp/3.2
REQUIRES          += app/cups/2.1.3

REQUIRES          += X11/libs/fontconfig/2.12.4

REQUIRES          += X11/X.org/lib/libXaw/1.0.13
REQUIRES          += X11/X.org/lib/libXcursor/1.1.14
REQUIRES          += X11/X.org/lib/libXi/1.7.6
REQUIRES          += X11/X.org/lib/libXinerama/1.1.3
REQUIRES          += X11/X.org/lib/libXrandr/1.5.0
REQUIRES          += X11/X.org/lib/libXv/1.0.10
REQUIRES          += X11/X.org/lib/libxkbfile/1.0.9

REQUIRES          += X11/X.org/xcb/xcb-util-cursor/0.1.3
REQUIRES          += X11/X.org/xcb/xcb-util-keysyms/0.4.0
REQUIRES          += X11/X.org/xcb/xcb-util-wm/0.4.1

REQUIRES          += libs/gstreamer/1.8.2
REQUIRES          += libs/gst-plugins-base/1.8.2

REQUIRES          += app/sqlite/3.12.2.0
REQUIRES          += app/postgresql/9.6.0
REQUIRES          += app/mariadb/10.0.30
REQUIRES          += libs/libiodbc/3.52.10

REQUIRES          += libs/botan/1.10.13

REQUIRES          += X11/libs/opengl-collection

# ======= __END_OF_REQUIRES__ =======


version            = 5.4.2
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/x/qt5/qt-everywhere-opensource-src-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/qt-everywhere-opensource-src-$(version)
ifeq ($(BUILD_QT_CREATOR),yes)
qtc_version        = 3.5.1
qtc_gz_archive     = $(SRC_PACKAGE_PATH)/packages/d/qt-creator/qt-creator-opensource-src-$(qtc_version).tar.gz
qtc_src_dir_name   = qt-creator-opensource-src-$(qtc_version)
qtc_doc_dir_name   = qt5-creator-$(qtc_version)
endif
src_dir_name       = qt-everywhere-opensource-src-$(version)
doc_dir_name       = qt5-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

pkgconfig_in       = $(CURDIR)/pkgconfig/Qt5.pc.in
profile_dir        = $(CURDIR)/profile.d
applications_dir   = $(CURDIR)/applications

config_spec        = $(CURDIR)/$(SRC_DIR)/qtbase/mkspecs/qconfig.pri
config_summary     = $(CURDIR)/$(SRC_DIR)/qtbase/config.summary


PATCHES = PATCHES
ifeq ($(BUILD_QT_CREATOR),yes)
OPT_PATCHES = PATCHES.qtc-$(qtc_version)
endif

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = xlibs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
QT5_PKG_NAME                = qt5
QT5_PKG_VERSION             = 5.4.2
QT5_PKG_ARCH                = $(TOOLCHAIN)
QT5_PKG_DISTRO_NAME         = $(DISTRO_NAME)
QT5_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
QT5_PKG_GROUP               = $(PKG_GROUP)
###                          |---handy-ruler-------------------------------|
QT5_PKG_SHORT_DESCRIPTION   = graphical user interface toolkit
QT5_PKG_URL                 = $(BUG_URL)
QT5_PKG_LICENSE             = GPLv3
QT5_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(QT5_PKG_NAME)-pkg-description
QT5_PKG_DESCRIPTION_FILE_IN = $(QT5_PKG_NAME)-pkg-description.in
QT5_PKG_INSTALL_SCRIPT      = $(QT5_PKG_NAME)-pkg-install.sh

QT5_PKG          = $(CURDIR)/$(TARGET_BUILD_DIR)/$(QT5_PKG_NAME)-package

pkg_basename     = $(QT5_PKG_NAME)-$(QT5_PKG_VERSION)-$(QT5_PKG_ARCH)-$(QT5_PKG_DISTRO_NAME)-$(QT5_PKG_DISTRO_VERSION)

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


env_sysroot = INSTALL_ROOT=$(QT5_PKG)


QT5_JOBS = -j$(NUMPROCS)


ifneq ($(filter $(HARDWARE),$(HARDWARE_CB1X)      \
                            $(HARDWARE_CB2X)      \
                            $(HARDWARE_CB3X)      \
                            $(HARDWARE_FFRK3288)  \
                            $(HARDWARE_M201) $(HARDWARE_MXV) \
                            $(HARDWARE_NIT6Q)     \
                            $(HARDWARE_OMAP5UEVM) \
                            $(HARDWARE_DRA7XXEVM)),)
ARCH   = arm
ABI    = gnueabihf
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_P201) $(HARDWARE_NEXBOX_A95X) \
                            $(HARDWARE_P212) $(HARDWARE_KHADAS_VIM)  \
                            $(HARDWARE_Q201) $(HARDWARE_ENYBOX_X2)),)
ARCH   = aarch64
ABI    = gnu
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC32)),)
ARCH   = i386
ABI    = gnu
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC64)),)
ARCH   = x86_64
ABI    = gnu
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_CI20) $(HARDWARE_BAIKAL_T1)),)
ARCH   = mips
ABI    = gnu
endif

TARGET_SPEC_DIR = linux-$(ARCH)-$(ABI)-g++
DEVICE_SPEC_DIR = linux-$(HARDWARE)-g++

QT_BUILD_ENVIRONMENT  = export PKG_CONFIG=/usr/bin/pkg-config ;
QT_BUILD_ENVIRONMENT += export PKG_CONFIG_SYSROOT_DIR=$(TARGET_DEST_DIR) ;
QT_BUILD_ENVIRONMENT += export PKG_CONFIG_PATH=$(ROOTFS_DEST_DIR)/usr/lib/pkgconfig:$(ROOTFS_DEST_DIR)/usr/share/pkgconfig ;
QT_BUILD_ENVIRONMENT += export PKG_CONFIG_LIBDIR=$(ROOTFS_DEST_DIR)/usr/lib/pkgconfig:$(ROOTFS_DEST_DIR)/usr/share/pkgconfig ;


configure_switches  = -confirm-license
configure_switches += -opensource
configure_switches += -device $(HARDWARE)
configure_switches += -device-option CCACHE=$(CCACHE)
configure_switches += -device-option CROSS_COMPILE=$(CROSS_PREFIX)

# ======= Target compiler doesn't support MIPS DSP/DSPr2 =======
ifneq ($(filter $(HARDWARE),$(HARDWARE_CI20) $(HARDWARE_BAIKAL_T1)),)
configure_switches += -no-mips_dsp
configure_switches += -no-mips_dspr2
endif

configure_switches += -sysroot $(TARGET_DEST_DIR)
configure_switches += -extprefix /usr/lib$(LIBSUFFIX)/qt-$(version)

configure_switches += -sysconfdir     /etc/xdg
configure_switches += -bindir         /usr/lib$(LIBSUFFIX)/qt-$(version)/bin
configure_switches += -headerdir      /usr/lib$(LIBSUFFIX)/qt-$(version)/include
configure_switches += -libdir         /usr/lib$(LIBSUFFIX)/qt-$(version)/lib
configure_switches += -archdatadir    /usr/lib$(LIBSUFFIX)/qt-$(version)
configure_switches += -plugindir      /usr/lib$(LIBSUFFIX)/qt-$(version)/plugins
configure_switches += -libexecdir     /usr/lib$(LIBSUFFIX)/qt-$(version)/libexec
configure_switches += -importdir      /usr/lib$(LIBSUFFIX)/qt-$(version)/imports
configure_switches += -qmldir         /usr/lib$(LIBSUFFIX)/qt-$(version)/qml
configure_switches += -datadir        /usr/lib$(LIBSUFFIX)/qt-$(version)
configure_switches += -docdir         /usr/lib$(LIBSUFFIX)/qt-$(version)/doc
configure_switches += -translationdir /usr/lib$(LIBSUFFIX)/qt-$(version)/translations
configure_switches += -examplesdir    /usr/lib$(LIBSUFFIX)/qt-$(version)/examples
configure_switches += -testsdir       /usr/lib$(LIBSUFFIX)/qt-$(version)/tests

configure_switches += -release
configure_switches += -shared
configure_switches += -force-pkg-config
configure_switches += -c++11
ifeq ($(filter $(HARDWARE),$(HARDWARE_PC64)),)
configure_switches += -no-largefile
endif
configure_switches += -no-gtkstyle
ifneq ($(filter $(HARDWARE),$(HARDWARE_CB1X) $(HARDWARE_CI20)        \
                            $(HARDWARE_M201) $(HARDWARE_MXV)         \
                            $(HARDWARE_P201) $(HARDWARE_NEXBOX_A95X) \
                            $(HARDWARE_P212) $(HARDWARE_KHADAS_VIM)  \
                            $(HARDWARE_Q201) $(HARDWARE_ENYBOX_X2)),)
configure_switches += -opengl es2
else
configure_switches += -opengl
endif
configure_switches += -accessibility
configure_switches += -system-sqlite
configure_switches += -plugin-sql-sqlite
configure_switches += -plugin-sql-psql
configure_switches += -plugin-sql-mysql
configure_switches += -plugin-sql-odbc
configure_switches += -system-zlib
configure_switches += -mtdev
configure_switches += -system-libpng
configure_switches += -system-libjpeg
configure_switches += -system-freetype
configure_switches += -system-harfbuzz
configure_switches += -openssl-linked
configure_switches += -system-pcre
configure_switches += -system-xcb
configure_switches += -xinput2
configure_switches += -xcb-xlib
configure_switches += -glib
configure_switches += -pulseaudio
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
configure_switches += -no-directfb
configure_switches += -linuxfb


ENABLE_EGLFS_SUPPORT = yes
ENABLE_KMS_SUPPORT   = yes

ifneq ($(filter $(HARDWARE),$(HARDWARE_CB1X) $(HARDWARE_CI20)        \
                            $(HARDWARE_M201) $(HARDWARE_MXV)         \
                            $(HARDWARE_P201) $(HARDWARE_NEXBOX_A95X) \
                            $(HARDWARE_P212) $(HARDWARE_KHADAS_VIM)  \
                            $(HARDWARE_Q201) $(HARDWARE_ENYBOX_X2)),)
ENABLE_KMS_SUPPORT = no
endif

ifeq ($(ENABLE_EGLFS_SUPPORT),yes)
configure_switches += -eglfs
ifeq ($(ENABLE_KMS_SUPPORT),yes)
configure_switches += -kms
else
configure_switches += -no-kms
endif
else
configure_switches += -no-eglfs
configure_switches += -no-kms
ENABLE_KMS_SUPPORT  =  no
endif


configure_switches += -qpa xcb

configure_switches += -qreal double
configure_switches += -no-warnings-are-errors
configure_switches += -make libs
configure_switches += -make tools
configure_switches += -make examples
configure_switches += -make tests
configure_switches += -no-strip
configure_switches += -no-pch
configure_switches += -no-rpath
configure_switches += -optimized-qmake
configure_switches += -verbose


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)/qt-$(version)/lib


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@cp -a $(CURDIR)/mkspecs/devices/$(DEVICE_SPEC_DIR) $(SRC_DIR)/qtbase/mkspecs/devices
	@cp -a $(CURDIR)/mkspecs/$(TARGET_SPEC_DIR) $(SRC_DIR)/qtbase/mkspecs
	@( cd $(SRC_DIR)/qtbase/mkspecs/devices/$(DEVICE_SPEC_DIR) ; \
	   cat qmake.conf.in | \
	     sed 's,@LIBDIRSUFFIX@,$(LIBSUFFIX),g'     | \
	     sed 's,@ARCH_FLAGS@,$(ARCH_FLAGS),g'      | \
	     sed 's,@ARCH_DEFS@,$(ARCH_DEFS),g'        | \
	     sed 's,@HW_FLAGS@,$(HW_FLAGS),g'          > qmake.conf ; \
	 )
	@( cd $(SRC_DIR)/qtbase/mkspecs/$(TARGET_SPEC_DIR) ; \
	   cat qmake.conf.in | \
	     sed 's,@CCACHE@,$(CCACHE),g'              | \
	     sed 's,@LIBDIRSUFFIX@,$(LIBSUFFIX),g'     | \
	     sed 's,@CROSS_COMPILE@,$(CROSS_PREFIX),g' | \
	     sed 's,@SYSROOT@,$(TARGET_DEST_DIR),g'    | \
	     sed 's,@ARCH_FLAGS@,$(ARCH_FLAGS),g'      | \
	     sed 's,@ARCH_DEFS@,$(ARCH_DEFS),g'        | \
	     sed 's,@HW_FLAGS@,$(HW_FLAGS),g'          > qmake.conf ; \
	 )
ifeq ($(BUILD_QT_CREATOR),yes)
	@echo "Expanding $(qtc_gz_archive)"
	@tar xzf $(qtc_gz_archive) -C $(SRC_DIR)
	$(call apply-opt-patches, $(SRC_DIR)/$(qtc_src_dir_name))
	@( cd $(SRC_DIR) ; \
	   mv $(qtc_src_dir_name) qtcreator ; \
	 )
endif
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && \
	  $(QT_BUILD_ENVIRONMENT) CFG_ARCH="$(ARCH)" ./configure $(configure_switches)
	# ======= Fix configure error for __x86_64__ architecture =======
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC64)),)
	@( cd $(SRC_DIR) ; \
	   sed -i "s,^\(#define QT_POINTER_SIZE\).*,\1 8," qtbase/src/corelib/global/qconfig.h ; \
	 )
endif
	@cd $(SRC_DIR) && $(QT_BUILD_ENVIRONMENT) $(MAKE)
ifeq ($(BUILD_QT_CREATOR),yes)
	# ======= Build Qt Creator $(qtc_version) =======
	@( cd $(SRC_DIR)/qtcreator ; \
	   echo ""                     >> .qmake.conf ; \
	   echo "USE_SYSTEM_BOTAN = 1" >> .qmake.conf ; \
	   ../qtbase/bin/qmake -makefile \
	                       -spec ../qtbase/mkspecs/devices/$(DEVICE_SPEC_DIR) \
	                       -o Makefile qtcreator.pro ; \
	   $(MAKE) ; \
	   $(MAKE) -j1 html_docs ; \
	 )
endif
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(QT5_PKG)
ifeq ($(BUILD_QT_CREATOR),yes)
	# ======= Install Qt Creator $(qtc_version) =======
	@cd $(SRC_DIR)/qtcreator && $(MAKE) -j1 install INSTALL_ROOT=$(QT5_PKG)/usr
	@( cd $(QT5_PKG)/usr/bin ; \
	   mv qtcreator qtcreator-bin ; \
	   echo "#!/bin/sh"                                  > qtcreator ; \
	   echo ""                                          >> qtcreator ; \
	   echo 'QT_LOGGING_TO_CONSOLE=1 qtcreator-bin $$@' >> qtcreator ; \
	   chmod a+x qtcreator ; \
	 )
	@( cd $(QT5_PKG)/usr/share/icons/hicolor ; \
	   for file in `find . -name "QtProject-qtcreator.png"` ; do \
	     mv $$file `dirname $$file`/qt5-creator.png ; \
	   done ; \
	 )
	@mkdir -p $(QT5_PKG)/usr/share/applications
	@cp -a $(applications_dir)/qt5-creator.desktop $(QT5_PKG)/usr/share/applications/qt5-creator.desktop
	# ======= Install Qt Creator $(qtc_version) Documentation =======
	@mkdir -p $(QT5_PKG)/usr/doc/$(qtc_doc_dir_name)
	@mkdir -p $(QT5_PKG)/usr/share/doc/$(qtc_doc_dir_name)
	@( cd $(SRC_DIR)/qtcreator ; \
	   cp -a LICENSE.LGPL* LGPL_EXCEPTION.TXT \
	         $(QT5_PKG)/usr/doc/$(qtc_doc_dir_name) ; \
	   cp -a LICENSE.LGPL* LGPL_EXCEPTION.TXT README.md doc/html \
	         $(QT5_PKG)/usr/share/doc/$(qtc_doc_dir_name) ; \
	 )
endif
	@cd $(SRC_DIR) && $(QT_BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Rename build-machine tools =======
	@( cd $(QT5_PKG)/usr/lib$(LIBSUFFIX)/qt-$(version)/bin ; \
	   for file in lconvert lrelease lupdate moc qdbuscpp2xml qdbusxml2cpp  \
	               qdoc qlalr qmake qmlimportscanner qmllint qmlmin rcc uic ; do \
	     mv $$file $(TARGET)-qt5-$${file} ; \
	   done ; \
	 )
	@mkdir -p $(QT5_PKG)/usr/bin
	@( cd $(QT5_PKG)/usr/lib$(LIBSUFFIX)/qt-$(version)/bin ; \
	   for file in lconvert lrelease lupdate moc qdbuscpp2xml qdbusxml2cpp  \
	               qdoc qlalr qmake qmlimportscanner qmllint qmlmin rcc uic ; do \
	     ( cd $(QT5_PKG)/usr/bin ; ln -sf ../../usr/lib$(LIBSUFFIX)/qt-$(version)/bin/$(TARGET)-qt5-$${file} . ) ; \
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
	       $(MAKE) -j1 install $(env_sysroot) ; \
	     ) ; \
	   done ; \
	 )
	@( cd $(SRC_DIR)/qtbase/qmake ; \
	   $(MAKE) clean ; \
	 )
	@( cd $(SRC_DIR)/qtbase ; \
	   sed -i "/^# Verify makespec/ a\exit 0" configure ; \
	   $(QT_BUILD_ENVIRONMENT) ./configure \
	      -confirm-license -opensource -prefix /usr/lib$(LIBSUFFIX)/qt-$(version) \
	      -arch $(ARCH) -platform $(TARGET_SPEC_DIR) \
	      -force-pkg-config -release -shared -make tools -make libs \
	      -nomake examples -nomake tests -optimized-qmake \
	      -sysroot $(TARGET_DEST_DIR) -extprefix /usr/lib$(LIBSUFFIX)/qt-$(version) \
	      -verbose ; \
	   cp -a bin/qmake $(QT5_PKG)/usr/lib$(LIBSUFFIX)/qt-$(version)/bin ; \
	 )
	# ======= Set actual target mkspecs/$(TARGET_SPEC_DIR) =======
	@( cd $(QT5_PKG)/usr/lib$(LIBSUFFIX)/qt-$(version)/mkspecs ; \
	   rm -rf $(TARGET_SPEC_DIR) ; \
	   rm -rf devices/$(DEVICE_SPEC_DIR) ; \
	   spec=`cat $(config_spec) | grep "^QT_CONFIG" | sed 's,QT_CONFIG[ \t]*+=[ \t]*\(.*\),\1,'` ; \
	   cat $(CURDIR)/mkspecs/qconfig.pri.in      | \
	       sed "s,@ARCH@,$(ARCH),g"              | \
	       sed "s,@LIBDIRSUFFIX@,$(LIBSUFFIX),g" | \
	       sed "s,@CONFIG_SPEC@,$$spec,g"          \
	            > $(QT5_PKG)/usr/lib$(LIBSUFFIX)/qt-$(version)/mkspecs/qconfig.pri ; \
	   echo -n "" > qdevice.pri ; \
	   echo -n "" > qmodule.pri ; \
	 )
	@cp -a $(CURDIR)/mkspecs-pkg/$(TARGET_SPEC_DIR) $(QT5_PKG)/usr/lib$(LIBSUFFIX)/qt-$(version)/mkspecs
	@( cd $(QT5_PKG)/usr/lib$(LIBSUFFIX)/qt-$(version)/mkspecs/$(TARGET_SPEC_DIR) ; \
	   cat qmake.conf.in | \
	     sed 's,@TARGET_PREFIX@,/usr,g'            | \
	     sed 's,@TARGET_BINDIR@,/usr/bin,g'        | \
	     sed 's,@LIBDIRSUFFIX@,$(LIBSUFFIX),g'     | \
	     sed 's,@ARCH_FLAGS@,$(ARCH_FLAGS),g'      > qmake.conf ; \
	   rm -f qmake.conf.in ; \
	 )
	@cp -a $(CURDIR)/mkspecs-pkg/devices/$(DEVICE_SPEC_DIR) $(QT5_PKG)/usr/lib$(LIBSUFFIX)/qt-$(version)/mkspecs/devices
	@( cd $(QT5_PKG)/usr/lib$(LIBSUFFIX)/qt-$(version)/mkspecs/devices/$(DEVICE_SPEC_DIR) ; \
	   cat qmake.conf.in | \
	     sed 's,@TARGET_PREFIX@,/usr,g'            | \
	     sed 's,@TARGET_BINDIR@,/usr/bin,g'        | \
	     sed 's,@LIBDIRSUFFIX@,$(LIBSUFFIX),g'     | \
	     sed 's,@ARCH_FLAGS@,$(ARCH_FLAGS),g'      > qmake.conf ; \
	   rm -f qmake.conf.in ; \
	 )
	# ======= Create symbolic links to the installed Qt5 =======
	@( cd $(QT5_PKG)/usr/lib$(LIBSUFFIX) ; ln -sf qt-$(version) qt5 )
	# ======= Install Qt.pc file =======
	@cat $(pkgconfig_in) | \
	     sed "s,@PREFIX@,/usr/lib$(LIBSUFFIX)/qt-$(version),g" | \
	     sed "s,@VERSION@,$(version),g" > $(QT5_PKG)/usr/lib$(LIBSUFFIX)/qt-$(version)/lib/pkgconfig/Qt5.pc
	# ======= Remove internal used dependencies of libjscore, libwebcore ======
	@sed -i "s# -Wl,-whole-archive -lWebKit1 -Wl,-no-whole-archive -L$(CURDIR)/$(SRC_DIR)/qtwebkit/Source/WebKit/##g" \
	       $(QT5_PKG)/usr/lib$(LIBSUFFIX)/qt-$(version)/lib/pkgconfig/Qt5WebKit.pc
	@sed -i "s# -Wl,-whole-archive -lWebKit2 -Wl,-no-whole-archive -L$(CURDIR)/$(SRC_DIR)/qtwebkit/Source/WebKit2/##g" \
	       $(QT5_PKG)/usr/lib$(LIBSUFFIX)/qt-$(version)/lib/pkgconfig/Qt5WebKit.pc
	@sed -i "s# -Wl,-whole-archive -lWebCore -Wl,-no-whole-archive -L$(CURDIR)/$(SRC_DIR)/qtwebkit/Source/WebCore/##g" \
	       $(QT5_PKG)/usr/lib$(LIBSUFFIX)/qt-$(version)/lib/pkgconfig/Qt5WebKit.pc
	@sed -i "s# -Wl,-whole-archive -lANGLE -Wl,-no-whole-archive -L$(CURDIR)/$(SRC_DIR)/qtwebkit/Source/ThirdParty/ANGLE/##g" \
	       $(QT5_PKG)/usr/lib$(LIBSUFFIX)/qt-$(version)/lib/pkgconfig/Qt5WebKit.pc
	@sed -i "s# -Wl,-whole-archive -lleveldb -Wl,-no-whole-archive -L$(CURDIR)/$(SRC_DIR)/qtwebkit/Source/ThirdParty/leveldb/##g" \
	       $(QT5_PKG)/usr/lib$(LIBSUFFIX)/qt-$(version)/lib/pkgconfig/Qt5WebKit.pc
	@sed -i "s# -Wl,-whole-archive -lJavaScriptCore -Wl,-no-whole-archive -L$(CURDIR)/$(SRC_DIR)/qtwebkit/Source/JavaScriptCore/##g" \
	       $(QT5_PKG)/usr/lib$(LIBSUFFIX)/qt-$(version)/lib/pkgconfig/Qt5WebKit.pc
	@sed -i "s# -Wl,-whole-archive -lWTF -Wl,-no-whole-archive -L$(CURDIR)/$(SRC_DIR)/qtwebkit/Source/WTF/##g" \
	       $(QT5_PKG)/usr/lib$(LIBSUFFIX)/qt-$(version)/lib/pkgconfig/Qt5WebKit.pc
	# ======= Link shared libraries into /usr/lib$(LIBSUFFIX) =======
	@( cd $(QT5_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in qt-$(version)/lib/*.so* ; do \
	     ln -sf $$file . ; \
	   done ; \
	 )
	# ======= Add Profile scripts =======
	@mkdir -p $(QT5_PKG)/etc/profile.d
	@cat $(profile_dir)/qt5.csh.in | sed "s,@LIBDIR@,/usr/lib$(LIBSUFFIX),g" > $(QT5_PKG)/etc/profile.d/qt5.csh
	@cat $(profile_dir)/qt5.sh.in  | sed "s,@LIBDIR@,/usr/lib$(LIBSUFFIX),g" > $(QT5_PKG)/etc/profile.d/qt5.sh
	@chmod 0755 $(QT5_PKG)/etc/profile.d/*
	# ======= Link pkgconfig files to 'normal' place =======
	@mkdir -p $(QT5_PKG)/usr/lib$(LIBSUFFIX)/pkgconfig
	@( cd $(QT5_PKG)/usr/lib$(LIBSUFFIX)/qt-$(version)/lib/pkgconfig ; \
	   for file in *.pc ; do \
	     ( cd $(QT5_PKG)/usr/lib$(LIBSUFFIX)/pkgconfig ; ln -sf ../../lib$(LIBSUFFIX)/qt-$(version)/lib/pkgconfig/$$file . ) ; \
	   done ; \
	 )
	# ======= Add menu entries for Qt applications =======
	@mkdir -p $(QT5_PKG)/usr/share/icons/hicolor/{16x16,32x32,48x48,64x64,128x128}/apps
	@( cd $(SRC_DIR) ; \
	   convert qtdoc/doc/src/images/qt-logo.png -resize 32x32 $(QT5_PKG)/usr/share/icons/hicolor/32x32/apps/qt5-logo.png ; \
	   convert qtdoc/doc/src/images/qt-logo.png -resize 48x48 $(QT5_PKG)/usr/share/icons/hicolor/48x48/apps/qt5-logo.png ; \
	   install -p -m644 -D qttools/src/assistant/assistant/images/assistant.png $(QT5_PKG)/usr/share/icons/hicolor/32x32/apps/qt5-assistant.png ; \
	   install -p -m644 -D qttools/src/assistant/assistant/images/assistant-128.png $(QT5_PKG)/usr/share/icons/hicolor/128x128/apps/qt5-assistant.png ; \
	   install -p -m644 -D qttools/src/designer/src/designer/images/designer.png $(QT5_PKG)/usr/share/icons/hicolor/128x128/apps/qt5-designer.png ; \
	   for icon in qttools/src/linguist/linguist/images/icons/linguist-*-32.png ; do \
	     file=`basename $${icon}` ; \
	     size=`echo $${file} | cut -d- -f2` ; \
	     install -p -m644 -D $${icon} $(QT5_PKG)/usr/share/icons/hicolor/$${size}x$${size}/apps/qt5-linguist.png ; \
	   done ; \
	   install -p -m644 -D qttools/src/qdbus/qdbusviewer/images/qdbusviewer.png $(QT5_PKG)/usr/share/icons/hicolor/32x32/apps/qt5-qdbusviewer.png ; \
	   install -p -m644 -D qttools/src/qdbus/qdbusviewer/images/qdbusviewer-128.png $(QT5_PKG)/usr/share/icons/hicolor/128x128/apps/qt5-qdbusviewer.png ; \
	 )
	@mkdir -p $(QT5_PKG)/usr/share/applications
	@( cd $(applications_dir) ; \
	   for file in assistant designer linguist qdbusviewer ; do \
	     cat qt5-$${file}.desktop.in | \
	       sed "s,@QT5LINK@,/usr/lib$(LIBSUFFIX)/qt-$(version),g" > $(QT5_PKG)/usr/share/applications/qt5-$${file}.desktop ; \
	   done ; \
	 )
	# ======= Install Documentation =======
	@mkdir -p $(QT5_PKG)/usr/doc/$(doc_dir_name)
	@cp -a $(SRC_DIR)/*GPL_EXCEPTION* $(SRC_DIR)/LICENSE* \
	       $(QT5_PKG)/usr/doc/$(doc_dir_name)
	@mkdir -p $(QT5_PKG)/usr/share/doc/$(doc_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a qtbase/INSTALL *GPL_EXCEPTION* LICENSE* README \
	         $(QT5_PKG)/usr/share/doc/$(doc_dir_name) ; \
	 )
	# ======= Install config.summary =======
	@cat $(config_summary) | sed '/^Platform notes:/,/^qmake vars/d' \
	                       > $(QT5_PKG)/usr/share/doc/$(doc_dir_name)/config.summary
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(QT5_PKG)/usr/lib$(LIBSUFFIX)/qt-$(version)/lib ; \
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
	@( cd $(QT5_PKG)/usr/lib$(LIBSUFFIX)/qt-$(version)/lib ; \
	   sed -i "s,$(CURDIR)/$(SRC_DIR),/usr/lib$(LIBSUFFIX)/qt-$(version),g" \
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
	@( cd $(QT5_PKG)/usr/lib$(LIBSUFFIX)/qt-$(version)/lib/pkgconfig ; \
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
	# ======= remove target path from *.cmake files =======
	@( cd $(QT5_PKG)/usr/lib$(LIBSUFFIX)/qt-$(version)/lib/cmake ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" Qt5Gui/Qt5GuiConfigExtras.cmake ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(QT5_PKG))
	# ======= Remove build-machine tools from target package =======
	@( cd $(QT5_PKG)/usr/lib$(LIBSUFFIX)/qt-$(version)/bin ; \
	   for file in lconvert lrelease lupdate moc qdbuscpp2xml qdbusxml2cpp  \
	               qdoc qlalr qmake qmlimportscanner qmllint qmlmin rcc uic ; do \
	     rm -f $(TARGET)-qt5-$${file} ; \
	   done ; \
	 )
ifeq ($(BUILD_QT_CREATOR),yes)
	@( cd $(QT5_PKG)/usr/bin ; \
	   for file in lconvert lrelease lupdate moc qdbuscpp2xml qdbusxml2cpp  \
	               qdoc qlalr qmake qmlimportscanner qmllint qmlmin rcc uic ; do \
	     rm -f $(TARGET)-qt5-$${file} ; \
	   done ; \
	 )
else
	@rm -rf $(QT5_PKG)/usr/bin
endif
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/qt-$(version)/lib ; \
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
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/qt-$(version)/lib/pkgconfig ; \
	   sed -i "s,/usr/lib,$(TARGET_DEST_DIR)/usr/lib,g" Qt5.pc                                            \
	                                                    Enginio.pc              Qt5Bluetooth.pc           \
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
	# ======= tune search path in *.cmake files for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/qt-$(version)/lib/cmake ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" Qt5Gui/Qt5GuiConfigExtras.cmake ; \
	 )
	# ======= Strip binaries =======
	@( cd $(QT5_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(QT5_PKG)/usr/lib$(LIBSUFFIX)/qt-$(version)/libexec ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if [ -n "$$rpath" ] ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(QT5_PKG_DESCRIPTION_FILE): $(QT5_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(QT5_PKG_DESCRIPTION_FILE) $(QT5_PKG_INSTALL_SCRIPT)
	@cp $(QT5_PKG_DESCRIPTION_FILE) $(QT5_PKG)/.DESCRIPTION
	@cp $(QT5_PKG_INSTALL_SCRIPT) $(QT5_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(QT5_PKG)/.REQUIRES
	@echo "pkgname=$(QT5_PKG_NAME)"                            >  $(QT5_PKG)/.PKGINFO ; \
	 echo "pkgver=$(QT5_PKG_VERSION)"                          >> $(QT5_PKG)/.PKGINFO ; \
	 echo "arch=$(QT5_PKG_ARCH)"                               >> $(QT5_PKG)/.PKGINFO ; \
	 echo "distroname=$(QT5_PKG_DISTRO_NAME)"                  >> $(QT5_PKG)/.PKGINFO ; \
	 echo "distrover=$(QT5_PKG_DISTRO_VERSION)"                >> $(QT5_PKG)/.PKGINFO ; \
	 echo "group=$(QT5_PKG_GROUP)"                             >> $(QT5_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(QT5_PKG_SHORT_DESCRIPTION)\"" >> $(QT5_PKG)/.PKGINFO ; \
	 echo "url=$(QT5_PKG_URL)"                                 >> $(QT5_PKG)/.PKGINFO ; \
	 echo "license=$(QT5_PKG_LICENSE)"                         >> $(QT5_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(QT5_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
