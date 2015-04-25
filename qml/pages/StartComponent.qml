import QtQuick 2.0
import Sailfish.Silica 1.0

Column {
    id: column
    anchors.fill: parent

    Text {
        width: parent.width
        height: parent.height/4
        horizontalAlignment: Text.AlignHCenter
        text: "Game Mode"
        font.pixelSize: Theme.fontSizeHuge
        color: "#0D6986"
    }

    Item {
        width: parent.width
        height: parent.height/4
        Button {
            text: "Arcade"
            anchors.centerIn: parent
            onClicked: {
                page.start("arcade")
            }
        }
    }
    Item {
        width: parent.width
        height: parent.height/4
        Button {
            text: "Classic Kuku Kube"
            anchors.centerIn: parent
            onClicked: {
                page.start("kuku")
            }
        }
    }
    Item {
        width: parent.width
        height: parent.height/4
        Button {
            text: "Hardcore"
            anchors.centerIn: parent
            onClicked: {
                page.start("hardcore")
            }
        }
    }
}
