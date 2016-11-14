import QtQuick 2.0
import harbour.report.card.QuickFlux 1.0
import Sailfish.Silica 1.0
import "../../actions"
import "../../stores"

Item {
    height: Theme.itemSizeMedium * 3

    Label {
        id: taskTimerLabel
        height: Theme.itemSizeLarge
        font.pixelSize: text.length > 8 ? 132 : 150
        text: TimerStore.taskTimerString
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            margins: Theme.paddingLarge
        }
    }

    Button {
        id: resetTimerButton
        text: qsTr("Reset")
        anchors {
            top: taskTimerLabel.bottom
            topMargin: Theme.paddingLarge * 3
            left: parent.left
            margins: Theme.paddingLarge
        }
        onClicked: AppActions.resetData()
    }

    Button {
        id: startOrFinishTimerButton
        text: TimerStore.timerActive ? qsTr("Stop") : qsTr("Start")
        anchors {
            top: taskTimerLabel.bottom
            topMargin: Theme.paddingLarge * 3
            right: parent.right
            margins: Theme.paddingLarge
        }
        onClicked: AppActions.pauseOrStartTaskTimer(InformationAboutTask.elementIndex)
    }
}
