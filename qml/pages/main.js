
function generateColor() {
    var l = Math.max(0.3, Math.random())
    l = Math.min(l*calculateLighter(page.progress),0.7)/calculateLighter(page.progress)
    //console.log("l",l,"calc",calculateLighter(page.progress))
    return Qt.hsla(Math.random(), Math.random(), l, 1);
}

function incrementCells(count) {
    if (1.5/count > Math.random() && count < 10) {
        return count+1
    }
    return count
}

function refreshCells(count) {
    var color = generateColor()
    grid.cellCount = incrementCells(count)
    grid.cellColor = color

    grid.model.clear()

    //console.log(grid.cellCount*grid.cellCount)
    for (var i=0;i<grid.cellCount*grid.cellCount;i++) {
        grid.model.append({
                              isAnswer: false
                              //cellColor: Qt.rgba(0.3, 0.7, 1, 1.0),
                          })
    }
    var randomCellId = Math.floor(Math.random()*grid.model.count);
    //console.log("random cell id is ",randomCellId)
    var randomCell = grid.model.get(randomCellId)
    randomCell.isAnswer = true
}


function calculateLighter(progress) {
    return 1+0.6/Math.sqrt(progress+1)
}
