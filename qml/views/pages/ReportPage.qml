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

        VerticalScrollDecorator {}

        Column {
            id: column
            spacing: Theme.paddingLarge
            anchors.margins: Theme.paddingLarge
            width: parent.width
            PageHeader { id: head; title: qsTr("Create report") }

            Label {
                text: qsTr("Select options for creating report")
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Label {
                text: qsTr("Set report period")
                width: parent.width
                anchors {
                    left: parent.left
                    margins: Theme.paddingLarge
                }
            }

            DateLabelComponent {
                id: beginningField
                textForLabel: qsTr("Start:")
                taskDate: InformationAboutTask.startDateTask
                anchors {
                    left: parent.left
                    right: parent.right
                }
            }

            DateLabelComponent {
                id: endField
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

            ComboBox {
                id: formatOptions
                width: parent.width
                label: qsTr("Chose file format")
                menu: ContextMenu {
                    Repeater {
                        model: comboBoxOptions
                        delegate: MenuItem {
                            text: model.name
                        }
                    }
                }

                ListModel {
                    id: comboBoxOptions
                    ListElement { name: "csv" }
                    ListElement { name: "html" }
                }
            }

            Button {
                anchors {
                    left: parent.left
                    right: parent.right
                    margins: Theme.paddingLarge
                }
                text: qsTr("Create report")
                onClicked: {
                    AppActions.formReport(beginningField.taskDate, endField.taskDate, formatOptions.currentItem.text);
                    popUp.start();
                }
            }
        }
    }

    SilicaFlickable {
        id: notification
        height: 0
        width: parent.width
        clip: true
        anchors.bottom: parent.bottom
        Rectangle {
            color: Theme.highlightBackgroundColor
            opacity: 0.5
            anchors {
                bottom: parent.bottom
                fill: parent
            }

            Label {
                id: notificationLabel
                text: TasksStore.notificationText
                width: parent.width
                wrapMode: Text.WordWrap
                anchors {
                    horizontalCenter: parent.horizontalCenter
                }
            }

        }

        SequentialAnimation {
            id: popUp
            NumberAnimation {
                target: notification
                properties: "height"
                to: notificationLabel.height
                duration: 200
            }
            NumberAnimation {
                duration: 2000
            }
            NumberAnimation {
                target: notification
                properties: "height"
                to: 0
                duration: 200
            }
        }
    }
}

