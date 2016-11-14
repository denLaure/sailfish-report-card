import QtQuick 2.0
import Sailfish.Silica 1.0
import "views/pages"
import "stores/"
import "scripts/"
import "actions/"

ApplicationWindow
{
    initialPage: Component {  MainPage { } }
    cover: Qt.resolvedUrl("views/cover/CoverPage.qml")
    allowedOrientations: Orientation.All
    _defaultPageOrientations: Orientation.All

    Component.onCompleted: {
        AppActions.createDatabase();
    }

    PageOpenerScript {}
}


