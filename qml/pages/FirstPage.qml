/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0
import "main.js" as Main

Page {
    id: page
    property int progress : 1

    Rectangle {
        anchors.fill: parent
        color: "#EDE5F4"
    }

    function iAmLoser() {
        losePageLoader.show = true
    }

    function restart() {
        progress = 1
        grid.cellCount = 1
        losePageLoader.show = false
        timer.running = true
        timer.timeRemaining = 10
        Main.refreshCells(grid.cellCount)
    }

    Text {

        y: Theme.paddingMedium
        width: Screen.width - Theme.paddingMedium
        text: "Score: "+(progress-1)
        horizontalAlignment: Text.AlignRight
    }

    Rectangle {
        color: Qt.rgba(1,1,1,0.2)
        border.color: "white"
        border.width: 1
        radius: 5
        width: Math.max(timerText.width, 60)
        height: timerText.height
        anchors.horizontalCenter: parent.horizontalCenter
        Text {
            y: Theme.paddingMedium
            anchors.horizontalCenter: parent.horizontalCenter
            id: timerText
            text: ""+timer.timeRemaining
            font.pixelSize: Theme.fontSizeExtraLarge
            Timer {
                id: timer
                property int timeRemaining : 1
                triggeredOnStart: false
                running: true
                interval: 1000
                repeat: true
                onTriggered: {
                    timeRemaining = timeRemaining - 1
                    check()
                }
                function check() {
                    if (timeRemaining < 1) {
                        running = false
                        page.iAmLoser()
                    }
                }

                function increment(time) {
                    timeRemaining = timeRemaining + time
                    timer.restart()
                }
                function lose(time) {
                    if (timeRemaining - time < 1) {
                        timeRemaining = 0
                    } else {
                        timeRemaining = timeRemaining - time
                    }
                    timer.restart()
                    check()
                }
            }
        }
    }

    Item {
        width: Screen.width
        height: Screen.width
        anchors.verticalCenter: parent.verticalCenter
        GridView {
            id: grid
            anchors.fill: parent
            property int cellCount : 1
            property color cellColor
            cellWidth: Screen.width / cellCount - 1
            cellHeight: cellWidth
            snapMode: GridView.NoSnap
            Component {
                id: cellDelegate
                Rectangle {
                    width : grid.cellWidth
                    height : grid.cellHeight
                    color: "transparent"
                    property bool isCorrect : isAnswer
                    Rectangle {
                        anchors.fill: parent
                        color: isAnswer? Qt.lighter(grid.cellColor, Main.calculateLighter(progress)) : grid.cellColor
                        anchors.margins: grid.cellWidth*0.05
                        radius: 10

                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            console.log("isCorrect",isCorrect)
                            if (isCorrect) {
                                Main.refreshCells(grid.cellCount)
                                page.progress = page.progress + 1
                                console.log(page.progress)
                                timer.increment(5)
                            } else {
                                timer.lose(5)
                            }
                        }
                    }
                }
            }
            model: ListModel{}
            delegate: cellDelegate
            Component.onCompleted: {
                page.restart()
            }
        }
    }

    Loader {
        id: losePageLoader
        property bool show: false
        sourceComponent: show? losePage : null
        Component {
            id: losePage
            Item {
                width: Screen.width
                height: Screen.height
                Rectangle {
                    anchors.fill: parent
                    color: Qt.rgba(0,0,0,0.4)
                }
                Rectangle {
                    width: Screen.width*0.8
                    height: Screen.height*0.8
                    anchors.centerIn: parent
                    color: "#8EC7D2"
                    radius: 10
                    Column {
                        anchors.fill: parent
                        Text {
                            width: parent.width
                            height: parent.height/2
                            text: "Your score is "+(page.progress-1)
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.pixelSize: Theme.fontSizeHuge
                        }
                        Item {
                            width: parent.width
                            height: parent.height/2
                            Button {
                                height: parent.width/2
                                text: "Restart"
                                anchors.centerIn: parent
                                onClicked: {
                                    page.restart()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

