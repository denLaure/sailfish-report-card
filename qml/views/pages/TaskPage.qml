import QtQuick 2.0
import harbour.report.card.QuickFlux 1.0
import Sailfish.Silica 1.0
import "../../actions"
import "../../stores"
import "../components"

Page{
    SilicaFlickable {
        contentHeight: column.height
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: qsTr("Delete")
                onClicked: AppActions.deleteTask(taskNameTetxField.text, InformationAboutTask.elementIndex)
            }

            MenuItem {
                text: qsTr("Edit spent time")
                onClicked: AppActions.editSpentTime(InformationAboutTask.spentTime)
            }

            MenuItem {
                text: qsTr("Task timer")
                onClicked: AppActions.openTaskTimer(InformationAboutTask.elementIndex)
            }
        }

        VerticalScrollDecorator {}

        Column {
            id: column
            spacing: Theme.paddingLarge
            anchors.margins: Theme.paddingLarge
            width: parent.width
            PageHeader { title: qsTr("Task") }

            TextField {
                id: taskNameTetxField
                width: parent.width
                placeholderText: qsTr("Enter the name of the task")
                text: InformationAboutTask.taskName
                labelVisible: false
                anchors {
                    left: parent.left
                    right: parent.right
                }
                EnterKey.onClicked: {
                    parent.focus = true;
                }
            }

            Label {
                id: isTaskNameValidLabel
                wrapMode: Text.Wrap
                text: qsTr("The task name cannot be empty")
                color: "red"
                visible: InformationAboutTask.isTaskNameValid
                anchors {
                    left: parent.left
                    right: parent.right
                    margins: Theme.paddingLarge
                }
            }

            TextArea {
                id: taskDescriptionTextArea
                text: InformationAboutTask.taskDescription
                labelVisible: false
                placeholderText: qsTr("Enter the description of the task")
                anchors {
                    left: parent.left
                    right: parent.right
                }
            }

            DateLabelComponent {
                id: startDateLabelComponent
                textForLabel: qsTr("Start:")
                taskDate: InformationAboutTask.startDateTask
                anchors {
                    left: parent.left
                    right: parent.right
                }
            }

            DateLabelComponent {
                id: finishDateLabelComponent
                textForLabel: qsTr("Finish:")
                taskDate: InformationAboutTask.finishDateTask
                anchors {
                    left: parent.left
                    right: parent.right
                }
            }

            Label {
                id: areTaskDatesValidLabel
                wrapMode: Text.Wrap
                text: qsTr("The finish date of the task is earlier than its start date")
                color: "red"
                visible: InformationAboutTask.areTaskDatesValid
                anchors {
                    left: parent.left
                    right: parent.right
                    margins: Theme.paddingLarge
                }
            }

            TextSwitch {
                height: Theme.itemSizeSmall
                id: doneTaskTextSwitch
                text: qsTr("Done")
                checked: InformationAboutTask.taskDone
            }

            Loader {
                height: Theme.itemSizeSmall / 1.5
                width: parent.width
                sourceComponent: spentTimeComponent
            }

            Label {
                id: isNewSpentTimeValidLabel
                wrapMode: Text.Wrap
                text: qsTr("Incorrect value of the spent time")
                color: "red"
                visible: InformationAboutTask.isNewSpentTimeNotValid
                anchors {
                    left: parent.left
                    right: parent.right
                    margins: Theme.paddingLarge
                }
            }

            Button {
                anchors {
                    left: parent.left
                    right: parent.right
                    margins: Theme.paddingLarge
                }
                text: qsTr("Log time")
                onClicked: AppActions.addSpentTime()
            }

            Button {
                anchors {
                    left: parent.left
                    right: parent.right
                    margins: Theme.paddingLarge
                }
                text: qsTr("Save")
                onClicked: AppActions.updateTaskInfo(startDateLabelComponent.taskDate, finishDateLabelComponent.taskDate, taskNameTetxField.text,
                                                     taskDescriptionTextArea.text, doneTaskTextSwitch.checked,
                                                     InformationAboutTask.spentTime, InformationAboutTask.elementIndex)
            }

        }

        Component {
            id: spentTimeComponent
            Item {
                Label {
                    id: spentTimeTextLabel
                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                        left: parent.left
                        margins: Theme.paddingLarge
                    }
                    text: qsTr("Spent time:")
                    verticalAlignment: Text.AlignVCenter
                }


                BackgroundItem {
                    height: spentTimeLabel.height + Theme.paddingMedium
                    width: spentTimeLabel.width + Theme.paddingMedium
                    id: spentTimeBackgroundItem
                    anchors {
                        left: spentTimeTextLabel.right
                        leftMargin: Theme.paddingLarge
                        margins: Theme.paddingSmall
                    }
                    Label {
                        id: spentTimeLabel
                        anchors.centerIn: parent
                        color: Theme.highlightColor
                        text: InformationAboutTask.spentTime.toFixed(1) + qsTr(" h.")
                    }
                    onClicked: AppActions.addSpentTime()
                }
            }
        }
    }
}
