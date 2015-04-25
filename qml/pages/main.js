var lvColor = [2, 3, 4, 5, 5, 6, 6, 7, 7, 7, 8, 8, 8, 8, 8, 8, 9]

function generateColorArcade(progress) {
    var l = Math.max(0.3, Math.random())
    l = Math.min(l*calculateLighter(progress),0.7)/calculateLighter(progress)
    console.log("l",l,"calc",calculateLighter(progress))
    var color = Qt.hsla(Math.random(), Math.random(), l, 1);
    var highlighted = Qt.lighter(color, calculateLighter(progress))
    return [toColor(color), toColor(highlighted)]
}

function toColor(t) {
    if (t.r && t.g && t.b && t.a) {
        return {r:t.r, g:t.g, b:t.b, a:t.a}
    }

    return {r: t[0], g:t[1], b:t[2], a:t[3]}
}

function generateColorKuku(progress) {
    function genColor(a) {
        return [Math.round(Math.random() * a)/255, Math.round(Math.random() * a)/255, Math.round(Math.random() * a)/255, 1]
    }

    function highlightColor(color, d) {
        return color.map(function (val) { return val + d/255})
    }

    var d = 0
    if (progress < lvColor.length) {
        d = Math.max(9 - lvColor[progress], 1) * 15
    } else if (progress < 20) {
        d = 10
    } else if (progress < 40) {
        d = 8
    } else if (progress < 50) {
        d = 5
    }

    console.log("generateColorKuku d =",d)

    var color = genColor(255 - d)

    return [toColor(color), toColor(highlightColor(color, d))]
}

function generateColorHardcore(progress) {
    return generateColorArcade(progress)
}

function generateColor(progress, mode) {
    if (mode === "arcade") {
        return generateColorArcade(progress)
    } else if (mode === "kuku") {
        return generateColorKuku(progress)
    } else if (mode === "hardcore") {
        return generateColorHardcore(progress)
    }
}

function incrementCellsArcade(progress, count) {
    if (1.5/count > Math.random() && count < 10) {
        return count+1
    }
    return count
}

function incrementCellsKuku(progress, count) {
    if (progress < lvColor.length) {
        return lvColor[progress]
    }
    return lvColor[lvColor.length-1]
}

function incrementCellsHardcore(progress, count) {
    return incrementCellsArcade(progress, count)
}

function incrementCells(progress, count, mode) {
    if (mode === "arcade") {
        return incrementCellsArcade(progress, count)
    } else if (mode === "kuku") {
        return incrementCellsKuku(progress, count)
    } else if (mode === "hardcore") {
        return incrementCellsHardcore(progress, count)
    }
    console.log("incrementCells error")
}

function refreshCells(count, progress, mode) {
    var colors = generateColor(progress, mode)
    grid.cellCount = incrementCells(progress, count, mode)

    grid.model.clear()

    //console.log(grid.cellCount*grid.cellCount)
    //console.log("colors",colors[0][0],colors[0][1],colors[0][2],colors[0][3])

    //console.log("type", typeof colors[0])
    //for (var prop in colors[0]) {
    //    console.log(prop)
    //}
    //console.log("lala", colors[0][0])
    //console.log("test", colors[0].r, colors[0].g, colors[0].b, colors[0].a, "\n", colors[1].r, colors[1].g, colors[1].b, colors[1].a)

    for (var i=0;i<grid.cellCount*grid.cellCount;i++) {
        grid.model.append({
                              isAnswer: false,
                              isHightlighted: false,
                              rgbaCellColor: colors[0] ,
                              //test: Qt.rgba(1,0,1,1),
                          })
    }

    var randomCellId = Math.floor(Math.random()*grid.model.count);
    console.log("random cell id is ",randomCellId)
    var randomCell = grid.model.get(randomCellId)
    grid.cellCorrectId = randomCellId
    randomCell.isAnswer = true
    randomCell.rgbaCellColor = colors[1]
}


function calculateLighter(progress) {
    return 1+0.6/Math.sqrt(progress+1)
}
