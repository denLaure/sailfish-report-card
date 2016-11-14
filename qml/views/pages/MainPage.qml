import QtQuick 2.0
import harbour.report.card.QuickFlux 1.0
import Sailfish.Silica 1.0
import "../../actions"
import "../../stores"
import "../components"

Page {

    RemorsePopup {
        id: remorsePopupMainPage
    }

    SilicaFlickable {
        contentHeight: column.height
        anchors.fill: parent

        VerticalScrollDecorator {}

        TasksListPage {}

        Component.onCompleted: {
           AppActions.fillTasksList();
           TasksStore.setNearTask();
        }

        Column {
            id: column
            spacing: Theme.paddingLarge
            anchors.margins: Theme.paddingLarge
            width: parent.width
            PageHeader { title: qsTr("Report Card") }

            Loader {
                width: parent.width
                sourceComponent: TasksStore.areAllTasksCompleted ? nothingScheduledComponent : nearTaskComponent;
            }

            Button {
                anchors {
                    left: parent.left
                    right: parent.right
                    margins: Theme.paddingLarge
                }
                text: qsTr("Tasks list")
                onClicked: {
                    AppActions.openTasksList()
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
                    AppActions.openReportPage();
                }
            }
        }
    }

    Component {
        id: nearTaskComponent
        Item {
            height: taskComponent.height + nearTaskLabel.height + Theme.paddingLarge
            Label {
                id: nearTaskLabel
                anchors{
                    top: parent.top
                    left: parent.left
                    right: parent.right
                    margins: Theme.paddingLarge
                }
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: Theme.fontSizeLarge
                text: qsTr("The closest tasks")
            }

            BackgroundItem {
                height: taskComponent.height
                anchors{
                    top: nearTaskLabel.bottom
                    left: parent.left
                    right: parent.right
                }
                TaskComponent {
                    id: taskComponent
                    startDate: TasksStore.nearestTask.startDate
                    finishDate: TasksStore.nearestTask.finishDate
                    taskName: TasksStore.nearestTask.name
                    spentTime: TasksStore.nearestTask.spentTime
                    anchors.fill: parent
                }
                onClicked: AppActions.showTask(remorsePopupMainPage, TasksStore.nearestTask.index)
            }
        }
    }

    Component {
        id: nothingScheduledComponent
        Label {
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: Theme.fontSizeLarge
            text: qsTr("Nothing scheduled")
        }
    }
}
