import QtQuick 2.0
import harbour.report.card.QuickFlux 1.0
import "../actions"
import "../views/pages"
import "../stores"

Item {

    property string dateTaskString: ""

    property string timeTaskString: ""

    property double hoursDateTask

    property double minutesDateTask

    property var remorsePopup

    AppScript {
        runWhen: ActionTypes.openNewTaskPage

        script: {
            InformationAboutTask.isTaskNameValid = false;
            InformationAboutTask.areTaskDatesValid = false;
            InformationAboutTask.updateInfo(-1);
            AppActions.navigateTo("../views/pages/AddNewTaskPage.qml");
        }
    }

    AppScript {
        runWhen: ActionTypes.saveCurrentTaskTimerAndOpenNew

        script: {
            TimerStore.isTaskTimerLaunched = false;
            InformationAboutTask.addSpentTimeForCurrentTaskTimer(TimerStore.elapsedTime / 3600000);
            TasksStore.updateSpentTime(TimerStore.taskIndex, TasksStore.list.get(TimerStore.taskIndex).spentTime)
            TimerStore.taskIndex = InformationAboutTask.elementIndex;
            TimerStore.resetData();
            AppActions.openTaskTimer();
        }
    }

    AppScript {
        runWhen: ActionTypes.resetCurrentTaskTimerAndOpenNew

        script: {
            TimerStore.isTaskTimerLaunched = false;
            TimerStore.taskIndex = InformationAboutTask.elementIndex;
            TimerStore.resetData();
            AppActions.openTaskTimer();
        }
    }

    AppScript {
        runWhen: ActionTypes.goToCurrentTaskTimer

        script: {
            pageStack.replace(Qt.resolvedUrl("../views/pages/TaskTimerPage.qml"));
        }
    }

    AppScript {
        runWhen: ActionTypes.openTaskTimer

        script: {
            if (TimerStore.taskIndex !== InformationAboutTask.elementIndex && TimerStore.isTaskTimerLaunched) {
                pageStack.push(Qt.resolvedUrl("../views/dialogs/StartNewTaskTimerDialog.qml"), {});
            } else {
                TimerStore.taskName = InformationAboutTask.taskName;
                TimerStore.taskDescription = InformationAboutTask.taskDescription;
                if (TimerStore.isDialogOpen) {
                    pageStack.replace(Qt.resolvedUrl("../views/pages/TaskTimerPage.qml"));
                    TimerStore.isDialogOpen = false;
                } else {
                    AppActions.navigateTo("../views/pages/TaskTimerPage.qml");
                }
            }
        }
    }

    AppScript {
        runWhen: ActionTypes.pauseOrStartTaskTimer

        script: {
            TimerStore.pauseOrStartTaskTimer(message.index);
        }
    }

    AppScript {
        runWhen: ActionTypes.resetData

        script: {
            TimerStore.resetData();
        }
    }

    AppScript {
        runWhen: ActionTypes.openTasksList

        script: {
            TasksStore.isFilterActive = false;
            AppActions.navigateTo("../views/pages/TasksListPage.qml");
        }
    }

    AppScript {
        runWhen: ActionTypes.filterTasksList

        script: {
            if (TasksStore.isFilterActive) {
                TasksStore.isFilterActive = false;
            } else {
                TasksStore.isFilterActive = true;
            }
        }
    }

    AppScript {
        runWhen: ActionTypes.addNewTask

        script: {
            if (message.TaskName !== '') {
                TasksStore.addTask(message.startDate, message.finishDate, message.TaskName, message.taskDescription);
                TasksStore.setNearTask();
                pageStack.pop();
            } else {
                InformationAboutTask.isTaskNameValid = true;
            }
        }
    }

    AppScript {
        runWhen: ActionTypes.editSpentTime

        script: {
            var editSpentTimeDialog = pageStack.push(Qt.resolvedUrl("../views/dialogs/EditSpentTimeDialog.qml"), {
                                                         "hours": Math.floor(message.currentSpentTime),
                                                         "minutes": message.currentSpentTime % 1 * 60 });
            editSpentTimeDialog.accepted.connect(function(){
                InformationAboutTask.spentTime = editSpentTimeDialog.hours + editSpentTimeDialog.minutes / 60;
            });
        }
    }

    AppScript {
        runWhen: ActionTypes.addSpentTime

        script: {
            var timePicker = pageStack.push("Sailfish.Silica.TimePickerDialog");
            timePicker.accepted.connect(
                        function() {
                            var spentTime = timePicker.hour + timePicker.minute / 60;
                            InformationAboutTask.addSpentTime(spentTime);
                        }
                        );
        }
    }

    AppScript {
        runWhen: ActionTypes.saveValueOfTaskTimer

        script: {
            pageStack.pop();
            var time = message.time / 3600000;
            InformationAboutTask.addSpentTime(time);
            TimerStore.resetData();
            TimerStore.isTaskTimerLaunched = false;
        }
    }

    AppScript {
        runWhen: ActionTypes.deleteTask

        script: {
            pageStack.pop();
            remorsePopup.execute("Removing task " + message.taskName,
                                 function() {
                                     TasksStore.deleteTask(message.index);
                                     TasksStore.setNearTask();
                                 });
        }
    }

    AppScript {
        runWhen: ActionTypes.showTask

        script: {
            remorsePopup = message.remorsePopup;
            InformationAboutTask.isTaskNameValid = false;
            InformationAboutTask.areTaskDatesValid = false;
            InformationAboutTask.isNewSpentTimeNotValid = false;
            InformationAboutTask.updateInfo(message.index);
            AppActions.navigateTo("../views/pages/TaskPage.qml")
        }
    }

    AppScript {
        runWhen: ActionTypes.updateTaskInfo

        script: {
            if (message.TaskName !== '') {
                TasksStore.updateTaskInfo(message.startDate, message.finishDate, message.TaskName, message.taskDescription,
                                          message.TaskDone, message.spentTime, message.index);
                TasksStore.setNearTask();
                pageStack.pop();
            } else {
                InformationAboutTask.isTaskNameValid = true;
            }
        }
    }

    AppScript {
        runWhen: ActionTypes.updateDateTask

        script: {
            InformationAboutTask.updateDateTask(message.dateTask, message.textLabel)
        }
    }

    function checkDateValid(textLabel) {
        var resultDate = new Date(dateTaskString + " " + timeTaskString);
        if (textLabel === qsTr("Start:") && resultDate < InformationAboutTask.finishDateTask ||
                textLabel === qsTr("Finish:") && resultDate > InformationAboutTask.startDateTask) {
            InformationAboutTask.areTaskDatesValid = false;
            AppActions.updateDateTask(resultDate, textLabel);
        } else {
            InformationAboutTask.areTaskDatesValid = true;
        }
    }

    AppScript {
        runWhen: ActionTypes.changeDateTask

        script: {
            var datePicker = pageStack.push("Sailfish.Silica.DatePickerDialog", {date: message.dateTask});
            datePicker.accepted.connect(
                        function() {
                            timeTaskString = Qt.formatDateTime(message.dateTask,"hh:mm");
                            dateTaskString = Qt.formatDateTime(datePicker.date, "yyyy-MM-dd");
                            checkDateValid(message.textLabel);
                        }
                        );
        }
    }


    AppScript {
        runWhen: ActionTypes.changeTimeTask

        script: {
            var timePicker = pageStack.push("Sailfish.Silica.TimePickerDialog", {
                                                hour: message.dateTask.getHours(),
                                                minute: message.dateTask.getMinutes()
                                            });
            timePicker.accepted.connect(
                        function() {
                            timeTaskString = timePicker.timeText;
                            dateTaskString = Qt.formatDateTime(message.dateTask, "yyyy-MM-dd");
                            checkDateValid(message.textLabel);
                        }
                        );
        }
    }

    AppScript {
        runWhen: ActionTypes.fillTasksList

        script: {
            TasksStore.fillTasksList();
        }
    }

    AppScript {
        runWhen: ActionTypes.createDatabase

        script: {
            TasksStore.createDatabase();
        }
    }

    AppScript {
        runWhen: ActionTypes.formReport

        script: {
            var reportCreated;
            if(message.format === "csv") {
                reportCreated = TasksStore.createCsvReport(message.startDate, message.endDate);
            } else {
                reportCreated = TasksStore.createHtmlReport(message.startDate, message.endDate);
            }
            if(reportCreated) {
                var splitPosition = reportCreated.lastIndexOf("/") + 1;
                TasksStore.notificationText = qsTr("Report") + " "
                        + reportCreated.substring(splitPosition) + " "
                        + qsTr("created in") + " "
                        + reportCreated.substring(0, splitPosition);
            } else {
                TasksStore.notificationText = qsTr("Unable to create report, cannot write to file");
            }
        }
    }

    AppScript {
        runWhen: ActionTypes.openReportPage

        script: {
            InformationAboutTask.isTaskNameValid = false;
            InformationAboutTask.areTaskDatesValid = false;
            InformationAboutTask.updateInfo(-1);
            AppActions.navigateTo("../views/pages/ReportPage.qml");
        }
    }

    AppListener {
        filter: ActionTypes.navigateTo
        onDispatched: {
            pageStack.push(Qt.resolvedUrl(message.url));
        }
    }
}
