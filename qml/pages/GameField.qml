import QtQuick 2.0
import Sailfish.Silica 1.0
import "main.js" as Main

Item {
    id: gameField

    width: Screen.width
    height: Screen.height

    function restart() {
        console.log("restart")
        page.progress = 1
        grid.cellCount = 1
        Main.refreshCells(grid.cellCount, page.progress, page.mode)
        page.pause = false
        timer.restart()
    }
    function showRightAnswer() {
        grid.model.get(grid.cellCorrectId).isHightlighted = true
    }

    function pause(b) {
        timer.pause(b)
        page.pause = b
    }

    function gameOver() {
        showRightAnswer()
        gameField.pause(true)
    }

    Text {
        y: Theme.paddingMedium
        width: Screen.width - Theme.paddingMedium
        text: "Score: "+(page.progress-1)
        horizontalAlignment: Text.AlignRight
        font.pixelSize: Theme.fontSizeLarge
    }

    CustomTimer {
        id: timer
        onTimerFinished: {
            gameOver()
        }
    }
    Text {
        x: Theme.paddingMedium
        y: Theme.paddingMedium
        text: "Pause"
        font.pixelSize: Theme.fontSizeLarge
        //font.bold: true
        //color: "#0D6986"
        MouseArea {
            anchors.fill: parent
            onClicked: {
                console.log("pause")
                gameField.pause(true)
                losePageLoader.showComponent("PauseComponent.qml")
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
            property int cellCorrectId : 0
            //property color cellColor
            cellWidth: Screen.width / cellCount - 1
            cellHeight: cellWidth
            snapMode: GridView.NoSnap
            Component {
                id: cellDelegate
                Rectangle {
                    id: cell
                    width : grid.cellWidth
                    height : grid.cellHeight
                    color: "transparent"
                    property bool isCorrect : isAnswer
                    property bool highlight : isHightlighted

                    onHighlightChanged : {
                        console.log("onHighlight changed")
                        cellAnim.restart()
                    }

                    Rectangle {
                        id: cellInside

                        property real mulCoef: 0.9
                        property color colorHighlighted
                        property color colorGeneral
                        property variant cellColor: rgbaCellColor

                        width: grid.cellWidth * mulCoef
                        height: grid.cellHeight * mulCoef
                        anchors.centerIn: parent
                        radius: 10

                        onCellColorChanged: {
                            colorGeneral = Qt.rgba(model.rgbaCellColor.r, model.rgbaCellColor.g, model.rgbaCellColor.b, model.rgbaCellColor.a)
                            color = colorGeneral
                            if (isCorrect) {
                                colorHighlighted = Qt.lighter(color, 1.8)
                            }
                        }

                        SequentialAnimation {
                            id: cellAnim
                            running: false

                            property int durationAll: 400
                            SequentialAnimation {
                                loops: 3

                                ParallelAnimation {
                                    PropertyAnimation { target: cellInside; property: "mulCoef"; from : 0.9; to: 1; duration: cellAnim.durationAll}
                                    PropertyAnimation { target: cellInside; property: "color"; from: cellInside.colorGeneral; to:cellInside.colorHighlighted ; duration: cellAnim.durationAll }
                                }
                                ParallelAnimation {
                                    PropertyAnimation { target: cellInside; property: "mulCoef"; from : 1; to: 0.9; duration: cellAnim.durationAll}
                                    PropertyAnimation { target: cellInside; property: "color"; from: cellInside.colorHighlighted; to:cellInside.colorGeneral ; duration: cellAnim.durationAll }
                                }
                            }
                            PropertyAnimation {duration: 2000}


                            onRunningChanged: {
                                if (!running) {
                                    losePageLoader.showComponent("RestartComponent.qml")
                                }
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (!page.pause) {
                                console.log("isCorrect",isCorrect)
                                if (isCorrect) {
                                    Main.refreshCells(grid.cellCount, page.progress, page.mode)
                                    page.progress = page.progress + 1
                                    console.log(page.progress)
                                    if (page.mode !== "kuku") {
                                        timer.increment(5)
                                    }
                                } else {
                                    if (page.mode === "hardcore") {
                                        gameOver()
                                    } else {
                                        if (page.mode !== "kuku") {
                                            timer.lose(5)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            model: ListModel{}
            delegate: cellDelegate
        }
    }
}
