/*
  AppActions is an action creator, a helper component to create
 and dispatch actions via the central dispatcher.
 */

pragma Singleton
import QtQuick 2.0
import harbour.report.card.QuickFlux 1.0
import "./"

ActionCreator {

    //Open window with given url
    signal navigateTo(string url)

    //Fill the Task List
    signal fillTasksList()

    //Save the value of the current timer and open a new task timer
    signal saveCurrentTaskTimerAndOpenNew()

    //Reset the value of the current task timer and open a new task timer
    signal resetCurrentTaskTimerAndOpenNew()

    //Go to the current task timer
    signal goToCurrentTaskTimer()

    //Set status of the timer
    signal pauseOrStartTaskTimer(int index)

    // Reset data of the timer
    signal resetData()

    //Save the value of Task Timer
    signal saveValueOfTaskTimer(int time)

    //Open the TasksListPage
    signal openTasksList()

    //Open the TaskTimerPage
    signal openTaskTimer()

    //Add the new Task
    signal addNewTask(date startDate, date finishDate, string TaskName, string taskDescription)

    //Create a database
    signal createDatabase()

    //Update the date of Task
    signal updateDateTask(date dateTask, string textLabel)

    //Open window with DatePickerDialog
    signal changeDateTask(date dateTask, string textLabel)

    //Open window with TimePickerDialog
    signal changeTimeTask(date dateTask, string textLabel)

    //Open window with Task
    signal showTask(var remorsePopup, int index)

    //Open window with new Task
    signal openNewTaskPage()

    //Delete Task from TasksList
    signal deleteTask(string taskName, int index)

    //Add spent time for Task
    signal addSpentTime()

    //Edit spent time fo Taks
    signal editSpentTime(double currentSpentTime)

    //Update informatiom about Task
    signal updateTaskInfo(date startDate, date finishDate, string TaskName, string taskDescription,
                          bool TaskDone, double spentTime,int index)

    //Create report in given time spot
    signal formReport(date startDate, date endDate, string format)

    //Open page for creating reports
    signal openReportPage()

    //Filter the tasks list
    signal filterTasksList()
}
