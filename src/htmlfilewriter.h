#ifndef HTMLFILEWRITER
#define HTMLFILEWRITER

#include <QObject>
#include <QDateTime>
#include <QTextDocumentWriter>
#include <QTextDocument>
#include <QTextTable>
#include <QTextCursor>
#include <QFileInfo>
#include <QTextTableFormat>
#include <QTextCharFormat>
#include <QBrush>
#include <QColor>
#include <QStandardPaths>
#include <QDir>

class HtmlFileWriter : public QObject
{
    Q_OBJECT
public:
    Q_INVOKABLE void createDocument(int rows, QVariantList columns) {
        report = new QTextDocument();
        QTextCursor cursor(report);
        table = cursor.insertTable(rows + 1, columns.length());
        QTextCharFormat format;
        format.setFontWeight(QFont::Bold);
        QTextCharFormat cellFormat;
        cellFormat.setBackground(QBrush(Qt::cyan));
        for(int col = 0; col < table->columns(); col++) {
            QTextTableCell cell = table->cellAt(0, col);
            QTextCursor cellCursor = cell.firstCursorPosition();
            cell.setFormat(cellFormat);
            cellCursor.mergeCharFormat(format);
            cellCursor.insertText(columns[col].toString());
        }
        QTextTableFormat tableFormat = cursor.currentTable()->format();
        tableFormat.setCellSpacing(0);
        table->setFormat(tableFormat);
    }

    Q_INVOKABLE void addRow(int row, QVariantList taskInfo) {
        QTextCharFormat cellFormat;
        cellFormat.setBackground(QBrush(Qt::darkCyan));
        for(int col = 0; col < table->columns(); col++) {
            QTextTableCell cell = table->cellAt(row, col);
            QTextCursor cellCursor = cell.firstCursorPosition();
            cellCursor.insertText(taskInfo[col].toString());
        }
        QTextTableCell indexCell = table->cellAt(row, 0);
        indexCell.setFormat(cellFormat);
    }

    Q_INVOKABLE QString writeToFile() {
        QString filename = QDateTime::currentDateTime().toString("yyyy.MM.dd-HH:mm:ss") + "-report.html";
        QDir::setCurrent(QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation) + "/ReportCard");
        QTextDocumentWriter writer(filename, "html");
        writer.write(report);
        report->~QTextDocument();
        QFileInfo info(filename);
        return info.absoluteFilePath();
    }
private:
    QTextDocument *report;
    QTextTable *table;
};
#endif // HTMLFILEWRITER

