import QtQuick 2.0
import Sailfish.Silica 1.0
import "../../stores"
import "../../actions"

Dialog {
    DialogHeader {
        id: dialogHeader
    }

    Component.onCompleted: {
        TimerStore.isDialogOpen = true;
    }

    Label {
        id: headerLabel
        wrapMode: Text.Wrap
        anchors {
            top: dialogHeader.bottom
            left: parent.left
            right: parent.right
            margins: Theme.paddingLarge
        }
        text: qsTr("You have already opened the task timer for \"") + TimerStore.taskName  + "\". " +
              qsTr("What do you want to do with the current task timers?")
    }


    ComboBox {
        id: actionSelectionComboBox
        anchors {
            top: headerLabel.bottom
            left: parent.left
            right: parent.right
        }
        label: qsTr("Please choose: ")
        currentIndex: 1

        menu: ContextMenu {
            Repeater {
                model: [qsTr('Reset data and open a new task timer'),
                    qsTr('Save data and open a new task timer'),
                    qsTr('Go to the current task timer')]

                MenuItem {
                    text: modelData
                }
            }
        }
    }
    onAccepted: {
        if (actionSelectionComboBox.currentIndex === 0) {
            AppActions.resetCurrentTaskTimerAndOpenNew();
        } else if (actionSelectionComboBox.currentIndex === 1) {
            AppActions.saveCurrentTaskTimerAndOpenNew();
        } else {
            AppActions.goToCurrentTaskTimer();
        }
    }
    onCanceled: TimerStore.isDialogOpen = false;
}
