import QtQuick 2.0
import Sailfish.Silica 1.0

Column {

    anchors.fill: parent
    Text {
        width: parent.width
        height: parent.height/4
        text: "Your score is " + (page.progress-1)
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: Theme.fontSizeExtraLarge
    }
    Item {
        width: parent.width
        height: parent.height/4
        Button {
            height: parent.width/2
            text: "Continue"
            anchors.centerIn: parent
            onClicked: {
                page.resume()
            }
        }
    }
    Item {
        width: parent.width
        height: parent.height/4
        Button {
            height: parent.width/2
            text: "Restart"
            anchors.centerIn: parent
            onClicked: {
                page.start(page.mode)
            }
        }
    }
    Item {
        width: parent.width
        height: parent.height/4
        Button {
            height: parent.width/2
            text: "Menu"
            anchors.centerIn: parent
            onClicked: {
                page.showMenu()
            }
        }
    }
}
