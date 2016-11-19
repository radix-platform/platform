INCLUDEPATH *= $$PWD/..
HEADERS += $$PWD/botan.h

    DEFINES += USE_SYSTEM_BOTAN
    CONFIG += link_pkgconfig
    PKGCONFIG += botan-1.10
