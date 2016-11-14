#ifdef QT_QML_DEBUG
#include <QtQuick/QQuickView>
#endif

#include <sailfishapp.h>
#include <QQmlComponent>
#include <QQmlContext>
#include <QQmlEngine>
#include <QDir>
#include <QStandardPaths>
#include <QGuiApplication>
#include <QQuickView>
#include "csvfilewriter.h"
#include "htmlfilewriter.h"


int main(int argc, char *argv[])
{
    QGuiApplication* app =  SailfishApp::application(argc, argv);
    QQuickView* view = SailfishApp::createView();

    qmlRegisterType<CsvFileWriter>("harbour.report.card.csvfilewriter", 1, 0 ,"CsvFileWriter");

    CsvFileWriter csvFileWriter;
    QQmlEngine* qmlEngine = view->engine();
    qmlEngine->rootContext()->setContextProperty("csvFileWriter", &csvFileWriter);
    QQmlComponent csvWriterComponent(qmlEngine, QUrl("TaskStore.qml"));
    csvWriterComponent.create();

    qmlRegisterType<HtmlFileWriter>("harbour.report.card.htmlfilewriter", 1, 0 ,"HtmlFileWriter");

    HtmlFileWriter htmlFileWriter;
    qmlEngine->rootContext()->setContextProperty("htmlFileWriter", &htmlFileWriter);
    QQmlComponent htmlWriterComponent(qmlEngine, QUrl("TaskStore.qml"));
    htmlWriterComponent.create();

    QDir(QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation)).mkdir("ReportCard");

    view->setSource(SailfishApp::pathTo("qml/report_card.qml"));
    view->showFullScreen();
    QObject::connect(view->engine(), &QQmlEngine::quit, app, &QGuiApplication::quit);
    return app->exec();
}

