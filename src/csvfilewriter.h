#ifndef CSVFILEWRITER
#define CSVFILEWRITER

#include <QObject>
#include <QFile>
#include <QDateTime>
#include <QTextStream>
#include <QStringList>
#include <QFileInfo>
#include <QTextCodec>
#include <QStandardPaths>
#include <QDir>

class CsvFileWriter : public QObject
{
    Q_OBJECT
public:
    Q_INVOKABLE QString openFile(QVariantList columns) {
        QString filename = QDateTime::currentDateTime().toString("yyyy.MM.dd-HH:mm:ss") + "-report.csv";
        csvFile.setFileName(filename);
        QDir::setCurrent(QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation) + "/ReportCard");
        csvFile.open(QIODevice::WriteOnly|QIODevice::Truncate);
        writeLine(columns);
        QFileInfo info(filename);
        return info.absoluteFilePath();
    }

    Q_INVOKABLE void closeFile() {
        csvFile.close();
    }

    Q_INVOKABLE void writeLine(QVariantList taskInfo) {
        QTextCodec *utf8 = QTextCodec::codecForName("Windows-1251");
        QTextStream stream(&csvFile);
        QStringList line;
        stream.setCodec(utf8);
        for(int i = 0; i < taskInfo.size(); i++) {
            line << taskInfo[i].toString();
        }
        stream << line.join(",") << endl;
    }
private:
    QFile csvFile;
};

#endif // CSVFILEWRITER

