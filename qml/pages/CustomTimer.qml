import QtQuick 2.0
import Sailfish.Silica 1.0

Rectangle {
    id: flashingblob
    signal timerFinished()

    function pause(b) {
        console.log("Timer pause",b)
        if (b) {
            if (timer.running) {
                console.log("timer.stop")
                timer.running = false
                timer.stop()
            }
        } else {
            if (!timer.running) {
                console.log("timer.start")
                timer.running = true
                timer.start()
            }
        }
    }


    color: Qt.rgba(1,1,1,0.2)
    border.color: "white"
    border.width: 1
    radius: 5
    width: Math.max(timerText.width, 60)
    height: timerText.height
    anchors.horizontalCenter: parent.horizontalCenter
    Text {
        id: timerText
        y: Theme.paddingMedium
        anchors.horizontalCenter: parent.horizontalCenter
        text: timer.timeRemaining
        font.pixelSize: Theme.fontSizeHuge
        Timer {
            id: timer
            property int timeRemaining
            triggeredOnStart: false
            running: true
            interval: 1000
            repeat: true
            onTriggered: {
                timer.timeRemaining = timer.timeRemaining - 1
                check()
            }
        }
    }

    Text {
        id: animLost
        x: timerText.x
        y: timerText.y
        z: 10
        visible: false
        font.pixelSize: Theme.fontSizeHuge

        function startAnimation(val) {
            console.log("timeLost")
            animLost.visible = true
            animateColor.restart()
            text = "-"+val
        }

        ParallelAnimation {
            id: animateColor
            running: false
            PropertyAnimation {
                target: animLost
                property: "y";
                from: timerText.y
                to: -timerText.width
                duration: 500
            }
            PropertyAnimation {
                target: animLost
                property: "opacity"
                from: 1
                to: 0
                duration: 500
            }
        }
    }

    function check() {
        if (timer.timeRemaining < 1) {
            timer.running = false
            timerFinished();
        }
    }

    function increment(time) {
        timer.timeRemaining = timer.timeRemaining + time
        timer.restart()
    }
    function lose(time) {
        console.log("lose")
        var loseSecs = time
        if (timer.timeRemaining - time < 1) {
            loseSecs = timer.timeRemaining
            timer.timeRemaining = 0
        } else {
            timer.timeRemaining = timer.timeRemaining - time
        }
        timer.restart()
        check()
        if (loseSecs !== 0) {
            animLost.startAnimation(loseSecs)
        }
    }

    function restart() {
        timer.running = true
        if (page.mode === "kuku") {
            timer.timeRemaining = 60
        } else {
            timer.timeRemaining = 10
        }
    }
    Component.onCompleted: {
        restart()
    }
}
