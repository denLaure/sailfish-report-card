import QtQuick 2.0
import harbour.report.card.QuickFlux 1.0
import Sailfish.Silica 1.0
import "../../actions"
import "../../stores"

Item {

    property date startDate

    property date finishDate

    property string taskName: ""

    property double spentTime

    height: column.height + Theme.paddingSmall

    Column {
        id: column
        width: parent.width
        spacing: Theme.paddingSmall

        Label {
            text: taskName
            font.pixelSize: Theme.fontSizeLarge
            wrapMode: Text.Wrap
            anchors {
                left: parent.left
                right: parent.right
                margins: Theme.paddingLarge
            }
        }

        Label {
            id: startDateTaskLabel
            text: qsTr("Start:  ") + Qt.formatDateTime(startDate, "   hh:mm     d MMM yyyy")
            font.pixelSize: Theme.fontSizeMedium
            wrapMode: Text.Wrap
            anchors {
                left: parent.left
                right: parent.right
                margins: Theme.paddingLarge
            }
        }

        Label {
            id: finishDateTaskLabel
            text: qsTr("Finish:") + Qt.formatDateTime(finishDate, "   hh:mm     d MMM yyyy")
            font.pixelSize: Theme.fontSizeMedium
            wrapMode: Text.Wrap
            anchors {
                left: parent.left
                right: parent.right
                margins: Theme.paddingLarge
            }
        }

        Label {
            id: spentTimeLabel
            text: qsTr("Spent time:") + "   " + spentTime.toFixed(1) + " " + qsTr("h.")
            font.pixelSize: Theme.fontSizeMedium
            anchors {
                left: parent.left
                right: parent.right
                margins: Theme.paddingLarge
            }
        }

    }
}
