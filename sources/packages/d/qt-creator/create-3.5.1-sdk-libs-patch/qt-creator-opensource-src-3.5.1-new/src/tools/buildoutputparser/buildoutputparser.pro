QTC_LIB_DEPENDS = utils
QTC_PLUGIN_DEPENDS = projectexplorer qtsupport qmakeprojectmanager
QT = core gui

include(../../qtcreatortool.pri)

TARGET = buildoutputparser

win32|equals(TEST, 1):DEFINES += HAS_MSVC_PARSER

SOURCES = \
    main.cpp \
    outputprocessor.cpp

HEADERS = \
    outputprocessor.h

LIBS += -L$$top_builddir/../qtbase/lib        -lQt5PrintSupport -lQt5Sql -lQt5Xml
LIBS += -L$$top_builddir/../qtdeclarative/lib -lQt5Qml -lQt5Quick
LIBS += -L$$top_builddir/../qttools/lib       -lQt5Help -lQt5CLucene
