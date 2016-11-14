pragma Singleton
import QtQuick 2.0
import harbour.report.card.QuickFlux 1.0
import Sailfish.Silica 1.0
import "../actions"

AppListener {

    property bool isTaskTimerLaunched: false

    property int taskIndex

    property string taskName

    property bool isDialogOpen: false

    property string taskDescription

    property bool timerActive: false

    property alias taskTimer: stopwatch

    property string taskTimerString: "00:00"

    property int elapsedTime: 0

    property date previousTime: new Date()

    Timer {
        id: stopwatch
        interval: 1000
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: {
            if (timerActive) {
                var currentTime = new Date ();
                var differentInTime = (currentTime.getTime() - previousTime.getTime());
                previousTime = currentTime;
                updateData(differentInTime);
            }
        }
    }

    function pauseOrStartTaskTimer(index){
        isTaskTimerLaunched = true;
        taskIndex = index;
        if (timerActive) {
            timerActive = false;
        } else {
            previousTime = new Date ();
            timerActive = true;
        }
    }

    function resetData() {
        timerActive = false;
        elapsedTime = 0;
        taskTimerString = "00:00";
    }

    function updateData(usec){
        elapsedTime += usec;
        taskTimerString = getTimeString(elapsedTime);
    }

    function getDigitString(digit) {
        return (digit < 10 ? "0" : "") + digit
    }

    function getTimeString(usec) {
        return  (usec >= 3600000 ? Math.floor(usec / 3600000) + ':' : '') +
                getDigitString(Math.floor((usec % 3600000) / 60000)) + ':' +
                getDigitString(Math.floor((usec % 60000) / 1000));
    }
}
