pragma Singleton
import QtQuick 2.0
import harbour.report.card.QuickFlux 1.0
import Sailfish.Silica 1.0
import "../actions"
import "./"

AppListener {
    property date startDateTask: new Date()

    property date finishDateTask: new Date()

    property ListModel tasksList: TasksStore.list

    property int elementIndex

    property string taskName

    property string taskDescription

    property double spentTime

    property bool taskDone

    property bool isTaskNameValid

    property bool areTaskDatesValid

    property bool isNewSpentTimeNotValid

    function updateInfo(index){
        if (index === -1){
            startDateTask = new Date();
            finishDateTask = new Date(startDateTask.getTime() + 3600000);
        } else {
            var element = tasksList.get(index);
            elementIndex = index;
            taskName = element.taskName;
            taskDescription = element.taskDescription
            startDateTask = element.startDate;
            finishDateTask = element.finishDate;
            taskDone = element.taskDone;
            spentTime = element.spentTime;
        }
    }

    function addSpentTime(value){
        spentTime += value;
    }

    function addSpentTimeForCurrentTaskTimer(value){
        tasksList.get(TimerStore.taskIndex).spentTime += value;
    }

    function updateDateTask(dateTask, textLabel){
        if (textLabel === "Start:"){
            startDateTask = new Date(dateTask);
        } else {
            finishDateTask = new Date(dateTask);
        }
    }
}
