pragma Singleton
import QtQuick 2.0
import harbour.report.card.QuickFlux 1.0
import QtQuick.LocalStorage 2.0
import Sailfish.Silica 1.0
import harbour.report.card.csvfilewriter 1.0
import harbour.report.card.htmlfilewriter 1.0
import "../actions"

AppListener {

    property alias list: tasksList

    property alias nearestTask: nearestTask

    property string notificationText

    property bool isFilterActive: false

    property bool areAllTasksCompleted: false

    QtObject {
        id: nearestTask
        property string name
        property date startDate
        property date finishDate
        property double spentTime
        property bool done
        property int index
    }

    ListModel {
        id: tasksList
    }

    ListModel {
        id: queryResult
    }

    CsvFileWriter {
        id: csvFileWriter
    }

    HtmlFileWriter {
        id: htmlFileWriter
    }

    function checkTasksOnCompleted(){
        for (var i = 0; i < tasksList.count; i++) {
            if (!tasksList.get(i).taskDone){
                areAllTasksCompleted = false;
                nearestTask.index = i;
                return;
            }
        }
        areAllTasksCompleted = true;
    }

    function setNearTask(){
        checkTasksOnCompleted();
        if (!areAllTasksCompleted) {
            var tempNearestTask = tasksList.get(nearestTask.index);
            for (var i = 0; i < tasksList.count; i++) {
                if (tasksList.get(i).finishDate <= tempNearestTask.finishDate &&
                    tasksList.get(i).startDate <= tempNearestTask.startDate && tasksList.get(i).taskDone === false) {
                    tempNearestTask = tasksList.get(i);
                    nearestTask.index = i;
                }
            }
            nearestTask.done = tempNearestTask.taskDone
            nearestTask.name = tempNearestTask.taskName
            nearestTask.startDate = tempNearestTask.startDate
            nearestTask.finishDate = tempNearestTask.finishDate
            nearestTask.spentTime = tempNearestTask.spentTime
        }
    }

    function addTask(startDate, finishDate, taskName, taskDescription){
        var index = tasksList.count;
        tasksList.append({"startDate": startDate, "finishDate": finishDate, "taskName": taskName,
                         "taskDescription": taskDescription, "taskDone": false, "spentTime": 0});
        var timeZone = -startDate.getTimezoneOffset() / 60;
        insertTaskToDatabase(startDate, finishDate, timeZone, taskName, taskDescription, 0, 0, index);
    }

    function updateSpentTime(index, spentTime){
        var database = getDatabase();
        database.transaction(
                    function(transaction) {
                        transaction.executeSql('UPDATE Tasks SET spentTime = ? WHERE id = ?', [spentTime, index]);
                    }
                    )
    }

    function updateTaskInfo(startDateTask, finishDateTask, taskName, taskDescription, taskDone, spentTime, index) {
        var database = getDatabase();
        database.transaction(
                function(transaction) {
                    transaction.executeSql('UPDATE Tasks SET startDate = ?, finishDate = ?, taskName = ?,
                                            taskDescription = ?, taskDone = ?, spentTime = ? WHERE id = ?',
                                           [startDateTask, finishDateTask, taskName, taskDescription, taskDone, spentTime, index]);
                }
        )
        var element = tasksList.get(index);
        element.startDate = startDateTask;
        element.finishDate = finishDateTask;
        element.taskDescription = taskDescription;
        element.taskName = taskName;
        element.taskDone = taskDone;
        element.spentTime = spentTime;
    }

    function deleteTask(index){
        var database = getDatabase();
                database.transaction(
                    function(transaction) {
                        transaction.executeSql('DELETE FROM tasks WHERE id = ?', [index]);
                        transaction.executeSql('UPDATE tasks SET id = id - 1 WHERE id > ?', [index]);
                    }
                )
        tasksList.remove(index);
    }

    function insertTaskToDatabase(startDate, finishDate, timeZone, taskName, taskDescription, taskDone, spentTime, index){
        var database = getDatabase();
        database.transaction(
            function(transaction) {
                transaction.executeSql('INSERT INTO tasks VALUES(?, ?, ?, ?, ?, ?, ?, ?)',
                                       [startDate, finishDate, timeZone, taskName, taskDescription, taskDone, spentTime, index]);
            }
        )
    }

    function createDatabase(){
        var database = getDatabase();
        database.transaction(
            function (transaction) {
                transaction.executeSql('CREATE TABLE IF NOT EXISTS tasks(startDate NUMERIC, finishDate NUMERIC,
                                      timeZone INT, taskName TEXT, taskDescription TEXT, taskDone INTEGER, spentTime REAL, id INTEGER)');
            }
        )
    }

    function getDatabase(){
        return LocalStorage.openDatabaseSync("TasksList", "1.0", "TasksList", 1000000);
    }

    function convertDateToUTC(date) {
        date.setTime(date.getTime() + date.getTimezoneOffset()*60*1000 );
    }

    function fillTasksList() {
        var database = getDatabase();
        database.transaction(
             function(transaction) {
                 var tasks = transaction.executeSql('SELECT * FROM tasks');
                 for (var i = 0; i < tasks.rows.length; i++) {
                     var element = tasks.rows.item(i);
                     var startDate = new Date (element.startDate);
                     var finishDate = new Date (element.finishDate);
                     convertDateToUTC(startDate);
                     convertDateToUTC(finishDate);
                     var taskDoneBoolean = element.taskDone === 0 ? false : true
                     tasksList.append({"startDate": startDate, "finishDate": finishDate, "taskName": element.taskName,
                                      "taskDescription": element.taskDescription, "taskDone": taskDoneBoolean, "spentTime": element.spentTime});
                 }
             }
         )
    }

    function createCsvReport(beginningDate, endDate) {
        selectByPeriod(beginningDate, endDate);
        var file = csvFileWriter.openFile([qsTr("Index"), qsTr("Start date"), qsTr("Due date"), qsTr("Task name"),
                                           qsTr("Task description"), qsTr("Completion status"), qsTr("Spent time")]);
        if(file) {
            for(var i = 0; i < queryResult.count; i++) {
                var element = queryResult.get(i);
                csvFileWriter.writeLine([i + 1, element.startDate, element.finishDate, element.taskName,
                                         element.taskDescription, element.taskDone ? "completed" : "not completed",
                                         element.spentTime.toFixed(0) + " " + qsTr("hours") + " "
                                         + (element.spentTime % 1 * 60).toFixed(0) + " " + qsTr("minutes")]);
            }
            csvFileWriter.closeFile();
            return file;
        }
        return false;
    }

    function createHtmlReport(beginningDate, endDate) {
        selectByPeriod(beginningDate, endDate);
        htmlFileWriter.createDocument(list.count, [qsTr("Index"), qsTr("Start date"), qsTr("Due date"), qsTr("Task name"),
                                                   qsTr("Task description"), qsTr("Task status"), qsTr("Spent time")]);
        for(var i = 0; i < queryResult.count; i++) {
            var element = queryResult.get(i);
            htmlFileWriter.addRow(i + 1, [i + 1, element.startDate, element.finishDate, element.taskName,
                                          element.taskDescription, element.taskDone ? "completed" : "not completed",
                                          element.spentTime.toFixed(0) + " " + qsTr("hours") + " "
                                          + (element.spentTime % 1 * 60).toFixed(0) + " " + qsTr("minutes")]);
        }
        return htmlFileWriter.writeToFile();
    }

    function selectByPeriod(beginning, end) {
        var database = getDatabase();
        queryResult.clear();
        database.transaction(
            function(transaction) {
                var tasks = transaction.executeSql('SELECT * FROM tasks WHERE startDate >= ? AND finishDate <= ?',
                                                   [beginning, end]);
                for (var i = 0; i < tasks.rows.length; i++) {
                    var element = tasks.rows.item(i);
                    var startDate = new Date (element.startDate);
                    var finishDate = new Date (element.finishDate);
                    convertDateToUTC(startDate);
                    convertDateToUTC(finishDate);
                    var taskDoneBoolean = element.taskDone === 0 ? false : true
                    queryResult.append({"startDate": startDate, "finishDate": finishDate, "taskName": element.taskName,
                                     "taskDescription": element.taskDescription, "taskDone": taskDoneBoolean, "spentTime": element.spentTime});
                }
            }
        )
    }
}
