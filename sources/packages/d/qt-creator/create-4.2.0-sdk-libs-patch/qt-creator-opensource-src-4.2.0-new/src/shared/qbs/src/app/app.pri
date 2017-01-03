include(../install_prefix.pri)

QT = core
TEMPLATE = app
!isEmpty(QBS_APPS_DESTDIR):DESTDIR = $${QBS_APPS_DESTDIR}
else:DESTDIR = ../../../bin

!isEmpty(QBS_APPS_RPATH_DIR) {
    linux-*:QMAKE_LFLAGS += -Wl,-z,origin \'-Wl,-rpath,$${QBS_APPS_RPATH_DIR}\'
    macx:QMAKE_LFLAGS += -Wl,-rpath,$${QBS_APPS_RPATH_DIR}
}

CONFIG += console
CONFIG -= app_bundle
CONFIG += c++11

include($${PWD}/../lib/corelib/use_corelib.pri)
include($${PWD}/shared/logging/logging.pri)

!isEmpty(QBS_APPS_INSTALL_DIR):target.path = $${QBS_APPS_INSTALL_DIR}
else:target.path = $${QBS_INSTALL_PREFIX}/bin
INSTALLS += target

LIBS += -L$$top_builddir/../qtbase/lib -lQt5Gui -lQt5Network -lQt5Xml
LIBS += -L$$top_builddir/../qtscript/lib -lQt5Script
