TARGET = harbour-report-card

CONFIG += sailfishapp \
    sailfishapp_i18n \

SOURCES += src/report_card.cpp

include(lib/quickflux-master/quickflux.pri)

OTHER_FILES += qml/report_card.qml \
    qml/views/cover/CoverPage.qml \
    qml/views/components/*.qml \
    qml/views/dialogs/*.qml \
    qml/actions/AppActions.qml \
    qml/actions/ActionTypes.qml \
    qml/actions/qml \
    qml/stores/*.qml \
    qml/adapters/*.qml \
    qml/scripts/*.qml \
    qml/views/pages/*.qml \
    rpm/harbour-report-card.changes.in \
    rpm/harbour-report-card.yaml \
    translations/*.ts \
    harbour-report-card.desktop

SAILFISHAPP_ICONS = 86x86 108x108 128x128 256x256

HEADERS += \
    src/csvfilewriter.h \
    src/htmlfilewriter.h

DISTFILES += \
    qml/views/pages/ReportPage.qml

localization.files = localization
localization.path = /usr/share/harbour-report-card/localization

INSTALLS += localization

TRANSLATIONS += translations/harbour-report-card-ru.ts

lupdate_only{
    SOURCES += QML/views/pages/*.qml \
        QML/views/components/*.qml
}
