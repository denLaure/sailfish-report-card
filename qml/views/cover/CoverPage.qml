import QtQuick 2.0
import Sailfish.Silica 1.0
import "../../stores"
import "../../actions"

CoverBackground {


    Loader {
        anchors.fill: parent
        sourceComponent: TimerStore.isTaskTimerLaunched ? taskTimerRunComponent :
                                                          (TasksStore.areAllTasksCompleted ? nothingScheduledComponent : nearTaskComponent)
    }

    Component {
        id: nothingScheduledComponent
        Label {
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: Theme.fontSizeLarge
            wrapMode: Text.Wrap
            text: qsTr("Nothing scheduled")
        }
    }

    Component {
        id: nearTaskComponent
        Item {
            Label {
                id: headerLabel
                text: qsTr("The closest tasks")
                font.pixelSize: Theme.fontSizeMedium
                wrapMode: Text.Wrap
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: taskNameLabel.top
                    margins: Theme.paddingLarge
                }
            }

            Label {
                id: taskNameLabel
                text: TasksStore.nearestTask.name
                font.pixelSize: Theme.fontSizeLarge
                wrapMode: Text.Wrap
                anchors.centerIn: parent

            }
        }
    }

    Component {
        id: taskTimerRunComponent
        Item {
            Label {
                id: taskNameLabel
                text: TimerStore.taskName
                font.pixelSize: Theme.fontSizeLarge
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.Wrap
                clip: true
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                    bottom: timerString.top
                    margins: Theme.paddingLarge
                }
            }

            Label {
                id: timerString
                anchors.centerIn: parent
                text: TimerStore.taskTimerString
                font.pixelSize: Theme.fontSizeExtraLarge * 1.5
            }

            CoverActionList {
                CoverAction {
                    iconSource: TimerStore.timerActive ? "image://theme/icon-cover-pause" : "image://theme/icon-cover-play"
                    onTriggered: AppActions.pauseOrStartTaskTimer(InformationAboutTask.elementIndex)
                }
            }
        }
    }
}


