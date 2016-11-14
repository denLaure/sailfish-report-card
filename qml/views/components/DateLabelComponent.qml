import QtQuick 2.0
import harbour.report.card.QuickFlux 1.0
import Sailfish.Silica 1.0
import "../../actions"
import "../../stores"

Item {

    property string textForLabel

    property date taskDate

    height: Theme.itemSizeSmall / 1.55

    Label {
        id: textLabel
        width: parent.width / 5
        anchors {
            left: parent.left
            margins: Theme.paddingLarge
        }
        text: textForLabel
        verticalAlignment: Text.AlignVCenter
    }

    BackgroundItem {
        id: timeTaskBackgroundItem
        height: timeTaskLabel.height + Theme.paddingMedium
        width: timeTaskLabel.width + Theme.paddingMedium
        anchors {
            left: textLabel.right
            bottom: parent.bottom
            margins: Theme.paddingSmall
        }
        Label {
            id: timeTaskLabel
            anchors.centerIn: parent
            text: Qt.formatDateTime(taskDate, "hh:mm")
            color: Theme.highlightColor
        }
        onClicked: {
            AppActions.changeTimeTask(taskDate, textForLabel);
        }
    }

    BackgroundItem {
        id: dateTaskBackgroundItem
        height: dateTaskLabel.height + Theme.paddingMedium
        width: dateTaskLabel.width + Theme.paddingMedium
        anchors {
            left: timeTaskBackgroundItem.right
            bottom: parent.bottom
            leftMargin: Theme.paddingLarge * 3
            margins: Theme.paddingSmall
        }
        Label {
            id: dateTaskLabel
            anchors.centerIn: parent
            text: Qt.formatDateTime(taskDate, "d MMM yyyy")
            color: Theme.highlightColor
        }
        onClicked: {
            AppActions.changeDateTask(taskDate, textForLabel);
        }
    }
}
