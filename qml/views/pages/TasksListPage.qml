import QtQuick 2.0
import harbour.report.card.QuickFlux 1.0
import Sailfish.Silica 1.0
import "../../actions"
import "../../stores"
import "../components"

Page {

    RemorsePopup {
        id: remorsePopupTasksListPage
    }

    SilicaListView {
        id: listView
        anchors {
            top: parent.top
            right: parent.right
            left: parent.left
            bottom: addNewTaskButton.top
        }
        clip: true
        PullDownMenu {
            MenuItem {
                text: TasksStore.isFilterActive ? qsTr("Show active tasks") : qsTr("Show completed tasks")
                onClicked: AppActions.filterTasksList()
            }
        }
        header: PageHeader { title: qsTr("Tasks List") }
        model: TasksStore.list
        spacing: Theme.paddingSmall
        delegate: BackgroundItem {
            id: tasksList
            visible: TasksStore.isFilterActive ? model.taskDone : !model.taskDone
            height: visible ? taskComponent.height : 0
            width: parent.width
            TaskComponent{
                id: taskComponent
                startDate: model.startDate
                finishDate: model.finishDate
                taskName: model.taskName
                spentTime: model.spentTime
                anchors {
                    left: parent.left
                    right: parent.right
                }
            }
            onClicked: AppActions.showTask(remorsePopupTasksListPage, index)
        }

        VerticalScrollDecorator {}
    }
    Button {
        id: addNewTaskButton
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            margins: Theme.horizontalPageMargin
        }
        text: qsTr("Add Task")
                onClicked: AppActions.openNewTaskPage()
    }
}
