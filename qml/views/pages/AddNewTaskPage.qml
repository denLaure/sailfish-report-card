import QtQuick 2.0
import harbour.report.card.QuickFlux 1.0
import Sailfish.Silica 1.0
import "../../actions"
import "../../stores"
import "../components"

Page {

    SilicaFlickable {
        contentHeight: column.height
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: qsTr("Save")
                onClicked: AppActions.addNewTask(startDateLabelComponent.taskDate, finishDateLabelComponent.taskDate,
                                                 taskNameTextField.text, taskDescriptionTextArea.text)
            }
        }

        VerticalScrollDecorator {}

        Column {
            id: column
            spacing: Theme.paddingLarge
            width: parent.width
            PageHeader { title: qsTr("New Task") }

            VerticalScrollDecorator {}

            TextField {
                id: taskNameTextField
                width: parent.width
                labelVisible: false
                placeholderText: qsTr("Enter the name of the task")
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
                placeholderText: qsTr("Enter the description of the task")
                labelVisible: false
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

            Button {
                anchors {
                    left: parent.left
                    right: parent.right
                    margins: Theme.paddingLarge
                }
                text: qsTr("Save")
                onClicked: AppActions.addNewTask(startDateLabelComponent.taskDate, finishDateLabelComponent.taskDate,
                                                 taskNameTextField.text, taskDescriptionTextArea.text);
            }
        }
    }
}
