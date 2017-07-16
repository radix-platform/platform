TARGET=cpaster

QTC_LIB_DEPENDS += \
    extensionsystem \
    utils
QTC_PLUGIN_DEPENDS += \
    coreplugin

include(../../../qtcreatortool.pri)

QT += network

HEADERS = ../protocol.h \
    ../cpasterconstants.h \
    ../pastebindotcomprotocol.h \
    ../pastebindotcaprotocol.h \
    ../kdepasteprotocol.h \
    ../urlopenprotocol.h \
    argumentscollector.h

SOURCES += ../protocol.cpp \
    ../pastebindotcomprotocol.cpp \
    ../pastebindotcaprotocol.cpp \
    ../kdepasteprotocol.cpp \
    ../urlopenprotocol.cpp \
    argumentscollector.cpp \
    main.cpp

LIBS += -L$$top_builddir/../qtbase/lib        -lQt5PrintSupport -lQt5Sql
LIBS += -L$$top_builddir/../qtdeclarative/lib -lQt5Qml
LIBS += -L$$top_builddir/../qttools/lib       -lQt5Help -lQt5CLucene
