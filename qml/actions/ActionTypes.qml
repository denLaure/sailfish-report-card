/*
  ActionTypes is a constant table to store all the available
 action types in an application.
 */

pragma Singleton
import QtQuick 2.0
import harbour.report.card.QuickFlux 1.0

KeyTable {
    id: actionTypes;

    property string navigateTo

    property string addNewTask

    property string openTasksList

    property string pauseOrStartTaskTimer

    property string resetData

    property string saveCurrentTaskTimerAndOpenNew

    property string resetCurrentTaskTimerAndOpenNew

    property string goToCurrentTaskTimer

    property string fillTasksList

    property string filterTasksList

    property string createDatabase

    property string updateDateTask

    property string changeDateTask

    property string changeTimeTask

    property string updateTaskInfo

    property string showTask

    property string openNewTaskPage

    property string deleteTask

    property string addSpentTime

    property string editSpentTime

    property string openTaskTimer

    property string saveValueOfTaskTimer

    property string createCsvReport

    property string createHtmlReport

    property string formReport

    property string openReportPage
}
