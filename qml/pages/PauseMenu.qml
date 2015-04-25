import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    function showComponent(comp) {
        loader.source = comp
    }
    function hideComponents() {
        loader.source = ""
    }

    width: Screen.width
    height: Screen.height
    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0,0,0,0.4)
    }
    MouseArea {
        anchors.fill: parent
    }

    Rectangle {
        width: Screen.width*0.8
        height: Screen.height*0.8
        anchors.centerIn: parent
        color: "#8EC7D2"
        radius: 10
        Loader {
            anchors.fill: parent
            id: loader
            source: ""
        }
    }
}
