import QtQuick 2.0
import Sailfish.Silica 1.0
import "../../stores"

Dialog {

    property int hours

    property int minutes

    Column {
        width: parent.width
        DialogHeader { }

        TextField {
            id: inputHoursTextField
            width: parent.width
            text: hours
            inputMethodHints: Qt.ImhDigitsOnly
            placeholderText: "Enter the new value of hours"
            label: qsTr("Hours")
            EnterKey.onClicked: {
                parent.focus = true;
            }
        }

        TextField {
            id: inputMinutesTextField
            width: parent.width
            text: minutes.toFixed(0)
            inputMethodHints: Qt.ImhDigitsOnly
            placeholderText: "Enter the new value of minutes"
            label: qsTr("Minutes")
            EnterKey.onClicked: {
                parent.focus = true;
            }
        }
    }

    onAccepted: {
        if (parseInt(inputHoursTextField.text) >= 0 && parseInt(inputMinutesTextField.text) >= 0) {
            InformationAboutTask.isNewSpentTimeNotValid = false;
            hours = parseInt(inputHoursTextField.text);
            minutes = parseInt(inputMinutesTextField.text);
        } else {
            InformationAboutTask.isNewSpentTimeNotValid = true;
        }
    }

    onCanceled: {
        InformationAboutTask.isNewSpentTimeNotValid = false;
    }
}
