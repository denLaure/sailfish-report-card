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
                text: qsTr("Save time")
                onClicked: AppActions.saveValueOfTaskTimer(TimerStore.elapsedTime)
            }
        }

        VerticalScrollDecorator {}

        Column {
            id: column
            spacing: Theme.paddingLarge
            anchors.margins: Theme.paddingLarge
            width: parent.width
            PageHeader { title: qsTr("Task Timer") }

            Label {
                id: taskNameLabel
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeExtraLarge
                text: TimerStore.taskName
                anchors {
                    left: parent.left
                    right: parent.right
                    margins: Theme.paddingLarge
                }
            }

            TaskTimerComponent {
                id: taskTimerComponent
                anchors {
                    left: parent.left
                    right: parent.right
                }
            }

            Label {
                text: qsTr("Description:")
                font.pixelSize: Theme.fontSizeLarge
                x: Theme.horizontalPageMargin
            }

            Label {
                id: taskDescriptionLabel
                wrapMode: Text.Wrap
                text: TimerStore.taskDescription
                anchors {
                    left: parent.left
                    right: parent.right
                    margins: Theme.paddingLarge
                }
            }
        }
    }
}
